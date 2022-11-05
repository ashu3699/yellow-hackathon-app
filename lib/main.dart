// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splitwise_api/splitwise_api.dart';

import 'homepage.dart';
// import 'sw_helper.dart';

void main() async {
  //ensure initialized
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();

  // SplitWiseService splitWiseService = SplitWiseService.initialize(
  //     'YUCGLaZKgfvS28cLwe11TvvpAwmG2bTDIUONkjyj',
  //     'C97Fid74ks4U5EhJORqbIK7q3WETyLK1gxzLXKw1');

  /// SplitWiseHelper is for saving and retrieving from shared storage
  // SplitWiseHelper splitWiseHelper = SplitWiseHelper();
  // if (splitWiseHelper.getTokens() == null) {
  //   var authURL = splitWiseService.validateClient();
  //   log(authURL);
  //   //This Will print the token and also return them save them to Shared Prefs
  //   TokensHelper tokens = await splitWiseService.validateClient(
  //       verifier: 'EQtSHqRW1TJXgnYWOCIr0O8B2IHTjjAUkF38D2ap');
  //   await splitWiseHelper.saveTokens(tokens);

  //   splitWiseService.validateClient(tokens: tokens);
  // } else {
  //   splitWiseService.validateClient(
  //       tokens: TokensHelper('YUCGLaZKgfvS28cLwe11TvvpAwmG2bTDIUONkjyj',
  //           'C97Fid74ks4U5EhJORqbIK7q3WETyLK1gxzLXKw1'));
  //   print(await splitWiseService.getCurrentUser());
  //   log('HardCode Authorization');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Code Yellow',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
