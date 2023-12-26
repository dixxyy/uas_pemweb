import 'package:flutter/material.dart';
import '../homepage/homepage.dart';
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
    // {
    //   'title': 'Version of Wallpaper App',
    //   'subtitle': '1.0.0',
    //   'icon': Icons.info,
    // },
    {
      'title': 'Developers',
      'subtitle': 'Kelompok 9 - Intensitas Kerja (Berurutan dari atas kebawah)',
      'icon': Icons.person,
      'developersList': [
        "Abdul Aziz",
        "Rojak Kurniawan",
        "Ahmad Rafi Kannajmi",
        "Muhammad Rizqi Fadhillah",
        "Dicky Saputra",
        "Devin Wijaya",
        "Muhammad Damar Firdaus",
        "Ilham Ambia",
        "Aditya Sastraatmaja",
        "Muhammad Rifqi Arrasyid",
        "Daffa Dzaky Syahbani",
        "Muhammad Alviansyah",
      ],
    },
    {
      'title': 'Github Front End',
      'subtitle': 'Tap to open',
      'icon': Icons.code,
      'link': 'https://github.com/kilyfa/FE_WallpaperApp_UAS',
    },
    {
      'title': 'Github Back End',
      'subtitle': 'Tap to open',
      'icon': Icons.code,
      'link': 'https://github.com/rojakkurniawan/BE_WallpaperApp_UAS',
    },
    {
      'title': 'Privacy Policy',
      'subtitle': 'Read our privacy policy',
      'icon': Icons.security,
    },
    // {
    //   'title': 'Terms and Conditions',
    //   'subtitle': 'Check the terms and conditions',
    //   'icon': Icons.assignment,
    // },
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

        if (_selectedIndex == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
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

    switch (title) {
      case 'About This App':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: const Text(
                  "Wallpaper App adalah aplikasi yang menyediakan beragam gambar latar belakang berkualitas tinggi untuk personalisasi layar perangkat Anda. Temukan pilihan menarik dari alam, seni, dan banyak kategori lainnya dalam satu aplikasi mudah digunakan."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        break;
      // case 'Version of Wallpaper App':
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text(title),
      //         content: Text(subtitle),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text('Close'),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   break;
      case 'Privacy Policy':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(title),
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Last Updated: 25 Desember 2023',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Information Collection and Use\n'
                    'Aplikasi kami tidak mengumpulkan informasi pribadi apa pun dari pengguna.\n\n'
                    'Log Data\n'
                    'Ketika Anda menggunakan aplikasi kami, kami tidak mengumpulkan data dan informasi melalui layanan pihak ketiga yang digunakan.\n\n'
                    'Changes to This Privacy Policy\n'
                    'Kami dapat memperbarui Kebijakan Privasi kami dari waktu ke waktu. Perubahan akan diumumkan dengan memperbarui tanggal "Last Updated" di atas.\n\n'
                    'Contact Us\n'
                    'Dengan menggunakan aplikasi kami, Anda setuju dengan Kebijakan Privasi kami.',
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        break;
      // case 'Terms and Conditions':
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(15.0),
      //         ),
      //         title: Text(title),
      //         content: const Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               'Last Updated: 25 Desember 2023',
      //               style: TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //             SizedBox(height: 10),
      //             Text(
      //               'Information Collection and Use\n'
      //               'Aplikasi kami tidak mengumpulkan informasi pribadi apa pun dari pengguna.\n\n'
      //               'Log Data\n'
      //               'Ketika Anda menggunakan aplikasi kami, kami tidak mengumpulkan data dan informasi melalui layanan pihak ketiga yang digunakan.\n\n'
      //               'Changes to This Privacy Policy\n'
      //               'Kami dapat memperbarui Kebijakan Privasi kami dari waktu ke waktu. Perubahan akan diumumkan dengan memperbarui tanggal "Last Updated" di atas.\n\n'
      //               'Contact Us\n'
      //               'Dengan menggunakan aplikasi kami, Anda setuju dengan Kebijakan Privasi kami.',
      //             ),
      //           ],
      //         ),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text('Close'),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   break;
      default:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(title),
              content: Text(subtitle),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListView(
            shrinkWrap: true,
            children: appInfo.map((info) {
              return GestureDetector(
                onTap: () {
                  if (info['title'] == 'Github Front End') {
                    _launchURL(info['link'] as String);
                  } else if (info['title'] == 'Github Back End') {
                    _launchURL(info['link'] as String);
                  } else if (info['title'] == 'Developers') {
                    _showDevelopersDialog(context, info['developersList']);
                  } else {
                    _showInfoDialog(context, info);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
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
                        ? const Text(
                            'Kelompok 9\n\n(Tap in here to see contributors)',
                            style: TextStyle(color: Colors.black87))
                        : Text(
                            info['subtitle'] as String,
                            style: TextStyle(color: Colors.grey[800]),
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

void _showDevelopersDialog(BuildContext context, List<String> developersList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Developers'),
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
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
