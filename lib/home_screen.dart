import 'package:flutter/material.dart';
import 'package:project_test/create_user_screen.dart';
import 'package:project_test/model/user_model.dart';
import 'package:project_test/updated_user_screen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> userList = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<User> users = await apiService.getUsers();
      setState(() {
        userList = users;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await apiService.deleteUser(userId);
      fetchUsers();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  void confirmDelete(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete", style: TextStyle(color: Colors.red)),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(userId);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildUserList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: userList.length,
      itemBuilder: (context, index) {
        User user = userList[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              user.username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text("User ID: ${user.userId}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(user: user),
                      ),
                    ).then((_) => fetchUsers());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => confirmDelete(user.userId),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateUserScreen()),
              ).then((_) => fetchUsers());
            },
          ),
        ],
      ),
      body: userList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading users..."),
                ],
              ),
            )
          : buildUserList(),
    );
  }
}
