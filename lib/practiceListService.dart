import 'dart:async';

import 'package:cpodpractice/contentService.dart';
import 'package:cpodpractice/padHelpers.dart';
import 'package:cpodpractice/types.dart';

class PracticeListService {
  ContentService contentService;

  PadStore _store = PadStore();

  PadStore get store => _store;

  bool dirty;
  bool loaded;

  save() async {
    print('saving');
    if (dirty == true) {
      print(_store.getList());
      await contentService.saveList(name: 'current', words: _store.getList());
      dirty = false;
    }
  }

  Future retrieve() {
    Completer c = Completer();

    contentService.getCurrentList().then((value) {
      if (loaded != true) {
        List<Kanji> lst = value;
        _store.addChars(lst);
        loaded = true;
        c.complete();
      } else {
        c.complete();
      }
    });
    return c.future;
  }

  eraseAll() {
    dirty = false;
    loaded = false;
    _store.clear();
  }
}
