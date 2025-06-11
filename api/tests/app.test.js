const request = require('supertest');
const app = require('../src/app');

describe('API Tests', () => {
  let server;

  beforeAll(() => {
    server = app.listen(0); // Use port 0 for testing
  });

  afterAll((done) => {
    server.close(done);
  });

  // ... rest of your tests
});

describe('API Tests', () => {
  describe('GET /health', () => {
    it('should return healthy status', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body.status).toBe('healthy');
      expect(response.body.timestamp).toBeDefined();
    });
  });

  describe('GET /api/v1/users', () => {
    it('should return users list', async () => {
      const response = await request(app)
        .get('/api/v1/users')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('POST /api/v1/users', () => {
    it('should create a new user', async () => {
      const newUser = {
        name: 'Test User',
        email: 'test@example.com'
      };

      const response = await request(app)
        .post('/api/v1/users')
        .send(newUser)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(newUser.name);
    });
  });
}); 
