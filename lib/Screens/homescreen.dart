import 'dart:convert';

import 'package:ezybook/Screens/messagescreen.dart';
import 'package:ezybook/models/shop.dart';
import 'package:ezybook/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_section_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;
  List<Shop> _shopList = []; // State variable to hold shops
  UserModel? user;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      final newIndex = pageController.page?.round() ?? 0;
      if (newIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    });
    _getShopData(); // Fetch shop data
    getUserData(); // fetch user data
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = UserModel.fromJson(userMap);
      });
    }
  }

  void _getShopData() {
    Query query = FirebaseDatabase.instance.ref("Shops");
    query.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<Object?, Object?>?;

      if (data != null && data.isNotEmpty) {
        List<Shop> shopList = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            Shop shop =
                Shop.fromJson(value.cast<String, dynamic>(), key.toString());
            shopList.add(shop);
            // print(shop.toJson());
          }
        });

        setState(() {
          _shopList = shopList; // Update the state with the fetched shops
        });
      }
    }, onError: (error) {
      print('Error occurred: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/images/ProfileIcon.png"),
          onPressed: () {
            // here i want to open profile popup
            _showProfileMenu(context);
          },
        ),
        backgroundColor: const Color(0xFFf7f7f9),
        title: Text("Hello, ${user?.name}"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 24,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          Home(allshopDetails: _shopList), // Correctly pass the data
          const MessageScreen(), // Ensure this is correctly defined
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF24baec),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/search_screen',
            arguments: {'shopDetails': _shopList},
          );
        },
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 29,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", false);
    prefs.setString("user", "");
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox appBarBox = context.findRenderObject() as RenderBox;
    final Offset offset = appBarBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        15.0, // Adjust this value to position the menu from the left edge
        offset.dy + kToolbarHeight + 30.0, // Position below the AppBar
        MediaQuery.of(context).size.width - 50.0, // Position from the right
        0.0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Account'),
            onTap: () {
              Navigator.pop(context); // Close the menu before navigating
              Navigator.pushNamed(context, "/user_profile_screen");
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () {
              signOut();

              Navigator.pop(context); // Close the menu before navigating
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signin_screen',
                (route) => false,
              );
            },
          ),
        ),
      ],
      elevation: 5.0,
    );
  }
}

class Home extends StatelessWidget {
  final List<Shop?> allshopDetails;

  const Home({super.key, required this.allshopDetails});

  @override
  Widget build(BuildContext context) {
    List<String> categories = ["Salon", "Restaurant"];

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Explore the",
                  style: TextStyle(fontSize: 35),
                ),
              ], //
            ),
            const Row(
              children: [
                Text(
                  "beautiful",
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  "  Services",
                  style: TextStyle(color: Colors.green, fontSize: 35),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (allshopDetails.isEmpty) // Handle empty state
              const Text(
                "Loading...",
                style: TextStyle(fontSize: 18),
              ),
            ...categories.map(
              (category) => CategorySection(
                category: category,
                allshopDetails: allshopDetails
                    .where((shop) => shop?.shopCategory == category)
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
