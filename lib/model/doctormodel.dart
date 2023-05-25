class Doctor {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String doctorId;
  final String speciality;
  final String about;
  final String paitents;
  final String experience;
  final String password;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.doctorId,
    required this.speciality,
    required this.experience,
    required this.about,
    required this.password,
    required this.paitents,
  });

  // factory Doctor.fromJson(Map<String, dynamic> json) {
  //   return Doctor(
  //     name: json['name'],
  //     email: json['email'],
  //     mobile: json['mobile'],
  //     doctorId: json['doctorId'],

  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'email': email,
  //     'mobile': mobile,
  //     'doctorId': doctorId,
  //   };
  // }
}
