import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';

/// Notların grid görünümündeki kartı. Sürüklenerek silinebilir, düzenlenebilir ve renk değiştirilebilir.
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

  /// Notu düzenleme sayfasına geçiş
  void _navigateToEdit() {
    Get.to(UpdateNoteDialog(index: index, controller: controller));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.hashCode.toString()),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(
        Icons.edit,
        Colors.green,
      ), // sola sürükleme
      secondaryBackground: const DismissBackground(), // sağa sürükleme (silme)
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _navigateToEdit(); // sola sürükleme -> düzenleme
          return false;
        } else {
          return await _showDeleteDialog(
            context,
          ); // sağa sürükleme -> silme onayı
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          controller.removeItem(index);
        }
      },
      child: InkWell(
        onDoubleTap: _navigateToEdit, // çift tıklama ile düzenle
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
              // Not metni
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
              // Tarih
              Text(
                dateText,
                style: GoogleFonts.robotoMono(
                  fontSize: 12.sp,
                  color: const Color(0xFF7D7461),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6.h),
              // Sağ alt köşedeki ikonlar: renk, düzenle, sil
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _iconBtn(
                    Icons.color_lens,
                    Colors.purple,
                    () => showColorGridMenu(context, index),
                  ),
                  _iconBtn(Icons.edit, Colors.green, onEdit),
                  _iconBtn(Icons.delete, Colors.red, onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sola sürükleme arka planı (düzenleme için)
  Widget _buildSwipeBackground(IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }

  /// Not kartı altındaki ikon buton yapısı
  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20.sp),
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 18.r,
    );
  }

  /// Silme işlemi için onay dialogu
  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Emin misiniz?'),
            content: const Text('Bu notu silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Vazgeç'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sil'),
              ),
            ],
          ),
    );
  }
}
