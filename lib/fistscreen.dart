import 'dart:convert';

import 'package:http/http.dart' as http;
Future<Modal> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {

    return Modal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {

    throw Exception('Failed to load album');
  }
}

class Modal {
  final String created_at;
  final String icon_url;
  final String id;
  final String updated_at;
  final String url;
  final String value;

  const Modal({
    required this.created_at,
    required this.icon_url,
    required this.id,
    required this.updated_at,
    required this.url,
    required this.value,
  });

  factory Modal.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'created_at': String created_at,
      'icon_url': String icon_url,
      'id': String id,
      'updated_at': String updated_at,
      'url': String url,
      'value': String value,
      } =>
          Modal(
            created_at: created_at,
            icon_url: icon_url,
            id: id,
            updated_at: updated_at,
            url: url,
            value: value,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
/*
class fistscreen extends StatefulWidget {
  const fistscreen({super.key});

  @override
  State<fistscreen> createState() => _fistscreenState();
}

class _fistscreenState extends State<fistscreen> {
  @override
  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse(' https://api.chucknorris.io/jokes/random'));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jokes'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),

        ],
      ),
    );
  }
}
*/