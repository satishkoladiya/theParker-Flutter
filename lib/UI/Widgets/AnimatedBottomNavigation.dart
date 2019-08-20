import 'dart:math';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukicons/moneyTransfer.dart';
import 'package:koukicons/simCard.dart';
import 'package:koukicons/tabletAndroid.dart';
import 'package:the_parker/UI/Resources/ConstantMethods.dart';
import 'package:the_parker/UI/Widgets/ParallexCardWidet.dart';
import 'package:the_parker/UI/Widgets/ease_in_widget.dart';
import 'package:the_parker/UI/utils/page_transformer.dart';

double bottomBarVisibleHeight = 55.0;
double bottomBarOriginalHeight = 80.0;
double bottomBarExpandedHeight = 300.0;

class CustomBottomNavigationBarAnimated extends StatefulWidget {
  CustomBottomNavigationBarAnimated({
    Key key,
    this.onTap,
    this.currentBottomBarPercent,
    this.currentProfilePercentage,
    // this.closeProfile,
  }) : super(key: key);

  final Function(int) onTap;
  // final Function(bool) closeProfile;
  final Function(double) currentBottomBarPercent;
  final double currentProfilePercentage;

  _CustomBottomNavigationBarAnimatedState createState() =>
      _CustomBottomNavigationBarAnimatedState();
}

