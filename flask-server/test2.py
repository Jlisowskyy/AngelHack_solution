import requests
BASE ="http://127.0.0.1:5000/"
user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }

response = requests.put(BASE + "user/" + "user1", json=user_data)

print(response.json())
input()
response = requests.delete(BASE + "user/user1")
print(response)
input()
response = requests.get(BASE + "user/2")
print(response.json())