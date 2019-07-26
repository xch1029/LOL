import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class ImagePreview extends StatelessWidget {
  final String image;
  const ImagePreview({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(direction: Axis.vertical, children: <Widget>[
        Expanded(
          flex: 2,
          child: ExtendedImage.network(
            image,
            fit: BoxFit.contain,
            //enableLoadState: false,
            mode: ExtendedImageMode.Gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
              );
            },
          ),
        ),
      ]),
    );
  }
}
