const express = require('express');
const axios = require('axios');
const WebSocket = require('ws');
const cron = require('node-cron');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3001;

// Stockage des métriques
let metrics = {
  api_health: [],
  system_metrics: [],
  logs: []
};

// Middleware
app.use(express.static('public'));
app.use(express.json());

// Health Check de l'API
async function checkAPIHealth() {
  try {
    const start = Date.now();
    const response = await axios.get('http://localhost:3000/health', { timeout: 5000 });
    const responseTime = Date.now() - start;
    
    const healthData = {
      timestamp: new Date().toISOString(),
      status: 'UP',
      response_time: responseTime,
      status_code: response.status,
      data: response.data
    };
    
    metrics.api_health.push(healthData);
    console.log(`✅ API Health: UP (${responseTime}ms)`);
    
    // Garde seulement les 1000 dernières entrées
    if (metrics.api_health.length > 1000) {
      metrics.api_health = metrics.api_health.slice(-1000);
    }
    
    return healthData;
  } catch (error) {
    const healthData = {
      timestamp: new Date().toISOString(),
      status: 'DOWN',
      error: error.message,
      response_time: null
    };
    
    metrics.api_health.push(healthData);
    console.log(`❌ API Health: DOWN - ${error.message}`);
    return healthData;
  }
}

// Métriques système
function getSystemMetrics() {
  const used = process.memoryUsage();
  const systemData = {
    timestamp: new Date().toISOString(),
    memory: {
      rss: Math.round(used.rss / 1024 / 1024 * 100) / 100,
      heapTotal: Math.round(used.heapTotal / 1024 / 1024 * 100) / 100,
      heapUsed: Math.round(used.heapUsed / 1024 / 1024 * 100) / 100,
      external: Math.round(used.external / 1024 / 1024 * 100) / 100
    },
    uptime: process.uptime(),
    cpu_usage: process.cpuUsage()
  };
  
  metrics.system_metrics.push(systemData);
  if (metrics.system_metrics.length > 500) {
    metrics.system_metrics = metrics.system_metrics.slice(-500);
  }
  
  return systemData;
}

// Routes API
app.get('/api/health', (req, res) => {
  const latest = metrics.api_health[metrics.api_health.length - 1];
  const uptime = metrics.api_health.filter(m => m.status === 'UP').length;
  const total = metrics.api_health.length;
  
  res.json({
    current_status: latest,
    uptime_percentage: total > 0 ? ((uptime / total) * 100).toFixed(2) : 0,
    total_checks: total,
    recent_checks: metrics.api_health.slice(-10)
  });
});

app.get('/api/metrics', (req, res) => {
  const latest_system = metrics.system_metrics[metrics.system_metrics.length - 1];
  res.json({
    system: latest_system,
    api_health: metrics.api_health.slice(-10),
    summary: {
      total_api_checks: metrics.api_health.length,
      api_uptime: metrics.api_health.filter(m => m.status === 'UP').length,
      monitoring_uptime: process.uptime()
    }
  });
});

app.get('/api/dashboard', (req, res) => {
  const recentHealth = metrics.api_health.slice(-20);
  const avgResponseTime = recentHealth
    .filter(h => h.response_time)
    .reduce((acc, h) => acc + h.response_time, 0) / recentHealth.filter(h => h.response_time).length;

  res.json({
    title: 'Mobile API Monitoring Dashboard',
    status: metrics.api_health[metrics.api_health.length - 1]?.status || 'UNKNOWN',
    uptime: ((metrics.api_health.filter(m => m.status === 'UP').length / metrics.api_health.length) * 100).toFixed(2),
    avg_response_time: Math.round(avgResponseTime || 0),
    total_checks: metrics.api_health.length,
    system_metrics: metrics.system_metrics[metrics.system_metrics.length - 1],
    recent_events: metrics.api_health.slice(-5)
  });
});

