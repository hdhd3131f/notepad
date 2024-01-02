import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notepad/login.dart';
import 'dart:convert' as convert;
import 'note.dart';

// ignore: must_be_immutable
class notepad extends StatefulWidget {
  String email;

  notepad({required this.email});

  @override
  State<notepad> createState() => _notepadState();
}

class _notepadState extends State<notepad> {
  final NoteNameControllere = TextEditingController();
  final desc = TextEditingController();

  String note_title = "";
  void initState() {
    super.initState();
    GetNotes();
  }

  void GetNotes() async {
    var url = "https://hadi1412234.000webhostapp.com/API/view.php";
    var response = await post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'email': widget.email,
        }));

    if (response.statusCode == 200) {
      list.clear();
      setState(() {
        String data = response.body;
        for (var ind in convert.jsonDecode(data)) {
          var not = Note(
            (ind["note_title"]),
            (ind["description"]),
          );
          list.add(not);
        }
      });
    }
  }

  Future<void> AddNote() async {
    final NoteTitleController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: NoteTitleController,
                decoration: InputDecoration(labelText: 'Note Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final Note_title = NoteTitleController.text;
                final description = descController.text;

                var url = "https://hadi1412234.000webhostapp.com/API/add.php";

                final response = await post(Uri.parse(url),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: convert.jsonEncode(
                      <String, String>{
                        'note_title': Note_title,
                        'description': description,
                        'email': widget.email,
                      },
                    ));

                if (response.statusCode == 200) {
                  var jsonResponse = convert.jsonDecode(response.body);
                  if (jsonResponse['note'] == true) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'The Title of this note is already exist. Please Enter another Title'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    GetNotes();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('note has been added.'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void delete() async {
    var url = "https://hadi1412234.000webhostapp.com/API/delete.php";
    var response = await post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'email': widget.email,
          'note_title': note_title,
        }));

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['delete'] == true) {
        GetNotes();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted succssessfully'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MY Notes"),
          centerTitle: true,
          leading: Container(),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              icon: Icon(Icons.exit_to_app),
              label: Text(""),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  setState(() {
                    NoteNameControllere.text = list[index].name;
                    desc.text = list[index].description;
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Note'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Note Title'),
                            TextField(
                              controller: NoteNameControllere,
                            ),
                            SizedBox(height: 10),
                            Text('Description'),
                            TextField(
                              controller: desc,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              String note_title = NoteNameControllere.text;
                              String description = desc.text;
                              String old_note_title = list[index].name;

                              var url =
                                  "https://hadi1412234.000webhostapp.com/API/edit.php";
                              var response = await post(Uri.parse(url),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: convert.jsonEncode(<String, String>{
                                    'email': widget.email,
                                    'note_title': note_title,
                                    'description': description,
                                    'old_note_title': old_note_title,
                                  }));

                              if (response.statusCode == 200) {
                                var jsonResponse =
                                    convert.jsonDecode(response.body);
                                if (jsonResponse['edit'] == true) {
                                  list[index].name = note_title;
                                  list[index].description = description;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('note has been updated'),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          notepad(
                                        email: widget.email,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('This Note is already exist!'),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );

                                  Navigator.of(context).pop();
                                }
                              }
                              // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ListTile(
                        leading: Image.network(
                          "Images/Noteicon.png",
                          width: 50,
                          height: 50,
                        ),
                        title: Text("${list[index].name}"),
                        subtitle: Text("${list[index].description}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              note_title = list[index].name;
                            });
                            delete();
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AddNote();
          },
          child: Icon(Icons.add),
        ));
  }
}
