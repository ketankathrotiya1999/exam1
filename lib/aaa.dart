import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'my Jokes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs;
  List<Map<String, dynamic>> jokeList = [];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _loadJokesFromSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadJokesFromSharedPreferences() async {
    final String storedJokes = _prefs.getString('jokes') ?? '[]';
    setState(() {
      jokeList = List<Map<String, dynamic>>.from(json.decode(storedJokes));
    });
  }

  Future<void> _fetchJoke() async {
    final response = await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> joke = json.decode(response.body);
      _storeJoke(joke);
    } else {
      // Handle API error
      print('Failed to fetch joke. Error: ${response.statusCode}');
    }
  }

  Future<void> _storeJoke(Map<String, dynamic> joke) async {
    final List<Map<String, dynamic>> updatedList = List.from(jokeList);
    updatedList.add({'joke': joke['value'], 'datetime': DateTime.now().toString()});
    final String updatedListJson = json.encode(updatedList);
    await _prefs.setString('jokes', updatedListJson);
    setState(() {
      jokeList = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Jokes'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showJokeList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(

                children: [


          for (var i =  jokeList.length-1; i < jokeList.length; i++)
            ListTile(
              title:  Text(jokeList[i]['joke']),

            ),


                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchJoke();
              },
              child: Text('Fetch My Laugh'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showJokeList() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Joke List'),
          content: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(

                children: [
                  for (var joke in jokeList)
                    ListTile(
                      title: Text(joke['joke']),
                      subtitle: Text(joke['datetime']),
                    ),
                ],
              ),
            ),
          ),
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
 
