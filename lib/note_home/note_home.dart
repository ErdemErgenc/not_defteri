import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';
import 'package:note_project1/pages/trash_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteHome extends StatelessWidget {
  final NoteController controller = Get.put(NoteController());
  final TextEditingController _controller = TextEditingController();
  final AppColors appColors = AppColors();
  final RxBool isGrid = false.obs;

  NoteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E3),
      appBar: AppBar(
        title: Text(
          "Notlarım",
          style: GoogleFonts.robotoSlab(
            fontSize: 24.sp,
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
            icon: Icon(Icons.delete_sweep, color: Colors.red, size: 32.sp),
            tooltip: "Tümünü Sil",
            onPressed: () {
              if (controller.items.isNotEmpty) {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        backgroundColor: const Color(0xFFF0EAD2),
                        title: Text(
                          "Tüm Notları Sil",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        content: Text(
                          "Tüm notları silmek istediğinize emin misiniz?",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Vazgeç",
                              style: TextStyle(
                                color: Colors.brown,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.clearItems();
                              Navigator.pop(context);
                              Get.snackbar(
                                "Tüm Notlar Silindi",
                                "Tüm notlar kaldırıldı",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              "Evet",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                        ],
                      ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "İlk notunuzu buraya yazın...",
                hintStyle: GoogleFonts.robotoMono(
                  color: Colors.brown[300],
                  fontStyle: FontStyle.italic,
                  fontSize: 15.sp,
                ),
                filled: true,
                fillColor: const Color(0xFFF0EAD2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.robotoMono(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  controller.addItem(text);
                  _controller.clear();
                }
              },
              icon: Icon(Icons.add, size: 22.sp),
              label: Text("Not Ekle", style: TextStyle(fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C6644),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return Center(
                    child: Text(
                      "Henüz not yok.\nUnutulmaz bir şey ekleyin.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.specialElite(
                        fontSize: 18.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  );
                }
                if (isGrid.value) {
                  return GridView.builder(
                    itemCount: controller.items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.85,
                      
                    ),
                    itemBuilder: (ctx, i) => _buildNoteCard(ctx, i),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (ctx, i) => _buildNoteCard(ctx, i),
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "trash",
            backgroundColor: Colors.redAccent,
            onPressed: () {
              Get.to(() => TrashPage());
            },
            tooltip: "Çöp Kutusu",
            child: Icon(Icons.delete, size: 26.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, int index) {
    final note = controller.items[index];
    final color = appColors.cardColors[index % appColors.cardColors.length];

    // Grid görünümünde farklı, list görünümünde farklı widget döndür
    if (isGrid.value) {
      return Dismissible(
        key: Key(note.text + index.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          controller.removeItem(index);
          Get.snackbar(
            "Not Silindi",
            "Not kaldırıldı",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        background: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(Icons.delete, color: Colors.white, size: 26.sp),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color,
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
                    icon: Icon(Icons.edit, color: Colors.black54, size: 20.sp),
                    onPressed: () => _showUpdateDialog(context, index),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    splashRadius: 18.r,
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                    onPressed: () => _showDeleteDialog(context, index),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    splashRadius: 18.r,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Liste görünümü (ListTile ile)
      return Dismissible(
        key: Key(note.text + index.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          controller.removeItem(index);
          Get.snackbar(
            "Not Silindi",
            "Not kaldırıldı",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        background: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(Icons.delete, color: Colors.white, size: 26.sp),
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
                  icon: Icon(Icons.edit, color: Colors.black54, size: 22.sp),
                  onPressed: () => _showUpdateDialog(context, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                  onPressed: () => _showDeleteDialog(context, index),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _showUpdateDialog(BuildContext context, int index) {
    final editCtrl = TextEditingController(text: controller.items[index].text);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFFF0EAD2),
            title: Text(
              "Edit Note",
              style: GoogleFonts.robotoSlab(fontSize: 18.sp),
            ),
            content: TextField(
              controller: editCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                hintText: "Update your thought...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.robotoMono(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(fontSize: 15.sp)),
              ),
              ElevatedButton(
                onPressed: () {
                  final newText = editCtrl.text.trim();
                  if (newText.isNotEmpty) {
                    controller.updateItem(index, newText);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: Text("Save", style: TextStyle(fontSize: 15.sp)),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFFF0EAD2),
            title: Text("Notu Sil", style: TextStyle(fontSize: 18.sp)),
            content: Text(
              "Bu notu silmek istediğinize emin misiniz?",
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.brown, fontSize: 15.sp),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.removeItem(index);
                  Navigator.pop(context);
                  Get.snackbar(
                    "Silindi",
                    "Not silindi",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text("Evet", style: TextStyle(fontSize: 15.sp)),
              ),
            ],
          ),
    );
  }
}
