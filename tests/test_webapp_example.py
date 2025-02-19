import pytest
import requests


# healthcheck
def test_healthcheck(baseurl):
    response = requests.get(f"{baseurl}/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"status": "OK"}

# register
def test_register_success(baseurl, user_credentials):
    url = f"{baseurl}/register"
    response = requests.post(url, json=user_credentials)
    assert response.status_code == 201

# login
def test_login_success(baseurl, user_credentials):
    url = f"{baseurl}/login"
    response = requests.post(url, json=user_credentials)
    assert response.status_code == 200
    assert 'token' in response.json()

def test_login_failure(baseurl, user_credentials):
    invalid_credentials = user_credentials.copy()
    invalid_credentials['password'] = 'invalid'
    url = f"{baseurl}/login"
    response = requests.post(url, json=invalid_credentials)
    assert response.status_code == 400
    assert response.json() == {"error": "Invalid email or password"}

# movie
@pytest.mark.parametrize("endpoint", ["/movie/1", "/movie?id=1"])
def test_movies_endpoint(baseurl, auth_token, endpoint):
    url = f"{baseurl}{endpoint}"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 200
    data = response.json()
    assert data['movieId'] == 1
    assert "title" in data
    assert "genres" in data
    assert isinstance(data['genres'], list)


def test_movies_endpoint_not_found(baseurl, auth_token):
    url = f"{baseurl}/movie/999999"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 404
    assert response.json() == {"error": "Movie not found"}

# rating
def test_ratings_endpoint(baseurl, auth_token):
    url = f"{baseurl}/rating/1"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 200
    data = response.json()
    assert data['movieId'] == 1
    assert isinstance(data['average_rating'], float)

def test_ratings_endpoint_not_found(baseurl, auth_token):
    url = f"{baseurl}/rating/999999"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 404
    assert response.json() == {"error": "No ratings found for this movie"}

# links
def test_links_endpoint(baseurl, auth_token):
    url = f"{baseurl}/link/1"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 200
    data = response.json()
    assert data['movieId'] == 1
    assert "imdbId" in data
    assert "tmdbId" in data

def test_links_endpoint_not_found(baseurl, auth_token):
    url = f"{baseurl}/link/999999"
    response = requests.get(url, headers={"Authorization": f"Bearer {auth_token}"})
    assert response.status_code == 404
    assert response.json() == {"error": "Link not found"}

# no access token send
@pytest.mark.parametrize("endpoint", ["/movie/1", "/movie?id=1", "/rating/1", "/link/1"])
def test_no_access_token(baseurl, endpoint):
    url = f"{baseurl}{endpoint}"
    response = requests.get(url)
    assert response.status_code == 401
    assert response.json() == {"error": "Authorization token required"}