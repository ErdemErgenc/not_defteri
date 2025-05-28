import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/widgets/color_grid_menu.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';
import '../controller/note_controller.dart';
import '../colors/colors.dart';

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

  final NoteController controller = Get.find();
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    final note = controller.items[index];
    final color =
        appColors.cardColors[note.colorIndex % appColors.cardColors.length];

    final dateText = DateFormat(
      'dd MMMM yyyy, HH:mm',
      'tr_TR',
    ).format(note.date);

    if (isGrid) {
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
              () => Get.to(
                UpdateNoteDialog(index: index, controller: controller),
              ),
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
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black54,
                        size: 20.sp,
                      ),
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
    } else {
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
              () => Get.to(
                UpdateNoteDialog(index: index, controller: controller),
              ),
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

  
}
