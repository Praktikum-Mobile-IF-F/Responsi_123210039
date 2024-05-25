import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/kopi_model.dart';
import '../services/api_data_source.dart';
import '../kopi_manager.dart';
import './kopi_detail.dart';
import '../main.dart';

class KopiPage extends StatefulWidget {
  const KopiPage({Key? key}) : super(key: key);

  @override
  _KopiPageState createState() => _KopiPageState();
}

class _KopiPageState extends State<KopiPage> {
  final KopiManager _kopiManager = KopiManager();
  late SharedPreferences _prefs;
  List<JenisKopi> _kopis = [];
  bool _isLoading = true;
  late SharedPreferences logindata;
  late String username = "";

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _loadKopis();
    initial();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _kopiManager.setPrefs(_prefs);
    setState(() {
      _isLoading = false;
    });
  }

  void _loadKopis() async {
    try {
      List<JenisKopi> kopis = await ApiDataSource().loadKopis();
      setState(() {
        _kopis = kopis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load kopi'),
      ));
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      _kopiManager.toggleFavorite(index);
    });

    String message = _kopiManager.favoriteIndices.contains(index)
        ? 'Added to favorites'
        : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  void logout() {
    logindata.setBool('login', true);
    logindata.remove('username');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Breeds List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 78, 38, 38),
        actions: [
          TextButton(
            onPressed: () {
              logout();
            },
            child: Text(
              "LOGOUT",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout_sharp, color: Colors.white))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _kopis.length,
              itemBuilder: (BuildContext context, int index) {
                final kopi = _kopis[index];
                return Card(
                  color: Color.fromARGB(255, 71, 38, 45),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Text(
                      kopi.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      kopi.description,
                      style: TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: _kopiManager.favoriteIndices.contains(index)
                          ? Icon(Icons.star, color: Colors.amber)
                          : Icon(Icons.star_border, color: Colors.white),
                      onPressed: () => _toggleFavorite(index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KopiDetail(kopi: kopi),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
