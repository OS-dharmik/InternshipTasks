import 'dart:convert';
import 'model_five.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Photo {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class Task5 extends StatefulWidget {
  const Task5({Key? key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  List<Photo> photos = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task5"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(imageUrl: photo.url),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Image.network(photo.thumbnailUrl),
                    title: Text(photo.title),
                  ),
                ),
              );
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchPhotos,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<void> fetchPhotos() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://jsonplaceholder.typicode.com/photos';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        photos = json.map((photoJson) => Photo.fromJson(photoJson)).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
      setState(() {
        isLoading = false;
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
