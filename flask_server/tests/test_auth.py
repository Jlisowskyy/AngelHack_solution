from tests import BaseTestCase
import json

class AuthTestCase(BaseTestCase):
    def test_register(self):
        response = self.client.post('/auth/register', json={
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'testpassword'
        })
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 201)
        self.assertIn('User created successfully', data['message'])

    def test_login(self):
        self.client.post('/auth/register', json={
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'testpassword'
        })
        response = self.client.post('/auth/login', json={
            'email': 'test@example.com',
            'password': 'testpassword'
        })
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 200)
        self.assertIn('access_token', data)

    def test_invalid_login(self):
        response = self.client.post('/auth/login', json={
            'email': 'nonexistent@example.com',
            'password': 'wrongpassword'
        })
        data = json.loads(response.data)
        self.assertEqual(response.status_code, 401)
        self.assertIn('Invalid credentials', data['error'])
