import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';

class FirstDismissibleGrid extends StatelessWidget {
  final dynamic note;
  final int index;
  final dynamic controller;
  final Color color;
  final String dateText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(BuildContext, int) showColorGridMenu;

  const FirstDismissibleGrid({
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
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Icon(Icons.edit, color: Colors.white, size: 26.sp),
      ),
      secondaryBackground: DismissBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          Get.to(UpdateNoteDialog(index: index, controller: controller));
          return false;
        } else {
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
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          controller.removeItem(index);
        }
      },
      child: InkWell(
        onDoubleTap:
            () =>
                Get.to(UpdateNoteDialog(index: index, controller: controller)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    note.text,
                    style: GoogleFonts.cabin(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[800],
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                dateText,
                style: GoogleFonts.robotoMono(
                  fontSize: 12.sp,
                  color: Color(0xFF7D7461),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black54, size: 20.sp),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 18.r,
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 18.r,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
