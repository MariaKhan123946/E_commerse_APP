import 'package:e_commerse_app/screens/cart_screen.dart';
import 'package:e_commerse_app/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cartItems = [];
  Set<String> favoriteItems = Set(); // Set to track favorited items
  int cartCount = 0; // Track cart count

  List<Map<String, dynamic>> items = [
    {
      'image': 'images/img_17.png',
      'name': 'Jens Jacket',
      'price': '\$29.99',
      'color': 'Red',
    },
    {
      'image': 'images/img_5.png',
      'name': 'Acrylic Sweater',
      'price': '\$19.99',
      'color': 'Blue',
    },
    {
      'image': 'images/img_7.png',
      'name': 'Sweaters',
      'price': '\$39.9',
      'color': 'Green',
    },
    {
      'image': 'images/img_6.png',
      'name': 'Off-the-shoulder',
      'price': '\$49.99',
      'color': 'Yellow',
    },
  ];

  List<Map<String, dynamic>> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = items;
    _searchController.addListener(() {
      filterItems();
    });
  }

  // Function to filter items based on search query
  void filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = items.where((item) {
        return item['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  // Function to add item to cart and mark as favorite
  Future<void> addToCart(String image, String name, String price,
      String color) async {
    setState(() {
      cartItems.add(
          {'image': image, 'name': name, 'price': price, 'color': color});
      cartCount = cartItems.length;
      favoriteItems.add(name); // Mark item as favorite
    });

    // Code to save to Firestore or any backend can be added here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
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
            Text(
              'Match Your Style',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Row with three small containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('Trading Now', style: TextStyle(color: Colors.white))),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('All', style: TextStyle(color: Colors.orange))),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('New', style: TextStyle(color: Colors.orange))),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return GridTile(
                    child: itemContainer(
                      image: item['image'],
                      name: item['name'],
                      price: item['price'],
                      color: item['color'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Navigate to CartScreen when cart icon is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 20,
                        maxHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          '$cartCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget itemContainer(
      {required String image, required String name, required String price, required String color}) {
    return Card(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to DetailScreen when image is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(
                              image: image,
                              name: name,
                              price: price,
                              color: color,
                            ),
                      ),
                    );
                  },
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 95, // Adjust the height as needed
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 35),
                  child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Text(price, style: TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Text(color, style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(favoriteItems.contains(name) ? Icons.favorite : Icons
                  .favorite_border),
              color: favoriteItems.contains(name) ? Colors.red : null,
              // Make it red if favorite
              onPressed: () {
                if (!favoriteItems.contains(name)) {
                  // Only add to cart if it's not already in the favorite list
                  addToCart(image, name, price, color);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}
// Separate CartScreen to display cart items
