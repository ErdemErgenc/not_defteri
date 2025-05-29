import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/colors/colors.dart';
import '../controller/note_controller.dart';

/// Not düzenleme işlemi için açılan dialog.
/// Kullanıcı notu buradan güncelleyebilir.
class UpdateNoteDialog extends StatefulWidget {
  final int index;
  final NoteController controller;

  const UpdateNoteDialog({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  State<UpdateNoteDialog> createState() => _UpdateNoteDialogState();
}

class _UpdateNoteDialogState extends State<UpdateNoteDialog> {
  late TextEditingController editCtrl;
  late int selectedColorIndex; // Renk seçimi (şimdilik dışarıdan ayarlanabilir)
  final AppColors appColors = AppColors();

  @override
  void initState() {
    super.initState();
    // Düzenlenecek notu al, text ve renk indexini başlat
    final note = widget.controller.items[widget.index];
    editCtrl = TextEditingController(text: note.text);
    selectedColorIndex = note.colorIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF0EAD2), // Açık retro bej arka plan
      title: Text(
        "Notu Düzenle",
        style: GoogleFonts.robotoSlab(fontSize: 18.sp),
      ),
      content: SizedBox(
        height: 200.h,
        width: 300.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Not metnini düzenleme alanı
            TextField(
              controller: editCtrl,
              maxLines: 6, // Daha uzun metinler için
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                hintText: "Notunu güncelle...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.robotoMono(fontSize: 15.sp),
            ),
            SizedBox(height: 16.h),
            // İstersen buraya renk seçim widget'ı eklenebilir.
          ],
        ),
      ),
      actions: [
        // İptal butonu
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("İptal", style: TextStyle(fontSize: 15.sp)),
        ),
        // Kaydet butonu
        ElevatedButton(
          onPressed: () {
            final newText = editCtrl.text.trim();
            if (newText.isNotEmpty) {
              widget.controller.updateItem(
                widget.index,
                newText,
                selectedColorIndex,
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: Text("Kaydet", style: TextStyle(fontSize: 15.sp)),
        ),
      ],
    );
  }
}
