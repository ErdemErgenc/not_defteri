import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project1/colors/colors.dart';
import 'package:note_project1/controller/note_controller.dart';

// ignore: must_be_immutable
class NoteHome extends StatelessWidget {
  final NoteController controller = Get.put(NoteController());
  final TextEditingController _controller = TextEditingController();

  // Farklı kart renkleri listesi
  AppColors appColors = AppColors();

  NoteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.clearItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Clear All"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Write your note here...",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
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
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Note"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  // Klavye açıkken resmi gösterme
                  if (MediaQuery.of(context).viewInsets.bottom > 0) {
                    return const SizedBox.shrink();
                  }
                  return const Center(
                    child: Image(image: AssetImage("lib/assets/notebook.png")),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.items.length,
                  itemBuilder:
                      (ctx, i) => _buildCard(ctx, i, appColors.cardColors),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, dynamic app) {
    final text = controller.items[index];
    // Renk seçimi: index % renk sayısı ile döngüsel olarak renk seçiyoruz
    final color = app[index % app.length];

    return GestureDetector(
      onTap: () => _showUpdateDialog(context, index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color, // Burada dinamik renk kullanılıyor
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _showUpdateDialog(context, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeItem(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int index) {
    final editCtrl = TextEditingController(text: controller.items[index]);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Update Note"),
            content: TextField(
              controller: editCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Edit your note...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
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
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }
}
