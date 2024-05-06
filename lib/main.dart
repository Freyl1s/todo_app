import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart';
//import 'package:html/parser.dart';
//import 'package:web_scraper/web_scraper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  //debugPrint("Das ist ein Test");
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 42, 176, 47)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Unsere erste Applikation Debug123'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Username
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
              ),
              //Password
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwortController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                ),
              ),

              //Login Button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _usernameController.text,
                        password: _passwortController.text);
                  },
                  child: Text('Login')),
              //Trenner zwischen den Buttons
              SizedBox(
                height: 20,
              ),
              //Register Button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                  onPressed: () async {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _usernameController.text,
                        password: _passwortController.text);
                  },
                  child: Text('Register')),

              SizedBox(
                height: 20,
              ),
              //Register Button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                  onPressed: () async {
                    
                    print("Button gedrückt")

                   Future getWebsiteDate() async {
                    final url = Uri.parse('https://www.hb9scbo.ch/de/rufzeichenliste.htm');
                    final response = await http.get(url);
                    dom.Document html = dom.Document.html(repsonse.body);

                    final titles = html
                    .querySelectorAll('#content > table')
                    .map((element) => element.innerHtml.trim())
                    .toList();

                    print('Count: ${titles.length}');
                    for (final title in titles) {
                    debugPrint(titles);
                    }


                    print("Button Ende")
                    
                    }
                  },
                  child: Text('Daten holen')),
            ],
          ),
        ));
  }
}
