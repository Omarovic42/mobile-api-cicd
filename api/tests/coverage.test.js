const request = require('supertest');
const app = require('../server');

describe('Additional Coverage Tests - Omarovic42', () => {
  let server;

  beforeAll(() => {
    server = app.listen(0);
  });

  afterAll((done) => {
    if (server) {
      server.close(done);
    } else {
      done();
    }
  });

  test('GET /nonexistent returns 404', async () => {
    const res = await request(app).get('/nonexistent');
    expect(res.status).toBe(404);
  });

  test('All endpoints return JSON with timestamp', async () => {
    const endpoints = ['/health', '/api/mobile'];
    
    for (const endpoint of endpoints) {
      const res = await request(app).get(endpoint);
      expect(res.body).toHaveProperty('timestamp');
      expect(res.body.timestamp).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/);
    }
  });
});
