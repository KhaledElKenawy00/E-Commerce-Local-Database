class Order {
  final int id;
  final int customerId;
  final String orderDate;
  final double totalAmount;
  final String status;

  Order({
    required this.id,
    required this.customerId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
  });

  // Convert Order into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}
