import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upi_india/upi_india.dart';
// import 'package:upi_pay/upi_pay.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
// import 'package:splitwise_api/splitwise_api.dart';

// import 'package:code_yellow/sw_helper.dart';

import 'models/expenses_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // getData() async {
  //   SplitWiseService splitWiseService = SplitWiseService.initialize(
  //       'YUCGLaZKgfvS28cLwe11TvvpAwmG2bTDIUONkjyj',
  //       'C97Fid74ks4U5EhJORqbIK7q3WETyLK1gxzLXKw1');
  //   SplitWiseHelper splitWiseHelper = SplitWiseHelper();
  //   // if (splitWiseHelper.getTokens() == null) {
  //   //   var authURL = splitWiseService.validateClient();
  //   //   print(authURL);
  //   //   //This Will print the token and also return them save them to Shared Prefs
  //   //   TokensHelper tokens = await splitWiseService.validateClient(
  //   //       verifier: 'theTokenYouGetAfterAuthorization');
  //   //   await splitWiseHelper.saveTokens(tokens);
  //   //   splitWiseService.validateClient(tokens: tokens);
  //   // } else {
  //   //   splitWiseService.validateClient(
  //   //       tokens: TokensHelper('YUCGLaZKgfvS28cLwe11TvvpAwmG2bTDIUONkjyj',
  //   //           'C97Fid74ks4U5EhJORqbIK7q3WETyLK1gxzLXKw1'));
  //   //   print(await splitWiseService.getCurrentUser());
  //   // }
  //   log(splitWiseHelper.getTokens().toString());
  // }

  UPIDetails? upiDetails;
  // final upiDetails = UPIDetails(
  //     upiID: "9572295742@ybl", payeeName: "Ashutosh Kumar", amount: 100);
  // List<ApplicationMeta> appMetaList = [];
  //upiIDController
  TextEditingController upiIDController = TextEditingController();
  UpiIndia upiIndia = UpiIndia();
  List<UpiApp>? apps;
  List<ExpensesResponse>? expensesData;
  apiCall() async {
    upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    // appMetaList = await UpiPay.getInstalledUpiApplications();
    // http.get(
    //     Uri.parse('https://secure.splitwise.com/api/v3.0/get_current_user'),
    //     headers: {
    //       'Authorization': 'Bearer EQtSHqRW1TJXgnYWOCIr0O8B2IHTjjAUkF38D2ap'
    //     }).then((response) {
    //   log(response.body);
    // });
    //http://localhost:3000/api/expenses
    var res = await http.get(Uri.parse('http://localhost:3000/api/expenses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Accept': "*/*",
          // 'connection': 'keep-alive',
          // 'Accept-Encoding': 'gzip, deflate, br',
        });
    final expensesResponse = expensesResponseFromJson(res.body);
    // log(res.body);
    setState(() {
      expensesData = expensesResponse;
    });
  }

  @override
  void initState() {
    super.initState();
    // getData();

    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Yellow'),
      ),
      // backgroundColor: Colors.amber,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
        ),
        child: cardList(),
      ),
    );
  }

  // getList() {
  //   return Column(
  //     children: [
  //       //show expenses in  listview builder
  //       Expanded(
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: expensesData?.length,
  //           itemBuilder: (context, index) {
  //             //for each expense description show the name and amount
  //             return Column(
  //               children: [
  //                 ListTile(
  //                   title: Text(expensesData?[index].description ?? ''),
  //                   subtitle: Text(
  //                       'Total expense: ${expensesData?[index].cost.toString() ?? ''}'),
  //                 ),
  //                 getUsers(expensesData?[index].users),
  //               ],
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  cardList() {
    return ListView.builder(
      itemCount: expensesData?.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.grey,
                  ],
                  stops: [
                    0.0,
                    1.0
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated)),
          child: Column(
            children: [
              ListTile(
                title: Text(expensesData?[index].description ?? ''),
                trailing: Text(
                    'Total expense: ${expensesData?[index].cost.toString() ?? ''}'),
                subtitle: Text(
                    'Date: ${expensesData?[index].date.toString().substring(0, 10)}'),
              ),
              getUsers(expensesData?[index].users),
            ],
          ),
        );
      },
    );
  }

  getUsers(List<User>? expenseData) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expenseData!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            upiIDController.clear();
            showDialog(
                context: context,
                builder: (context) => dialogBox(expenseData[index].user,
                    double.parse(expenseData[index].netBalance).abs()));
          },
          child: ListTile(
            leading: ClipOval(
                child: Image.network(expenseData[index].user.picture.medium)),
            minVerticalPadding: 20,
            title: Text(expenseData[index].user.firstName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paid:${expenseData[index].paidShare}'),
                if (double.parse(expenseData[index].netBalance) < 0)
                  Text(
                      'Owes:${double.parse(expenseData[index].netBalance) * -1}'),
                if (double.parse(expenseData[index].paidShare) > 0)
                  Text(
                      'You are owed:${double.parse(expenseData[index].netBalance)}')
              ],
            ),
          ),
        );
      },
    );
  }

  dialogBox(CreatedBy user, amount) {
    return AlertDialog(
      title: const Text('Pay'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(user.firstName.toString()),

          const SizedBox(
            height: 10,
          ),
          //show amount
          Text('Amount: $amount'),
          // if (upiIDController.text.isNotEmpty)
          const SizedBox(
            height: 10,
          ),
          //enter upi id
          TextField(
            controller: upiIDController,
            decoration: const InputDecoration(
                labelText: 'Enter UPI ID', border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Upi apps available'),

          // if (apps!.isNotEmpty)
          for (var app in apps!) appWidget(app),
          // appWidget(appMetaList[0]),
          ElevatedButton(
            onPressed: () async {
              // UPIPaymentQRCode(
              //   upiDetails: upiDetails,
              //   size: 200,
              // );
              Navigator.pop(context);
              upiDetails = UPIDetails(
                  upiID: upiIDController.text,
                  payeeName: user.firstName,
                  transactionNote:
                      'Payment for ${user.firstName} from Code Yellow',
                  amount: amount);
              showDialog(
                  context: context,
                  builder: (context) => qrCode(user.firstName, amount));
            },
            child: const Text('Pay with QR'),
          )
        ],
      ),
    );
  }

  qrCode(name, amount) {
    return AlertDialog(
      title: const Text('Pay with QR'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name),
          const SizedBox(
            height: 10,
          ),
          //show amount
          Text('Amount: $amount'),
          // if (upiIDController.text.isNotEmpty)
          const SizedBox(
            height: 10,
          ),
          UPIPaymentQRCode(
            upiDetails: upiDetails!,
            size: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          //cancel button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return upiIndia.startTransaction(
      app: app,
      receiverUpiId: "9078600498@ybl",
      receiverName: 'Payee Name',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
  }

  Widget appWidget(UpiApp app) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // app.icon,
        // // Logo
        // Image.file(
        //   File.fromRawPath(app.icon),
        //   height: 50,
        //   width: 50,
        // ),

        Container(
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.center,
          child: Text(
            // appMeta.upiApplication.getAppName(),
            app.name,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
