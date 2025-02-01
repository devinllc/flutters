
import 'package:flutter/material.dart';
import 'package:assign/profile/presentation/screen/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks the bottom nav selection
  bool _isReplySelected = false; // Tracks if "Reply" is selected
  bool _isLoading = false; // Tracks loading state

  // List of widgets for each tab
  final List<Widget> _screens = [
    Center(child: Text("Home Content", style: TextStyle(fontSize: 18))),
    Center(child: Text("Explore Content", style: TextStyle(fontSize: 18))),
    Center(child: Text("Create Content", style: TextStyle(fontSize: 18))),
    Center(
        child: Text("Notifications Content", style: TextStyle(fontSize: 18))),
    ProfileScreen(username: 'example_username'), // Your Profile Screen
  ];

  // Simulates data fetching (if needed)
  Future<void> _fetchDataForScreen() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDataForScreen(); // Initial data fetch
  }

  // Get Floating Action Button Icon based on the current state
  IconData _getFloatingIcon() {
    if (_selectedIndex == 2) {
      return Icons.create; // Icon for "Create"
    } else if (_isReplySelected) {
      return Icons.reply; // Icon for "Reply"
    } else {
      return Icons.videocam; // Icon for "Video"
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isReplySelected = false; // Reset "Reply" when navigating
    });
    _fetchDataForScreen(); // Fetch data when navigating to a new screen
  }

  void _onTextTapped(bool isReply) {
    setState(() {
      _isReplySelected = isReply; // Update selection based on tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show progress bar
          : _screens[_selectedIndex], // Display the selected screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Switch to "Create" on FAB click
          });
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(_getFloatingIcon(), color: Colors.white), // Dynamic icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            bottom: 18, // Position above the bottom navigation bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _onTextTapped(false), // Switch to "Video"
                  child: Text(
                    'Video',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isReplySelected ? Colors.grey : Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _onTextTapped(true), // Switch to "Reply"
                  child: Text(
                    'Reply',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isReplySelected ? Colors.deepPurple : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String>(
        future: Future.delayed(Duration(seconds: 2), () => "Home Content"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            return Text(snapshot.data ?? "",
                style: TextStyle(fontSize: 18)); // Display data
          } else {
            return Text("No Content Found");
          }
        },
      ),
    );
  }
}
