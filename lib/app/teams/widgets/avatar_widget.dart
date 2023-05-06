// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  String imgUrl;
  double width;
  double height;
  AvatarImage({
    Key? key,
    this.width = 100,
    this.height = 100,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgUrl),
        ),
      ),
    );
  }
}
