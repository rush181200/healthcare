class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final List<dynamic> history;
  final String heartRate;

  User(
      {required this.name,
      required this.id,
      required this.email,
      required this.mobile,
      required this.password,
      required this.history,
      required this.heartRate});

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     name: json['name'],
  //     email: json['email'],
  //     mobile: json['mobile'],
  //     password: json['password'],
  //     history: List<dynamic>.from(json['history']),
  //     heartRate: json['heartRate'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'email': email,
  //     'mobile': mobile,
  //     'history': history,
  //     'heartRate': heartRate,
  //   };
  // }
}
