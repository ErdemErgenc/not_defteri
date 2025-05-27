import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/controller/note_controller.dart';

class ClearNotesDialog extends StatelessWidget {
  final NoteController controller;

  const ClearNotesDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2),
      title: const Text("Tüm Notları Sil"),
      content: const Text(
        "Tüm notları çöp kutusuna taşımak istediğinize emin misiniz?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Vazgeç", style: TextStyle(color: Colors.brown)),
        ),
        ElevatedButton(
          onPressed: () {
            controller.moveAllToTrash();
            Navigator.pop(context);
            Get.snackbar(
              "Tüm Notlar Çöp Kutusuna Taşındı",
              "Tüm notlar çöp kutusunda.",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text("Evet"),
        ),
      ],
    );
  }
}
