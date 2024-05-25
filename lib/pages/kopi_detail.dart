import 'package:flutter/material.dart';
import '../model/kopi_model.dart';

class KopiDetail extends StatelessWidget {
  final JenisKopi kopi;

  const KopiDetail({Key? key, required this.kopi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(width: 16),
            Text(
              kopi.name,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1B1A55),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 116, 76, 52),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    kopi.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    kopi.description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 16.0),
                  _buildDetailItem("Price", kopi.price as String?),
                  _buildDetailItem("Region", kopi.region),
                  _buildDetailItem("Weight", kopi.weight as String?),
                  _buildDetailItem("Roast Level", kopi.roastLevel as String?),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return value != null && value.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
