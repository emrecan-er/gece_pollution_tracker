import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gece_pollution_tracker/auth/create_an_account/register_screen.dart';
import 'package:gece_pollution_tracker/constants.dart';
import 'package:gece_pollution_tracker/main_page/main_page.dart';
import 'package:get/route_manager.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipPath(
            clipper: BottomConvexClipper(),
            child: Container(
                width: Get.width,
                height: Get.height / 2,
                color: kMainColor,
                child: Center(
                  child: Image.asset(
                    'assets/bulut.png',
                    scale: 1.8,
                  ),
                )),
          ),
          Text(
            'Welcome to Gece ,',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'title',
              fontSize: 25,
            ),
          ),
          Text(
            'Smart Pollution Tracker',
            style: TextStyle(
              fontFamily: 'title',
              fontSize: 28,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Kayıt ol tuşuna basarak tüm şartlarımızı kabul etmiş olursunuz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(RegisterScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width / 1.5, 50),
              ),
              child: const Text(
                'Create an Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                Get.to(MainPage());
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.green,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width / 1.5, 50),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Giriş Yapmakta sorun mu yaşıyorsunuz?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomConvexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
