import requests
BASE ="http://127.0.0.1:5000/"
#BASE = "http://192.168.0.143:5000/"
user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'preferences': 'skibi',
            'profile_picture_url': 'path/to/profile_picture'
        }

response = requests.get(BASE + "course/course1")
print(response.json())
input()

response = requests.put(BASE + "user/" + "user1", json=user_data)
print(response.json())
input()

course_data = {
        'id': 'course1',
        'title': 'Course 1',
        'description': 'A sample course',
        'short_description': 'Sample short description',
        'category': 'Category 1',
        'duration': '10 hours',
        'thumbnail_path': 'path/to/thumbnail',
        'rating': 4.5,
        'istructor_id': 'user1'
    }

response = requests.put(BASE + "course/" + "course1", json=course_data)

print(response.json())
input()
#response = requests.delete(BASE + "user/user1")
#print(response)
#input()
response = requests.get(BASE + "course/course1")
print(response.json())