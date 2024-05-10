import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/opening/login.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool passwordVisibility = true;
  String userRole = "User";

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String dropdownvalue = 'User' ;    
  final List <String> items = ['User', 'Admin'];

  Future<void> signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (dropdownvalue == 'User') {
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        try {
          await saveUser('users');
        } 
        catch (e) {
          print(e);
        }
      
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserMainScreen(index: 0,),
          ),
        );
      
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'email-already-in-use') {
          CustomAlertBox(context, 'This email already in use');
        } else {
          CustomAlertBox(context, 'An error occurred: ${e.code}');
        }
      }
    }

    else if (dropdownvalue == 'Admin') {

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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        try {
          await saveUser('admins');
        } 
        catch (e) {
          print(e);
        }

        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(index: 0,),
          ),
        );

      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'email-already-in-use') {
          CustomAlertBox(context, 'This email already in use');
        } else {
          CustomAlertBox(context, 'An error occurred: ${e.code}');
        }
      }
    }

    else {
      CustomAlertBox(context, 'Something went wrong please try again.');
    }
  }

  Future <void> saveUser(String path) async {

    var fireBaseUser = await FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection(path)
    .doc(fireBaseUser?.uid)
    .set({
      "uid" : fireBaseUser?.uid,
      "username" : _usernameController.text.trim(),
      "email" : _emailController.text.trim(),
      "role" : userRole,
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
           actions: [
            GestureDetector(onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => LoginPage()));
            }, 
            child: Row(
              children: [
                Icon(Icons.login_rounded),
                SizedBox(width: 8,),
                Text('Login',
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
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height / 1.2,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text('Sign up',
                    style: Theme.of(context).textTheme.displayLarge
                    ),
                    SizedBox(height: 20,),
                    Text('Create a new account',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54
                    ),)
                ],
              ),
              Column(
                children: <Widget>[
                  inputField(label: 'Name', controller: _usernameController),
                  SizedBox(height: 10,),
                  inputField(label: 'Email', controller: _emailController),
                  SizedBox(height: 10,),
                  inputFieldPassword(label: 'Password',
                  passwordVisibility: passwordVisibility,
                  controller: _passwordController),
                  SizedBox(height: 10,),
                  dropDownAdmin(label: 'Select role',
                    items: items),
                ],
              ),
              SizedBox(height: 30,),
              SignupButton(),
              Spacer(),
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
      ],
    );
  }

  Widget SignupButton() {
    return Padding(
              padding: EdgeInsets.only(top: 3, left: 3),
              child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: MaterialButton(
              onPressed: signUp,
              minWidth: double.infinity,
              height: 60,
              color: kPrimaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              child: Text('Sign up',
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
            onPressed: _togglePasswordView,
            icon: Icon(
              passwordVisibility ? Icons.visibility_off : Icons.visibility,
            ),
            color: kPrimaryColor, 
          )
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
