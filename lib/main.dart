import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainScreen(toggleTheme: _toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  MainScreen({required this.toggleTheme});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = "nature"; // Default category
  bool _isLoggedIn = false;
  String _username = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onLoginSuccess(String username) {
    setState(() {
      _isLoggedIn = true;
      _username = username;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginPage(onLoginSuccess: _onLoginSuccess);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Image LAB'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Logout button
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://media.licdn.com/dms/image/v2/D5622AQF07VTpzRkwDw/feedshare-shrink_800/feedshare-shrink_800/0/1724013922794?e=2147483647&v=beta&t=LAIcNj4iFnTtUrnGFEuMfxFaPOgho5Hq3Sg68NUoDXg',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, $_username',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            _buildDrawerItem('Food', 'food'),
            _buildDrawerItem('Nature', 'nature'),
            _buildDrawerItem('Photography', 'photography'),
          ],
        ),
      ),
      body: FullScreenImagesPage(category: _selectedCategory),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Images'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Images'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, String category) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _onCategorySelected(category);
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function(String) onLoginSuccess;

  LoginPage({required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Hardcoded authentication with default username and password as "123"
      if (username == "shovo" && password == "123") {
        widget.onLoginSuccess(username);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fetch Images from Unsplash
class FullScreenImagesPage extends StatefulWidget {
  final String category;

  FullScreenImagesPage({required this.category});

  @override
  _FullScreenImagesPageState createState() => _FullScreenImagesPageState();
}

class _FullScreenImagesPageState extends State<FullScreenImagesPage> {
  List<String> imageUrls = [];
  final String unsplashApiKey =
      "gpc1EnKt1pI5SEB6uOE2WNhMhhsGfW0fwI5NT9AuohA";

  @override
  void initState() {
    super.initState();
    _fetchImages(widget.category);
  }

  Future<void> _fetchImages(String query) async {
    final url = Uri.parse(
        "https://api.unsplash.com/search/photos?query=$query&per_page=10&client_id=$unsplashApiKey");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Fetch the image results and shuffle them for randomness
      List<String> fetchedImageUrls = List<String>.from(
          data["results"].map((image) => image["urls"]["regular"]));
      fetchedImageUrls.shuffle(); // Shuffle the list to randomize the images

      setState(() {
        imageUrls = fetchedImageUrls;
      });
    } else {
      print("Failed to load images");
    }
  }

  @override
  void didUpdateWidget(FullScreenImagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _fetchImages(widget.category); // Fetch new images when the category changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageUrls.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageDetailScreen(imageUrl: imageUrls[index]),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
                ),
              );
            },
          );
  }
}

// Image Detail Page with Full-Screen View
class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: false,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 2.5,
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
