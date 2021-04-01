import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          _SomedayShow(),
          _SomedayTextField(),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
    );
  }
}

class _SomedayShow extends StatefulWidget {
  _SomedayShow({Key key}) : super(key: key);

  final List<String> images = [
    'https://i.pinimg.com/originals/6f/6a/0f/6f6a0f431ebe6debfe11a35d22dfd665.jpg',
    'https://i.pinimg.com/originals/7b/00/7f/7b007f05c5f67c1b59cbe5a6d5977cfd.jpg',
    'https://wallpapercave.com/wp/wp5429555.jpg',
    'https://wallpapercave.com/wp/wp4861208.jpg',
    'https://i.pinimg.com/originals/26/38/2d/26382da38d7677231057d923d9b0c8c3.jpg',
    'https://www.itl.cat/pngfile/big/49-492999_anime-landscape-wallpaper-492109-old-japanese-house-anime.jpg',
    'https://cdn.wallpapersafari.com/64/0/jpvDU3.jpg',
    'https://wallpapercave.com/wp/wp5429454.jpg',
    'https://p4.wallpaperbetter.com/wallpaper/400/142/398/anime-landscape-city-view-buildings-anime-girl-wallpaper-preview.jpg',
    'https://images2.alphacoders.com/703/703350.png'
  ];

  @override
  _SomedayShowState createState() => _SomedayShowState();
}

class _SomedayShowState extends State<_SomedayShow> {
  Timer _imageCycleTimer;
  int _imageIndex = 0;
  bool _isImageAvailable = false;

  @override
  void dispose() {
    super.dispose();
    if (_imageCycleTimer != null && _imageCycleTimer.isActive) {
      _imageCycleTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      widget.images[_imageIndex],
      fit: BoxFit.cover,
    );

    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        _isImageAvailable = true;
        _imageCycleTimer = Timer(Duration(seconds: 10), () {
          updateImage();
        });
      },
    ));

    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_isImageAvailable)
              Container(
                color: Colors.black,
              ),
            image,
          ],
        ));
  }

  void updateImage() {
    setState(() {
      _imageIndex++;
      if (_imageIndex >= widget.images.length) {
        _imageIndex = 0;
      }
      _isImageAvailable = false;
      print('updating image...');
    });
  }
}

class _SomedayTextField extends StatelessWidget {
  const _SomedayTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                fillColor: Colors.white,
                hintStyle: TextStyle(
                  fontSize: 36,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                ),
                hintText: 'Someday..',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
