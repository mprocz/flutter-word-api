import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:word_api/service/word_service.dart';

class WordPage extends StatefulWidget {
  late final String word;
  WordPage({super.key, required this.word});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  String? partOfSpeech;
  String? phonetic;
  String? syllables;
  List<String> examples = [];
  bool isLoading = true;

  void initState() {
    super.initState();
    fetchsearchWord(widget.word); // Inicialize a busca pela palavra aqui
  }

  Future<void> fetchsearchWord(word) async {
    setState(() {
      isLoading = true;
    });
    try {
      dynamic data = await searchWord(word);
      while (data['word'].split(" ").length > 1) {
        data = await searchWord(word);
      }
      ;
      print(data);
      setState(() {
        word = data['word'];
        partOfSpeech = data['results'][0]['partOfSpeech'];
        phonetic = data['pronunciation']?['all'] ?? 'N/A';
        syllables = data['syllables']?['list']?.join(' - ') ?? 'N/A';
        examples = (data['results'][0]['examples'] ?? []).cast<String>();
      });
    } catch (e) {
      print('Error fetching word: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "WordLab",
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 49, 56, 72),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Word: ${widget.word}",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Part of Speech: ${partOfSpeech ?? 'N/A'}",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Phonetic: ${phonetic ?? 'N/A'}",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Syllables: ${syllables ?? 'N/A'}",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Examples of Use:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            ...examples.map((example) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "- $example",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Synonyms'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 49, 56, 72),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 49, 56, 72))),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Antonyms'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 49, 56, 72),
                            side: BorderSide(
                                color: Color.fromARGB(255, 49, 56, 72)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Rhymes'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 49, 56, 72),
                            side: BorderSide(
                                color: Color.fromARGB(255, 49, 56, 72)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
