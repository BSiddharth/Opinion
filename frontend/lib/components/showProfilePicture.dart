import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowProfilePicture extends StatelessWidget {
  const ShowProfilePicture({required this.url, required this.dimension});
  final String url;
  final double dimension;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 500),
      fadeOutDuration: Duration(milliseconds: 500),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        // child: CircularProgressIndicator(
        //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
        // ),
      ),
      errorWidget: (context, url, error) => Container(
          width: dimension,
          height: dimension,
          color: Colors.black,
          child: Center(
              child: Icon(
            Icons.error,
            color: Colors.redAccent,
          ))),
    );
  }
}
