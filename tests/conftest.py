import pytest
import requests
import os
import uuid
from dotenv import load_dotenv

load_dotenv()

@pytest.fixture(scope="session")
def user_credentials():
    return {
        "email": f"{str(uuid.uuid4())[:8]}@example.com",
        "password": str(uuid.uuid4())[:8]
    }

def get_app_host():
    return os.getenv('APP_HOST', 'localhost')

def get_app_port():
    return os.getenv('APP_PORT', 80)

@pytest.fixture(scope="session")
def baseurl():
    return f"http://{get_app_host()}:{get_app_port()}/v1"


@pytest.fixture(scope="session")
def auth_token(baseurl, user_credentials):
    url = f"{baseurl}/login"
    login_response = requests.post(url, json=user_credentials)
    assert login_response.status_code == 200 # logged in successfully
    return login_response.json()['token']
