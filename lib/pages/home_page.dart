import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../api_client/api_client.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          _SomedayShow(),
          _Tint(),
          // _SomedayTextField(),
          _SomedaySoon(),
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

class _Tint extends StatelessWidget {
  const _Tint({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
    );
  }
}

class _SomedayShow extends StatefulWidget {
  _SomedayShow({Key key}) : super(key: key);

  @override
  _SomedayShowState createState() => _SomedayShowState();
}

class _SomedayShowState extends State<_SomedayShow> {
  bool _isFaderVisible = true;

  Future<void> _showFuture;

  List<String> _imageSources;
  Image _curImage;
  bool _isImageAvailable = false;
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    _showFuture = runShow();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _showFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _showFuture = runShow();
          print('running show again');
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            _isImageAvailable ? _curImage : SizedBox.expand(),
            AnimatedOpacity(
              opacity: _isFaderVisible ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> runShow() async {
    ImagesApi imagesApi = ImagesApi();

    if (_imageSources == null || _imageSources.length <= 0) {
      // _imageSources = await imagesApi.getImages();
      setStaticImageSources();
    }

    _isImageAvailable = false;

    _curImage = Image.network(
      _imageSources[_imageIndex],
      fit: BoxFit.cover,
      headers: {
        'Referrer-Policy': 'no-referrer',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-dest': 'image',
        'sec-fetch-site': 'none',
        'upgrade-insecure-requests': '1',
        'cache-control': 'max-age=0',
        'content-type': 'image/jpg'
      },
    );

    final ImageStream stream = _curImage.image.resolve(ImageConfiguration());
    final Completer<void> completer = Completer<void>();
    stream.addListener(ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        _isImageAvailable = true;
        completer.complete();
      },
    ));

    await completer.future;

    // Uint8List bytes = await imagesApi.getImageBytes(_imageSources[_imageIndex]);
    // _curImage = Image.memory(
    //   bytes,
    //   fit: BoxFit.cover,
    // );
    // _isImageAvailable = true;

    _isFaderVisible = false;
    setState(() {
      print('fade out');
    });

    await Future.delayed(Duration(seconds: 10));

