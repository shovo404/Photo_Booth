import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FullScreenImages(),
    );
  }
}

class FullScreenImages extends StatefulWidget {
  @override
  _FullScreenImagesState createState() => _FullScreenImagesState();
}

class _FullScreenImagesState extends State<FullScreenImages> {
  int _selectedIndex = 0;

  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1739609579483-00b49437cc45?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1735317461815-1a0ba64e9a56?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529138029-5b049119cfb1?q=80&w=1994&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1735276680702-c008c8035c18?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1735424080768-8730f9c8a0e9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1726317986176-382bffd78c99?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  final List<Widget> _screens = [
    WelcomePage(), // Home screen (Welcome page)
    FullScreenImagesPage(), // Image screen
    SettingsPage(), // Settings screen (placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image LAB')),
      drawer: Drawer(
        elevation: 16,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://www.w3schools.com/w3images/avatar2.png',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, Shovo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            _buildDrawerItem('Food', () {
              _onItemClick('Food');
            }),
            _buildDrawerItem('Nature', () {
              _onItemClick('Nature');
            }),
            _buildDrawerItem('Photography', () {
              _onItemClick('Photography');
            }),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavigationItemTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Images'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }

  void _onItemClick(String item) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('You clicked $item')));
  }

  void _onNavigationItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// Welcome page with typing animation
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _displayText = '';
  final String _fullText = 'Welcome 🎞 Store Dev. By SHOVO🏴‍☠️';

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() async {
    for (int i = 0; i < _fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _displayText = _fullText.substring(0, i + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _displayText,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Image screen widget
class FullScreenImagesPage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1735317461815-1a0ba64e9a56?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529138029-5b049119cfb1?q=80&w=1994&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1735276680702-c008c8035c18?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1735424080768-8730f9c8a0e9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1726317986176-382bffd78c99?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1734640548068-1cfe6cb6b96b?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: imageUrls.map((url) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(url, fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }
}

// Settings screen widget (placeholder)
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings Page', style: TextStyle(fontSize: 20)));
  }
}
