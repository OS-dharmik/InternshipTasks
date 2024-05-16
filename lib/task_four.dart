import 'dart:convert';
import 'model_four.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Task4 extends StatefulWidget {
  const Task4({Key? key});

  @override
  State<Task4> createState() => _Task4State();
}

class _Task4State extends State<Task4> {
  List<Post> posts = [];
  bool isLoading = false; // Add a boolean to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task4"),
      ),
      body: Stack(
        // Use Stack to overlay the loader on top of the list
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final title = post.title;
              final text = post.body; // Define text variable here
              return GestureDetector(
                onTap: () {
                  _showAlertDialog(
                      title, text); // Pass text to _showAlertDialog
                },
                child: Card(
                  child: ListTile(
                    leading: Text("${post.id}"),
                    title: Text(title),
                  ),
                ),
              );
            },
          ),
          if (isLoading) // Show loader if isLoading is true
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchdata,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void fetchdata() async {
    setState(() {
      isLoading = true; // Set isLoading to true before fetching data
    });

    final url = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        posts = json.map((e) => Post.fromJson(e)).toList();
        isLoading = false; // Set isLoading to false after data is loaded
      });
    } else {
      // Handle error if the request fails
      print('Failed to load data: ${response.statusCode}');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  void _showAlertDialog(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
