import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/widgets/dismiss_background.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';

/// Liste görünümü için not kartı.
/// Sola kaydırıldığında düzenleme, sağa kaydırıldığında silme işlemi sunar.
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

  // Düzenleme ekranına yönlendirme fonksiyonu
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
      ), // sola kaydırma arka planı
      secondaryBackground:
          const DismissBackground(), // sağa kaydırma arka planı (sil)
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _navigateToEdit();
          return false; // düzenleme ekranına git, dismiss yapma
        } else {
          // silme onayı al
          return await _showDeleteDialog(context);
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          controller.removeItem(index);
        }
      },
      child: InkWell(
        onDoubleTap: _navigateToEdit, // çift tıkla düzenleme aç
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
                  color: const Color(0xFF7D7461),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            trailing: Wrap(
              spacing: 8.w,
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
          ),
        ),
      ),
    );
  }

  /// Kaydırma arka planı için widget
  Widget _buildSwipeBackground(IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }

  /// Trailing kısmındaki ikon butonlar için yardımcı fonksiyon
  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22.sp),
      onPressed: onTap,
    );
  }

  /// Silme onay dialogu gösterir
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
