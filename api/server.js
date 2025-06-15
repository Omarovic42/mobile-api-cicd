const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
    author: 'Omarovic42'
  });
});

app.get('/api/mobile', (req, res) => {
  res.json({
    message: 'Mobile API CI/CD - Omarovic42',
    version: '1.0.0',
    endpoints: ['/health', '/api/mobile', '/api/users'],
    timestamp: new Date().toISOString()
  });
});

app.get('/api/users', (req, res) => {
  res.json({
    users: [
      { id: 1, name: 'John Doe' },
      { id: 2, name: 'Jane Smith' }
    ],
    count: 2
  });
});

app.get('/', (req, res) => {
  res.json({
    project: 'Mobile API CI/CD',
    author: 'Omarovic42',
    version: '1.0.0'
  });
});

// Only start the server if not in test environment
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log('🚀 Mobile API CI/CD Pipeline - Omarovic42');
    console.log('📱 Server running on port ' + port);
    console.log('🌍 Environment: ' + (process.env.NODE_ENV || 'development'));
    console.log('🔢 Version: 1.0.0');
    console.log('⏰ Started at: ' + new Date().toISOString());
    console.log('🎯 Ready for CI/CD deployment!');
  });
}

module.exports = app;
