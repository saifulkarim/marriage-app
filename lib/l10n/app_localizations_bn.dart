// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'GetMarried';

  @override
  String get loginTitle => 'লগইন';

  @override
  String get registerTitle => 'নতুন অ্যাকাউন্ট তৈরি করুন';

  @override
  String get nameLabel => 'নাম';

  @override
  String get nameRequired => 'নাম লিখুন';

  @override
  String get emailOrMobile => 'ইমেইল বা মোবাইল';

  @override
  String get emailOrMobileRequired => 'ইমেইল বা মোবাইল লিখুন';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get passwordMin => 'কমপক্ষে ৮ অক্ষর';

  @override
  String get login => 'লগইন';

  @override
  String get register => 'রেজিস্টার';

  @override
  String get or => 'অথবা';

  @override
  String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get alreadyHaveAccount => 'অ্যাকাউন্ট আছে? লগইন';

  @override
  String get newAccountPrompt => 'নতুন অ্যাকাউন্ট? রেজিস্টার';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get navHome => 'হোম';

  @override
  String get navSearch => 'খুঁজুন';

  @override
  String get navShortlist => 'শর্টলিস্ট';

  @override
  String get navChat => 'চ্যাট';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get language => 'ভাষা';

  @override
  String get languageBn => 'বাংলা';

  @override
  String get languageEn => 'English';

  @override
  String get languageUpdated => 'ভাষা আপডেট হয়েছে';

  @override
  String get createBiodata => 'বায়োডাটা তৈরি করুন';

  @override
  String get editBiodata => 'বায়োডাটা সম্পাদনা';

  @override
  String biodataStep(int step) {
    return 'বায়োডাটা — ধাপ $step/4';
  }

  @override
  String get back => 'পিছনে';

  @override
  String get saveNext => 'সংরক্ষণ ও পরবর্তী';

  @override
  String get finish => 'শেষ';

  @override
  String get biodataSaved => 'বায়োডাটা সফলভাবে সংরক্ষিত';

  @override
  String get writeInYourLanguage => 'নিজের ভাষায় লিখুন — বাংলা বা English';

  @override
  String get contentLanguage => 'লেখার ভাষা';

  @override
  String get maintenanceDefault =>
      'অ্যাপ রক্ষণাবেক্ষণে আছে। পরে আবার চেষ্টা করুন।';

  @override
  String get googleNotConfigured => 'Google Sign-In কনফিগার করা নেই।';

  @override
  String get googleEmailRequired => 'Google অ্যাকাউন্টে ইমেইল প্রয়োজন';

  @override
  String get googleSignInFailed => 'Google সাইন-ইন ব্যর্থ';

  @override
  String get assalamuAlaikum => 'আসসালামু আলাইকুম';

  @override
  String assalamuAlaikumName(String name) {
    return 'আসসালামু আলাইকুম,\n$name';
  }

  @override
  String get findLifePartner => 'জীবনসঙ্গী খুঁজুন';

  @override
  String get trustedSubtitle =>
      'হাজার হাজার মানুষের বিশ্বস্ত।\nগুরুত্বপূর্ণ সম্পর্কের জন্য তৈরি।';

  @override
  String get recommendedMatches => 'সুপারিশকৃত ম্যাচ';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get completeBiodataForMatches => 'ম্যাচ দেখতে বায়োডাটা সম্পূর্ণ করুন';

  @override
  String get successStories => 'সফলতার গল্প';

  @override
  String get story1 =>
      'আলহামদুলিল্লাহ! আমরা GetMarried-এ একে অপরকে পেয়েছি এবং গত বছর বিয়ে করেছি।';

  @override
  String get story2 =>
      'গুরুত্বপূর্ণ বিবাহের জন্য বিশ্বস্ত প্ল্যাটফর্ম। অত্যন্ত সুপারিশকৃত!';

  @override
  String get quickSearch => 'দ্রুত খোঁজ';

  @override
  String get advancedSearch => 'উন্নত খোঁজ';

  @override
  String get basicSearch => 'সাধারণ খোঁজ';

  @override
  String get bride => 'কনে';

  @override
  String get groom => 'বর';

  @override
  String get findMatches => 'ম্যাচ খুঁজুন';

  @override
  String profileStrength(int percent) {
    return 'প্রোফাইল শক্তি: $percent%';
  }

  @override
  String get premiumMember => 'আপনি প্রিমিয়াম সদস্য';

  @override
  String planLabel(String plan) {
    return 'প্ল্যান: $plan';
  }

  @override
  String get manage => 'ম্যানেজ';

  @override
  String get connections => 'সংযোগ';

  @override
  String get views => 'ভিউ';

  @override
  String get shortlists => 'শর্টলিস্ট';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get preferences => 'পছন্দসমূহ';

  @override
  String get premium => 'প্রিমিয়াম';

  @override
  String get more => 'আরও';

  @override
  String get downloadBiodataPdf => 'বায়োডাটা PDF ডাউনলোড';

  @override
  String get privacyPriority =>
      '১০০% নিরাপদ ও গোপনীয়। আপনার গোপনীয়তা আমাদের অগ্রাধিকার।';

  @override
  String get searchByBiodataNo => 'বায়োডাটা নম্বর দিয়ে খুঁজুন';

  @override
  String get go => 'যান';

  @override
  String get clearAll => 'সব মুছুন';

  @override
  String get lessFilters => 'কম ফিল্টার';

  @override
  String get moreFilters => 'আরও ফিল্টার';

  @override
  String showMatches(int count) {
    return 'ম্যাচ দেখান ($count)';
  }

  @override
  String get reset => 'রিসেট';

  @override
  String get topMatchesForYou => 'আপনার জন্য শীর্ষ ম্যাচ';

  @override
  String get noBiodataFound => 'কোনো বায়োডাটা পাওয়া যায়নি';

  @override
  String get shortlistEmpty => 'শর্টলিস্ট খালি';

  @override
  String get saveProfilesYouLike => 'পছন্দের প্রোফাইল সংরক্ষণ করুন';

  @override
  String get noChatsYet => 'এখনো কোনো চ্যাট নেই';

  @override
  String get acceptInterestToChat =>
      'চ্যাট শুরু করতে একটি ইন্টারেস্ট গ্রহণ করুন';

  @override
  String get messages => 'বার্তা';

  @override
  String get chats => 'চ্যাট';

  @override
  String get noMessagesYet => 'এখনো কোনো বার্তা নেই';

  @override
  String get matchesForYou => 'আপনার জন্য ম্যাচ';

  @override
  String get mostRelevant => 'সবচেয়ে প্রাসঙ্গিক';

  @override
  String allMatches(int count) {
    return 'সব ম্যাচ ($count)';
  }

  @override
  String get recentlyActive => 'সম্প্রতি সক্রিয়';

  @override
  String get newMembers => 'নতুন সদস্য';

  @override
  String get age => 'বয়স';

  @override
  String get religion => 'ধর্ম';

  @override
  String get location => 'অবস্থান';

  @override
  String get education => 'শিক্ষা';

  @override
  String get noMatchesFound => 'কোনো ম্যাচ পাওয়া যায়নি';

  @override
  String get shortlisted => 'শর্টলিস্টে';

  @override
  String get getBetterMatches => 'আরও ভালো ম্যাচ পান';

  @override
  String get premiumResponses => 'প্রিমিয়াম সদস্যরা ১০ গুণ বেশি সাড়া পান';

  @override
  String get upgrade => 'আপগ্রেড';

  @override
  String get sent => 'পাঠানো';

  @override
  String get received => 'প্রাপ্ত';

  @override
  String get noInterestsYet => 'এখনো কোনো ইন্টারেস্ট নেই';

  @override
  String get contactInfo => 'যোগাযোগের তথ্য';

  @override
  String get close => 'বন্ধ';

  @override
  String get unlockContact => 'যোগাযোগ আনলক করুন';

  @override
  String get waitingGuardian => 'অভিভাবকের অনুমোদনের অপেক্ষায়';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get meetings => 'মিটিং';

  @override
  String get supportReports => 'সাপোর্ট ও রিপোর্ট';

  @override
  String get billing => 'বিলিং';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get verification => 'যাচাইকরণ';

  @override
  String get unlockedContacts => 'আনলক করা যোগাযোগ';

  @override
  String get photoAccess => 'ফটো অ্যাক্সেস';

  @override
  String get videoBiodata => 'ভিডিও বায়োডাটা';

  @override
  String get consultants => 'কনসালট্যান্ট';

  @override
  String get weddingServices => 'বিবাহ সেবা';

  @override
  String get secureTitle => '১০০% নিরাপদ';

  @override
  String get secureSubtitle => 'আপনার গোপনীয়তা আমাদের অগ্রাধিকার';

  @override
  String get verifiedTitle => 'যাচাইকৃত';

  @override
  String get verifiedSubtitle => 'আসল প্রোফাইল';

  @override
  String get genuineTitle => 'আসল';

  @override
  String get genuineSubtitle => 'গুরুত্বপূর্ণ ম্যাচ';

  @override
  String get shortcutMatches => 'ম্যাচ';

  @override
  String get shortcutPremium => 'প্রিমিয়াম';

  @override
  String get shortcutVisitors => 'ভিজিটর';

  @override
  String get shortcutShortlist => 'শর্টলিস্ট';

  @override
  String get shortcutVerified => 'যাচাইকৃত';

  @override
  String get profileLabel => 'প্রোফাইল';

  @override
  String get interest => 'ইন্টারেস্ট';

  @override
  String errorPrefix(String message) {
    return 'ত্রুটি: $message';
  }

  @override
  String get buyCredits => 'ক্রেডিট কিনুন';

  @override
  String get subscription => 'সাবস্ক্রিপশন';

  @override
  String profileId(String id) {
    return 'আইডি: $id';
  }
}
