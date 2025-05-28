import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';

class SecondDismissibleGrid extends StatelessWidget {
  final dynamic note;
  final int index;
  final dynamic controller;
  final Color color;
  final String dateText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(BuildContext, int) showColorGridMenu;

  const SecondDismissibleGrid({
    super.key,
    required this.note,
    required this.index,
    required this.controller,
    required this.color,
    required this.dateText,
    required this.onEdit,
    required this.onDelete,
    required this.showColorGridMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.hashCode.toString()),
      direction: DismissDirection.endToStart,
      background: DismissBackground(),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Emin misiniz?'),
                content: Text('Bu notu silmek istediğinize emin misiniz?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Vazgeç'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Sil'),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) {
        controller.removeItem(index);
      },
      child: InkWell(
        onDoubleTap:
            () =>
                Get.to(UpdateNoteDialog(index: index, controller: controller)),
        child: Card(
          color: color,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.w),
            title: Text(
              note.text,
              style: GoogleFonts.cabin(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.brown[800],
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                dateText,
                style: GoogleFonts.robotoMono(
                  fontSize: 13.sp,
                  color: Color(0xFF7D7461),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            trailing: Wrap(
              spacing: 8.w,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.color_lens,
                    color: Colors.black54,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    showColorGridMenu(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black54, size: 22.sp),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}