class OrderDetails {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;

  OrderDetails({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  // Convert OrderDetails into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
