import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

import 'package:note_project1/controller/note_controller.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/widgets/first_dismissible_grid.dart';
import 'package:note_project1/widgets/second_dismissible_grid.dart';

class TrashPage extends StatelessWidget {
  TrashPage({super.key});

  final NoteController controller = Get.find<NoteController>();
  final RxBool isGrid = false.obs;
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E3),
      appBar: AppBar(
        title: Text(
          "Çöp Kutusu",
          style: GoogleFonts.robotoSlab(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E503F),
          ),
        ),
        backgroundColor: const Color(0xFFDAB49D),
        elevation: 2,
        centerTitle: true,
        actions: [
          // Görünüm tipi değiştir (Grid / Liste)
          Obx(
            () => IconButton(
              icon: Icon(
                isGrid.value ? Icons.view_list : Icons.grid_view_rounded,
                color: const Color(0xFF5E503F),
                size: 28.sp,
              ),
              tooltip: "Görünümü Değiştir",
              onPressed: () => isGrid.toggle(),
            ),
          ),

          // Tümünü kalıcı sil butonu
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red, size: 32.sp),
            tooltip: "Tümünü Kalıcı Sil",
            onPressed: () {
              if (controller.trash.isEmpty) return;
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      backgroundColor: const Color(0xFFF0EAD2),
                      title: const Text("Çöp Kutusunu Temizle"),
                      content: const Text(
                        "Tüm notları kalıcı olarak silmek istediğinize emin misiniz?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Vazgeç",
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.clearTrash();
                            Navigator.pop(context);
                            Get.snackbar(
                              "Çöp Kutusu",
                              "Tüm notlar kalıcı olarak silindi",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: const Text("Evet"),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF5E503F)),
      ),
      body: Obx(() {
        // Çöp kutusu boşsa bilgilendirme mesajı ve animasyon göster
        if (controller.trash.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300.w,
                  height: 300.w,
                  child: const RiveAnimation.asset(
                    'lib/rive/trash_can.riv',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Çöp kutusu boş.",
                  style: GoogleFonts.specialElite(
                    fontSize: 26.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        // Grid veya Liste görünümüne göre widget döndür
        return isGrid.value
            ? GridView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.trash.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (ctx, i) => _buildTrashCard(context, i, true),
            )
            : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.trash.length,
              itemBuilder: (ctx, i) => _buildTrashCard(context, i, false),
            );
      }),
    );
  }

  /// Her bir çöp kutusu kartı (Grid ya da Liste görünümüne göre)
  Widget _buildTrashCard(BuildContext context, int index, bool isGridView) {
    final note = controller.trash[index];
    final color =
        appColors.cardColors[(note.colorIndex ?? 0) %
            appColors.cardColors.length];

    if (isGridView) {
      return FirstDismissibleGrid(
        note: note,
        index: index,
        controller: controller,
        color: color,
        dateText: DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(note.date),
        onEdit: () {}, // Çöp kutusunda düzenleme genelde olmaz, istersen ekle
        onDelete: () => _confirmDelete(context, index),
        showColorGridMenu: (ctx, idx) {},
      );
    } else {
      return SecondDismissibleGrid(
        note: note,
        index: index,
        controller: controller,
        color: color,
        dateText: DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(note.date),
        onEdit: () {}, // Çöp kutusunda düzenleme genelde olmaz
        onDelete: () => _confirmDelete(context, index),
        showColorGridMenu: (ctx, idx) {},
      );
    }
  }

  /// Kart içinde kullanılan aksiyon butonu (geri al / sil)
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20.sp),
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 18.r,
    );
  }

  /// Kalıcı silme onayı diyalogu
  Future<void> _confirmDelete(BuildContext context, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Emin misiniz?"),
            content: const Text(
              "Bu notu kalıcı olarak silmek istiyor musunuz?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Vazgeç"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sil"),
              ),
            ],
          ),
    );

    Future<bool?> confirmRestore(BuildContext context) {
      return showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Emin misiniz?"),
              content: const Text(
                "Bu notu geri almak istediğinize emin misiniz?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Vazgeç"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Geri Al"),
                ),
              ],
            ),
      );
    }

    if (result == true) {
      controller.deleteFromTrash(index);
    }
  }

  Future<bool?> _confirmRestore(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Emin misiniz?"),
            content: const Text(
              "Bu notu geri almak istediğinize emin misiniz?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Vazgeç"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Geri Al"),
              ),
            ],
          ),
    );
  }
}
