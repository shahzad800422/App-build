class Config {
  static String BASE_AUDIO_URL = "https://chinesepod-recap.s3.amazonaws.com/";
  static String BASE_API_URL = "https://ws.chinesepod.com:444/";

  static String GET_CODE_URL =
      BASE_API_URL + "1.0.0/instances/prod/device/get-code";

  static String CHECK_CODE_URL =
      BASE_API_URL + "1.0.0/instances/prod/device/check-code";
  static String CHECK_SESSION_ID =
      BASE_API_URL + "1.0.0/instances/prod/main/check-sessionid";
  static String GET_LESSON_ID =
      "https://www.chinesepod.com/api/v1/recap/get-lessons";
  static String LOGIN = BASE_API_URL + "1.0.0/instances/prod/main/login";
  static String NO_RECAP = BASE_AUDIO_URL + "Not.Available.jpg";

  static final String PLAYBACK_CHANNEL_ID = "playback_channel";
  static final int PLAYBACK_NOTIFICATION_ID = 1;
  static final int DOWNLOAD_NOTIFICATION_ID = 2;
  static final int NEW_LESSON = 3;

  static final int RECAP_JOB_SERVICE_ID = 4;

  static final String MEDIA_SESSION_TAG = "audio_demo";
  static final String DOWNLOAD_CHANNEL_ID = "download_channel";

  static final int JOB_REPEAT_TIME = 5;
}
