import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/widgets/color_grid_menu.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/first_dismissible_grid.dart';
import 'package:note_project1/widgets/second_dismissible_grid.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';
import '../controller/note_controller.dart';
import '../colors/colors.dart';

/// Tek bir not kartını temsil eder.
/// Grid ya da liste görünümü seçeneğine göre farklı widget'lar döner.
class NoteCard extends StatelessWidget {
  final int index;
  final bool isGrid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  NoteCard({
    super.key,
    required this.index,
    required this.isGrid,
    required this.onEdit,
    required this.onDelete,
  });

  // Controller ve renk paleti GetX ile bulunuyor
  final NoteController controller = Get.find();
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    final note = controller.items[index];

    // Renk dizisinden, notun renk indeksine göre renk seç
    final color =
        appColors.cardColors[note.colorIndex % appColors.cardColors.length];

    // Tarih formatlama - Türkçe locale kullanılıyor
    final dateText = DateFormat(
      'dd MMMM yyyy, HH:mm',
      'tr_TR',
    ).format(note.date);

    // Görünüm tipine göre uygun kart widget'ını döndür
    if (isGrid) {
      return FirstDismissibleGrid(
        note: note,
        index: index,
        controller: controller,
        color: color,
        dateText: dateText,
        onEdit: onEdit,
        onDelete: onDelete,
        showColorGridMenu: showColorGridMenu,
      );
    } else {
      return SecondDismissibleGrid(
        note: note,
        index: index,
        controller: controller,
        color: color,
        dateText: dateText,
        onEdit: onEdit,
        onDelete: onDelete,
        showColorGridMenu: showColorGridMenu,
      );
    }
  }
}
