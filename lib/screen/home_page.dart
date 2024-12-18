import 'package:eapp/screen/cart_page.dart';
import 'package:eapp/screen/order_page.dart';
import 'package:eapp/screen/register_page.dart';
import 'package:eapp/screen/user_details.dart';
import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  int? userId;

  HomePage({super.key, this.userId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'MacBook air',
      'price': 2000.0,
      "imageUrl": "assets/macbook.jpeg",
      "description": """The most powerful Mac laptops and
desktops ever. Supercharged by Apple 
silicon. MacBook Air,""",
      "category": "Labtops"
    },
    {
      'id': 2,
      'name': 'Iphone 15 Pro',
      'price': 1150.0,
      "imageUrl": "assets/iphone.jpeg",
      "description": """Explore iPhone, the world's most powerful 
personal device. Check out iPhone 13 Pro,
iPhone 13 Pro Max""",
      "category": "Phones"
    },
    {
      'id': 3,
      'name': 'Asus vivo book',
      'price': 750.0,
      "imageUrl": "assets/asus.jpeg",
      "description": """Driven by innovation & committed to quality,
ASUS has a wide selection of best in class 
products. Find & buy a laptop,""",
      "category": "Labtops"
    },
    {
      'id': 4,
      'name': 'Samsung s24',
      'price': 954.0,
      "imageUrl": "assets/ultra.jpeg",
      "description": """Samsung Galaxy S24 Ultra Android smartphone.
Announced Jan 2024. Features 6.8″ display, 
Snapdragon 8 Gen 3""",
      "category": "Phones"
    },
  ];

  final List<Map<String, dynamic>> _cart = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Map<String, dynamic>? _userDetails;
  Future<void> _fetchUserDetails() async {
    var user = await _databaseHelper.queryById(
        DatabaseHelper.tableCustomers, widget.userId!);
    setState(() {
      _userDetails = user;
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart!')),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(
                cart: _cart,
                userId: widget.userId!,
              )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header (User info can be added here)
            _userDetails != null
                ? UserAccountsDrawerHeader(
                    accountName: Text(
                      "${_userDetails!['name']}",
                      style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ), // Placeholder, fetch actual name from database
                    accountEmail: Text(
                      "${_userDetails!['email']}",
                      style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ), // Placeholder, fetch email
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: Colors.red,
                  )),
            ListTile(
              title: Text(
                "User Details",
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
              onTap: () {
                // Navigate to the user details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserPage(userId: widget.userId!)),
                );
              },
            ),
            ListTile(
              title: Text(
                "Shipping Order",
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
              onTap: () {
                // Navigate to the shipping orders page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrdersPage(userId: widget.userId!)),
                );
              },
            ),
            ListTile(
              title: Text(
                "Sign Out",
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
              onTap: () {
                // Navigate to the shipping orders page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterScreen()), // Replace SignInPage with HomePage
                );
              },
            ),

            // Add other ListTiles here as needed (like logout, settings, etc.)
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
              fontSize: 30,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.pink),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _navigateToCart,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 1, color: Colors.red)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${product['name']}',
                            style: TextStyle(
                                fontSize: 25,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            '\$${product['price']}',
                            style: TextStyle(
                                fontSize: 25,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            """ ${product['description']}
                            """,
                            style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 55,
                          ),
                          Image.asset(
                            product['imageUrl'],
                            height: 70,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Category : ${product['category']}',
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: IconButton(
                                onPressed: () => _addToCart(product),
                                icon: Container(
                                  decoration: BoxDecoration(color: Colors.pink),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Add To Cart',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Icon(Icons.shopping_cart)
                                    ],
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
