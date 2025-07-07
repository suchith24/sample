import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _rememberMe = false;

  List<String> dropdown = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Form"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://imgv3.fotor.com/images/blog-richtext-image/a-shadow-of-a-boy-carrying-the-camera-with-red-sky-behind.jpg'),
                    radius: 75,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "ENTER YOUR EMAIL",
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.green),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty ? "Enter your email" : null,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.number,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "ENTER YOUR PASSWORD",
                      hintStyle: const TextStyle(color: Colors.blue),
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.pink),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your password" : null,
                  ),


                  SizedBox(height: 16),


                  CheckboxListTile(
                    title: Text("Remember Me"),
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  DropdownButtonFormField(
                    value: selectedValue,
                    decoration: InputDecoration(
                      labelText: 'Select Item',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular((10)),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items:
                    dropdown.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an item';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24),

                  ElevatedButton(
                    child: Text("Signup"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, '/signup');
                      }
                    },
                  ),
                ],
              ),
            ),

          ),
        ),
      ),

    );

  }
}