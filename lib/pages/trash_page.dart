import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/controller/note_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TrashPage extends StatelessWidget {
  final NoteController controller = Get.find<NoteController>();
  final RxBool isGrid = false.obs;

  TrashPage({super.key});

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
          Obx(
            () => IconButton(
              icon: Icon(
                isGrid.value ? Icons.view_list : Icons.grid_view_rounded,
                color: const Color(0xFF5E503F),
                size: 28.sp,
              ),
              tooltip: "Görünümü Değiştir",
              onPressed: () => isGrid.value = !isGrid.value,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Color(0xFF5E503F)),
            tooltip: "Tümünü Kalıcı Sil",
            onPressed: () {
              controller.clearTrash();
              Get.snackbar(
                "Çöp Kutusu",
                "Tüm notlar kalıcı olarak silindi",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF5E503F)),
      ),
      body: Obx(() {
        if (controller.trash.isEmpty) {
          return Center(
            child: Text(
              "Çöp kutusu boş.",
              style: GoogleFonts.specialElite(
                fontSize: 18.sp,
                color: Colors.grey[700],
              ),
            ),
          );
        }
        if (isGrid.value) {
          return GridView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.trash.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.w,
              mainAxisSpacing: 14.h,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (ctx, i) => _buildTrashCard(ctx, i, true),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.trash.length,
            itemBuilder: (ctx, i) => _buildTrashCard(ctx, i, false),
          );
        }
      }),
    );
  }

  Widget _buildTrashCard(BuildContext context, int index, bool isGrid) {
    final note = controller.trash[index];

    if (isGrid) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EAD2),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 2),
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
              DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(note.date),
              style: GoogleFonts.robotoMono(
                fontSize: 12.sp,
                color: Colors.brown[400],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.restore, color: Colors.green, size: 20.sp),
                  onPressed: () {
                    controller.restoreFromTrash(index);
                    Get.snackbar(
                      "Geri Yüklendi",
                      "Not geri alındı",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashRadius: 18.r,
                ),
                SizedBox(width: 4.w),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                  onPressed: () {
                    controller.deleteFromTrash(index);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashRadius: 18.r,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Liste görünümü
      return Card(
        color: const Color(0xFFF0EAD2),
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
              DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(note.date),
              style: GoogleFonts.robotoMono(
                fontSize: 13.sp,
                color: Colors.brown[400],
              ),
            ),
          ),
          trailing: Wrap(
            spacing: 8.w,
            children: [
              IconButton(
                icon: Icon(Icons.restore, color: Colors.green, size: 22.sp),
                onPressed: () {
                  controller.restoreFromTrash(index);
                  Get.snackbar(
                    "Geri Yüklendi",
                    "Not geri alındı",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                onPressed: () {
                  controller.deleteFromTrash(index);
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
