import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:heart_rate/api/doctorapi.dart';
import 'package:heart_rate/doctor/doctorlogin.dart';
import 'package:heart_rate/users/home_page.dart';
import 'package:heart_rate/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/userapi.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _password;
  late String _mobileNumber;
  String? speciality;
  String? about;
  String? paitents;
  String? experience;
  bool _isDoctor = false;
  String _doctorId = "000";

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
    return Provider<UserApi>(
      create: (context) => UserApi(),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Color(MyColors.primary),
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Doctor ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your doctor ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _doctorId = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'About'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Details';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    about = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Speciality'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your speciality';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    speciality = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'no. of paitents'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your number of paitents';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paitents = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'experience'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your experience';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    experience = value!;
                  },
                ),
                SizedBox(height: 16),
                Container(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) => DoctorLogin()));
                      },
                      child: Text("Already a user? login")),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Register'),
                  onPressed: () {
                    print(_isDoctor);
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // TODO: Register user with the entered details

                      // Clear form
                      _formKey.currentState!.reset();

                      Provider.of<DoctorApi>(context, listen: false)
                          .sendDocDetails(
                              name: _name,
                              Doctorid: _doctorId,
                              email: _email,
                              number: _mobileNumber,
                              password: _password,
                              about: about,
                              experience: experience,
                              paitents: paitents,
                              speciality: speciality);
                      setState(() {
                        _isDoctor = false;
                      });

                      FlutterToastr.show("Register", context);
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
