import 'package:flutter/material.dart';
import 'package:uas_pemweb/homepage.dart';
import 'package:uas_pemweb/views/bottom_navigation.dart';
import 'package:uas_pemweb/views/category_list.dart';
import 'package:uas_pemweb/views/favorite_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  int _selectedIndex = 3;

  final List<Map<String, dynamic>> appInfo = const [
    {
      'title': 'About This App',
      'subtitle': 'Information about the application',
      'icon': Icons.phone_android_outlined,
    },
    {
      'title': 'Version of Wallpaper App',
      'subtitle': '0.8.3',
      'icon': Icons.info,
    },
    {
      'title': 'Developers',
      'subtitle': 'Kelompok 9',
      'icon': Icons.person,
      'developersList': [
        'Abdul Aziz',
        'Ilham Ambia',
        'Devin Wijaya',
        'Dicky Saputra',
        'Rojak Kurniawan',
        'Aditya Sastraatmaja',
        'Ahmad Rafi Kannajmi',
        'Muhammad Alviansyah',
        'Daffa Dzaky Syahbani',
        'Muhammad Damar Firdaus',
        'Muhammad Rifqi Arrasyid',
        'Muhammad Rizqi Fadhillah',
      ],
    },
    {
      'title': 'Gitlab',
      'subtitle': 'Tap to open',
      'icon': Icons.code,
      'link': 'https://github.com/kilyfa/FE_WallpaperApp_UAS',
    },
    {
      'title': 'Privacy Policy',
      'subtitle': 'Read our privacy policy',
      'icon': Icons.security,
    },
    {
      'title': 'Terms and Conditions',
      'subtitle': 'Check the terms and conditions',
      'icon': Icons.assignment,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

        if (_selectedIndex == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
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
          //
        }
      }
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showInfoDialog(BuildContext context, Map<String, dynamic> info) {
    String title = info['title'] as String;
    String subtitle = info['subtitle'] as String;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDevelopersDialog(
      BuildContext context, List<String> developersList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Developers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: developersList.map((developer) {
              return Text(developer);
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListView(
            shrinkWrap: true,
            children: appInfo.map((info) {
              return GestureDetector(
                onTap: () {
                  if (info['title'] == 'Gitlab') {
                    _launchURL(info['link']);
                  } else if (info['title'] == 'Developers') {
                    _showDevelopersDialog(context, info['developersList']);
                  } else {
                    _showInfoDialog(context, info);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    leading: Icon(
                      info['icon'] as IconData,
                      color: Colors.grey[800],
                    ),
                    title: Text(
                      info['title'] as String,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    subtitle: info['title'] == 'Developers'
                        ? Text('Tap to see developers')
                        : Text(
                            info['subtitle'] as String,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
