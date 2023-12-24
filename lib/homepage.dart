import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pemweb/category.dart';
import 'package:uas_pemweb/imagepage.dart';
import 'package:uas_pemweb/koneksi/category_data.dart';
import 'package:uas_pemweb/views/aboutus.dart';
import 'package:uas_pemweb/views/category_list.dart';
import '../views/bottom_navigation.dart';
import '../views/favorite_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../dark_mode/theme_provider.dart';
import '../dark_mode/theme_mode.dart';

Widget _buildIcon(BuildContext context) {
  ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;
  print("Current theme: $themeData");
  return themeData == AppTheme.darkMode
      ? Icon(Icons.nightlight_round)
      : Icon(Icons.wb_sunny);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedIndexCarousel = 0;
  int _totalPages = 7;
  late CarouselController _carouselController;

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

        if (_selectedIndex == 0) {
        } else if (_selectedIndex == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CategoryList()),
            (route) => false,
          );
        } else if (_selectedIndex == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteView()),
            (route) => false,
          );
        } else if (_selectedIndex == 3) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
            (route) => false,
          );
        }
      }
    });
  }

  void _updateIndex(int index) {
    if (index >= 0 && index < _totalPages) {
      setState(() {
        _selectedIndexCarousel = index;
      });
      _carouselController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();

    _selectedIndexCarousel = _selectedIndexCarousel.clamp(0, _totalPages - 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.jumpToPage(_selectedIndexCarousel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallpaper App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: _buildIcon(context),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(bottom: 20, left: 20),
                title: Text(
                  'Recommended For You!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                width: 300,
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    viewportFraction: 0.7,
                    aspectRatio: 9 / 16,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      _updateIndex(index);
                    },
                  ),
                  items: List.generate(_totalPages, (index) {
                    double scaleFactor = 0.9;
                    if (index == _selectedIndexCarousel) {
                      scaleFactor = 1.0;
                    }
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          _updateIndex(index);
                          print('Card pressed at index $index');
                        },
                        child: Container(
                          child: Transform.scale(
                            scale: scaleFactor,
                            child: Card(
                              elevation: 4,
                              child: Center(child: Text('Wallpaper $index')),
                              color: _selectedIndexCarousel == index
                                  ? Colors.pink
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 8.0, right: 8.0, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    AnimatedSmoothIndicator(
                      activeIndex: _selectedIndexCarousel % _totalPages,
                      count: _totalPages,
                      effect:
                          ExpandingDotsEffect(dotWidth: 7.5, dotHeight: 7.5),
                      onDotClicked: (index) {
                        _updateIndex(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
            CategoryWidget(boxes: boxes),
          ];
        },
        body: const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
          child: Display(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
