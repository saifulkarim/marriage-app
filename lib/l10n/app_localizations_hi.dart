// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'GetMarried';

  @override
  String get loginTitle => 'लॉग इन करें';

  @override
  String get registerTitle => 'नया खाता बनाएं';

  @override
  String get nameLabel => 'नाम';

  @override
  String get nameRequired => 'नाम दर्ज करें';

  @override
  String get emailOrMobile => 'ईमेल या मोबाइल';

  @override
  String get emailOrMobileRequired => 'ईमेल या मोबाइल दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordMin => 'कम से कम 8 अक्षर';

  @override
  String get login => 'लॉग इन';

  @override
  String get register => 'रजिस्टर';

  @override
  String get or => 'या';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? लॉग इन';

  @override
  String get newAccountPrompt => 'नया खाता? रजिस्टर';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get navHome => 'होम';

  @override
  String get navSearch => 'खोजें';

  @override
  String get navShortlist => 'शॉर्टलिस्ट';

  @override
  String get navChat => 'चैट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get language => 'भाषा';

  @override
  String get languageBn => 'বাংলা';

  @override
  String get languageEn => 'English';

  @override
  String get languageUpdated => 'भाषा अपडेट हो गई';

  @override
  String get createBiodata => 'बायोडाटा बनाएं';

  @override
  String get editBiodata => 'बायोडाटा संपादित करें';

  @override
  String biodataStep(int step) {
    return 'बायोडाटा — चरण $step/4';
  }

  @override
  String get back => 'पीछे';

  @override
  String get saveNext => 'सहेजें और आगे';

  @override
  String get finish => 'समाप्त';

  @override
  String get biodataSaved => 'बायोडाटा सफलतापूर्वक सहेजा गया';

  @override
  String get writeInYourLanguage => 'अपने शब्दों में लिखें — हिंदी या English';

  @override
  String get contentLanguage => 'लेखन भाषा';

  @override
  String get maintenanceDefault =>
      'ऐप रखरखाव में है। बाद में पुनः प्रयास करें।';

  @override
  String get googleNotConfigured => 'Google Sign-In कॉन्फ़िगर नहीं है।';

  @override
  String get googleEmailRequired => 'Google खाते में ईमेल आवश्यक है';

  @override
  String get googleSignInFailed => 'Google साइन-इन विफल';

  @override
  String get assalamuAlaikum => 'अस्सलामु अलैकुम';

  @override
  String assalamuAlaikumName(String name) {
    return 'अस्सलामु अलैकुम,\n$name';
  }

  @override
  String get findLifePartner => 'जीवनसाथी खोजें';

  @override
  String get trustedSubtitle => 'हजारों का भरोसा।\nसार्थक रिश्तों के लिए बना।';

  @override
  String get recommendedMatches => 'अनुशंसित मैच';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get completeBiodataForMatches => 'मैच देखने के लिए बायोडाटा पूरा करें';

  @override
  String get successStories => 'सफलता की कहानियां';

  @override
  String get story1 =>
      'अलहम्दुलिल्लाह! हम GetMarried पर मिले और पिछले साल शादी की।';

  @override
  String get story2 =>
      'गंभीर विवाह के लिए विश्वसनीय प्लेटफॉर्म। अत्यधिक अनुशंसित!';

  @override
  String get quickSearch => 'त्वरित खोज';

  @override
  String get advancedSearch => 'उन्नत खोज';

  @override
  String get basicSearch => 'साधारण खोज';

  @override
  String get bride => 'दुल्हन';

  @override
  String get groom => 'दूल्हा';

  @override
  String get findMatches => 'मैच खोजें';

  @override
  String profileStrength(int percent) {
    return 'प्रोफ़ाइल शक्ति: $percent%';
  }

  @override
  String get premiumMember => 'आप प्रीमियम सदस्य हैं';

  @override
  String planLabel(String plan) {
    return 'प्लान: $plan';
  }

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get connections => 'कनेक्शन';

  @override
  String get views => 'व्यू';

  @override
  String get shortlists => 'शॉर्टलिस्ट';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get preferences => 'प्राथमिकताएं';

  @override
  String get premium => 'प्रीमियम';

  @override
  String get more => 'और';

  @override
  String get downloadBiodataPdf => 'बायोडाटा PDF डाउनलोड';

  @override
  String get privacyPriority =>
      '100% सुरक्षित और गोपनीय। आपकी गोपनीयता हमारी प्राथमिकता है।';

  @override
  String get searchByBiodataNo => 'बायोडाटा नंबर से खोजें';

  @override
  String get go => 'जाएं';

  @override
  String get clearAll => 'सब साफ़ करें';

  @override
  String get lessFilters => 'कम फ़िल्टर';

  @override
  String get moreFilters => 'और फ़िल्टर';

  @override
  String showMatches(int count) {
    return 'मैच दिखाएं ($count)';
  }

  @override
  String get reset => 'रीसेट';

  @override
  String get topMatchesForYou => 'आपके लिए शीर्ष मैच';

  @override
  String get noBiodataFound => 'कोई बायोडाटा नहीं मिला';

  @override
  String get shortlistEmpty => 'शॉर्टलिस्ट खाली है';

  @override
  String get saveProfilesYouLike => 'पसंदीदा प्रोफ़ाइल सहेजें';

  @override
  String get noChatsYet => 'अभी कोई चैट नहीं';

  @override
  String get acceptInterestToChat => 'चैट शुरू करने के लिए रुचि स्वीकार करें';

  @override
  String get messages => 'संदेश';

  @override
  String get chats => 'चैट';

  @override
  String get noMessagesYet => 'अभी कोई संदेश नहीं';

  @override
  String get matchesForYou => 'आपके लिए मैच';

  @override
  String get mostRelevant => 'सबसे प्रासंगिक';

  @override
  String allMatches(int count) {
    return 'सभी मैच ($count)';
  }

  @override
  String get recentlyActive => 'हाल ही में सक्रिय';

  @override
  String get newMembers => 'नए सदस्य';

  @override
  String get age => 'उम्र';

  @override
  String get religion => 'धर्म';

  @override
  String get location => 'स्थान';

  @override
  String get education => 'शिक्षा';

  @override
  String get noMatchesFound => 'कोई मैच नहीं मिला';

  @override
  String get shortlisted => 'शॉर्टलिस्ट में';

  @override
  String get getBetterMatches => 'बेहतर मैच पाएं';

  @override
  String get premiumResponses =>
      'प्रीमियम सदस्यों को 10 गुना अधिक प्रतिक्रिया मिलती है';

  @override
  String get upgrade => 'अपग्रेड';

  @override
  String get sent => 'भेजे गए';

  @override
  String get received => 'प्राप्त';

  @override
  String get noInterestsYet => 'अभी कोई रुचि नहीं';

  @override
  String get contactInfo => 'संपर्क जानकारी';

  @override
  String get close => 'बंद करें';

  @override
  String get unlockContact => 'संपर्क अनलॉक करें';

  @override
  String get waitingGuardian => 'अभिभावक की मंजूरी की प्रतीक्षा';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get meetings => 'मीटिंग';

  @override
  String get supportReports => 'सहायता और रिपोर्ट';

  @override
  String get billing => 'बिलिंग';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get verification => 'सत्यापन';

  @override
  String get unlockedContacts => 'अनलॉक किए गए संपर्क';

  @override
  String get photoAccess => 'फ़ोटो एक्सेस';

  @override
  String get videoBiodata => 'वीडियो बायोडाटा';

  @override
  String get consultants => 'सलाहकार';

  @override
  String get weddingServices => 'विवाह सेवाएं';

  @override
  String get secureTitle => '100% सुरक्षित';

  @override
  String get secureSubtitle => 'आपकी गोपनीयता हमारी प्राथमिकता';

  @override
  String get verifiedTitle => 'सत्यापित';

  @override
  String get verifiedSubtitle => 'प्रामाणिक प्रोफ़ाइल';

  @override
  String get genuineTitle => 'वास्तविक';

  @override
  String get genuineSubtitle => 'गंभीर मैच';

  @override
  String get shortcutMatches => 'मैच';

  @override
  String get shortcutPremium => 'प्रीमियम';

  @override
  String get shortcutVisitors => 'विज़िटर';

  @override
  String get shortcutShortlist => 'शॉर्टलिस्ट';

  @override
  String get shortcutVerified => 'सत्यापित';

  @override
  String get profileLabel => 'प्रोफ़ाइल';

  @override
  String get interest => 'रुचि';

  @override
  String errorPrefix(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get buyCredits => 'क्रेडिट खरीदें';

  @override
  String get subscription => 'सदस्यता';

  @override
  String profileId(String id) {
    return 'आईडी: $id';
  }
}
