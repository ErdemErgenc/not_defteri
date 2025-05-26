import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_project1/controller/note_controller.dart';

class TrashPage extends StatelessWidget {
  final NoteController controller = Get.find<NoteController>();

  TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E3),
      appBar: AppBar(
        title: Text(
          "Çöp Kutusu",
          style: GoogleFonts.robotoSlab(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E503F),
          ),
        ),
        backgroundColor: const Color(0xFFDAB49D),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Color(0xFF5E503F)),
            onPressed: () {
              controller.clearTrash();
              Get.snackbar(
                "Çöp Kutusu",
                "Tüm notlar kalıcı olarak silindi",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: "Tümünü Kalıcı Sil",
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
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.trash.length,
          itemBuilder:
              (ctx, i) => Card(
                color: const Color(0xFFF0EAD2),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.brown.withOpacity(0.13),
                    width: 1.2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    controller.trash[i].text,
                    style: GoogleFonts.cabin(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[800],
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: Color(0xFF9C6644),
                        ),
                        tooltip: "Geri Yükle",
                        onPressed: () {
                          controller.restoreFromTrash(i);
                          Get.snackbar(
                            "Geri Yüklendi",
                            "Not geri alındı",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        tooltip: "Kalıcı Sil",
                        onPressed: () {
                          controller.deleteFromTrash(i);
                        },
                      ),
                    ],
                  ),
                ),
              ),
        );
      }),
    );
  }
}
