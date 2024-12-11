import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:word_api/service/word_service.dart';
import 'package:word_api/views/word_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool resize = false;
  String? word;
  String? partOfSpeech;
  String? phonetic;
  String? syllables;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomWord();
  }

  Future<void> fetchRandomWord() async {
    setState(() {
      isLoading = true;
    });
    try {
      dynamic data = await randomWord();
      while (data['word'].split(" ").length > 1){
        data = await randomWord();
      };
      print(data);
      setState(() {
        word = data['word'];
        partOfSpeech = data['results'][0]['partOfSpeech'];
        phonetic = data['pronunciation']?['all'] ?? 'N/A';
        syllables = data['syllables']?['list']?.join(' - ') ?? 'N/A';
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
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            color: Color.fromARGB(255, 49, 56, 72),
            width: MediaQuery.of(context).size.width,
            height: resize
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.55,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.0),
                  Text(
                    "WordLab",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "Find definitions, synonyms, and more...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 191, 191, 192),
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIconColor: Color.fromARGB(255, 95, 95, 95),
                        hintText: "Search for a word",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        filled: true,
                        fillColor: Color.fromARGB(255, 217, 217, 217)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Color.fromARGB(255, 49, 56, 72), fontSize: 20),
                    onSubmitted: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordPage(word: value),
                        ),
                      );
                    },
                  ) 
                ],
              ),
            ),
          ),  
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              word ?? '',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 49, 56, 72),
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                fetchRandomWord();
                              },
                              child: Icon(IconData(0xf00e9,
                                  fontFamily: 'MaterialIcons'), size: 35.0,),
                            )
                          ],
                        ),
                        const SizedBox(height: 40.0),
                        Text(
                          partOfSpeech != null
                              ? 'Part of Speech: $partOfSpeech'
                              : '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          phonetic != null ? 'Phonetic: $phonetic' : '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          syllables != null ? 'Syllables: $syllables' : '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              resize = !resize;
                            });
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.keyboard_arrow_right, color: Color.fromARGB(255, 49, 56, 72)),
                              Text(
                                "More",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 49, 56, 72),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          /*Spacer(),*/
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
    );
  }
}
