import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/tile%20items/salary%20management/salary_management_screen.dart';

class SalaryDetails extends StatefulWidget {
  final String uid;
  const SalaryDetails({super.key, required this.uid});

  @override
  State<SalaryDetails> createState() => _SalaryDetailsState();
}

class _SalaryDetailsState extends State<SalaryDetails> {

  String currentTime = DateFormat('yMMMM').format(DateTime.now());
  String timeStamp = DateFormat('yyyy-MM').format(DateTime.now());
  TextEditingController _paymentController = TextEditingController();
  var collection = FirebaseFirestore.instance.collection("salary");
  late List date = [];
  late List amount = [];
  bool isLoaded = false;
  bool isNotPaid = true;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {
  List tempDate = [];
  List tempAmount = [];

  try {
    var data = await collection.doc(widget.uid).get();
    if (data.exists && data.data() != null) {
      data.data()?.forEach((key, value) {
        tempDate.add(key);
        tempAmount.add(value);
      });
    }
    
    setState(() {
      date = tempDate;
      amount = tempAmount;
      if (date.contains(timeStamp)) {
        isNotPaid = false;
      }
      isLoaded = true;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong. Please try again..')),
    );
  }
}

  salaryPayment() async {

    String Payment= _paymentController.text.trim();

    try {
      if (Payment.isNotEmpty) {
        var uid = widget.uid;
        var salary = await FirebaseFirestore.instance.collection('salary').doc(uid);
        var path = await FirebaseFirestore.instance.collection('salary').doc(uid).get();
      
        if (path.exists && path.data() != null) {
          salary.update({
          timeStamp: Payment,
        });
        }
        else {
          salary.set({
          timeStamp: Payment,
        });
        }
      
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SalaryDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Salary paid successfully')),
        );
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SalaryDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again..')),
        );
      }
      _paymentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment details',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              date.clear();
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => SalaryManagementScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isLoaded ? Padding(
                padding: const EdgeInsets.all(13),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [ 
                          Text("Current month", style: TextStyle(fontSize: 20),),
                          Text(currentTime, style: TextStyle(fontSize: 20),)
                        ]
                      ),
                      isNotPaid ? Column(
                        children: [
                          Row(
                            children: [
                              Text("Not paid ", style: TextStyle(color: Colors.red, fontSize: 23),),
                              Icon(Icons.cancel_outlined, color: Colors.red, size: 25,)
                            ],
                          ),
                          ElevatedButton(onPressed: () {
                            PaymentAlertBox(context);
                          }, 
                          child: Text("pay", style: TextStyle(fontSize: 23),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
                            foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          ),
                          )
                        ],
                      ) :  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("paid ", style: TextStyle(color: Colors.green, fontSize: 23),),
                              Icon(Icons.verified_outlined, color: Colors.green, size: 25,)
                            ],
                          ), 
                        ]
                      )
                    ],
                  ),
                ),
              ) : Text(''),
              SizedBox(height: 10,),
              date.isNotEmpty ? Text('History',style: TextStyle(color: kPrimaryColor, fontSize: 25),) : Text(''),
              SizedBox(
                height: MediaQuery.of(context).size.height - 125,
                child: isLoaded ? ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: date.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(date[index].toString()),
                        trailing: Text("- " + amount[index].toString(), style: TextStyle(color: Colors.green, fontSize: 18),),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ) : Center(child: CircularProgressIndicator(color: Colors.black,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic PaymentAlertBox(BuildContext context) {
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text("Enter amount",
      textAlign: TextAlign.center,
      ),
      actions: [
        Center(
              child: TextField(
                controller: _paymentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  )
                ),
              ),
            ),
            SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
          child: MaterialButton(onPressed: () {
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
          ),
          minWidth: 100,
          height: 50,
          color: kPrimaryColor,
          textColor: Colors.white, 
          child: Text('Cancel')),
        ),
        Center(
          child: MaterialButton(onPressed: salaryPayment,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
          ),
          minWidth: 100,
          height: 50,
          color: Colors.green,
          textColor: Colors.white, 
          child: Text('Pay')),
        )
          ],
        )
      ],
    );
  }
  );
}
}