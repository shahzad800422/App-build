class LessonBanner {
  final String lessonId;
  final String imgUrl;
  final String videoUrl;

  const LessonBanner(this.lessonId, this.imgUrl, this.videoUrl);
}

const List<LessonBanner> Banners = const <LessonBanner>[
  const LessonBanner('4121', 'assets/images/4121.png',
      'http://embed.wistia.com/deliveries/c19aed85b27d79d0860b7494523fad7ddc67fc14.bin'),
  const LessonBanner('4123', 'assets/images/4123.png',
      'http://embed.wistia.com/deliveries/615bfb43315b711ce90104a5dd264601a3a6ad5a.bin'),
  const LessonBanner('4124', 'assets/images/4124.png',
      'https://embed-ssl.wistia.com/deliveries/efaf44d3996bea794935698707211c2d786b7788.bin'),
  const LessonBanner('4125', 'assets/images/4125.png',
      'https://embed-ssl.wistia.com/deliveries/0869d6b01309dbaa4b5cde7ffa927494f416f5f7.bin'),
  const LessonBanner('4126', 'assets/images/4126.png',
      'https://embed-ssl.wistia.com/deliveries/665db3ed07a2caa96f86165988fa820156e7e153.bin'),
  const LessonBanner('4166', 'assets/images/4166.png',
      'https://embed-ssl.wistia.com/deliveries/0beeb363f7d2246ad47459e4f43b04a088073dc0.bin'),
  const LessonBanner('4128', 'assets/images/4128.jpg',
      'https://embed-ssl.wistia.com/deliveries/8974fed378eb980497531f65a9aa3f98b33efbe2.bin'),
  const LessonBanner('4129', 'assets/images/4129.jpg',
      'http://embed.wistia.com/deliveries/b157e393ec6e5aad703603e02e3428191cc51648.bin'),
  const LessonBanner('4130', 'assets/images/4130.jpg',
      'https://embed-ssl.wistia.com/deliveries/bc9dbd3b79d7634b0cd065008120352ee0c4ac39.bin'),
];

String getLessonBanner(String lessonID) {
  var ret;
  for (int i = 0; i < Banners.length; i++) {
    var lesson = Banners[i];
    if (lesson.lessonId == lessonID) {
      ret = lesson.imgUrl;
      break;
    }
  }
  return ret;
}

LessonBanner getLessonBanner2(String lessonID) {
  var ret;
  for (int i = 0; i < Banners.length; i++) {
    var lesson = Banners[i];
    if (lesson.lessonId == lessonID) {
      ret = lesson;
      break;
    }
  }
  return ret;
}
