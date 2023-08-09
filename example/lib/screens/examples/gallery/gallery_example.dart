import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view_example/screens/common/app_bar.dart';
import 'package:photo_view_example/screens/examples/gallery/gallery_example_item.dart';

class GalleryExample extends StatefulWidget {
  @override
  _GalleryExampleState createState() => _GalleryExampleState();
}

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}

class _GalleryExampleState extends State<GalleryExample> {
  bool verticalGallery = false;

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Gallery Example",
      showGoBack: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GalleryExampleItemThumbnail(
                  galleryExampleItem: galleryItems[0],
                  onTap: () {
                    open(context, 0);
                  },
                ),
                GalleryExampleItemThumbnail(
                  galleryExampleItem: galleryItems[1],
                  onTap: () {
                    open(context, 1);
                  },
                ),
                GalleryExampleItemThumbnail(
                  galleryExampleItem: GalleryExampleItem(
                    id: "tag3",
                    resource: "assets/small-gallery2.jpg",
                  ),
                  onTap: () {
                    open(context, 2);
                  },
                ),
                GalleryExampleItemThumbnail(
                  galleryExampleItem: galleryItems[3],
                  onTap: () {
                    open(context, 3);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Vertical"),
                Checkbox(
                  value: verticalGallery,
                  onChanged: (value) {
                    setState(() {
                      verticalGallery = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      CustomPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              builderForHero: _buildItemForHero,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
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
                    // Navigator.pop(context);
                    Navigator.of(context).pop();
                    print("tui!!");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PhotoViewGalleryPageOptions> _buildItem(BuildContext context, int index) async {
    // await Future.delayed(Duration.zero);
    final GalleryExampleItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                item.resource,
                height: 200.0,
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained * 1,
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : true
            ? PhotoViewGalleryPageOptions.customChild(
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage(item.resource),
                      fit: BoxFit.contain,
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print("点击了播放按钮！");
                        },
                      ),
                    )
                  ],
                ),
                // childSize: Size(1640.0, 923.0),
                childSize: const Size(1640, 923),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
                disableScale: true,
              )
            : PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(item.resource),
                // initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
              );
  }

  PhotoViewGalleryPageOptions _buildItemForHero(BuildContext context, int index) {
    // await Future.delayed(Duration.zero);
    final GalleryExampleItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                item.resource,
                height: 200.0,
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained * 1,
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : true
            ? PhotoViewGalleryPageOptions.customChild(
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage(item.resource),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            print("点击了播放按钮！");
                          },
                        ),
                      )
                    ],
                  ),
                ),
                // childSize: Size(1640.0, 923.0),
                childSize: const Size(1640, 923),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
                disableScale: true,
              )
            : PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(item.resource),
                // initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
              );
  }
}
