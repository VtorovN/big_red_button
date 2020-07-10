import 'package:big_red_button/utility/saved_pairs_holder.dart';
import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';

class SavedPairsScreen extends StatefulWidget {
  static const routeName = '/saved';

  @override
  _SavedPairsScreenState createState() => _SavedPairsScreenState();
}

class _SavedPairsScreenState extends State<SavedPairsScreen> {
  SavedPairsHolder savedPairsHolder;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(savedPairsHolder);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    savedPairsHolder = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: Text('Favorites')),
            body: FutureBuilder<List<WordPair>>(
                future: savedPairsHolder.initList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Widget pageBody;
                    if (snapshot.data.length == 0) {
                      pageBody = Center(
                          child: Text('Nothing here yet :/',
                              style: TextStyle(fontSize: 24)));
                    } else {
                      final tiles = snapshot.data.map((WordPair pair) {
                        final alreadySaved = true;
                        return ListTile(
                          title: Text(_buildPairString(pair),
                              style: TextStyle(fontSize: 18)),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (alreadySaved) {
                                    savedPairsHolder.remove(pair);
                                  } else {
                                    savedPairsHolder.add(pair);
                                  }
                                });
                              },
                              icon: alreadySaved
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icons.favorite_border),
                        );
                      });

                      final divided =
                          ListTile.divideTiles(context: context, tiles: tiles)
                              .toList();

                      pageBody = ListView(children: divided);
                    }
                    return pageBody;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }

  String _buildPairString(WordPair pair) {
    return pair.first + ' ' + pair.second;
  }
}
