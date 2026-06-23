import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GetMarried'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get registerTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @emailOrMobile.
  ///
  /// In en, this message translates to:
  /// **'Email or mobile'**
  String get emailOrMobile;

  /// No description provided for @emailOrMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter email or mobile'**
  String get emailOrMobileRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordMin.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMin;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @newAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'New account? Register'**
  String get newAccountPrompt;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navShortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get navShortlist;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageBn.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBn;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated'**
  String get languageUpdated;

  /// No description provided for @createBiodata.
  ///
  /// In en, this message translates to:
  /// **'Create Biodata'**
  String get createBiodata;

  /// No description provided for @editBiodata.
  ///
  /// In en, this message translates to:
  /// **'Edit Biodata'**
  String get editBiodata;

  /// No description provided for @biodataStep.
  ///
  /// In en, this message translates to:
  /// **'Biodata — Step {step}/4'**
  String biodataStep(int step);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @saveNext.
  ///
  /// In en, this message translates to:
  /// **'Save & Next'**
  String get saveNext;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @biodataSaved.
  ///
  /// In en, this message translates to:
  /// **'Biodata saved successfully'**
  String get biodataSaved;

  /// No description provided for @writeInYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Write in your own words — Bangla or English'**
  String get writeInYourLanguage;

  /// No description provided for @contentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Writing language'**
  String get contentLanguage;

  /// No description provided for @maintenanceDefault.
  ///
  /// In en, this message translates to:
  /// **'App is under maintenance. Please try again later.'**
  String get maintenanceDefault;

  /// No description provided for @googleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In not configured. Set GOOGLE_SERVER_CLIENT_ID when running the app.'**
  String get googleNotConfigured;

  /// No description provided for @googleEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Google account email is required'**
  String get googleEmailRequired;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get googleSignInFailed;

  /// No description provided for @assalamuAlaikum.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get assalamuAlaikum;

  /// No description provided for @assalamuAlaikumName.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum,\n{name}'**
  String assalamuAlaikumName(String name);

  /// No description provided for @findLifePartner.
  ///
  /// In en, this message translates to:
  /// **'Find Your Life Partner'**
  String get findLifePartner;

  /// No description provided for @trustedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted by Thousands.\nMade for Meaningful Relationships.'**
  String get trustedSubtitle;

  /// No description provided for @recommendedMatches.
  ///
  /// In en, this message translates to:
  /// **'Recommended Matches'**
  String get recommendedMatches;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @completeBiodataForMatches.
  ///
  /// In en, this message translates to:
  /// **'Complete biodata to see matches'**
  String get completeBiodataForMatches;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @story1.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah! We found each other on GetMarried and got married last year.'**
  String get story1;

  /// No description provided for @story2.
  ///
  /// In en, this message translates to:
  /// **'A trusted platform for serious matrimony. Highly recommended!'**
  String get story2;

  /// No description provided for @quickSearch.
  ///
  /// In en, this message translates to:
  /// **'Quick Search'**
  String get quickSearch;

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

  /// No description provided for @basicSearch.
  ///
  /// In en, this message translates to:
  /// **'Basic Search'**
  String get basicSearch;

  /// No description provided for @bride.
  ///
  /// In en, this message translates to:
  /// **'Bride'**
  String get bride;

  /// No description provided for @groom.
  ///
  /// In en, this message translates to:
  /// **'Groom'**
  String get groom;

  /// No description provided for @findMatches.
  ///
  /// In en, this message translates to:
  /// **'Find Matches'**
  String get findMatches;

  /// No description provided for @profileStrength.
  ///
  /// In en, this message translates to:
  /// **'Profile Strength: {percent}%'**
  String profileStrength(int percent);

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'You are a Premium Member'**
  String get premiumMember;

  /// No description provided for @planLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan: {plan}'**
  String planLabel(String plan);

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @connections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connections;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @shortlists.
  ///
  /// In en, this message translates to:
  /// **'Shortlists'**
  String get shortlists;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @downloadBiodataPdf.
  ///
  /// In en, this message translates to:
  /// **'Download Biodata PDF'**
  String get downloadBiodataPdf;

  /// No description provided for @privacyPriority.
  ///
  /// In en, this message translates to:
  /// **'100% Secure & Confidential. Your privacy is our priority.'**
  String get privacyPriority;

  /// No description provided for @searchByBiodataNo.
  ///
  /// In en, this message translates to:
  /// **'Search by Biodata No'**
  String get searchByBiodataNo;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @lessFilters.
  ///
  /// In en, this message translates to:
  /// **'Less Filters'**
  String get lessFilters;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @showMatches.
  ///
  /// In en, this message translates to:
  /// **'Show Matches ({count})'**
  String showMatches(int count);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @topMatchesForYou.
  ///
  /// In en, this message translates to:
  /// **'Top Matches for You'**
  String get topMatchesForYou;

  /// No description provided for @noBiodataFound.
  ///
  /// In en, this message translates to:
  /// **'No biodata found'**
  String get noBiodataFound;

  /// No description provided for @shortlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Shortlist is empty'**
  String get shortlistEmpty;

  /// No description provided for @saveProfilesYouLike.
  ///
  /// In en, this message translates to:
  /// **'Save profiles you like'**
  String get saveProfilesYouLike;

  /// No description provided for @noChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;

  /// No description provided for @acceptInterestToChat.
  ///
  /// In en, this message translates to:
  /// **'Accept an interest to start chatting'**
  String get acceptInterestToChat;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @matchesForYou.
  ///
  /// In en, this message translates to:
  /// **'Matches for You'**
  String get matchesForYou;

  /// No description provided for @mostRelevant.
  ///
  /// In en, this message translates to:
  /// **'Most Relevant'**
  String get mostRelevant;

  /// No description provided for @allMatches.
  ///
  /// In en, this message translates to:
  /// **'All Matches ({count})'**
  String allMatches(int count);

  /// No description provided for @recentlyActive.
  ///
  /// In en, this message translates to:
  /// **'Recently Active'**
  String get recentlyActive;

  /// No description provided for @newMembers.
  ///
  /// In en, this message translates to:
  /// **'New Members'**
  String get newMembers;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @noMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get noMatchesFound;

  /// No description provided for @shortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get shortlisted;

  /// No description provided for @getBetterMatches.
  ///
  /// In en, this message translates to:
  /// **'Get Better Matches'**
  String get getBetterMatches;

  /// No description provided for @premiumResponses.
  ///
  /// In en, this message translates to:
  /// **'Premium members get 10x more responses'**
  String get premiumResponses;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @noInterestsYet.
  ///
  /// In en, this message translates to:
  /// **'No interests yet'**
  String get noInterestsYet;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @unlockContact.
  ///
  /// In en, this message translates to:
  /// **'Unlock contact'**
  String get unlockContact;

  /// No description provided for @waitingGuardian.
  ///
  /// In en, this message translates to:
  /// **'Waiting for guardian approval'**
  String get waitingGuardian;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @meetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get meetings;

  /// No description provided for @supportReports.
  ///
  /// In en, this message translates to:
  /// **'Support & Reports'**
  String get supportReports;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @unlockedContacts.
  ///
  /// In en, this message translates to:
  /// **'Unlocked Contacts'**
  String get unlockedContacts;

  /// No description provided for @photoAccess.
  ///
  /// In en, this message translates to:
  /// **'Photo Access'**
  String get photoAccess;

  /// No description provided for @videoBiodata.
  ///
  /// In en, this message translates to:
  /// **'Video Biodata'**
  String get videoBiodata;

  /// No description provided for @consultants.
  ///
  /// In en, this message translates to:
  /// **'Consultants'**
  String get consultants;

  /// No description provided for @weddingServices.
  ///
  /// In en, this message translates to:
  /// **'Wedding Services'**
  String get weddingServices;

  /// No description provided for @secureTitle.
  ///
  /// In en, this message translates to:
  /// **'100% Secure'**
  String get secureTitle;

  /// No description provided for @secureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is our priority'**
  String get secureSubtitle;

  /// No description provided for @verifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedTitle;

  /// No description provided for @verifiedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authentic profiles'**
  String get verifiedSubtitle;

  /// No description provided for @genuineTitle.
  ///
  /// In en, this message translates to:
  /// **'Genuine'**
  String get genuineTitle;

  /// No description provided for @genuineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Serious matches'**
  String get genuineSubtitle;

  /// No description provided for @shortcutMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get shortcutMatches;

  /// No description provided for @shortcutPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get shortcutPremium;

  /// No description provided for @shortcutVisitors.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get shortcutVisitors;

  /// No description provided for @shortcutShortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get shortcutShortlist;

  /// No description provided for @shortcutVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get shortcutVerified;

  /// No description provided for @profileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @buyCredits.
  ///
  /// In en, this message translates to:
  /// **'Buy Credits'**
  String get buyCredits;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @profileId.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String profileId(String id);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
