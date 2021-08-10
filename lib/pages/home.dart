import 'dart:io';

import 'package:band/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '1', name: 'Queen', votes: 5),
    Band(id: '1', name: 'Heros of Silence', votes: 5),
    Band(id: '1', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Row(
          children: [
            Icon(
              Icons.delete_rounded,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Delete Band',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        // LLamar a borrar en el server
      },
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print('${band.name} hi! band');
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(textController.text),
                child: Text('Add'),
                textColor: Colors.blue,
              )
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                // isDefaultAction: true,
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      // agregar
      this.bands.add(new Band(id: DateTime.now().toString(), name: name));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
