import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';


void showColorGridMenu(BuildContext context, int noteIndex) {
  final AppColors appColors = AppColors();
  final NoteController controller = Get.find();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Select Color'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: appColors.cardColors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 renk yatayda
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, colorIndex) {
              final color = appColors.cardColors[colorIndex];
              return GestureDetector(
                onTap: () {
                  controller.updateItemColor(noteIndex, colorIndex);
                  Navigator.of(context).pop(); // dialogu kapat
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
