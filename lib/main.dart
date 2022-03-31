// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gerador de nomes',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
        ),
        home: const RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  List<String> _saved = <String>[];
  final _biggerFont = const TextStyle(
      fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.normal);

  @override
  void initState() {
    _saved = <String>[];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de nomes'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Sugestões salvas',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index].toString());

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Removido dos salvos' : 'Salvo',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index].toString());
                } else {
                  _saved.add(_suggestions[index].toString());
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sugestões de nomes salvos'),
              backgroundColor: Colors.redAccent,
            ),
            body: ListView.builder(
              itemCount: _saved.length,
              itemBuilder: (BuildContext context, int count) {
                String pair = _saved[count];

                return Dismissible(
                  onDismissed: (direction) {
                    setState(() {
                      _saved.remove(pair);
                    });
                  },
                  key: Key(_saved[count]),
                  child: ListTile(
                    title: Text(
                      pair,
                      style: _biggerFont,
                    ),
                    trailing: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.black87,
                      semanticLabel: "Remover",
                    ),
                  ),
                );
              }
            ),
          );
        },
      ),
    );
  }
}
