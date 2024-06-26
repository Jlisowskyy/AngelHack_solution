import 'package:flutter/material.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  String? _profileImageUrl;

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      // Custom logic after account creation
      await _handleCreateAccount();

      // Navigate to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Future<void> _handleCreateAccount() async {
    // Implement your custom logic here
    // For example, save the user data to the database or call an API
    print('Account created for login: ${_loginController.text}');
    await Future.delayed(
        Duration(seconds: 2)); // Simulate some delay for custom logic
  }

  void _loadProfileImage() {
    if (_profileImageController.text.isNotEmpty) {
      setState(() {
        _profileImageUrl = _profileImageController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _profileImageUrl != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_profileImageUrl!),
                          onBackgroundImageError: (error, stackTrace) {
                            setState(() {
                              _profileImageUrl = null;
                            });
                          },
                          child: _profileImageUrl == null
                              ? Icon(Icons.error, size: 50)
                              : null,
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.camera_alt, size: 50),
                        ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _profileImageController,
                  decoration: InputDecoration(
                    labelText: 'Profile Image URL',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: _loadProfileImage,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _loginController,
                  decoration: InputDecoration(labelText: 'Login'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your login';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _createAccount,
                    child: Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
