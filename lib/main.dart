import 'package:big_red_button/screens/saved_pairs.dart';
import 'package:big_red_button/utility/saved_pairs_holder.dart';
import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';

void main() => runApp(BigRedButtonApp());

class BigRedButtonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'The Big Red Button',
        home: BigRedButtonHome(),
        routes: {SavedPairsScreen.routeName: (context) => SavedPairsScreen()});
  }
}

class BigRedButtonHome extends StatefulWidget {
  @override
  _BigRedButtonHomeState createState() => _BigRedButtonHomeState();
}

class _BigRedButtonHomeState extends State<BigRedButtonHome> {
  WordPair destroyedObject;
  SavedPairsHolder savedPairsHolder = SavedPairsHolder();

  @override
  Widget build(BuildContext context) {
    //savedPairsHolder.initList();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () async {
                final returnedHolder = await Navigator.pushNamed(
                        context, '/saved', arguments: savedPairsHolder)
                    as SavedPairsHolder;

                setState(() {
                  savedPairsHolder = returnedHolder;
                });
              },
            )
          ],
        ),
        body: _buildStateWithDestroyedObject());
  }

  Widget _buildStateWithDestroyedObject() {
    String destroyedObjectString;

    if (destroyedObject == null) {
      destroyedObjectString = '';
    } else {
      destroyedObjectString =
          'Вы уничтожили:\n' + _buildPairString(destroyedObject);
    }

    final alreadySaved = savedPairsHolder.contains(destroyedObject);

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('THE BIG RED BUTTON', style: TextStyle(fontSize: 30.0)),
        SizedBox(
            width: 200.0,
            height: 200.0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _generateDestroyedObject();
                });
              },
              shape: CircleBorder(
                side: BorderSide(color: Colors.black),
              ),
              backgroundColor: Colors.red,
              splashColor: Colors.deepOrange,
            )),
        Column(children: <Widget>[
          Text(
            destroyedObjectString,
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          Visibility(
              visible: destroyedObjectString.isEmpty ? false : true,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (alreadySaved) {
                        savedPairsHolder.remove(destroyedObject);
                      } else {
                        savedPairsHolder.add(destroyedObject);
                      }
                    });
                  },
                  icon: alreadySaved
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 35,
                        )
                      : Icon(Icons.favorite_border, size: 35)))
        ])
      ],
    ));
  }

  void _generateDestroyedObject() {
    destroyedObject =
        generateWordPairs(typeOfPair: TypeOfPair.adjectiveNoun).elementAt(0);
  }

  String _buildPairString(WordPair pair) {
    return pair.first + ' ' + pair.second;
  }
}
