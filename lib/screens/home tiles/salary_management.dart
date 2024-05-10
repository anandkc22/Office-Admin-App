import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/size.dart';
import 'package:office_administrator_app/screens/tile%20items/salary%20management/salary_management_screen.dart';

class SalaryManagement extends StatelessWidget {

  const SalaryManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => SalaryManagementScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: .05
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/icons/salary.png',
                height: kCategoryCardImageSize,
                ),
            ),
            SizedBox(height: 5,),
            Text('Salary\nManagement',
            style: TextStyle(
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
    );
  }
}