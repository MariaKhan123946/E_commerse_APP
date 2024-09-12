import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// DetailScreen.dart
class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final String color;

  DetailScreen({
    required this.image,
    required this.name,
    required this.price,
    required this.color,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedSize = 'M'; // Default selected size
  Map<String, dynamic>? selectedColor; // No color selected by default

  final List<Map<String, dynamic>> colors = [
    {'color': Colors.grey, 'name': 'Grey', 'hex': '#808080'},
    {'color': Colors.pink, 'name': 'Pink', 'hex': '#FFC0CB'},
    {'color': Colors.blue, 'name': 'Blue', 'hex': '#0000FF'},
    {'color': Colors.green, 'name': 'Green', 'hex': '#008000'},
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Function to add item to Firestore
  Future<void> addToCart(String color, String image, String name, String price, String size) async {
    try {
      // Get the current user's ID
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        // Add item to the user's cart in Firestore
        await firestore.collection('carts').doc(currentUser.uid).collection('items').add({
          'name': name,
          'image': image,
          'price': price,
          'color': color,
          'size': size,
          'timestamp': FieldValue.serverTimestamp(), // For sorting items by time
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name added to cart!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to sign in to add items to the cart.')),
        );
      }
    } catch (e) {
      print('Error adding item to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart. Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with logo and avatar
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Image.asset('images/img_15.png', height: 20),
                    ),
                  ),
                ),
                Spacer(),
                // Avatar
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('images/img_16.png'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Main item image
          Center(
            child: Image.asset(
              widget.image,
              height: 270,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          // Item name and price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  widget.price,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Sizes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['S', 'M', 'L', 'XL'].map((size) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedSize == size ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: selectedSize == size ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          // Colors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color['color'],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // Add the selected item to the user's cart in Firestore
                  await addToCart(
                    selectedColor?['name'] ?? widget.color,
                    widget.image,
                    widget.name,
                    widget.price,
                    selectedSize,
                  );
                },
                child: Text('Add to Cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
