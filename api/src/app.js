const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Base de données en mémoire (temporaire)
let users = [
  { id: 1, name: 'John Doe', email: 'john@example.com' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
];
let nextUserId = 3;

// Routes
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    totalUsers: users.length
  });
});

app.get('/api/v1/users', (req, res) => {
  res.json({
    users: users,
    total: users.length,
    timestamp: new Date().toISOString()
  });
});

app.post('/api/v1/users', (req, res) => {
  const { name, email } = req.body;
  
  // Validation basique
  if (!name || !email) {
    return res.status(400).json({
      error: 'Name and email are required'
    });
  }
  
  // Créer le nouvel utilisateur
  const newUser = {
    id: nextUserId++,
    name,
    email,
    created: new Date().toISOString()
  };
  
  // Ajouter à la "base de données" en mémoire
  users.push(newUser);
  
  res.status(201).json({
    message: 'User created successfully',
    user: newUser,
    totalUsers: users.length
  });
});

// Route pour supprimer un utilisateur (bonus)
app.delete('/api/v1/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const userIndex = users.findIndex(user => user.id === userId);
  
  if (userIndex === -1) {
    return res.status(404).json({ error: 'User not found' });
  }
  
  const deletedUser = users.splice(userIndex, 1)[0];
  res.json({
    message: 'User deleted successfully',
    user: deletedUser,
    totalUsers: users.length
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`👥 Users API: http://localhost:${PORT}/api/v1/users`);
  console.log(`💾 Storage: In-memory (temporary)`);
});

module.exports = app;
