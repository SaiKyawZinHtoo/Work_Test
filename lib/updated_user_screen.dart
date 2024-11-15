import 'package:flutter/material.dart';
import 'package:project_test/api_service.dart';
import 'package:project_test/model/user_model.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> updateUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show an alert if fields are empty
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Input Error"),
          content: Text("Username and password cannot be empty."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final updatedUser = User(
      userId: widget.user.userId,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    try {
      await apiService.editUser(widget.user.userId, updatedUser);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("User updated successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Return to the previous screen
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Update Error"),
          content: Text("Failed to update user. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateUser,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Update User",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
