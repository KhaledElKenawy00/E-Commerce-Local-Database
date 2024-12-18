import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // For the database
import 'package:path/path.dart'; // For database path

class OrdersPage extends StatefulWidget {
  final int userId; // Pass the user ID to fetch orders for that specific user.

  OrdersPage({required this.userId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Map<String, dynamic>>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _fetchOrders(); // Fetch orders when the page is initialized
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final db = await openDatabase(
      join(await getDatabasesPath(),
          'ecommerce.db'), // Update with your database path
    );

    // Query orders for the signed-in user
    final orders = await db.query(
      'orders',
      where: 'customerId = ?',
      whereArgs: [widget.userId],
    );

    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order['id']}'),
                subtitle: Text('Total: \$${order['totalAmount']}'),
                trailing: Text(order['status']),
                onTap: () {
                  // Navigate to the shipping or order details page if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
