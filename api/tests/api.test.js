const request = require('supertest');
const app = require('../server');

describe('Mobile API Tests - Omarovic42', () => {
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

  test('GET /health returns 200', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.author).toBe('Omarovic42');
  });

  test('GET /api/mobile returns API info', async () => {
    const res = await request(app).get('/api/mobile');
    expect(res.status).toBe(200);
    expect(res.body.message).toContain('Omarovic42');
  });

  test('GET /api/users returns users list', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(res.body.users).toBeDefined();
    expect(res.body.count).toBe(2);
  });

  test('GET / returns project info', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.author).toBe('Omarovic42');
  });
});
