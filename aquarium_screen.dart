import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'fish.dart';
import 'storage.dart';

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 1.0;
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _loadSettings();

    // Start the fish movement loop
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _updateFishPositions();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer
    _controller.dispose();
    super.dispose();
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  void _saveSettings() async {
    await Storage.savePreferences(fishList.length, selectedColor.value, selectedSpeed);
  }

  void _loadSettings() async {
    final preferences = await Storage.loadPreferences();
    if (preferences != null) {
      setState(() {
        fishList = List.generate(preferences['fishCount'], (index) => Fish(color: Color(preferences['fishColor']), speed: preferences['fishSpeed'].toDouble()));
      });
    }
  }

  // Update fish positions
  void _updateFishPositions() {
    setState(() {
      for (var fish in fishList) {
        fish.move(); // Move each fish
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Aquarium")),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            color: Colors.lightBlue[50],
            child: Stack(
              children: fishList.map((fish) => fish.build()).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: _addFish, child: Text("Add Fish")),
              ElevatedButton(onPressed: _saveSettings, child: Text("Save Settings")),
            ],
          ),
          // Slider for speed adjustment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text("Speed: ${selectedSpeed.toStringAsFixed(1)}"),
                Slider(
                  value: selectedSpeed,
                  min: 0.1,
                  max: 5.0,
                  divisions: 50,
                  label: selectedSpeed.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      selectedSpeed = value; // Update the selected speed
                    });
                    for (var fish in fishList) {
                      fish.speed = selectedSpeed; // Update speed for existing fish
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
