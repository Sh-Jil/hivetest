import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivetest/datamodel.dart';
import 'package:hivetest/dbfunc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(ContactsAdapter().typeId)) {
    Hive.registerAdapter(ContactsAdapter());
  }
  await Hive.openBox<Contacts>('contacts');
  runApp(const MyApp());
}

var name = TextEditingController();
var number = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              title: Text("add contacts"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(hintText: "Enter Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: number,
                    decoration: InputDecoration(hintText: "Enter PHone NUmber"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      addtodb();
                    },
                    child: Text("Add To Contacts")),
                Expanded(
                    child: ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Contacts>('contacts').listenable(),
                        builder: (BuildContext ctx, Box<Contacts> newlist,
                            Widget? child) {
                          if (newlist.values.isEmpty) {
                            return Center(child: Text("Contacts is empty"));
                          } else {
                            return ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  var contacts = newlist.getAt(index);
                                  return ListTile(
                                    title: Text(contacts!.name.toString()),
                                    subtitle: Text(contacts.number.toString()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              return dialogue(
                                                  context,
                                                  contacts.name,
                                                  contacts.number,
                                                  contacts.id);
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              if (contacts.id != null) {
                                                return removefromdb(
                                                    contacts.id!);
                                              }
                                            },
                                            icon: Icon(Icons.delete_outline)),
                                      ],
                                    ),
                                  );
                                }),
                                separatorBuilder:
                                    (BuildContext ctx, int index) => Divider(),
                                itemCount: newlist.values.length);
                          }
                        }))
              ],
            )));
  }
}

Future<void> addtodb() async {
  final _name = name.text;
  final _number = number.text;

  if (_name.isNotEmpty && _number.isNotEmpty) {
    var contacts = Contacts(name: _name, number: _number);

    addtocontacts(contacts);
  }
  name.clear();
  number.clear();
}

void dialogue(context, name, number, id) {
  var _name = TextEditingController(text: name);
  var _number = TextEditingController(text: number);
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Edit the contact"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _name,
                decoration: InputDecoration(hintText: "Enter Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _number,
                decoration: InputDecoration(hintText: "Enter PHone NUmber"),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      var contact = Contacts(
                          name: _name.text, number: _number.text, id: id);
                      editdb(contact, id);
                    },
                    child: Text("Save"))
              ],
            )
          ],
        );
      });
}
