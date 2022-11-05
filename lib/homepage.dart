import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upi_india/upi_india.dart';

import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

import 'expenses_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UPIDetails? upiDetails;
  TextEditingController upiIDController = TextEditingController();
  UpiIndia upiIndia = UpiIndia();
  List<UpiApp>? apps;
  List<ExpensesResponse>? expensesData;
  var userData;
  apiCall() async {
    var url = Uri.parse('https://codeyellow.herokuapp.com/api/me');
    var response = await http.get(url);

    var res = await http.get(
      Uri.parse('https://codeyellow.herokuapp.com/api/expenses'),
    );
    final expensesResponse = expensesResponseFromJson(res.body);

    userData = jsonDecode(response.body);
    expensesData = expensesResponse;

    upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Yellow'),
      ),
      body: (expensesData == null)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          userData['picture']['medium'],
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Current User: ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData['first_name'] +
                                    ' ' +
                                    userData['last_name'],
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Email: ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData['email'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: cardList())
              ],
            ),
    );
  }

  cardList() {
    return ListView.builder(
      itemCount: expensesData!.length,
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
                title: Text(expensesData![index].description ?? ''),
                trailing: Text(
                    'Total expense: ${expensesData![index].cost.toString()}'),
                subtitle: Text(
                    'Date: ${expensesData![index].date.toString().substring(0, 10)}'),
              ),
              getUsers(expensesData![index].users),
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
          Text('Amount: $amount'),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: upiIDController,
            decoration: const InputDecoration(
                labelText: 'Enter UPI ID', border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
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
            child: const Text('Pay'),
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
          Text('Amount: $amount'),
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
          Text(upiIDController.text),
          const SizedBox(
            height: 10,
          ),
          const Text('Upi apps available'),
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: apps!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return appWidget(apps![index], upiIDController.text, name,
                      amount, 'Payment for $name from Code Yellow');
                }),
          ),
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

  Future<UpiResponse> initiateTransaction(
      UpiApp app, String upi, String name, double amount, String note) async {
    return upiIndia.startTransaction(
      app: app,
      receiverUpiId: upi,
      receiverName: name,
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: note,
      amount: amount,
    );
  }

  Widget appWidget(
      UpiApp app, String upi, String name, double amount, String note) {
    return GestureDetector(
      onTap: () {
        initiateTransaction(app, upi, name, amount, note).then((value) {
          print(value);
        });
      },
      child: Image.memory(
        (app.icon),
        height: 50,
        width: 50,
      ),
    );
  }
}
