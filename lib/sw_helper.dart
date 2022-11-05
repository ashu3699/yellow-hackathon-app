import 'package:shared_preferences/shared_preferences.dart';

import 'package:splitwise_api/splitwise_api.dart';

class SplitWiseHelper {
  saveTokens(TokensHelper tokens) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tokens', [tokens.token!, tokens.tokenSecret!]);
  }

  getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokens');
  }
}
