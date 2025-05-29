import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';

/// Notun arka plan rengini değiştirmek için renk seçim ızgarası
void showColorGridMenu(BuildContext context, int noteIndex) {
  final AppColors appColors = AppColors();
  final NoteController controller = Get.find();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Not Rengini Seç',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5E503F),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: appColors.cardColors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Yatayda 5 renk kutusu
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, colorIndex) {
              final color = appColors.cardColors[colorIndex];

              return GestureDetector(
                onTap: () {
                  controller.updateItemColor(
                    noteIndex,
                    colorIndex,
                  ); // Rengi güncelle
                  Navigator.of(context).pop(); // Dialogu kapat
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                ),
              );
            },
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC), // Hafif bej zemin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Yumuşatılmış köşeler
        ),
      );
    },
  );
}
