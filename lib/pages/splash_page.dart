import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/note_home/note_home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart' as rive;

/// Uygulama açılışında gösterilen Splash ekranı
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü: toplam 4 saniyelik animasyon süresi
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Ölçek (zoom) animasyonu: önce büyür, sonra sabitlenir
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.5),
        weight: 30,
      ),
    ]).animate(_controller);

    // Saydamlık (opacity) animasyonu: başta görünür, sonra yavaşça kaybolur
    _opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    _controller.forward(); // Animasyonu başlat

    // Animasyon tamamlandığında ana sayfaya geçiş yap
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 900),
            pageBuilder: (_, __, ___) => NoteHome(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Bellek sızıntısını önlemek için controller'ı yok et
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAB49D), // Arka plan rengi (retro kahve ton)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animasyonu
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              ),
              child: SizedBox(
                width: 300.w,
                height: 300.w,
                child: rive.RiveAnimation.asset(
                  "lib/rive/notebook.riv",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            // Hoş geldiniz metni
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) =>
                  Opacity(opacity: _opacityAnimation.value, child: child),
              child: Text(
                "Not Defterinize Hoşgeldiniz",
                style: GoogleFonts.robotoSlab(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E503F),
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
