import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../homepage/category.dart';
import '../homepage/imagepage.dart';
import 'package:uas_pemweb/koneksi/api.dart';
import 'package:uas_pemweb/koneksi/category_data.dart';
import 'package:uas_pemweb/views/ImageView.dart';
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
      ? const Icon(Icons.nightlight_round)
      : const Icon(Icons.wb_sunny);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedIndexCarousel = 0;
  final int _totalPages = 7;
  late CarouselController _carouselController;
  int currentPage = 1;
  List<WallpaperModel> wallpapers = [];
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    _carouselController = CarouselController();
    super.initState();
    _loadMore();
  }

  void _loadMore() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    HttpHelper helper = HttpHelper();
    List<WallpaperModel> newWallpapers = await helper.getpics(currentPage);

    if (newWallpapers.isEmpty) {
      setState(() => hasMore = false);
    } else {
      currentPage++;
      setState(() => wallpapers.addAll(newWallpapers));
    }

    setState(() => isLoading = false);
  }

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
            MaterialPageRoute(builder: (context) => const AboutPage()),
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
            const SliverAppBar(
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
                  items: List.generate(min(_totalPages, wallpapers.length),
                      (index) {
                    double scaleFactor = 0.9;
                    if (index == _selectedIndexCarousel) {
                      scaleFactor = 1.0;
                    }
                    final item = wallpapers[index];
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          _updateIndex(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imgUrl: item.imageUrl,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: Transform.scale(
                            scale: scaleFactor,
                            child: Card(
                              elevation: 4,
                              child: Image.network(
                                index < wallpapers.length
                                    ? wallpapers[index].imageUrl
                                    : 'Loading...',
                                fit: BoxFit.cover,
                              ),
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
                    bottom: 20.0, left: 5.0, right: 5.0, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    AnimatedSmoothIndicator(
                      activeIndex: _selectedIndexCarousel % _totalPages,
                      count: _totalPages,
                      effect: const ExpandingDotsEffect(
                          dotWidth: 7.5, dotHeight: 7.5),
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
          padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
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
