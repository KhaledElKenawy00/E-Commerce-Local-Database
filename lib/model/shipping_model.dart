class Shipping {
  final int id;
  final int orderId;
  final String shippingAddress;
  final String shippingStatus;
  final String shippingDate;
  final String deliveryDate;

  Shipping({
    required this.id,
    required this.orderId,
    required this.shippingAddress,
    required this.shippingStatus,
    required this.shippingDate,
    required this.deliveryDate,
  });

  // Convert Shipping into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'shippingAddress': shippingAddress,
      'shippingStatus': shippingStatus,
      'shippingDate': shippingDate,
      'deliveryDate': deliveryDate,
    };
  }

  factory Shipping.fromMap(Map<String, dynamic> map) {
    return Shipping(
      id: map['id'],
      orderId: map['orderId'],
      shippingAddress: map['shippingAddress'],
      shippingStatus: map['shippingStatus'],
      shippingDate: map['shippingDate'],
      deliveryDate:
          map['deliveryDate'] ?? '', // Handle empty or null delivery date
    );
  }
}
