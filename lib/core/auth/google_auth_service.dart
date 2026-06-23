import 'package:getmarried/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleSignIn? _googleSignIn;

  GoogleSignIn get _client {
    _googleSignIn ??= GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: AppConfig.googleServerClientId.isNotEmpty ? AppConfig.googleServerClientId : null,
      clientId: AppConfig.googleIosClientId.isNotEmpty ? AppConfig.googleIosClientId : null,
    );
    return _googleSignIn!;
  }

  Future<GoogleSignInAccount?> signIn() async {
    if (!AppConfig.isGoogleSignInConfigured) {
      throw StateError('Google Sign-In is not configured. Set GOOGLE_SERVER_CLIENT_ID or GOOGLE_IOS_CLIENT_ID.');
    }
    return _client.signIn();
  }

  Future<void> signOut() async {
    if (_googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
  }
}
