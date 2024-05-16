import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task5 extends StatefulWidget {
  const Task5({Key? key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  List<dynamic> users = [];
  bool isLoading = false; // Add a boolean to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task5"),
      ),
      body: Stack(
        // Use Stack to overlay the loader on top of the list
        children: [
          ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final title = user['title'];
              final thumbnail = user['thumbnailUrl'];
              final imageUrl = user['url'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(imageUrl: imageUrl),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Image.network(thumbnail),
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

    final url = 'https://jsonplaceholder.typicode.com/photos';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = response.body;
      final List<dynamic> json = jsonDecode(body);
      setState(() {
        users = json;
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
}

class ImagePage extends StatelessWidget {
  final String imageUrl;

  const ImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
