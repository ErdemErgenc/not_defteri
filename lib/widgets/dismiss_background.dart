import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Sürükleyerek silme işlemi sırasında gösterilen kırmızı arka plan ve çöp kutusu ikonu
class DismissBackground extends StatelessWidget {
  const DismissBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ), // Her not kartı arasında boşluk
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ), // Sağdan ikon için boşluk
      alignment: Alignment.centerRight, // İkonu sağa hizala
      decoration: BoxDecoration(
        color: Colors.redAccent, // Silme işlemi için kırmızı vurgu rengi
        borderRadius: BorderRadius.circular(15.r), // Köşeleri yumuşat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Hafif gölge efekti
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 26.sp, // Responsive ikon boyutu
      ),
    );
  }
}
