import 'package:eapp/model/order_model.dart';
import 'package:eapp/model/shipping_model.dart';
import 'package:eapp/screen/shipping_details.dart';
import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  List<Map<String, dynamic>> cart;
  final int userId;

  CartPage({required this.cart, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Save order to the database
  void _placeOrder(BuildContext context) async {
    final db = await DatabaseHelper().database;

    // Calculate the total amount, ensuring null values are handled
    final totalAmount = widget.cart.fold(
      0.0, // Start with 0.0 to handle floating point arithmetic
      (total, item) {
        final price = item['price'] ?? 0.0; // Default to 0.0 if null
        // final quantity = item['quantity'] ?? 0; // Default to 0 if null
        // return total + price * quantity
        return total + price;
      },
    );

    // Create the Order object
    final order = Order(
      id: 0, // 0 because it will auto-increment
      customerId: widget.userId,
      orderDate: DateTime.now().toIso8601String(),
      totalAmount: totalAmount,
      status: 'Pending',
    );

    // Insert order into the database
    final orderId = await db.insert(DatabaseHelper.tableOrders, order.toMap());

    // Create shipping info (example data)
    final shipping = Shipping(
      id: 0,
      orderId: orderId,
      shippingAddress:
          '${_userDetails!['address'] ?? 'N/A'}', // Replace with real data
      shippingStatus: 'Pending',
      shippingDate: DateTime.now().toIso8601String(),
      deliveryDate: '',
    );

    // Insert shipping info into the database
    await db.insert(DatabaseHelper.tableShipping, shipping.toMap());

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );

    setState(() {
      widget.cart.clear();
    });

    // Navigate to Shipping Details Page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingDetailsPage(orderId: orderId),
      ),
    );
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Map<String, dynamic>? _userDetails;

  Future<void> _fetchUserDetails() async {
    var user = await _databaseHelper.queryById(
        DatabaseHelper.tableCustomers, widget.userId);
    setState(() {
      _userDetails = user;
    });
  }

  @override
  void initState() {
    _fetchUserDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "CartPage",
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.pink),
      )),
      body: widget.cart.isNotEmpty
          ? ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cart[index];
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 5),
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
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Center(
                    child: CircularProgressIndicator(
                  color: Colors.pink,
                )),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Cart Is Empty😥😣",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                )
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _placeOrder(context),
          child: Text('Place Order'),
        ),
      ),
    );
  }
}
