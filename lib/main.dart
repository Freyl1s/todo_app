import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom; // Verwenden eines Präfixes für html

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Scraping Example',
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
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.hb9scbo.ch/de/rufzeichenliste.htm'));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        // Beispiel: Alle Listenelemente scrapen
        List<dom.Element> listItems =
            document.querySelectorAll('td'); // Verwenden des Präfixes dom
        List<String> itemTexts = listItems.map((item) => item.text).toList();

        setState(() {
          items = itemTexts;
        });
      } else {
        setState(() {
          items = ['Error: ${response.statusCode}'];
        });
      }
    } catch (e) {
      setState(() {
        items = ['An error occurred: $e'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Scraping Example1'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}
