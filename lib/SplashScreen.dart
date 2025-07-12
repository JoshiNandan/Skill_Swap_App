import 'package:flutter/material.dart';
import 'package:skill_swap_app/screen/login_page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 70),
              Text(
                'Skill Swap App',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 380),
              Row(
                children: [
                  SizedBox(width: 20),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(40),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 70,
                  //         offset: Offset(5, 10),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Image.asset("images/skill.png"),
                  // ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Hope To Make Your Journey Effortless..',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
