import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/note_controller.dart';

class DeleteNoteDialog extends StatelessWidget {
  final int index;
  final NoteController controller;

  const DeleteNoteDialog({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2),
      title: Text("Notu Sil", style: TextStyle(fontSize: 18.sp)),
      content: Text(
        "Bu notu silmek istediğinize emin misiniz?",
        style: TextStyle(fontSize: 15.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Vazgeç",
            style: TextStyle(color: Colors.brown, fontSize: 15.sp),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            controller.removeItem(index);
            Navigator.pop(context);
            Get.snackbar(
              "Silindi",
              "Not silindi",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          child: Text("Evet", style: TextStyle(fontSize: 15.sp)),
        ),
      ],
    );
  }
}
