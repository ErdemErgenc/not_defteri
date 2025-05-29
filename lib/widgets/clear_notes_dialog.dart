import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/controller/note_controller.dart';

/// Tüm notları çöp kutusuna taşıma işlemi için onay diyaloğu
class ClearNotesDialog extends StatelessWidget {
  final NoteController controller;

  const ClearNotesDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2), // Açık sarımsı zemin rengi
      title: const Text(
        "Tüm Notları Sil",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF5E503F), // Kahverengi ton
        ),
      ),
      content: const Text(
        "Tüm notları çöp kutusuna taşımak istediğinize emin misiniz?",
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        /// İptal butonu
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Vazgeç",
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.w600),
          ),
        ),

        /// Onay butonu
        ElevatedButton(
          onPressed: () {
            controller.moveAllToTrash(); // Tüm notları çöp kutusuna taşı
            Navigator.pop(context); // Diyaloğu kapat

            // Kullanıcıya bilgi ver
            Get.snackbar(
              "Tüm Notlar Çöp Kutusuna Taşındı",
              "Tüm notlar çöp kutusunda.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.brown[50],
              colorText: Colors.black87,
              margin: EdgeInsets.all(12.w),
              duration: const Duration(seconds: 2),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text("Evet"),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), // Köşeleri yumuşat
      ),
    );
  }
}
