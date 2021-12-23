import 'package:flutter/material.dart';
import 'getinfo.dart';

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
        children: <Widget>[
          const Text(
            "Model Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.modelName(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Model Number
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Model Number",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.modelNumber(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // OS Version
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "OS Version",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.osVersion(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Resolution
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Resolution (prediction)",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          // Width
          const Text(
            "Width Size",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.widthResolution(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          // Height
          const Text(
            "Height Size",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.heightResolution(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Board Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Board Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.boardName(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Kernel Version
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Kernel Version",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.kernelVersion(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
    ],

    /* SoC Infomation */
    <Widget>[
      // CPU Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "CPU Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.cpuName(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      //CPU Arch
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "CPU Architecture",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.cpuArch(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // CPU Cores
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "CPU Cores",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.cpuCores(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Chip ID
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Chip ID",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.chipID(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      // Total Memory
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Total Memory",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.totalMemoryMB(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      /* 
      // GPU Name
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "GPU Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                GetDeviceInfo.gpuName(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
        ],
      ),
      */
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
