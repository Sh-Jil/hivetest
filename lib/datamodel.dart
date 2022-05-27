import 'package:hive_flutter/hive_flutter.dart';
part 'datamodel.g.dart';

@HiveType(typeId: 0)
class Contacts extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String number;

  @HiveField(2)
  int? id;

  Contacts({required this.name, required this.number, this.id});
}
