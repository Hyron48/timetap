import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timetap/utils/constants.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: offWhite,
          highlightColor: lightGrey,
          child: ListTile(
            title: Container(
              height: 40,
              color: white,
              margin: EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        );
      },
    );
  }
}