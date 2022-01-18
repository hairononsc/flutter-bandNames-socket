import 'dart:io';

import 'package:band/models/band.dart';
import 'package:band/services/sockect_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final serverStatus = Provider.of<SocketService>(context, listen: false);

    serverStatus.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final serverStatus = Provider.of<SocketService>(context);
    serverStatus.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverStatus = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (serverStatus.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
            // child: Icon(Icons.offline_bolt, color:Colors.blue[300],),
          )
        ],
        backgroundColor: Colors.white,
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, i) => bandTile(bands[i]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);

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
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
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
              ));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
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
              ));
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      // agregar
      // this.bands.add(new Band(id: DateTime.now().toString(), name: name));
      final serverStatus = Provider.of<SocketService>(context, listen: false);
      serverStatus.socket.emit('add-band', {'name': name});
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      Color(0xffFF2375),
      Color(0xffFF7465),
      Color(0xff005463),
      Color(0xffFF0025),
      Color(0xff145289),
      Color(0xff987456),
    ];
    return Container(
        width: double.infinity,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          // centerText: "BANDS",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
            decimalPlaces: 0,
          ),
        ));
  }
}
