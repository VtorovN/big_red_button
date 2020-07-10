import 'package:big_red_button/utility/saved_pairs_database.dart';
import 'package:russian_words/russian_words.dart';

class SavedPairsHolder {
  SavedPairsDatabase _pairs = SavedPairsDatabase();
  List<WordPair> pairsList = List();

  SavedPairsHolder();

  Future<List<WordPair>> initList() async {
    // initialize before usage!
    pairsList = await _pairs.getPairs();
    return pairsList;
  }

  bool contains(WordPair pair) {
    return pairsList.contains(pair);
  }

  void add(WordPair pair) {
    _pairs.addPair(pair);
    pairsList.add(pair);
  }

  void remove(WordPair pair) {
    _pairs.removePair(pair);
    pairsList.remove(pair);
  }

  Set<Map<String, dynamic>> toMapsSet() {
    Set<Map<String, dynamic>> set = Set();
    pairsList.forEach((pair) {
      Map<String, dynamic> map = {'pair': _buildPairString(pair)};
      set.add(map);
    });
    return set;
  }

  String _buildPairString(WordPair pair) {
    return pair.first + ' ' + pair.second;
  }
}
