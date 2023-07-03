import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Swiper extends StatefulWidget {
  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;

  fetchCarouselImages() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection('banners').get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]['image'],
        );
      }
    });
    return qn.docs;
  }

  List<String> getLocalImages() {
    // Replace this with the logic to get local image paths
    return [
      'assets/img1.jpg',
      'assets/img2.jpg',
      'assets/img3.jpg',
    ];
  }

  @override
  void initState() {
    // fetchCarouselImages();
    _carouselImages = getLocalImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 10,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                items: _carouselImages
                    .map((item) => Padding(
                      padding: const EdgeInsets.only(left: 3,right: 3),
                      child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    // image: NetworkImage(item),
                                    image: AssetImage(item),
                                    fit: BoxFit.fitWidth)),
                          ),
                    ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {
                        _dotPosition = val;
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DotsIndicator(
                dotsCount:
                    _carouselImages.length == 0 ? 1 : _carouselImages.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: Colors.red,
                color: Colors.red.withOpacity(0.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(8,8),
                size: Size(6,6),
              ),
            )
          ],
        ),
      ),
    );
  }
}
