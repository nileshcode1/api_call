import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<dynamic> _users;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getUsers();
  }

  Future<void> _getUsers() async {
    final response = await http.get(
      Uri.parse('https://reqres.in/api/users'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _users = data['data'];
        _loading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> _createUser() async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      body: {
        'name': 'John Doe',
        'job': 'Developer',
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final name = data['name'];
      final job = data['job'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('User Created'),
          content: Text('Name: $name\nJob: $job'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      throw Exception('Failed to create user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    title: Text(user['first_name'] + ' ' + user['last_name']),
                    subtitle: Text(user['email']),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createUser();
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
