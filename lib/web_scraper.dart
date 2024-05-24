import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://www.example.com'));

  if (response.statusCode == 200) {
    // Webseite erfolgreich abgerufen
    var document = parser.parse(response.body);

    // Beispiel: Titel der Seite extrahieren
    String title =
        document.querySelector('title')?.text ?? 'Kein Titel gefunden';
    print('Titel der Seite: $title');

    // Weitere Daten extrahieren
    // ...
  } else {
    print('Fehler beim Abrufen der Webseite: ${response.statusCode}');
  }
}
