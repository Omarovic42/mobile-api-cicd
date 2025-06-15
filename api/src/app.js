const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// In-memory storage
let users = [
  { id: 1, name: 'John Doe', email: 'john@example.com', createdAt: '2024-01-01T00:00:00.000Z' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com', createdAt: '2024-01-01T00:00:00.000Z' }
];

// Health check endpoint - Updated to match test expectations
app.get('/health', (req, res) => {
  res.json({
<<<<<<< HEAD
    status: 'healthy',
=======
    status: 'healthy',  // Changed from 'OK' to 'healthy'
>>>>>>> develop
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Get all users - Updated to include success field
app.get('/api/v1/users', (req, res) => {
  res.json({
<<<<<<< HEAD
    success: true,
    data: users,
    total: users.length,
    timestamp: new Date().toISOString()
=======
    success: true,  // Added success field
    data: users
>>>>>>> develop
  });
});

// Create user - Updated to include success field
app.post('/api/v1/users', (req, res) => {
  const { name, email } = req.body;
<<<<<<< HEAD

  // Validation basique
=======
  
>>>>>>> develop
  if (!name || !email) {
    return res.status(400).json({
      success: false,
      error: 'Name and email are required'
    });
  }
<<<<<<< HEAD

  // Créer le nouvel utilisateur
=======
  
>>>>>>> develop
  const newUser = {
    id: users.length + 1,
    name,
    email,
    createdAt: new Date().toISOString()
  };
<<<<<<< HEAD

  // Ajouter à la "base de données" en mémoire
=======
  
>>>>>>> develop
  users.push(newUser);

  res.status(201).json({
<<<<<<< HEAD
    success: true,
    data: newUser,
    message: 'User created successfully',
    totalUsers: users.length
  });
});

// Route pour supprimer un utilisateur (bonus)
app.delete('/api/v1/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const userIndex = users.findIndex(user => user.id === userId);

  if (userIndex === -1) {
    return res.status(404).json({ 
      success: false,
      error: 'User not found' 
    });
  }

  const deletedUser = users.splice(userIndex, 1)[0];
  res.json({
    success: true,
    data: deletedUser,
    message: 'User deleted successfully',
    totalUsers: users.length
  });
});

// Only start server if not in test environment
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`👥 Users API: http://localhost:${PORT}/api/v1/users`);
    console.log(`💾 Storage: In-memory (temporary)`);
  });
}
=======
    success: true,  // Added success field
    data: newUser
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong!'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found'
  });
});
>>>>>>> develop

// Only start server if not in test environment
if (process.env.NODE_ENV !== 'test') {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`👥 Users API: http://localhost:${PORT}/api/v1/users`);
    console.log(`💾 Storage: In-memory (temporary)`);
  });
}

module.exports = app;
