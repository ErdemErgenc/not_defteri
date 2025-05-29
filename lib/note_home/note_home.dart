import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/controller/note_controller.dart';
import 'package:note_project1/pages/trash_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_project1/widgets/clear_notes_dialog.dart';
import 'package:note_project1/widgets/delete_note_dialog.dart';
import 'package:note_project1/widgets/note_card.dart';
import 'package:note_project1/widgets/update_note_dialog.dart';
import 'package:rive/rive.dart';

class NoteHome extends StatelessWidget {
  // Kontroller
  final NoteController controller = Get.put(NoteController());
  final TextEditingController _textController = TextEditingController();
  final RxBool isGrid = false.obs;

  // Renk sabitleri
  final Color backgroundColor = const Color(0xFFF8F4E3);
  final Color appBarColor = const Color(0xFFDAB49D);
  final Color titleColor = const Color(0xFF5E503F);
  final Color inputFillColor = const Color(0xFFF0EAD2);
  final Color buttonColor = const Color(0xFF9C6644);

  NoteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildTextInput(),
            SizedBox(height: 20.h),
            _buildAddButton(),
            SizedBox(height: 20.h),
            _buildNoteList(), // Not kartları (grid veya list)
          ],
        ),
      ),
      floatingActionButton: _buildFloatingTrashButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Uygulama üst çubuğu
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Notlarım",
        style: GoogleFonts.robotoSlab(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
      backgroundColor: appBarColor,
      elevation: 2,
      centerTitle: true,
      actions: [
        // Görünüm değiştirici (Grid/List)
        Obx(
          () => IconButton(
            icon: Icon(
              isGrid.value ? Icons.view_list : Icons.grid_view_rounded,
              color: titleColor,
              size: 28.sp,
            ),
            tooltip: "Görünümü Değiştir",
            onPressed: () => isGrid.value = !isGrid.value,
          ),
        ),
        // Tüm notları temizleme butonu
        IconButton(
          icon: Icon(Icons.delete_sweep, color: Colors.red, size: 32.sp),
          tooltip: "Tümünü Sil",
          onPressed: () {
            if (controller.items.isNotEmpty) {
              showDialog(
                context: Get.context!,
                builder: (_) => ClearNotesDialog(controller: controller),
              );
            }
          },
        ),
      ],
    );
  }

  /// Not yazmak için giriş alanı
  Widget _buildTextInput() {
    return TextField(
      controller: _textController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Notunuzu buraya yazın...",
        hintStyle: GoogleFonts.robotoMono(
          color: Colors.brown[300],
          fontStyle: FontStyle.italic,
          fontSize: 15.sp,
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
      style: GoogleFonts.robotoMono(fontSize: 16.sp),
    );
  }

  /// "Not Ekle" butonu
  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {
        final text = _textController.text.trim();
        if (text.isNotEmpty) {
          controller.addItem(text);
          _textController.clear();
        }
      },
      icon: Icon(Icons.add, size: 22.sp),
      label: Text("Not Ekle", style: TextStyle(fontSize: 16.sp)),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      ),
    );
  }

  /// Not listesini Grid veya List olarak gösterir
  Widget _buildNoteList() {
    return Expanded(
      child: Obx(() {
        if (controller.items.isEmpty) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 120.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320.w,
                      height: 320.w,
                      child: const RiveAnimation.asset(
                        'lib/rive/downloading_book.riv',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Henüz not yok.\nUnutulmaz bir şey ekleyin.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.specialElite(
                        fontSize: 18.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Grid görünüm
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
        }

        // Liste görünüm
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (ctx, i) => _buildNoteCard(ctx, i),
        );
      }),
    );
  }

  /// Tek bir not kartı oluşturur
  Widget _buildNoteCard(BuildContext context, int index) {
    return NoteCard(
      index: index,
      isGrid: isGrid.value,
      onEdit: () => _showUpdateDialog(context, index),
      onDelete: () => _showDeleteDialog(context, index),
    );
  }

  /// Not güncelleme dialogu
  void _showUpdateDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => UpdateNoteDialog(index: index, controller: controller),
    );
  }

  /// Not silme dialogu
  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => DeleteNoteDialog(index: index, controller: controller),
    );
  }

  /// Çöp kutusu butonu (Floating Action Button)
  Widget _buildFloatingTrashButton() {
    return Row(
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
    );
  }
}
