import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: HttpExample()));
}

class HttpExample extends StatefulWidget {
  const HttpExample({super.key});

  @override
  State<HttpExample> createState() => _HttpExampleState();
}

class _HttpExampleState extends State<HttpExample> {
  // membuat variabel user untuk menampung data user
  List<dynamic> users = [];
  // cek loading data karna ambil data dari API internet butuh waktu
  bool isLoading = true;

  // fungsi untuk mengambil data user dari API
  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      setState(() {
        // data body dimasukin di variabel user dengan decode json
        users = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('gagal ambil data user');
    }
  }

  // panggil fungsi di initState agar data langsung diambil saat apk dijalankan
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // tampilan ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ambil data dari API')), 
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // cek apakah masih loading
          : ListView.builder(
              // jika tidak loading, tampilkan data user dengan ListView.builder
              itemCount: users.length,
              itemBuilder: (context, index) {
                // variabel user, untuk mengambil user dari setiap index
                final user = users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                );
              },
            ),
    );
  }
}
