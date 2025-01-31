import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
// import 'package:hive_ce/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Box box;
  final noteCtrl = TextEditingController();
  List notes = [];

  void initBox() async {
    box = await Hive.openBox('notes');
    loadBox();
  }

  void loadBox() {
    notes = box.values.toList();
    setState(() {});
    print(notes.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                doDelete(index);
              },
              child: Card(
                child: ListTile(
                  title: Text(
                    notes.elementAt(index),
                  ),
                ),
              ),
            );
          },
          itemCount: notes.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void showAddDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close')),
              ElevatedButton(
                onPressed: doAdd,
                child: const Text('Add'),
              ),
            ],
            content: TextField(
              controller: noteCtrl,
            ),
            title: const Text('Add Note'),
          );
        });
  }

  void doAdd() {
    box.add(noteCtrl.text);
    noteCtrl.clear();
    Navigator.of(context).pop();
    loadBox();
  }

  void doDelete(int i) {
    box.deleteAt(i);
    loadBox();
  }
}

// class NotesScreen extends StatelessWidget {
//   const NotesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 var box = await Hive.openBox('items');
//                 box.add('tamayo');
//                 print('saved name');
//               },
//               child: Text('Open Box'),
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   var box = await Hive.openBox('items');
//                   var name = box.get('name');
//                   // await box.clear();
//                   print(box.keys);
//                   print(box.values);
//                   print(box.get(0));
//                 },
//                 child: Text('Get from box'))
//           ],
//         ),
//       ),
//     );
//   }
// }
