import 'package:flutter/material.dart';
import 'package:flutter_app/models/git_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    const stringUri =
        "https://api.giphy.com/v1/gifs/trending?api_key=SxBi5wIYfAAz5vckhlgJNGcVdfhlwOSp&limit=20&rating=g";
    final response = await http.get(Uri.parse(stringUri));
    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body); //convierte a un objeto json

      //go el objet json para load la lis gifs con cada elemento
      for (var item in jsonData['data']) {
        gifs.add(
          Gif(item['title'], item['images']['downsized']['url']),
        );
      }

      // print(jsonData);
      // print(jsonData['data']);
      // print(jsonData['data'][0]);
      print('${gifs[0].name} ${gifs[0].url}');
    } else {
      throw Exception("Fallo la coneccion");
    }

    return gifs;
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "APIs Flutter",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Material App bar"),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _listadoGifs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("good");
                    //los dat snapshot son nullable
                    ListView(
                      children: _listGifs(snapshot.data!),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text('error');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(
        Text(gif.name),
      );
    }
    return gifs;
  }
}
