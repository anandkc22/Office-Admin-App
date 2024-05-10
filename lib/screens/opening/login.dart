import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/opening/signin.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisibility = true;
  String? userRole;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String dropdownvalue = 'User' ;    
  final List <String> items = ['User', 'Admin'];

  Future<void> logIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (dropdownvalue == "User") {
      if (email.isEmpty || password.isEmpty) {
        CustomAlertBox(context, 'Enter required field');
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        },
      );
      
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      
        final fireBaseUser = FirebaseAuth.instance.currentUser;
      
        if (fireBaseUser != null) {
        final profile = await FirebaseFirestore.instance
            .collection("users")
            .doc(fireBaseUser.uid)
            .get();
      
        if (profile.exists) {
          setState(() {
            userRole = profile.data()?['role'];
          });
        }
      }
      
        if (userRole == "User") {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserMainScreen(index: 0,),
            ),
          );
        }
        else {
          Navigator.of(context).pop();
          CustomAlertBox(context, 'You are not an user');
        }
      
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          CustomAlertBox(context, 'Invalid email or password');
        } else {
          CustomAlertBox(context, 'An error occurred: ${e.code}');
        }
      }
    }

    else if (dropdownvalue == "Admin") {

      if (email.isEmpty || password.isEmpty) {
        CustomAlertBox(context, 'Enter required field');
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final fireBaseUser = FirebaseAuth.instance.currentUser;

        if (fireBaseUser != null) {
        final profile = await FirebaseFirestore.instance
            .collection("admins")
            .doc(fireBaseUser.uid)
            .get();

        if (profile.exists) {
          setState(() {
            userRole = profile.data()?['role'];
          });
        }
      }

        if (userRole == "Admin") {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(index: 0,),
            ),
          );
        }
        else {
          Navigator.of(context).pop();
          CustomAlertBox(context, 'You are not an admin');
        }

      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          CustomAlertBox(context, 'Invalid email or password');
        } else {
          CustomAlertBox(context, 'An error occurred: ${e.code}');
        }
      }
    }

    else {
      CustomAlertBox(context, 'Something went wrong please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
           actions: [
            GestureDetector(onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SignInPage()));
            }, 
            child: Row(
              children: [
                Icon(Icons.edit_note_outlined),
                SizedBox(width: 5,),
                Text('Sign up',
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor
                ),
                ),
              ],
            )),
            SizedBox(width: 20,),
           ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.2,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text('Login',
                      style: Theme.of(context).textTheme.displayLarge
                      ),
                      SizedBox(height: 20,),
                      Text('Login to your account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54
                        )
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(
                    horizontal: 40
                  ),
                  child: Column(
                    children: <Widget>[
                      inputField(label: 'Email', 
                      controller: _emailController),
                      SizedBox(height: 10,),
                      inputFieldPassword(label: 'Password', 
                      passwordVisibility: passwordVisibility,
                      controller: _passwordController),
                      SizedBox(height: 10,),
                      dropDownAdmin(label: 'Select role',
                      items: items,
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),),
                    loginButton(),
                    Spacer(),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownAdmin({label, items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
          ),
        ),
        SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey
            )
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownvalue,
            icon: Icon(Icons.arrow_drop_down),
            elevation: 1,
            style: TextStyle(color: Colors.black),
            padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10
            ),
            onChanged: (newValue) {
            setState(() {
              dropdownvalue = newValue ?? "";
            });
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
                ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Padding loginButton() {
    return Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: MaterialButton(
              onPressed: logIn,
              minWidth: double.infinity,
              height: 60,
              color: kPrimaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              child: Text('Login',
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField({label, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),
      ),
      SizedBox(height: 5,),
      TextField(
        controller: controller,
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
      SizedBox(height: 10,),
    ],
  );
}

Widget inputFieldPassword({label, passwordVisibility, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),
      ),
      SizedBox(height: 5,),
      TextField(
        controller: controller,
        obscureText: passwordVisibility,
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
          ),
          suffixIcon: IconButton(
            color: kPrimaryColor,
            onPressed: _togglePasswordView, 
            icon: Icon(
              passwordVisibility ? Icons.visibility_off : Icons.visibility,
            ))
        ),
      ),
      SizedBox(height: 10,),
    ],
  );
}

void _togglePasswordView() {
    setState(() {
      passwordVisibility = !passwordVisibility;
    });
  }
  
  static CustomAlertBox(BuildContext context, String text) {
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text(text,
      textAlign: TextAlign.center,
      ),
      actions: [
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
          child: Text('Ok')),
            )
          ],
        );
      }
    );
  }
}
