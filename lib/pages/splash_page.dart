import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project1/note_home/note_home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart' as rive;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => NoteHome());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAB49D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300.w,
              height: 300.w,
              child: rive.RiveAnimation.asset(
                "lib/rive/notebook.riv",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Not Defterim",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5E503F),
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
