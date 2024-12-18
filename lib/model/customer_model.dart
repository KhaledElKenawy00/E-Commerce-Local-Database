class Customer {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String phone;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'phone': phone,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
      phone: map['phone'],
    );
  }
}
