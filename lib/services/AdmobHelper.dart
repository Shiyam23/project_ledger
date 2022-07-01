import 'dart:io';

class AdmobHelper {

  static String get getInlineBannerId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    }
    throw UnsupportedError("Unsupported platform for Admob");
  }

  static String get getInterstitialVideoId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8691691433";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589807";
    }
    throw UnsupportedError("Unsupported platform for Admob");
  }
}