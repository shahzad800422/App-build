import 'package:cpodpractice/practiceListService.dart';
import 'package:cpodpractice/types.dart';
import 'package:cpodpractice/userPreference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PracticeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<PracticeListService, PracticeModel>(
      create: (context) => PracticeModel(),
      update: (context, pList, pModel) => pModel..pService = pList,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Practice List"),
        ),
        body: vocabList(),
        bottomNavigationBar: Consumer<PracticeModel>(
          builder: (BuildContext context, PracticeModel pModel, Widget child) {
            //   return Text(value.currentUser['showName']);
            return BottomAppBar(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      pModel.clearAll();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text('tap to select\nswipe to remove'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget vocabList() {
    return Consumer2<PracticeModel, UserPreference>(
      builder: (BuildContext context, PracticeModel pService,
          UserPreference userPreference, Widget child) {
            return showVocabs(context, pService, userPreference);
          },
    );
/*
    return Consumer<PracticeModel>(
      builder: (BuildContext context, PracticeModel pService, Widget child) {
        print('list store');
        // print(pList.store.toString());
        print('list store2');
        return showVocabs(context, pService);
      },
    );*/
/*
    return Consumer<PracticeModel>(
      builder: (BuildContext context, PracticeModel pService, Widget child) {
        print('list store');
        // print(pList.store.toString());
        print('list store2');
        return showVocabs(context, pService);
      },
    ); */
  }

  Widget showVocabs(context, PracticeModel pm, UserPreference userPreference) {
    var words = pm.pService.store.getList();
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: words.length,
      itemBuilder: (BuildContext context, int index) {
        Kanji w = words[index];
        //  return _getTitle(context, w);
        print(words[index]);
        print(w.runtimeType);
        return _getTitle(context, w, userPreference.chineseStandard, index, pm);
      },
    );
  }

  Widget _getTitle(BuildContext context, Kanji w, String standard, int index,
      PracticeModel pm) {
    var chinese = standard == 'T' ? w.traditional : w.simplified;
    return Card(
      child: Dismissible(
        key: ValueKey(index),
        background: Container(
          color: Colors.redAccent,
        ),
        child: ListTile(
          title: Text(chinese), // fw tradtional?
          trailing: Text(w.pinyin),
          subtitle: Text(_getHintLine(w)),
          onTap: () {
            pm.pService.store.setCharIndex(index);
            pm.pService.save();
            Navigator.pop(context);
          },
          onLongPress: () {
            /*
            pm.pService.store.setCharIndex(index);
            pm.pService.save();
            Navigator.pop(context);*/
          },
        ),
        onDismissed: (direction) {
          pm.pService.store.removeKanji(w);
          pm.pService.dirty = true;

          var msg = '${w.simplified} removed';

          Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
        },
      ),
    );
  }
}

String _getHintLine(Kanji w) {
  if (w.source.length == 1)
    return w.english;
  else
    return '(' + w.source + ') ' + w.english;
}

class PracticeModel with ChangeNotifier {
  PracticeListService pService;

  void clearAll() {
    pService.store.clear();
    pService.dirty = true;
    pService.save();
    notifyListeners();
  }
}
