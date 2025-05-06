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
      theme: ThemeData(
        primaryColor: Color(0xFF2A2B38),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFEBA7),
          secondary: Color(0xFF5E6681),
          surface: Color(0xFFF5F5F5),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: Color(0xFF2A2B38), fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color(0xFF2A2B38)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFEBA7),
            foregroundColor: Color(0xFF5E6681),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Color(0xFF2A2B38),
        scaffoldBackgroundColor: Color(0xFF1F2029),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFFEBA7),
          secondary: Color(0xFF5E6681),
          surface: Color(0xFF1F2029),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: Color(0xFFF5F5F5), fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color(0xFFD3D3D3)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFEBA7),
            foregroundColor: Color(0xFF5E6681),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
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
  String _selectedCategory = "nature";
  bool _isLoggedIn = false;
  String _username = '';

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
        title: Text('Image LAB', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A2B38), Color(0xFF5E6681)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        actions: [
          IconButton(icon: Icon(Icons.brightness_6), onPressed: widget.toggleTheme),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF1F2029),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A2B38), Color(0xFF5E6681)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 20),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(context, 'Food', 'food', Icons.fastfood),
              _buildDrawerItem(context, 'Nature', 'nature', Icons.park),
              _buildDrawerItem(context, 'Photography', 'photography', Icons.camera_alt),
            ],
          ),
        ),
      ),
      body: FullScreenImagesPage(category: _selectedCategory),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2A2B38),
        selectedItemColor: Color(0xFFFFEBA7),
        unselectedItemColor: Color(0xFFD3D3D3),
        currentIndex: ['food', 'nature', 'photography'].indexOf(_selectedCategory),
        onTap: (index) {
          _onCategorySelected(['food', 'nature', 'photography'][index]);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Nature'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Photography'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String category, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFFFEBA7)),
      title: Text(title, style: TextStyle(color: Color(0xFFF5F5F5))),
      tileColor: _selectedCategory == category ? Color(0xFF5E6681).withAlpha((0.3 * 255).toInt()) : null,
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
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F2029), Color(0xFF2A2B38)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF2A2B38),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Log In!',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1F2029),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.person, color: Color(0xFFFFEBA7), size: 20),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: Color(0xFFD3D3D3)),
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Color(0xFFD3D3D3)),
                                border: InputBorder.none,
                              ),
                              validator: (value) =>
                                  value!.trim().isEmpty ? 'Enter username' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1F2029),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.lock, color: Color(0xFFFFEBA7), size: 20),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: Color(0xFFD3D3D3)),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Color(0xFFD3D3D3)),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              validator: (value) =>
                                  value!.trim().isEmpty ? 'Enter password' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Forgot password feature not implemented')),
                        );
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Color(0xFFFFEBA7), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImagesPage extends StatefulWidget {
  final String category;

  FullScreenImagesPage({required this.category});

  @override
  _FullScreenImagesPageState createState() => _FullScreenImagesPageState();
}

class _FullScreenImagesPageState extends State<FullScreenImagesPage> {
  List<String> imageUrls = [];
  final String unsplashApiKey = "gpc1EnKt1pI5SEB6uOE2WNhMhhsGfW0fwI5NT9AuohA";

  @override
  void initState() {
    super.initState();
    _fetchImages(widget.category);
  }

  Future<void> _fetchImages(String query) async {
    final url = Uri.parse(
        "https://api.unsplash.com/search/photos?query=$query&per_page=30&client_id=$unsplashApiKey");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> fetchedImageUrls = List<String>.from(
          data["results"].map((image) => image["urls"]["regular"]));
      fetchedImageUrls.shuffle();

      setState(() {
        imageUrls = fetchedImageUrls;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load images')),
      );
    }
  }

  @override
  void didUpdateWidget(FullScreenImagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _fetchImages(widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageUrls.isEmpty
        ? Center(child: CircularProgressIndicator(color: Color(0xFFFFEBA7)))
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
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
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFEBA7),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Icon(Icons.error, color: Color(0xFFFFEBA7));
                    },
                  ),
                ),
              );
            },
          );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2B38),
        iconTheme: IconThemeData(color: Color(0xFFFFEBA7)),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFEBA7),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Icon(Icons.error, color: Color(0xFFFFEBA7));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFEBA7),
        foregroundColor: Color(0xFF5E6681),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download feature not implemented')),
          );
        },
        child: Icon(Icons.download),
      ),
    );
  }
}