class _CustomBottomNavigationBarAnimatedState
    extends State<CustomBottomNavigationBarAnimated>
    with TickerProviderStateMixin {
  CurvedAnimation curve;

  //*Parallex Animation Code
  AnimationController animationControllerBottomBarParallex;
  var offsetBottomBarParallex = 0.0;
  get currentBottomBarParallexPercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarParallex /
              (bottomBarExpandedHeight - bottomBarOriginalHeight),
        ),
      );
  bool isBottomBarParallexOpen = false;
  Animation<double> animationParallex;

  void onParallexVerticalDragUpdate(details) {
    offsetBottomBarParallex -= details.delta.dy;
    if (offsetBottomBarParallex > bottomBarExpandedHeight) {
      offsetBottomBarParallex = bottomBarExpandedHeight;
    } else if (offsetBottomBarParallex < 0) {
      offsetBottomBarParallex = 0;
    }
    widget.currentBottomBarPercent(currentBottomBarParallexPercentage);
    setState(() {});
  }

  void animateBottomBarParallex(bool open) {
    // if (isBottomBarParallexOpen) {
    //   isBottomBarParallexOpen = false;
    // }

    if (isBottomBarMoreOpen) {
      animateBottomBarMore(!isBottomBarMoreOpen);
    }

    animationControllerBottomBarParallex = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isBottomBarParallexOpen
                            ? currentBottomBarParallexPercentage
                            : (1 - currentBottomBarParallexPercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarParallex, curve: Curves.ease);
    animationParallex = Tween(
            begin: offsetBottomBarParallex,
            end: open ? bottomBarExpandedHeight : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetBottomBarParallex = animationParallex.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isBottomBarParallexOpen = open;
            }
          });
    animationControllerBottomBarParallex.forward();
  }

  //* More Button Animation Code

  AnimationController animationControllerBottomBarMore;
  var offsetBottomBarMore = 0.0;
  get currentBottomBarMorePercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarMore /
              (bottomBarExpandedHeight - bottomBarOriginalHeight),
        ),
      );
  bool isBottomBarMoreOpen = false;
  Animation<double> animationMore;

  void onMoreVerticalDragUpdate(details) {
    offsetBottomBarMore -= details.delta.dy;
    if (offsetBottomBarMore > bottomBarExpandedHeight) {
      offsetBottomBarMore = bottomBarExpandedHeight;
    } else if (offsetBottomBarMore < 0) {
      offsetBottomBarMore = 0;
    }
    widget.currentBottomBarPercent(currentBottomBarMorePercentage);
    setState(() {});
  }

  void animateBottomBarMore(bool open) {
    if (isBottomBarParallexOpen) {
      animateBottomBarParallex(!isBottomBarParallexOpen);
    }

    animationControllerBottomBarMore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (1000 *
                        (isBottomBarMoreOpen
                            ? currentBottomBarMorePercentage
                            : (1 - currentBottomBarMorePercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarMore, curve: Curves.ease);
    animationMore = Tween(
            begin: offsetBottomBarMore,
            end: open ? bottomBarExpandedHeight : 0.0)
        .animate(curve)
          ..addListener(
            () {
              setState(() {
                offsetBottomBarMore = animationMore.value;
              });
            },
          )
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                isBottomBarMoreOpen = open;
              }
            },
          );
    animationControllerBottomBarMore.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentProfilePercentage > 0.30) {
      if (isBottomBarParallexOpen) {
        animateBottomBarParallex(false);
      }
    }
    return CustomBottomNavigationBar(
      //* "Parallex" Animation
      animateBottomBarParallex: animateBottomBarParallex,
      currentBottomBarParallexPercentage: currentBottomBarParallexPercentage,
      isBottomBarParallexOpen: isBottomBarParallexOpen,
      onTap: widget.onTap,
      onParallexVerticalDragUpdate: onParallexVerticalDragUpdate,
      onParallexPanDown: () => animationControllerBottomBarParallex?.stop(),
      //* "More" Animation
      animateBottomBarMore: animateBottomBarMore,
      currentBottomBarMorePercentage: currentBottomBarMorePercentage,
      isBottomBarMoreOpen: isBottomBarMoreOpen,
      onMoreVerticalDragUpdate: onMoreVerticalDragUpdate,
      onMorePanDown: () => animationControllerBottomBarMore?.stop(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerBottomBarParallex?.dispose();
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    Key key,
    this.onTap,
    this.animateBottomBarParallex,
    this.currentBottomBarParallexPercentage,
    this.isBottomBarParallexOpen,
    this.onParallexPanDown,
    this.onParallexVerticalDragUpdate,
    this.animateBottomBarMore,
    this.currentBottomBarMorePercentage,
    this.isBottomBarMoreOpen,
    this.onMorePanDown,
    this.onMoreVerticalDragUpdate,
  }) : super(key: key);

  final Function(int) onTap;

  final double currentBottomBarParallexPercentage;
  final Function(bool) animateBottomBarParallex;
  final bool isBottomBarParallexOpen;
  final Function(DragUpdateDetails) onParallexVerticalDragUpdate;
  final Function() onParallexPanDown;

  final double currentBottomBarMorePercentage;
  final Function(bool) animateBottomBarMore;
  final bool isBottomBarMoreOpen;
  final Function(DragUpdateDetails) onMoreVerticalDragUpdate;
  final Function() onMorePanDown;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 15,
      right: 15,
      child: Card(
        color: Colors.transparent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SizedBox(
          height: bottomBarOriginalHeight +
              //* Increase height when parallex card is expanded *//
              (bottomBarExpandedHeight - bottomBarOriginalHeight) *
                  currentBottomBarParallexPercentage +
              //* Increase height when More Button is expanded *//
              (bottomBarExpandedHeight) * currentBottomBarMorePercentage,
          child: Stack(
            children: <Widget>[
              _buildBackgroundForParallexCard(context),

              isBottomBarParallexOpen ? _buildParallexCards() : Container(),

              _buildOtherButtons(context),
              _buildMoreExpandedCard(context),
              // Container(color: Colors.blue,),
              _buildCenterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreExpandedCard(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 60,
      child: Opacity(
        opacity: currentBottomBarMorePercentage,
        child: Container(
          height: (bottomBarExpandedHeight - bottomBarVisibleHeight - 10) *
              currentBottomBarMorePercentage,
          // color: Colors.blue,
          child: Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  // color: Colors.red,
                  child: FlatButton(
                    child: Icon(
                      Icons.monetization_on,
                      size: 50,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0),
        height: bottomBarVisibleHeight +
            (bottomBarExpandedHeight - 0) * currentBottomBarMorePercentage,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[_buildMoreButton(), _buildSearchButton()],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Expanded(
      child: Container(
        height: bottomBarVisibleHeight,
        child: FloatingActionButton(
          heroTag: 'sdansiux',
          // padding: EdgeInsets.only(left: 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                EvaIcons.search,
                size: 30,
                // color: Theme.of(context).primaryColor,
              ),
              Text(
                'Search',
                style: ktitleStyle.copyWith(
                  fontSize: 13,
                  // color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
          onPressed: () {
            onTap(2);
          },
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: bottomBarVisibleHeight,
            child: GestureDetector(
              onPanDown: (_) => onMorePanDown,
              onVerticalDragUpdate: onMoreVerticalDragUpdate,
              onVerticalDragEnd: (_) {
                _dispatchBottomBarMoreOffset();
              },
              onVerticalDragCancel: () {
                _dispatchBottomBarMoreOffset();
              },
              child: FloatingActionButton(
                heroTag: 'dsc',
                // padding: EdgeInsets.only(right: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                onPressed: () {
                  onTap(0);
                  animateBottomBarMore(!isBottomBarMoreOpen);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform(
                      alignment: FractionalOffset.center,
                      transform: new Matrix4.identity()
                        ..rotateZ(180 *
                            currentBottomBarMorePercentage *
                            3.1415927 /
                            180),
                      child: Icon(
                        EvaIcons.arrowCircleUpOutline,
                        size: 30,
                        // color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'More',
                      style: ktitleStyle.copyWith(
                        fontSize: 13,
                        // color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: (bottomBarExpandedHeight - bottomBarVisibleHeight) *
                currentBottomBarMorePercentage,
            // child: Container(
            //   color: Colors.red,
            // ),
          )
        ],
      ),
    );
  }

  Widget _buildBackgroundForParallexCard(BuildContext context) {
    return Positioned(
      top: 25,
      bottom: 55,
      left: 0,
      right: 0,
      child: Container(
        height: (bottomBarExpandedHeight - bottomBarOriginalHeight) *
            currentBottomBarParallexPercentage,
        color: Theme.of(context).canvasColor,
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30 +
          (bottomBarExpandedHeight - bottomBarOriginalHeight) *
              currentBottomBarParallexPercentage -
          25 * currentBottomBarMorePercentage,
      // alignment: Alignment.topCenter,
      child: SizedBox(
        height: 50,
        width: 50,
        child: EaseInWidget(
          onTap: () {
            onTap(1);
            animateBottomBarParallex(!isBottomBarParallexOpen);
          },
          child: GestureDetector(
            onPanDown: (_) => onParallexPanDown,
            onVerticalDragUpdate: onParallexVerticalDragUpdate,
            onVerticalDragEnd: (_) {
              _dispatchBottomBarParallexOffset();
            },
            onVerticalDragCancel: () {
              _dispatchBottomBarParallexOffset();
            },
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).textTheme.body1.color,
              heroTag: 'adaojd',
              elevation: 0,
              onPressed: null,
              child: Icon(
                Icons.view_column,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final parallaxCardItemsList = <ParallaxCardItem>[
    ParallaxCardItem(
      title: 'Overexposed',
      body: 'Maroon 5',
      marker: Marker(
          markerId: MarkerId('nswtdkaslnnad'),
          position: LatLng(19.017573, 72.856276)),
    ),
    ParallaxCardItem(
      title: 'Blurryface',
      body: 'Twenty One Pilots',
      marker: Marker(
          markerId: MarkerId('nsdkasnnad'),
          position: LatLng(19.017573, 72.856276)),
    ),
    ParallaxCardItem(
      title: 'Free Spirit',
      body: 'Khalid',
      marker: Marker(
          markerId: MarkerId('nsdkasnndswad'),
          position: LatLng(19.077573, 72.856276)),
    ),
  ];

  Widget _buildParallexCards() {
    return Positioned(
      bottom: 35 * currentBottomBarParallexPercentage,
      left: 0,
      right: 0,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: 30.0 * currentBottomBarParallexPercentage),
        child: SizedBox.fromSize(
          size: Size.fromHeight(200.0 * currentBottomBarParallexPercentage),
          child: PageTransformer(
            pageViewBuilder: (context, visibilityResolver) {
              return PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: parallaxCardItemsList.length,
                itemBuilder: (context, index) {
                  final item = parallaxCardItemsList[index];
                  final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);
                  return ParallaxCardsWidget(
                    item: item,
                    pageVisibility: pageVisibility,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _dispatchBottomBarParallexOffset() {
    if (!isBottomBarParallexOpen) {
      if (currentBottomBarParallexPercentage < 0.3) {
        animateBottomBarParallex(false);
      } else {
        animateBottomBarParallex(true);
      }
    } else {
      if (currentBottomBarParallexPercentage > 0.6) {
        animateBottomBarParallex(true);
      } else {
        animateBottomBarParallex(false);
      }
    }
  }

  void _dispatchBottomBarMoreOffset() {
    if (!isBottomBarMoreOpen) {
      if (currentBottomBarMorePercentage < 0.3) {
        animateBottomBarMore(false);
      } else {
        animateBottomBarMore(true);
      }
    } else {
      if (currentBottomBarMorePercentage > 0.6) {
        animateBottomBarMore(true);
      } else {
        animateBottomBarMore(false);
      }
    }
  }
}
