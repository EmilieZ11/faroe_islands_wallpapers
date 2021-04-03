import 'package:flutter/cupertino.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class Viewer extends StatelessWidget {
  Viewer({Key key, this.photo}) : super(key: key);
  final String photo;

  void close(BuildContext context) {
    Navigator.of(context).pop();
    MyApp.viewing = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        close(context);
        return false;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: GestureDetector(
              onTapUp: (TapUpDetails tud) => close(context),
              child: Hero(
                tag: photo,
                transitionOnUserGestures: true,
                child: Image.asset(photo),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: CupertinoButton(
              color: Color(0xFFEEEEEE),
              child: Text(
                'Set as Wallpaper',
                style: TextStyle(color: Color(0xFF000000)),
              ),
              onPressed: () async {
                if (MyApp.setting) return;
                MyApp.setting = true;
                String result;
                try {
                  await WallpaperManager.setWallpaperFromAsset(
                      photo, WallpaperManager.HOME_SCREEN);
                  result = "Done!";
                } on Exception {
                  result = 'Failed!';
                }
                Fluttertoast.showToast(
                    msg: result,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xF0EEEEEE),
                    textColor: Color(0xFF000000),
                    fontSize: 16.0);
                MyApp.setting = false;
              },
            ),
          ),
        ],
      ),
    );
  }
}
