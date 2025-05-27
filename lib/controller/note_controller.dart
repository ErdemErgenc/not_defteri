import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_project1/controller/note_item.dart';

class NoteController extends GetxController {
  static const _storageKey = 'notes2';
  static const _trashKey = 'trash_notes';
  final box = GetStorage();
  var items = <NoteItem>[].obs;
  var trash = <NoteItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    List? stored = box.read<List>(_storageKey);
    if (stored != null) {
      items.assignAll(
        stored.map((e) => NoteItem.fromJson(Map<String, dynamic>.from(e))),
      );
    }
    List? trashStored = box.read<List>(_trashKey);
    if (trashStored != null) {
      trash.assignAll(
        trashStored.map((e) => NoteItem.fromJson(Map<String, dynamic>.from(e))),
      );
    }
    ever(
      items,
      (_) => box.write(_storageKey, items.map((e) => e.toJson()).toList()),
    );
    ever(
      trash,
      (_) => box.write(_trashKey, trash.map((e) => e.toJson()).toList()),
    );
  }

  void addItem(String item, {int colorIndex = 0}) {
    items.add(
      NoteItem(text: item, date: DateTime.now(), colorIndex: colorIndex),
    );
  }


  void removeItem(int index) {
    trash.add(items[index]);
    items.removeAt(index);
  }

  void clearItems() => items.clear();

  void updateItem(int index, String newItem, [int? newColorIndex]) {
    if (index >= 0 && index < items.length) {
      final oldNote = items[index];
      items[index] = NoteItem(
        text: newItem,
        date: DateTime.now(),
        colorIndex: newColorIndex ?? oldNote.colorIndex,
      );
    }
  }

  void restoreFromTrash(int index) {
    items.add(trash[index]);
    trash.removeAt(index);
  }

  void deleteFromTrash(int index) => trash.removeAt(index);

  void clearTrash() => trash.clear();

  void moveAllToTrash() {
    trash.addAll(items);
    items.clear();
  }

  void updateItemColor(int index, int colorIndex) {
    if (index >= 0 && index < items.length) {
      final oldNote = items[index];
      items[index] = NoteItem(
        text: oldNote.text,
        date: oldNote.date,
        colorIndex: colorIndex,
      );
    }
  }

}
