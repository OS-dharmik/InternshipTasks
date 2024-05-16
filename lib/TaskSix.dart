import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task6 extends StatefulWidget {
  const Task6({Key? key});

  @override
  State<Task6> createState() => _Task6State();
}

class _Task6State extends State<Task6> {
  List<dynamic> datas = [];
  List<dynamic> filteredDatas = []; // List to store filtered data
  bool filterCompleted = false; // Variable to track filter status
  TextEditingController searchController = TextEditingController(); // Controller for search text field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: fetchdata,
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        title: Text("Task 6"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                filterCompleted = !filterCompleted; // Toggle filter status
              });
            },
            icon: Icon(Icons.filter_alt),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {
              // Perform search when search icon is pressed
              search();
            },
            icon: Icon(Icons.search),
          ),
        ],
        // Add search TextField to AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                // Perform search when Enter is pressed on keyboard
                search();
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final data = filteredDatas.isNotEmpty ? filteredDatas[index] : datas[index];
          final title = data['title'];
          final done = data['completed'];

          // Check if the data matches the filter status
          if (filterCompleted && !done) {
            return SizedBox.shrink(); // If filter is true and data is not completed, hide the item
          } else {
            return Card(
              child: ListTile(
                title: Text(title),
                leading: Checkbox(
                  onChanged: null,
                  value: done,
                ),
              ),
            );
          }
        },
        itemCount: filteredDatas.isNotEmpty ? filteredDatas.length : datas.length,
      ),
    );
  }

  void fetchdata() async {
    final url = "https://jsonplaceholder.typicode.com/todos";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        datas = json;
        filteredDatas = datas; // Initialize filtered data with original data
        print(datas);
      });
    } else {
      print("error occured error code ${response.statusCode}");
    }
  }

  void search() {
    String query = searchController.text.toLowerCase();
    setState(() {
      // Filter data based on search query
      filteredDatas = datas.where((data) => data['title'].toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    // Dispose the search controller when the widget is disposed
    searchController.dispose();
    super.dispose();
  }
}
