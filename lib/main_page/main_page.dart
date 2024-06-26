import 'package:flutter/material.dart';
import 'package:gece_pollution_tracker/main_page_content.dart';
import 'package:gece_pollution_tracker/maps/maps_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  var lat;
  var long;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    MainPageContent(),
    MapsPage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Color(0xffe4e4e4),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class MetricCard extends StatelessWidget {
  var backgroundColor;
  String metric;
  String metricValue;
  MetricCard(
      {required this.backgroundColor,
      required this.metric,
      required this.metricValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: backgroundColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                metric,
                style: GoogleFonts.varelaRound(fontSize: 13),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metricValue,
                  style: GoogleFonts.varelaRound(fontSize: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Dummy SettingsPage for demonstration purposes
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Page'),
    );
  }
}
