import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Text _barTitle = const Text("Overview");

  List pages = [
    /* Overview */
    <Widget>[
      // ModelName
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Model Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Model Number
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Model Number",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // OS Version
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "OS Version",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Resolution
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Resolution",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          // Width
          Text(
            "Width Size",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          // Height
          Text(
            "Height Size",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Board Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Board Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Kernel Version
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Kernel Version",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
    ],

    /* SoC Infomation */
    <Widget>[
      // CPU Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "CPU Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      //CPU Arch
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "CPU Architecture",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // CPU Cores
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "CPU Cores",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Chip ID
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Chip ID",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Total Memory
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Total Memory",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // GPU Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "GPU Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Dummy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
    ],
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _barTitle = const Text("Overview");
          }
          break;
        case 1:
          {
            _barTitle = const Text("SoC Infomation");
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _barTitle,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cable),
            label: 'SoC Infomation',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
