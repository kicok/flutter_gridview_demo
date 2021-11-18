import 'package:flutter/material.dart';
import 'package:flutter_gridview_demo/providers/pixabay_photos.dart';

class ImageDetail extends StatelessWidget {
  final PixabayPhotoItem photo;
  const ImageDetail({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.user),
      ),
    );
  }
}
