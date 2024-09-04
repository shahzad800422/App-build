class Lesson {
  final String name;
  final String imgUrl;
  final String type;
  final String lessonId;
  const Lesson(this.name, this.imgUrl, this.type, this.lessonId);

  String toString() {
    return '$name, $imgUrl, $type, $lessonId';
  }
}

const List<Lesson> Lessons = const <Lesson>[
  const Lesson('HSK0', 'assets/images/learn_how_to.png', '', ''),
  const Lesson('HSK1', 'assets/images/HSK-1.png', 'HSK1', '4245'),
  const Lesson('HSK1', 'assets/images/HSK-2.png', 'HSK2', '4246'),
  const Lesson('HSK1', 'assets/images/HSK-3.png', 'HSK3', '4247'),
  const Lesson('HSK1', 'assets/images/HSK-4.png', 'HSK4', '4248'),
  const Lesson('HSK1', 'assets/images/HSK-5.png', 'HSK5', '4249'),
  const Lesson('HSK1', 'assets/images/HSK-6.png', 'HSK6', '4250'),
  const Lesson('HSK1', 'assets/images/HSK-7.png', 'HSK7', '4251'),
  const Lesson('HSK1', 'assets/images/HSK-8.png', 'HSK8', '4252'),
  const Lesson('HSK1', 'assets/images/HSK-9.png', 'HSK9', '4253'),
  const Lesson('HSK1', 'assets/images/HSK-10.png', 'HSK10', '4254'),
  const Lesson('HSK1', 'assets/images/HSK-11.png', 'HSK11', '4255'),
  const Lesson('HSK1', 'assets/images/HSK-12.png', 'HSK12', '4256'),
  const Lesson('66WORDS', 'assets/images/learn_how_to.png', '', ''),
  const Lesson('66WORDS1', 'assets/images/66w1.jpg', '66WORDS1', '4121'),
  const Lesson('66WORDS2', 'assets/images/66w2.jpg', '66WORDS2', '4123'),
  const Lesson('66WORDS3', 'assets/images/66w3.jpg', '66WORDS3', '4124'),
  const Lesson('66WORDS4', 'assets/images/66w4.jpg', '66WORDS4', '4125'),
  const Lesson('66WORDS5', 'assets/images/66w5.jpg', '66WORDS5', '4126'),
  const Lesson('66WORDS6', 'assets/images/66w6.jpg', '66WORDS6', '4166'),
  const Lesson('66WORDS7', 'assets/images/66w7.jpg', '66WORDS7', '4128'),
  const Lesson('66WORDS8', 'assets/images/66w8.jpg', '66WORDS8', '4129'),
  const Lesson('66WORDS9', 'assets/images/66w9.jpg', '66WORDS9', '4130'),
];

List<Lesson> getLessonList(String appShort) {
  if (appShort == '66WORDS') {
    return List.from(
        Lessons.where((Lesson element) => element.name.startsWith('66')));
  } else if (appShort == 'HSK')
    return List.from(
        Lessons.where((Lesson element) => element.name.startsWith('HSK')));
  else
    return Lessons;
}

String getLessonIDFromType(String usrType) {
  var ret;
  for (int i = 0; i < Lessons.length; i++) {
    var lesson = Lessons[i];
    if (lesson.type == usrType) {
      ret = lesson.lessonId;
      break;
    }
  }
  return ret;
}
