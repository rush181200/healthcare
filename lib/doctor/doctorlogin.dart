import 'package:flutter/material.dart';
import 'package:heart_rate/api/doctorapi.dart';
import 'package:heart_rate/doctor/doctorhome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/doctormodel.dart';

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callapi();
  }

  callapi() {
    Provider.of<DoctorApi>(context, listen: false).getDoctorDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorApi>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!.trim();
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    icon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!.trim();
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // perform login logic with email and password
                      logincheck(_email!, _password!, value.doctors);
                    }
                  },
                  child: Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> logincheck(String email, String password, List<Doctor> doc) async {
    for (int i = 0; i < doc.length; i++) {
      if (email == doc[i].email && password == doc[i].password) {
        print('user login');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('did', doc[i].id);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DoctorHome()));
      } else if (email != doc[i].email) {
        print('user is not register');
      } else if (email == doc[i].email && password != doc[i].password) {
        print('Wrong password');
      }
    }
    return 0;
  }
}
