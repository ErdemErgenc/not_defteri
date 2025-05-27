import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';
import 'package:note_project1/pages/trash_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/widgets/clear_notes_dialog.dart';
import 'package:note_project1/widgets/delete_note_dialog.dart';
import 'package:note_project1/widgets/note_card.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';

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
            icon: Icon(
              Icons.delete_sweep,
              color: const Color.fromARGB(255, 230, 0, 0),
              size: 32.sp,
            ),
            tooltip: "Tümünü Sil",
            onPressed: () {
              if (controller.items.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => ClearNotesDialog(controller: controller),
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
                hintText: "Notunuzu buraya yazın...",
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
    return NoteCard(
      index: index,
      isGrid: isGrid.value,
      onEdit: () => _showUpdateDialog(context, index),
      onDelete: () => _showDeleteDialog(context, index),
    );
  }

  void _showUpdateDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => UpdateNoteDialog(index: index, controller: controller),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => DeleteNoteDialog(index: index, controller: controller),
    );
  }
}
