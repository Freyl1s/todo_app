import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

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
  List<List<String>> tableData = [];

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

        // Alle <td> Elemente scrapen
        List<dom.Element> tdElements = document.querySelectorAll('td');

        // Die <td> Elemente in Gruppen von 6 teilen
        List<List<String>> rows = [];
        for (int i = 0; i < tdElements.length; i += 6) {
          List<String> row = [];
          for (int j = 0; j < 6; j++) {
            if (i + j < tdElements.length) {
              row.add(tdElements[i + j].text.trim());
            }
          }
          rows.add(row);
        }

        setState(() {
          tableData = rows;
        });
      } else {
        setState(() {
          tableData = [
            ['Error: ${response.statusCode}']
          ];
        });
      }
    } catch (e) {
      setState(() {
        tableData = [
          ['An error occurred: $e']
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Scraping Example'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Row(
                children: const [
                  Expanded(
                      flex: 1,
                      child: Text('Column 1',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 1,
                      child: Text('Column 4',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 1,
                      child: Text('Column 5',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tableData.length,
                  itemBuilder: (context, index) {
                    var row = tableData[index];
                    return Row(
                      children: [
                        Expanded(flex: 1, child: Text(row[0])), // Column 1
                        Expanded(flex: 1, child: Text(row[3])), // Column 4
                        Expanded(flex: 1, child: Text(row[4])), // Column 5
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
