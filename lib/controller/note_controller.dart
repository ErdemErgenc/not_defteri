import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NoteController extends GetxController {
  static const _storageKey = 'notes2'; // <<< Yeni anahtar
  final box = GetStorage();
  var items = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Sadece String olanları oku
    List<dynamic>? stored = box.read<List>(_storageKey);
    if (stored != null) {
      items.assignAll(stored.whereType<String>());
    }
    // Her değişimde tekrar yaz
    ever(items, (_) => box.write(_storageKey, items));
  }

  void addItem(String item) => items.add(item);

  void removeItem(int index) => items.removeAt(index);

  void clearItems() => items.clear();

  void updateItem(int index, String newItem) {
    if (index >= 0 && index < items.length) {
      items[index] = newItem;
    }
  }
}
