import 'package:eapp/model/shipping_model.dart';
import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart';

class ShippingDetailsPage extends StatefulWidget {
  final int orderId;

  ShippingDetailsPage({required this.orderId});

  @override
  _ShippingDetailsPageState createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  late Future<Shipping?> _shippingDetails;

  @override
  void initState() {
    super.initState();
    _shippingDetails = _fetchShippingDetails(widget.orderId);
  }

  // Function to fetch shipping details from the database
  Future<Shipping?> _fetchShippingDetails(int orderId) async {
    final db = await DatabaseHelper.instance;

    // Query the shipping details from the database
    final result = await db.queryByOrderId(
        DatabaseHelper.tableShipping, orderId, "orderId");

    // Return the shipping data if available
    if (result!.isNotEmpty) {
      return Shipping.fromMap(result); // Use a fromMap constructor
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details'),
      ),
      body: FutureBuilder<Shipping?>(
        future: _shippingDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No shipping details found.'));
          }

          final shipping = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(shipping.shippingAddress, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(
                  'Shipping Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(shipping.shippingStatus, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(
                  'Shipping Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(shipping.shippingDate, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(
                  'Delivery Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                    shipping.deliveryDate.isEmpty
                        ? 'Not delivered yet'
                        : shipping.deliveryDate,
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