// Dashboard HTML
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Mobile API Monitoring</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
            .container { max-width: 1200px; margin: 0 auto; }
            .card { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            .status-up { color: #28a745; font-weight: bold; }
            .status-down { color: #dc3545; font-weight: bold; }
            .metrics { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; }
            .refresh-btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
            .logs { background: #000; color: #0f0; padding: 15px; border-radius: 4px; height: 200px; overflow-y: auto; font-family: monospace; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📊 Mobile API Monitoring Dashboard</h1>
            
            <div class="card">
                <h2>🎯 Current Status</h2>
                <div id="current-status">Loading...</div>
            </div>
            
            <div class="metrics">
                <div class="card">
                    <h3>📈 API Health</h3>
                    <div id="api-health">Loading...</div>
                </div>
                <div class="card">
                    <h3>💻 System Metrics</h3>
                    <div id="system-metrics">Loading...</div>
                </div>
                <div class="card">
                    <h3>📊 Statistics</h3>
                    <div id="statistics">Loading...</div>
                </div>
            </div>
            
            <div class="card">
                <h2>📝 Recent Events</h2>
                <div id="recent-events" class="logs"></div>
            </div>
            
            <button class="refresh-btn" onclick="loadDashboard()">🔄 Refresh</button>
        </div>
        
        <script>
            async function loadDashboard() {
                try {
                    const response = await fetch('/api/dashboard');
                    const data = await response.json();
                    
                    document.getElementById('current-status').innerHTML = \`
                        <p>Status: <span class="status-\${data.status.toLowerCase()}">\${data.status}</span></p>
                        <p>Uptime: \${data.uptime}%</p>
                        <p>Avg Response Time: \${data.avg_response_time}ms</p>
                    \`;
                    
                    document.getElementById('api-health').innerHTML = \`
                        <p>Total Checks: \${data.total_checks}</p>
                        <p>Success Rate: \${data.uptime}%</p>
                    \`;
                    
                    if (data.system_metrics) {
                        document.getElementById('system-metrics').innerHTML = \`
                            <p>Memory: \${data.system_metrics.memory.heapUsed}MB</p>
                            <p>Uptime: \${Math.round(data.system_metrics.uptime)}s</p>
                        \`;
                    }
                    
                    document.getElementById('statistics').innerHTML = \`
                        <p>Monitoring Since: \${Math.round(data.system_metrics?.uptime || 0)}s ago</p>
                        <p>Last Check: \${new Date(data.recent_events[0]?.timestamp).toLocaleTimeString()}</p>
                    \`;
                    
                    const eventsHtml = data.recent_events.map(event => 
                        \`[\${new Date(event.timestamp).toLocaleTimeString()}] \${event.status} \${event.response_time ? '(' + event.response_time + 'ms)' : ''}\`
                    ).join('\\n');
                    document.getElementById('recent-events').textContent = eventsHtml;
                    
                } catch (error) {
                    console.error('Error loading dashboard:', error);
                }
            }
            
            // Auto refresh every 10 seconds
            setInterval(loadDashboard, 10000);
            loadDashboard();
        </script>
    </body>
    </html>
  `);
});

// Tâches programmées
cron.schedule('*/10 * * * * *', () => {
  checkAPIHealth();
});

cron.schedule('*/30 * * * * *', () => {
  getSystemMetrics();
});

// WebSocket pour updates en temps réel
const wss = new WebSocket.Server({ port: 3002 });
wss.on('connection', function connection(ws) {
  console.log('📡 Client connecté au monitoring WebSocket');
  
  const interval = setInterval(() => {
    ws.send(JSON.stringify({
      type: 'update',
      data: {
        latest_health: metrics.api_health[metrics.api_health.length - 1],
        latest_system: metrics.system_metrics[metrics.system_metrics.length - 1]
      }
    }));
  }, 5000);
  
  ws.on('close', () => {
    clearInterval(interval);
    console.log('📡 Client déconnecté du monitoring');
  });
});

// Démarrage du serveur
app.listen(PORT, () => {
  console.log(`🚀 Monitoring Dashboard: http://localhost:${PORT}`);
  console.log(`📊 API Metrics: http://localhost:${PORT}/api/dashboard`);
  console.log(`📡 WebSocket: ws://localhost:3002`);
  console.log(`✅ Monitoring démarré sans Docker !`);
  
  // Premier check
  checkAPIHealth();
  getSystemMetrics();
});
