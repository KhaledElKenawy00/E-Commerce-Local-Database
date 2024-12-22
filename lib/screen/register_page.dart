import 'package:eapp/screen/admin_panel.dart';
import 'package:eapp/screen/signin_page.dart';
import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routName = "/RegisterScreen";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        final db = DatabaseHelper.instance;
        await db.insert("customers", {
          "name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "address": _addressController.text,
          "phone": _phoneController.text,
          "signedIn": 1
        });

        print("""name:${_nameController.text}
             password:${_passwordController.text}
             email:${_emailController.text}

      """);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer Registered Successfully!')),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // ); // Navigate to Home Page // Navigate back after successful registration
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AdminPanel(),
                  ),
                );
              },
              icon: Icon(
                Icons.admin_panel_settings,
                size: 30,
              ))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Register Page',
          style: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset("assets/txt.png"),
              Text(
                'Register a New customer account ',
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your email' : null,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerCustomer,
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("I have An Account?"),
                  SizedBox(width: 5),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage(),
                          ),
                        );
                      },
                      child: Text(
                        "SignIn",
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
