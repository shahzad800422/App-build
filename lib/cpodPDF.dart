import 'package:flutter/material.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:cpodpractice/lessonService.dart';

class CpodPDF extends StatelessWidget {
  final Map<String, dynamic> lesson;

  CpodPDF(this.lesson); 

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: mainPage(context),
    );
  }

  Future getPDF(BuildContext context) async {
    //  return Future.delayed(const Duration(milliseconds: 5000), () async {
    print(lesson);
    print(lesson['id']);
    LessonService lservice = LessonService(null);//fw!
    var pdf = await lservice.getPDF(lesson);
    print('back from get pdf');
    var pdfPath = await lservice.savePDF(lesson['id'], pdf);
    print('saved into ' + pdfPath);
    return Future.value(pdfPath);
    //  });
  }

  Widget mainPage(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            } else
              return displayPDF(snapshot.data);
          } else {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
        },
        future: getPDF(context));
  }

  Widget displayPDF(String pdfName) {
    /* fw to supress the warning due to pdf lib not in pubspec.yml
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Lesson"),
        ),
        path: pdfName);
        */
  }
}
