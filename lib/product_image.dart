import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:quick_room_services/values/colors.dart';

import 'manage/static_method.dart';

class ZoomableImagePage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  ZoomableImagePage({super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  State<ZoomableImagePage> createState() => _ZoomableImagePageState();
}

class _ZoomableImagePageState extends State<ZoomableImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            STM().back2Previous(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        elevation: 0,
        backgroundColor: Clr().transparent,
      ),
      body:widget.imageUrls.isNotEmpty? PhotoViewGallery.builder(
        itemCount: widget.imageUrls.length,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            errorBuilder: (context, url, error) =>
                Center(child: STM().loadingPlaceHolder()),

          );
        },
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                :null ,
          ),
        ),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        pageController: PageController(initialPage: widget.initialIndex),
      ):Center(child:STM().loadingPlaceHolder()),
    );
  }
}
