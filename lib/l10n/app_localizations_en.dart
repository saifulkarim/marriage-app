// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GetMarried';

  @override
  String get loginTitle => 'Log in';

  @override
  String get registerTitle => 'Create new account';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get emailOrMobile => 'Email or mobile';

  @override
  String get emailOrMobileRequired => 'Enter email or mobile';

  @override
  String get password => 'Password';

  @override
  String get passwordMin => 'At least 8 characters';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Register';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get newAccountPrompt => 'New account? Register';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navShortlist => 'Shortlist';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get languageBn => 'বাংলা';

  @override
  String get languageEn => 'English';

  @override
  String get languageUpdated => 'Language updated';

  @override
  String get createBiodata => 'Create Biodata';

  @override
  String get editBiodata => 'Edit Biodata';

  @override
  String biodataStep(int step) {
    return 'Biodata — Step $step/4';
  }

  @override
  String get back => 'Back';

  @override
  String get saveNext => 'Save & Next';

  @override
  String get finish => 'Finish';

  @override
  String get biodataSaved => 'Biodata saved successfully';

  @override
  String get writeInYourLanguage =>
      'Write in your own words — Bangla or English';

  @override
  String get contentLanguage => 'Writing language';

  @override
  String get maintenanceDefault =>
      'App is under maintenance. Please try again later.';

  @override
  String get googleNotConfigured =>
      'Google Sign-In not configured. Set GOOGLE_SERVER_CLIENT_ID when running the app.';

  @override
  String get googleEmailRequired => 'Google account email is required';

  @override
  String get googleSignInFailed => 'Google sign-in failed';

  @override
  String get assalamuAlaikum => 'Assalamu Alaikum';

  @override
  String assalamuAlaikumName(String name) {
    return 'Assalamu Alaikum,\n$name';
  }

  @override
  String get findLifePartner => 'Find Your Life Partner';

  @override
  String get trustedSubtitle =>
      'Trusted by Thousands.\nMade for Meaningful Relationships.';

  @override
  String get recommendedMatches => 'Recommended Matches';

  @override
  String get viewAll => 'View All';

  @override
  String get completeBiodataForMatches => 'Complete biodata to see matches';

  @override
  String get successStories => 'Success Stories';

  @override
  String get story1 =>
      'Alhamdulillah! We found each other on GetMarried and got married last year.';

  @override
  String get story2 =>
      'A trusted platform for serious matrimony. Highly recommended!';

  @override
  String get quickSearch => 'Quick Search';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get basicSearch => 'Basic Search';

  @override
  String get bride => 'Bride';

  @override
  String get groom => 'Groom';

  @override
  String get findMatches => 'Find Matches';

  @override
  String profileStrength(int percent) {
    return 'Profile Strength: $percent%';
  }

  @override
  String get premiumMember => 'You are a Premium Member';

  @override
  String planLabel(String plan) {
    return 'Plan: $plan';
  }

  @override
  String get manage => 'Manage';

  @override
  String get connections => 'Connections';

  @override
  String get views => 'Views';

  @override
  String get shortlists => 'Shortlists';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get preferences => 'Preferences';

  @override
  String get premium => 'Premium';

  @override
  String get more => 'More';

  @override
  String get downloadBiodataPdf => 'Download Biodata PDF';

  @override
  String get privacyPriority =>
      '100% Secure & Confidential. Your privacy is our priority.';

  @override
  String get searchByBiodataNo => 'Search by Biodata No';

  @override
  String get go => 'Go';

  @override
  String get clearAll => 'Clear All';

  @override
  String get lessFilters => 'Less Filters';

  @override
  String get moreFilters => 'More Filters';

  @override
  String showMatches(int count) {
    return 'Show Matches ($count)';
  }

  @override
  String get reset => 'Reset';

  @override
  String get topMatchesForYou => 'Top Matches for You';

  @override
  String get noBiodataFound => 'No biodata found';

  @override
  String get shortlistEmpty => 'Shortlist is empty';

  @override
  String get saveProfilesYouLike => 'Save profiles you like';

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get acceptInterestToChat => 'Accept an interest to start chatting';

  @override
  String get messages => 'Messages';

  @override
  String get chats => 'Chats';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get matchesForYou => 'Matches for You';

  @override
  String get mostRelevant => 'Most Relevant';

  @override
  String allMatches(int count) {
    return 'All Matches ($count)';
  }

  @override
  String get recentlyActive => 'Recently Active';

  @override
  String get newMembers => 'New Members';

  @override
  String get age => 'Age';

  @override
  String get religion => 'Religion';

  @override
  String get location => 'Location';

  @override
  String get education => 'Education';

  @override
  String get noMatchesFound => 'No matches found';

  @override
  String get shortlisted => 'Shortlisted';

  @override
  String get getBetterMatches => 'Get Better Matches';

  @override
  String get premiumResponses => 'Premium members get 10x more responses';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get sent => 'Sent';

  @override
  String get received => 'Received';

  @override
  String get noInterestsYet => 'No interests yet';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get close => 'Close';

  @override
  String get unlockContact => 'Unlock contact';

  @override
  String get waitingGuardian => 'Waiting for guardian approval';

  @override
  String get notifications => 'Notifications';

  @override
  String get meetings => 'Meetings';

  @override
  String get supportReports => 'Support & Reports';

  @override
  String get billing => 'Billing';

  @override
  String get changePassword => 'Change Password';

  @override
  String get verification => 'Verification';

  @override
  String get unlockedContacts => 'Unlocked Contacts';

  @override
  String get photoAccess => 'Photo Access';

  @override
  String get videoBiodata => 'Video Biodata';

  @override
  String get consultants => 'Consultants';

  @override
  String get weddingServices => 'Wedding Services';

  @override
  String get secureTitle => '100% Secure';

  @override
  String get secureSubtitle => 'Your privacy is our priority';

  @override
  String get verifiedTitle => 'Verified';

  @override
  String get verifiedSubtitle => 'Authentic profiles';

  @override
  String get genuineTitle => 'Genuine';

  @override
  String get genuineSubtitle => 'Serious matches';

  @override
  String get shortcutMatches => 'Matches';

  @override
  String get shortcutPremium => 'Premium';

  @override
  String get shortcutVisitors => 'Visitors';

  @override
  String get shortcutShortlist => 'Shortlist';

  @override
  String get shortcutVerified => 'Verified';

  @override
  String get profileLabel => 'Profile';

  @override
  String get interest => 'Interest';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get buyCredits => 'Buy Credits';

  @override
  String get subscription => 'Subscription';

  @override
  String profileId(String id) {
    return 'ID: $id';
  }
}
