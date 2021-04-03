import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = "Faroe Islands Wallpapers";
  static final int wpCount = 10; //51
  static bool viewing = false, setting = false;

  @override
  Widget build(BuildContext context) =>
      CupertinoApp(title: title, home: WPHome());
}

class WPHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return CupertinoPageScaffold(
      backgroundColor: Color(0xFF000000),
      //0xFF222222
      resizeToAvoidBottomInset: true,
      // Whether the child should size itself to avoid the window's bottom inset.
      // For example, if there is an onscreen keyboard displayed above the scaffold,
      // the body can be resized to avoid overlapping the keyboard,
      // which prevents widgets inside the body from being obscured by the keyboard.
      // Defaults to true and cannot be null.
      navigationBar: CupertinoNavigationBar(
        middle: Text(MyApp.title),
      ),
      child: GridView.extent(
        //padding: EdgeInsets.fromLTRB(.05.wp, .05.wp + 68, .05.wp, .05.wp),
        padding: EdgeInsets.fromLTRB(0, 76, 0, 0),
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: List.generate(MyApp.wpCount, (i) => WPItem(i: i)),
      ),
    );
  }
}

class WPItem extends StatefulWidget {
  WPItem({Key key, this.i}) : super(key: key);
  final int i;

  @override
  State createState() => WPItemState();
}

class WPItemState extends State<WPItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    String address = 'assets/wp/' + z(widget.i + 1, 3) + '.jpg';

    return GestureDetector(
      //behavior: HitTestBehavior.translucent, ??!?!?!?!
      onTapDown: (TapDownDetails tdd) {
        setState(() {
          _hover = true;
        });
      },
      onTapUp: (TapUpDetails tud) {
        setState(() {
          _hover = false;
        });
        if (MyApp.viewing) return;
        goTo(context, Viewer(photo: address));
        MyApp.viewing = true;
      },
      onTapCancel: () {
        setState(() {
          _hover = false;
        });
      },
      child: Container(
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: Hero(
                tag: address,
                transitionOnUserGestures: true, //?!?
                child: Image.asset(address, fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.333,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 65),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(_hover ? 0x00000000 : 0x99000000),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String z(int i, int style) {
  var s = i.toString().split(''), sb = StringBuffer();
  for (int x = style; x >= 1; x--)
    sb.write(s.length >= x ? s[s.length - x] : '0');
  return sb.toString();
}

Future goTo(BuildContext context, Widget route) => Navigator.of(context)
    .push(CupertinoPageRoute<void>(builder: (context) => route));
