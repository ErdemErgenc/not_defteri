import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/note_controller.dart';

class UpdateNoteDialog extends StatelessWidget {
  final int index;
  final NoteController controller;

  const UpdateNoteDialog({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final editCtrl = TextEditingController(text: controller.items[index].text);

    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2),
      title: Text("Edit Note", style: GoogleFonts.robotoSlab(fontSize: 18.sp)),
      content: TextField(
        controller: editCtrl,
        maxLines: 3,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          hintText: "Update your thought...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
        style: GoogleFonts.robotoMono(fontSize: 15.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(fontSize: 15.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            final newText = editCtrl.text.trim();
            if (newText.isNotEmpty) {
              controller.updateItem(index, newText);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: Text("Save", style: TextStyle(fontSize: 15.sp)),
        ),
      ],
    );
  }
}
