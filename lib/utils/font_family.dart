import 'package:get/utils.dart';
import 'package:qareeb/config/data_store.dart';

class FontFamily {
  // The constant name for the Arabic font.
  static const String kherbatFont = "Khebrat";

  // Helper getter to check if the current language is Arabic.
  static bool get isArabic {
    // 1. Standard way: Check the app's current locale.

    final bool isLocaleArabic = Get.locale?.languageCode == 'ar';

    // 2. Your way: Check the value you saved manually.

    final bool isStoredArabic = getData.read("lan2") == 'ar';

    // Return true if EITHER one is true.

    return isLocaleArabic || isStoredArabic;
  }

  // Each font is now a getter that checks the language before returning a font name.
  static String get gilroyRegular => isArabic ? kherbatFont : "GilroyRegular";
  static String get gilroyLight => isArabic ? kherbatFont : "GilroyLight";
  static String get gilroyBold => isArabic ? kherbatFont : "GilroyBold";
  static String get sofiaProLight => isArabic ? kherbatFont : "SofiaProLight";
  static String get sofiaProBold => isArabic ? kherbatFont : "SofiaProBold";
  static String get sofiaRegular => isArabic ? kherbatFont : "SofiaRegular";
  static String get sofiaProRegular =>
      isArabic ? kherbatFont : "SofiaProRegular";
  static String get gilroyMedium => isArabic ? kherbatFont : "Gilroy Medium";
}
