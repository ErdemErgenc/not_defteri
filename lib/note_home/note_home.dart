import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';
import 'package:note_project1/pages/trash_page.dart';
import 'package:intl/intl.dart';

class NoteHome extends StatelessWidget {
  final NoteController controller = Get.put(NoteController());
  final TextEditingController _controller = TextEditingController();
  final AppColors appColors = AppColors();

  NoteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E3),
      appBar: AppBar(
        title: Text(
          "Notlarım",
          style: GoogleFonts.robotoSlab(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E503F),
          ),
        ),
        backgroundColor: const Color(0xFFDAB49D),
        elevation: 2,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                ),
                filled: true,
                fillColor: const Color(0xFFF0EAD2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.robotoMono(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  controller.addItem(text);
                  _controller.clear();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Not Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C6644),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return Center(
                    child: Text(
                      "Henüz not yok.\nUnutulmaz bir şey ekleyin.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.specialElite(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (ctx, i) => _buildNoteCard(ctx, i),
                );
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
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, int index) {
    final note = controller.items[index];
    final color = appColors.cardColors[index % appColors.cardColors.length];

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
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            note.text,
            style: GoogleFonts.cabin(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.brown[800],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(note.date),
              style: GoogleFonts.robotoMono(
                fontSize: 13,
                color: Colors.brown[400],
              ),
            ),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: () => _showUpdateDialog(context, index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int index) {
    final editCtrl = TextEditingController(text: controller.items[index].text);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFFF0EAD2),
            title: Text("Edit Note", style: GoogleFonts.robotoSlab()),
            content: TextField(
              controller: editCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                hintText: "Update your thought...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.robotoMono(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
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
                child: const Text("Save"),
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
            title: const Text("Notu Sil"),
            content: const Text("Bu notu silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.brown),
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
                child: const Text("Evet"),
              ),
            ],
          ),
    );
  }
}
