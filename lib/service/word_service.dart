import 'dart:convert';

import 'package:http/http.dart' as http;

const String _token = "6017db4585mshd1d452ceb0a0b92p1fb1edjsnd2473ebc0595";

Future<Map> searchWord(String word) async {
    http.Response response;
    String url = "https://wordsapiv1.p.rapidapi.com/words/$word";
    response = await http.get(Uri.parse(url), headers: {"X-Mashape-Key": _token});
    print(json.decode(response.body));
    return json.decode(response.body);
}

Future<Map> randomWord() async {
    http.Response response;
    String url = "https://wordsapiv1.p.rapidapi.com/words?random=true";
    response = await http.get(Uri.parse(url), headers: {"X-Mashape-Key": _token});
    print(json.decode(response.body));
    return json.decode(response.body);
}
