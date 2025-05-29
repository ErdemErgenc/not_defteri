import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_project1/note_home/note_home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note_project1/pages/splash_page.dart';

/// Uygulamanın giriş noktası
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter bağlamını başlat
  await GetStorage.init(); // Kalıcı veri depolama için GetStorage'ı başlat
  await initializeDateFormatting(
    'tr_TR',
    null,
  ); // Türkçe tarih formatlarını yükle
  runApp(const MyApp()); // Uygulamayı başlat
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 915), // Tasarım için temel ekran boyutu (px)
      minTextAdapt:
          true, // Metin boyutunun ekran boyutuna uyum sağlamasını sağlar
      splitScreenMode: true, // Split screen desteği için
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, // Sağ üstteki debug banner'ı gizle
          title: 'Note App',
          // İlk açılan sayfa (SplashPage)
          home: SplashPage(),
        );
      },
    );
  }
}
