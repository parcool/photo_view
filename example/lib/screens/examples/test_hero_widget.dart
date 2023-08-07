import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 5500);
// 修改为你想要的动画持续时间，单位是毫秒，上面设置为500毫秒
}

class TestHeroWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: InkWell(
                child: Hero(
                    tag: "tag",
                    child: Container(
                      color: Colors.blue,
                      width: 200,
                      height: 200,
                      child: const Image(image: AssetImage("assets/small-image.jpg"),),
                    )),
                onTap: () {
                  Navigator.of(context).push(CustomPageRoute(builder: (_) {
                    return TestHeroTargetWidget();
                  }));
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestHeroTargetWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            InkWell(
              child: Hero(
                  tag: "tag",
                  child: Container(
                    color: Colors.red,
                    width: 500,
                    height: 500,
                    child: const Image(image: AssetImage("assets/large-image.jpg"),),
                  )),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
