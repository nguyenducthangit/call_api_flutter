import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/models/Users.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Users> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final email = user.email;
            final color = user.gender == 'male' ? Colors.blue : Colors.green;
            return ListTile(
              title: Text(user.name.last),
              subtitle: Text(user.phone),
              tileColor: color,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUser,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void fetchUser() async {
    print('fetchUser called');
    const url = 'https://randomuser.me/api/?results=100';
    //khai báo url hắng số
    final uri = Uri.parse(url);
    // phân tích đối tượng thành uri
    final reponse = await http.get(uri);
    final body = reponse.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    final transformed = results.map((e) {
      final name = UserName(
        title: e['name']['title'],
        first: e['name']['first'],
        last: e['name']['last'],
      );
      return Users(
        cell: e['cell'],
        email: e['email'],
        gender: e['gender'],
        nat: e['nat'],
        phone: e['phone'],
        name: name,
      );
    }).toList();
    setState(() {
      users = transformed;
    });
    print('fetchUsers complete');
  }
}
