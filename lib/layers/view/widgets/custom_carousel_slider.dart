import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hba_management/core/configuration/styles.dart';
import 'package:hba_management/core/enum.dart';
import 'package:hba_management/layers/data/model/image_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({
    super.key,
    required this.images,
    required this.autoScroll,
    this.withDelete = false,
    this.onDelete,
    this.height,
    this.width,
    this.startIndex,
  });
  final bool autoScroll;
  final bool withDelete;
  final void Function(ImageModel)? onDelete;
  final double? height;
  final double? width;
  final int? startIndex;
  final List<ImageModel> images;

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final PageController _pageController = PageController();

  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.page == widget.images.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    if (widget.autoScroll) {
      startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.images.length);
    if (widget.startIndex != null && _pageController.hasClients) {
      _pageController.animateToPage(widget.startIndex!,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height ?? size.height * 0.35,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                ImageModel image = widget.images[index];
                return Hero(
                  tag: image.imageUrl,
                  child: ImagePlaceHolder(
                    imageType: image.imageType,
                    imageUrl: image.imageUrl,
                  ),
                );
              },
            ),
            IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            widget.images.length > 1
                ? Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: widget.images.length,
                          effect: SwapEffect(
                            activeDotColor: Colors.white70,
                            dotColor: Colors.white38,
                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Positioned(
              top: 10,
              left: 10,
              child: Visibility(
                visible: widget.withDelete,
                child: IconButton(
                  onPressed: () => widget
                      .onDelete!(widget.images[_pageController.page!.floor()]),
                  icon: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                      backgroundColor: Styles.colorPrimary.withOpacity(0.9)),
                ),
              ),
            ),
          ],
        ));
  }
}

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({
    super.key,
    required this.imageType,
    required this.imageUrl,
  });
  final String imageUrl;
  final ImageType imageType;

  @override
  Widget build(BuildContext context) {
    return imageType == ImageType.NETWORK
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          )
        : imageType == ImageType.FILE
            ? Image.file(
                File(imageUrl),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              );
  }
}
