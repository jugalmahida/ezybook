import 'package:ezybook/Screens/messagescreen.dart';
import 'package:flutter/material.dart';

import 'category_section_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;

  List<Map<String, String>> allshopDetails = [
    {
      "category": "HairSalons",
      "name": "Glamour Cuts",
      "rating": "4.5",
      "location": "Downtown, Cityville",
      "mainimage": "assets/images/Im1.png",
      "aboutshop":
          "Specializing in contemporary styles and classic cuts. Our expert stylists are here to make you look and feel fabulous.Specializing in contemporary styles and classic cuts. Our expert stylists are here to make you look and feel fabulous.Specializing in contemporary styles and classic cuts. Our expert stylists are here to make you look and feel fabulous.Specializing in contemporary styles and classic cuts. Our expert stylists are here to make you look and feel fabulous.",
      "price": "120"
    },
    {
      "category": "HairSalons",
      "name": "Style Haven",
      "rating": "4.8",
      "location": "Uptown, Cityville",
      "mainimage": "assets/images/Im2.png",
      "aboutshop":
          "Your destination for a refreshing new look. Enjoy personalized consultations and premium hair treatments.",
      "price": "180"
    },
    {
      "category": "HairSalons",
      "name": "Chic Cuts",
      "rating": "4.6",
      "location": "Westside, Cityville",
      "mainimage": "assets/images/onboard1.png",
      "aboutshop":
          "Offering top-notch haircuts and coloring services. Come and experience our relaxing atmosphere and skilled professionals.",
      "price": "100"
    },
    {
      "category": "HairSalons",
      "name": "Elegant Styles",
      "rating": "4.7",
      "location": "Eastside, Cityville",
      "mainimage": "assets/images/onboard2.png",
      "aboutshop":
          "From trendy styles to classic cuts, we offer a wide range of hair services to meet your needs.",
      "price": "150"
    },
    {
      "category": "HairSalons",
      "name": "Refined Looks",
      "rating": "4.9",
      "location": "Central, Cityville",
      "mainimage": "assets/images/onboard3.png",
      "aboutshop":
          "Experience luxury with our high-end hair care and styling. Expert stylists and a comfortable environment await you.",
      "price": "200"
    },
    {
      "category": "HairSalons",
      "name": "Best Hair's",
      "rating": "3.0",
      "location": "Uptown, Cityville",
      "mainimage": "assets/images/Im2.png",
      "aboutshop":
          "Your destination for a refreshing new look. Enjoy personalized consultations and premium hair treatments.",
      "price": "180"
    },
    {
      "category": "Clinic",
      "name": "Wellness Clinic",
      "rating": "4.5",
      "location": "Northside, Cityville",
      "mainimage": "assets/images/Im3.png",
      "aboutshop":
          "Offering comprehensive healthcare services including general medicine, dermatology, and preventive care.",
      "price": "Varies"
    },
    {
      "category": "Clinic",
      "name": "City Health Center",
      "rating": "4.6",
      "location": "Southside, Cityville",
      "mainimage": "assets/images/Im4.png",
      "aboutshop":
          "Providing expert medical services with a focus on patient comfort and effective treatment plans.",
      "price": "Varies"
    },
    {
      "category": "Clinic",
      "name": "Family Care Clinic",
      "rating": "4.7",
      "location": "Eastside, Cityville",
      "mainimage": "assets/images/Im5.png",
      "aboutshop":
          "Dedicated to delivering compassionate care for all ages. Our team is here to support your family's health.",
      "price": "Varies"
    },
    {
      "category": "Clinic",
      "name": "Healthy Horizons Clinic",
      "rating": "4.8",
      "location": "Westside, Cityville",
      "mainimage": "assets/images/Im6.png",
      "aboutshop":
          "Expert medical services with a focus on wellness and preventive care. We strive to improve your quality of life.",
      "price": "Varies"
    },
    {
      "category": "Clinic",
      "name": "Advanced Medical Center",
      "rating": "4.9",
      "location": "Central, Cityville",
      "mainimage": "assets/images/Im7.png",
      "aboutshop":
          "Providing state-of-the-art healthcare and specialized medical services in a modern facility.",
      "price": "Varies"
    },
    {
      "category": "Clinic",
      "name": "Best Clinic's",
      "rating": "3.9",
      "location": "Central, Cityville",
      "mainimage": "assets/images/Im7.png",
      "aboutshop":
          "Providing state-of-the-art healthcare and specialized medical services in a modern facility.",
      "price": "Varies"
    },
    {
      "category": "Restaurant",
      "name": "Gourmet Bistro",
      "rating": "4.6",
      "location": "Downtown, Cityville",
      "mainimage": "assets/images/Im8.png",
      "aboutshop":
          "Enjoy a fine dining experience with a menu featuring local and international cuisine prepared by top chefs.",
      "price": "50"
    },
    {
      "category": "Restaurant",
      "name": "The Dine Spot",
      "rating": "4.7",
      "location": "Uptown, Cityville",
      "mainimage": "assets/images/Im9.png",
      "aboutshop":
          "A cozy place offering a variety of delicious dishes from around the world. Perfect for family dinners and special occasions.",
      "price": "40"
    },
    {
      "category": "Restaurant",
      "name": "Urban Eats",
      "rating": "4.5",
      "location": "Westside, Cityville",
      "mainimage": "assets/images/Im10.png",
      "aboutshop":
          "Experience a vibrant atmosphere with a diverse menu of contemporary dishes and fresh ingredients.",
      "price": "30"
    },
    {
      "category": "Restaurant",
      "name": "Taste of Italy",
      "rating": "4.8",
      "location": "Eastside, Cityville",
      "mainimage": "assets/images/Im11.png",
      "aboutshop":
          "Indulge in authentic Italian cuisine with a menu featuring pasta, pizza, and more, all made from scratch.",
      "price": "35"
    },
    {
      "category": "Restaurant",
      "name": "Seafood Haven",
      "rating": "4.9",
      "location": "Central, Cityville",
      "mainimage": "assets/images/Im12.png",
      "aboutshop":
          "A seafood lover's paradise offering the freshest catches and a variety of seafood dishes in a relaxed setting.",
      "price": "60"
    }
  ];

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
        title: const Text("Hello, Raj"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/Notification.png"),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          Home(allshopDetails: allshopDetails), // Correctly pass the data
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
            arguments: {'shopDetails': allshopDetails},
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
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: '',
          ),
        ],
      ),
    );
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
  final List<Map<String, String>> allshopDetails;

  const Home({super.key, required this.allshopDetails});

  @override
  Widget build(BuildContext context) {
    List<String> categories = ["HairSalons", "Clinic", "Restaurant"];

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Explore the\nbeautiful",
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  "Services",
                  style: TextStyle(color: Colors.green, fontSize: 35),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...categories.map((category) => CategorySection(
                  category: category,
                  allshopDetails: allshopDetails
                      .where((shop) => shop['category'] == category)
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }
}