    _isFaderVisible = true;
    setState(() {
      print('fade in');
    });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _imageIndex++;
      if (_imageIndex >= _imageSources.length) {
        _imageIndex = 0;
      }
      print('changing image');
    });
  }

  void setStaticImageSources() {
    _imageSources = [
      'https://i.pinimg.com/originals/6f/6a/0f/6f6a0f431ebe6debfe11a35d22dfd665.jpg',
      'https://i.pinimg.com/originals/7b/00/7f/7b007f05c5f67c1b59cbe5a6d5977cfd.jpg',
      'https://wallpapercave.com/wp/wp5429555.jpg',
      'https://wallpapercave.com/wp/wp4861208.jpg',
      'https://i.pinimg.com/originals/26/38/2d/26382da38d7677231057d923d9b0c8c3.jpg',
      'https://wallpapercave.com/wp/wp5429454.jpg',
      'https://images.hdqwalls.com/download/anime-girl-flying-paper-plane-4k-9h-2560x1440.jpg',
      'https://c.wallhere.com/photos/52/bb/airport_original_characters_anime-61716.jpg!d',
      'https://mocah.org/uploads/posts/1146184-illustration-anime-anime-girls-sky-clouds-Saenai-Heroine-no-Sodatekata-paper-planes-mythology-Kato-Megumi-screenshot-computer-wallpaper-mangaka.jpg',
      'https://png.pngtree.com/thumb_back/fw800/background/20190222/ourmid/pngtree-paper-plane-cartoon-background-flying-in-the-sky-skyover-the-skyfly-image_60065.jpg',
      // 'https://www.wallpapermaiden.com/wallpaper/18192/download/3840x2160/anime-girl-profile-view-paper-airplane-school-uniform-scenic.png',
      'https://c4.wallpaperflare.com/wallpaper/165/852/937/girl-sky-anime-airplane-wallpaper-preview.jpg',
    ];

    // _imageSources = [
    //   "https://w.wallhaven.cc/full/n6/wallhaven-n618z7.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-01lpp3.jpg",
    //   "https://w.wallhaven.cc/full/4o/wallhaven-4oygx5.jpg",
    //   "https://w.wallhaven.cc/full/ne/wallhaven-nero9o.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gyy9q.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gp1kq.jpg",
    //   "https://w.wallhaven.cc/full/48/wallhaven-483z21.jpg",
    //   "https://w.wallhaven.cc/full/4x/wallhaven-4xw17l.jpg",
    //   "https://w.wallhaven.cc/full/4l/wallhaven-4lv2y2.jpg",
    //   "https://w.wallhaven.cc/full/47/wallhaven-47we9e.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gvj93.jpg",
    //   "https://w.wallhaven.cc/full/96/wallhaven-96k1m8.png",
    //   "https://w.wallhaven.cc/full/vg/wallhaven-vgdj28.jpg",
    //   "https://w.wallhaven.cc/full/0q/wallhaven-0qw35q.jpg",
    //   "https://w.wallhaven.cc/full/dg/wallhaven-dgj7j3.jpg",
    //   "https://w.wallhaven.cc/full/ey/wallhaven-ey3dro.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-01qm69.jpg",
    //   "https://w.wallhaven.cc/full/0p/wallhaven-0pdlxj.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4g8oqd.jpg",
    //   "https://w.wallhaven.cc/full/yj/wallhaven-yjxeg7.jpg",
    //   "https://w.wallhaven.cc/full/42/wallhaven-42pdwg.jpg",
    //   "https://w.wallhaven.cc/full/4l/wallhaven-4lldq2.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-012759.jpg",
    //   "https://w.wallhaven.cc/full/83/wallhaven-8396v2.jpg"
    // ];

    // _imageSources = [
    //   "https://w.wallhaven.cc/full/n6/wallhaven-n618z7.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-01lpp3.jpg",
    //   "https://w.wallhaven.cc/full/4o/wallhaven-4oygx5.jpg",
    //   "https://w.wallhaven.cc/full/ne/wallhaven-nero9o.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gyy9q.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gp1kq.jpg",
    //   "https://w.wallhaven.cc/full/48/wallhaven-483z21.jpg",
    //   "https://w.wallhaven.cc/full/4x/wallhaven-4xw17l.jpg",
    //   "https://w.wallhaven.cc/full/4l/wallhaven-4lv2y2.jpg",
    //   "https://w.wallhaven.cc/full/47/wallhaven-47we9e.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4gvj93.jpg",
    //   "https://w.wallhaven.cc/full/96/wallhaven-96k1m8.png",
    //   "https://w.wallhaven.cc/full/vg/wallhaven-vgdj28.jpg",
    //   "https://w.wallhaven.cc/full/0q/wallhaven-0qw35q.jpg",
    //   "https://w.wallhaven.cc/full/dg/wallhaven-dgj7j3.jpg",
    //   "https://w.wallhaven.cc/full/ey/wallhaven-ey3dro.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-01qm69.jpg",
    //   "https://w.wallhaven.cc/full/0p/wallhaven-0pdlxj.jpg",
    //   "https://w.wallhaven.cc/full/4g/wallhaven-4g8oqd.jpg",
    //   "https://w.wallhaven.cc/full/yj/wallhaven-yjxeg7.jpg",
    //   "https://w.wallhaven.cc/full/42/wallhaven-42pdwg.jpg",
    //   "https://w.wallhaven.cc/full/4l/wallhaven-4lldq2.jpg",
    //   "https://w.wallhaven.cc/full/01/wallhaven-012759.jpg",
    //   "https://w.wallhaven.cc/full/83/wallhaven-8396v2.jpg"
    // ];

    // _imageSources = [
    //   "https://w.wallhaven.cc/full/72/wallhaven-72p5k3.jpg",
    // ];
    //

    _imageSources.shuffle();
  }
}

class _SomedayTextField extends StatelessWidget {
  _SomedayTextField({Key key}) : super(key: key);

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
                focusColor: Colors.white,
              ),
              cursorColor: Colors.white,
              cursorHeight: 36,
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SomedaySoon extends StatelessWidget {
  const _SomedaySoon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Someday... launching soon! ✈️",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 64,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
