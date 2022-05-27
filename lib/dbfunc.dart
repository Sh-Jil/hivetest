import 'datamodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

void addtocontacts(Contacts value) async {
  var box = await Hive.openBox<Contacts>('contacts');
  var id = await box.add(value);
  value.id = id;
}

void removefromdb(int id) async {
  var box = await Hive.openBox<Contacts>('contacts');
  box.delete(id);
}

void editdb(Contacts value, int id) async {
  var box = await Hive.openBox<Contacts>('contacts');
  box.put(id, value);
}
