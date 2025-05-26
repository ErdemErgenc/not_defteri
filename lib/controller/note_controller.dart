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

  void addItem(String item) =>
      items.add(NoteItem(text: item, date: DateTime.now()));

  void removeItem(int index) {
    trash.add(items[index]);
    items.removeAt(index);
  }

  void clearItems() => items.clear();

  void updateItem(int index, String newItem) {
    if (index >= 0 && index < items.length) {
      items[index] = NoteItem(text: newItem, date: DateTime.now());
    }
  }

  void restoreFromTrash(int index) {
    items.add(trash[index]);
    trash.removeAt(index);
  }

  void deleteFromTrash(int index) => trash.removeAt(index);

  void clearTrash() => trash.clear();
}
