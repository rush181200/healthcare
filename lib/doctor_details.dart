import 'package:flutter/material.dart';
import 'package:heart_rate/styles/colors.dart';
import 'package:heart_rate/styles/styles.dart';
import 'package:heart_rate/users/bookingdet.dart';
import 'package:provider/provider.dart';

import 'api/bookingapi.dart';

class SliverDoctorDetail extends StatefulWidget {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? doctorId;
  String? speciality;
  String? about;
  String? paitents;
  String? experience;
  String? password;
  SliverDoctorDetail({
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

  @override
  State<SliverDoctorDetail> createState() => _SliverDoctorDetailState();
}

class _SliverDoctorDetailState extends State<SliverDoctorDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Detail Doctor'),
            backgroundColor: Color(MyColors.primary),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/hospital.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(
              about: widget.about,
              doctorId: widget.doctorId,
              email: widget.email,
              experience: widget.experience,
              id: widget.id,
              mobile: widget.mobile,
              name: widget.name,
              paitents: widget.paitents,
              password: widget.password,
              speciality: widget.speciality,
            ),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? doctorId;
  String? speciality;
  String? about;
  String? paitents;
  String? experience;
  String? password;
  DetailBody({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name!,
                            style: TextStyle(
                                color: Color(MyColors.header01),
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            speciality!,
                            style: TextStyle(
                              color: Color(MyColors.grey02),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/doctor03.jpeg'),
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paitents - ${paitents}',
                            style: TextStyle(
                                color: Color(MyColors.header01),
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Experience - ${experience} years',
                            style: TextStyle(
                              color: Color(MyColors.grey02),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'About Doctor',
            style: kTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            about!,
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(MyColors.primary),
              ),
            ),
            child: Text('Book Appointment'),
            onPressed: () => {
              Provider.of<BookingApi>(context, listen: false)
                  .getBookingDetails(id: id),
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => BookingDets()))
            },
          )
        ],
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
