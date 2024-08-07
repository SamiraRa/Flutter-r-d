import 'package:flutter_object_box/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  ObjectBox._create(this.store);
// ObjectBox._create(this.store) {
//     Add any additional setup code, e.g. build queries.
//   }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store =
        await openStore(directory: p.join(docsDir.path, "objectBox_crud"));
    return ObjectBox._create(store);
  }
}
