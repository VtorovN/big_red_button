import 'package:big_red_button/utility/saved_pairs_holder.dart';
import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';

class SavedPairsScreen extends StatefulWidget {
  static const routeName = '/saved';

  @override
  _SavedPairsScreenState createState() => _SavedPairsScreenState();
}

enum ContextAction { select, delete }

class _SavedPairsScreenState extends State<SavedPairsScreen> {
  SavedPairsHolder savedPairsHolder;
  List<WordPair> selectedPairs = List<WordPair>();
  bool selectModeActive = false;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(savedPairsHolder);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    savedPairsHolder = ModalRoute.of(context).settings.arguments;

    if (selectedPairs.isEmpty) {
      selectModeActive = false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: selectModeActive
                ? AppBar(
                    title: Text('Favorites'),
                    leading: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedPairs.clear();
                            selectModeActive = false;
                          });
                        },
                        icon: Icon(Icons.clear)),
                    actions: <Widget>[
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: Text(
                                        'Are you sure you want to delete these?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          setState(() {
                                            selectedPairs.forEach((pair) {
                                              savedPairsHolder.remove(pair);
                                            });
                                            selectModeActive = false;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete))
                    ],
                  )
                : AppBar(title: Text('Favorites')),
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
                        bool isSelected = selectedPairs.contains(pair);

                        return Material(
                            child: InkWell(
                                child: Container(
                                    color: isSelected
                                        ? Colors.grey.withOpacity(0.5)
                                        : Colors.white,
                                    child: ListTile(
                                      title: Text(_buildPairString(pair),
                                          style: TextStyle(fontSize: 18)),
                                      trailing: selectModeActive
                                          ? Checkbox(
                                              activeColor: Colors.blue,
                                              value: isSelected,
                                              onChanged: (currentValue) {
                                                setState(() {
                                                  if (currentValue) {
                                                    selectedPairs.add(pair);
                                                  } else {
                                                    selectedPairs.remove(pair);
                                                  }
                                                });
                                              },
                                            )
                                          : PopupMenuButton(
                                              onSelected: (ContextAction
                                                  selectedAction) {
                                                setState(() {
                                                  switch (selectedAction) {
                                                    case ContextAction.select:
                                                      setState(() {
                                                        selectModeActive = true;
                                                        selectedPairs.add(pair);
                                                      });
                                                      break;

                                                    case ContextAction.delete:
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Delete'),
                                                              content: Text(
                                                                  'Are you sure you want to delete this?'),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                      "No"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                      "Yes"),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      savedPairsHolder
                                                                          .remove(
                                                                              pair);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });
                                                  }
                                                });
                                              },
                                              itemBuilder: (context) {
                                                List<
                                                        PopupMenuEntry<
                                                            ContextAction>>
                                                    list = List<
                                                        PopupMenuEntry<
                                                            ContextAction>>();
                                                list.add(PopupMenuItem(
                                                    child: Text("Select"),
                                                    value:
                                                        ContextAction.select));
                                                list.add(PopupMenuDivider(
                                                    height: 10));
                                                list.add(PopupMenuItem(
                                                    child: Text("Delete"),
                                                    value:
                                                        ContextAction.delete));
                                                return list;
                                              },
                                              icon: Icon(Icons.more_vert),
                                            ),
                                      onLongPress: () {
                                        setState(() {
                                          selectModeActive = true;
                                          if (isSelected) {
                                            selectedPairs.remove(pair);
                                          } else {
                                            selectedPairs.add(pair);
                                          }
                                        });
                                      },
                                      onTap: () {
                                        if (selectModeActive) {
                                          setState(() {
                                            if (isSelected) {
                                              selectedPairs.remove(pair);
                                            } else {
                                              selectedPairs.add(pair);
                                            }
                                          });
                                        }
                                      },
                                    ))));
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
