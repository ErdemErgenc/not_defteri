import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/note_controller.dart';

/// Tek bir notu silmek için onay penceresi
class DeleteNoteDialog extends StatelessWidget {
  final int index; // Silinecek notun listede bulunduğu index
  final NoteController controller;

  const DeleteNoteDialog({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2), // Vintage arka plan rengi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), // Daha yumuşak köşeler
      ),
      title: Text(
        "Notu Sil",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5E503F),
        ),
      ),
      content: Text(
        "Bu notu silmek istediğinize emin misiniz?",
        style: TextStyle(fontSize: 15.sp),
      ),
      actions: [
        // Vazgeç butonu
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Vazgeç",
            style: TextStyle(color: Colors.brown, fontSize: 15.sp),
          ),
        ),

        // Silme işlemini onaylayan buton
        ElevatedButton(
          onPressed: () {
            controller.removeItem(index); // Notu sil
            Navigator.pop(context); // Dialogu kapat
            Get.snackbar(
              "Silindi", // Başlık
              "Not silindi", // Açıklama
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.brown[100],
              colorText: Colors.black87,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Dikkat çekici silme rengi
            foregroundColor: Colors.white,
          ),
          child: Text("Evet", style: TextStyle(fontSize: 15.sp)),
        ),
      ],
    );
  }
}
