import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uas_pemweb/koneksi/api.dart';
import 'package:uas_pemweb/koneksi/category_data.dart';
import 'package:uas_pemweb/views/ImageView.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CategoryImagePage extends StatefulWidget {
  final String category;

  const CategoryImagePage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryImagePage> createState() => _CategoryImagePageState();
}

String findImagePathByParameter(String parameter) {
  BoxData? box = boxes.firstWhere(
    (element) => element.parameter.toLowerCase() == parameter.toLowerCase(),
  );

  return box.imagePath;
}

class ImageBottom extends StatelessWidget {
  final List<WallpaperModel>? data;

  const ImageBottom({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return data != null
        ? GridView.builder(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.55,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageView(
                          imgUrl: data![index].imageUrl,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                      imageUrl: data![index].imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : buildLoadingGrid();
  }

  Widget buildLoadingGrid() {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.black54,
      highlightColor: Colors.black87,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          return GridTile(
            child: Container(color: Colors.black38),
          );
        },
      ),
    );
  }
}

Widget buildErrorGrid() {
  return const Center(
    child: Text(
      'Error loading images.',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white38,
      ),
    ),
  );
}

class _CategoryImagePageState extends State<CategoryImagePage> {
  late ScrollController _scrollController;
  late List<WallpaperModel> _allWallpapers;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _allWallpapers = [];
    _fetchCategoryImages(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _fetchCategoryImages(int page) async {
    try {
      HttpHelper helper = HttpHelper();
      List<WallpaperModel> wallpapers =
          await helper.getCategoryPics(page, widget.category);

      _allWallpapers.addAll(wallpapers);

      setState(() {});
    } catch (e) {}
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _currentPage++;
    });

    await _fetchCategoryImages(_currentPage);
  }

  Future<void> _handleRefresh() async {
    _currentPage = 1;
    _allWallpapers.clear();
    await _fetchCategoryImages(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = findImagePathByParameter(widget.category);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              snap: false,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        '${widget.category.capitalize()} Images',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1.7, 1.2),
                              blurRadius: 0.9,
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              leading: BackButton(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ImageBottom(data: _allWallpapers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
