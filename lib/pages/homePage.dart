import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:akshayam/constants/kConstants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akshayam/model/services.dart';

import 'dart:math' as math;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool light = true;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // // FirebaseFirestore.instance
  // //     .collection('services')
  // //     .snapshots()
  // List<QueryDocumentSnapshot> _documents = [];

  // @override
  // void initState() {
  // super.initState();
  // _fetchServices();
  // }

  // Future<void> _fetchServices() async {
  // final Stream<QuerySnapshot<Map>> snapshot = await _firestore.collection('services').snapshots();
  // setState(() {
  // _documents = snapshot.doc;
  // });
  // }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFE4A14), Color(0xffFF1F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/akshayam.png',
                width: width / 3,
              )),
          actions: [
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: light,
                activeColor: Colors.white,
                activeTrackColor: Colors.white,
                thumbColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xffFE4A14)),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    light = value;
                  });
                },
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: width / 10,
                )),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffE5F9F4),
                  Color(0xffF68D5F),
                  Color(0xffF68D5F),
                  Colors.white,
                  Colors.white
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Padding(
            padding: EdgeInsets.only(top: width / 3.0),
            child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  "assets/ram-temple.png",
                  width: width / 2,
                )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  "assets/temple-bells.png",
                  width: width / 2.5,
                )),
          ),
          ListView(
            children: [
              Gap(height*0.05),
              SwiperWithBottomPagination(),
              Gap(20),
              Stack(
                children: [
                  // OmSymbol(width: width),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)),
                    ),
                    width: width,
                    // height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(20),
                        Padding(
                          padding:  EdgeInsets.only(left: width * 0.06),
                          child: Text("SERVICES",
                          // textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child:StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('services')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text('Something went wrong'));
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                List<Service> services = snapshot.data!.docs
                                    .map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  // Check if both 'iconUrl' and 'name' fields exist and are non-null
                                  if (data['iconUrl'] != null && data['name'] != null) {
                                    return Service.fromJson(data);
                                  }
                                  return null;
                                })
                                    .where((service) => service != null)
                                    .cast<Service>()
                                    .toList();

                                if (services.isEmpty) {
                                  return Center(child: Text('No services found'));
                                }

                                return NonScrollableGridView(services: services,);

                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  OmSymbol(width: width),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OmSymbol extends StatelessWidget {
  const OmSymbol({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -100, // Adjust these values as needed
      right: -60,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(
            "assets/om.png",
            width: width, // Adjust size as needed
            height: width * 0.8,
          ),
        ),
      ),
    );
  }
}






class NonScrollableGridView extends StatelessWidget {
  final List<Service> services;

  NonScrollableGridView({required this.services});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // Adjust this value to change the aspect ratio of grid items
      ),
      itemCount: services.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Service service = services[index];
        return ServiceItem(icon: service.iconUrl, label: service.name);
        // Card(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.network(
        //         service.iconUrl,
        //         height: 50,
        //         width: 50,
        //         fit: BoxFit.contain,
        //       ),
        //       SizedBox(height: 8),
        //       Text(
        //         service.name,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String icon;
  final String label;

  ServiceItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            icon,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SwiperWithBottomPagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 3, // Adjust this value as needed
      child: Swiper(
        itemWidth: width / 1.1,
        itemHeight: height / 4,
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: CustomLayoutOption(
          startIndex: 0,
          stateCount: 2,
        )..addTranslate([
          Offset(-370.0, 10.0),
          Offset(0.0, 0.0),
          Offset(370.0, 10.0)
        ]),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(images[index]),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),

          );
        },
        itemCount: 3,
        pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
            activeColor: Color(0xffFE4A14),
            color: Colors.black12,
            size: 10,
            activeSize: 12,
          ),
        ),
      ),
    );
  }
}






