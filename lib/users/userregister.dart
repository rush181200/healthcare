import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:heart_rate/users/home_page.dart';
import 'package:heart_rate/styles/colors.dart';
import 'package:heart_rate/users/userlogin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/userapi.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _password;
  late String _mobileNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callapi();
  }

  callapi() {
    Provider.of<UserApi>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<UserApi>(
      create: (context) => UserApi(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _mobileNumber = value!;
                  },
                ),
                SizedBox(height: 16),
                Container(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) => LoginPage()));
                      },
                      child: Text("Already a user? login")),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Register'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // TODO: Register user with the entered details

                      // Clear form
                      _formKey.currentState!.reset();

                      Provider.of<UserApi>(context, listen: false).sendDetails(
                        name: _name,
                        email: _email,
                        number: _mobileNumber,
                        password: _password,
                      );

                      FlutterToastr.show('Registered', context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
