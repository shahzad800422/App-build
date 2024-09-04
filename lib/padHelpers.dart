import './types.dart';

class PadUtil {
  static String makeURLSubFix(Kanji kj) {
    print('inside makeURL');
    print(kj);
    print(kj.english);
    // kj.english = 'Eng';
    var wordInfo = makeKanjiHint(kj.english);
    print(wordInfo);

    return '?kanji=${kj.simplified}&pinyin=${kj.pinyin}&defination=${wordInfo[1]}&word=${wordInfo[0]}';
  }

  static String updateURLSubFix(String url, Kanji kj) {
    String params = makeURLSubFix(kj);
    return updateQuery(url: url, params: params);
  }

  static String updateQuery({String url, String params}) {
    var pos = url?.indexOf('?');

    if (pos != -1) {
      return url.substring(0, pos) + params;
    } else
      return null;
  }

  static List<String> makeKanjiHint(String hint, {int max_size = 30}) {
    int p = hint.indexOf('(');
    int p2 = hint.indexOf(')');
    String ret1;
    String ret2;

    print(max_size);

    if (p != -1 && p2 == p + 2) {
      int splt = hint.indexOf(':');
      if (splt != -1) {
        ret1 = hint.substring(0, splt);
        ret2 = hint.substring(splt + 1);
      } else {
        ret1 = 'kanji';
        ret2 = hint;
      }
    } else {
      ret1 = 'kanji';
      ret2 = hint;
    }
    if (ret2.length > max_size)
      ret2 = ret2.substring(0, max_size); // fw check word boundry from right
    ret1 = ret1.replaceFirst('(', '%28').replaceFirst(')', '%29');
    ret2 = ret2.replaceAll('(', '%28').replaceAll(')', '%29');
    return [ret1, ret2];
  }
}

class PadStore {
  int _charIndex = 0;

  List<Kanji> _lst = [];

/*
  List<Kanji> _lst = [

    new Kanji('金', 'jin', 'gold'),
    new Kanji('木', 'mu', 'word')
  ];*/

  PadStore() {
    _charIndex = 0;
  }

  List<Kanji> getList() {
    return _lst;
  }

  bool addChar(Kanji k) {
    bool exists = false;
    for (final Kanji item in _lst) {
      if (k.simplified == item.simplified) {
        exists = true;
        break;
      }
    }
    if (!exists) _lst.add(k);
    return !exists;
  }

  // return -1 if not found
  int _search(String zi) {
    int ofs = -1;
    for (int i = 0; i < _lst.length; i++) {
      var item = _lst[i];
      if (zi == item.simplified || zi == item.traditional) {
        // fw traditional chinese?
        ofs = i;
        break;
      }
    }

    return ofs;
  }

  int addChars(List<Kanji> chars) {
    int cnt = 0;
    chars.forEach((Kanji e) {
      if (addChar(e)) cnt += 1;
    });
    return cnt;
  }

  Kanji currentChar() {
    print('_charindex');
    print(_charIndex);
    return _lst[_charIndex];
  }

  void incCharIndex(bool reverse) {
    if (!reverse) {
      _charIndex += 1;
      if (_charIndex >= _lst.length) _charIndex = 0;
    } else {
      _charIndex -= 1;
      if (_charIndex < 0) _charIndex = _lst.length - 1;
    }
  }

  int count() {
    return _lst.length;
  }

  int charIndex() {
    return _charIndex;
  }

  void setCharIndex(int index) {
    _charIndex = index;
  }

  void setCharIndexByZi(String zi) {
    int ofs = _search(zi);
    if (ofs != -1) _charIndex = ofs;
  }

  void gotoLast() {
    _charIndex = _lst.length - 1;
  }

  void clear() {

    print('store got cleared, why?');
    _lst.clear();
    _charIndex = 0;
  }

  void removeAt(int index) {
    print('removing ');
    print(_lst);
    print(index);
    print('removing done');
    _lst.removeAt(index);
    if (_charIndex > _lst.length - 1) {
      _charIndex = _lst.length - 1;
      if (_charIndex < 0) _charIndex = 0;
    }
  }

  void removeKanji(Kanji w) {
    print('removekanji');
    _lst.removeWhere((Kanji element) {
      print('removing');
      print(element);
      return element.simplified == w.simplified;
    });
    if (_charIndex > _lst.length - 1) {
      _charIndex = _lst.length - 1;
      if (_charIndex < 0) _charIndex = 0;
    }
  }
}
