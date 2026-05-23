import pytest
import sys
import os
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Mock all heavy dependencies before importing app
sys.modules['torch'] = MagicMock()
sys.modules['torchvision'] = MagicMock()
sys.modules['torchaudio'] = MagicMock()
sys.modules['model'] = MagicMock()

with patch('firebase_admin.initialize_app'), \
     patch('firebase_admin.credentials.Certificate'), \
     patch('generate_firebase_config.generate_config_file'):
    from app import app as flask_app


@pytest.fixture
def client():
    flask_app.config['TESTING'] = True
    flask_app.config['SECRET_KEY'] = 'test-secret-key'
    with flask_app.test_client() as client:
        yield client


# Test 1: /ping returns 200 and correct status
def test_ping(client):
    response = client.get('/ping')
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'ok'


# Test 2: /upload without login returns 401
def test_upload_requires_auth(client):
    response = client.post('/upload')
    assert response.status_code == 401
    data = response.get_json()
    assert 'error' in data


# Test 3: /upload with no file returns 400
def test_upload_no_file(client):
    with client.session_transaction() as sess:
        sess['user_id'] = 1
    response = client.post('/upload', data={})
    assert response.status_code == 400
    data = response.get_json()
    assert data['error'] == 'No file uploaded'


# Test 4: /signup with missing fields returns 400
def test_signup_missing_fields(client):
    response = client.post('/signup', json={})
    assert response.status_code == 400
    data = response.get_json()
    assert 'error' in data


# Test 5: /api/history without user_id returns 400
def test_history_missing_user_id(client):
    response = client.get('/api/history')
    assert response.status_code == 400
    data = response.get_json()
    assert 'error' in data
