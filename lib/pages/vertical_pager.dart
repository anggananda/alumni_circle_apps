import 'package:alumni_circle_app/dto/datas.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class VerticalCardPagger extends StatefulWidget {
  const VerticalCardPagger({super.key});

  @override
  State<VerticalCardPagger> createState() => _VerticalCardPaggerState();
}

class _VerticalCardPaggerState extends State<VerticalCardPagger> {
  Future<List<Datas>>? _datas;

  @override
  void initState() {
    super.initState();
    _datas = DataService.fetchDatas(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: FutureBuilder<List<Datas>>(
                  future: _datas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<Datas> data = snapshot.data!;

                      // Build titles and images from your data
                      final List<String> titles = data
                          .map((item) => item.name)
                          .toList(); // Assuming 'title' exists in Datas
                      final List<Widget> images = data
                          .map((item) => buildImageWidget(
                              '${Endpoints.urlDatas}/public/${item.imageUrl!}'))
                          .toList(); // Assuming 'imageUrl' exists in Datas

                      return VerticalCardPager(
                        titles: titles,
                        images: images,
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        onPageChanged: (page) {
                          // Handle page change if needed
                        },
                        onSelectedItem: (index) {
                          // Handle item selection if needed
                        },
                        initialPage: 0,
                        align: ALIGN.CENTER,
                        physics: ClampingScrollPhysics(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // Show a loading indicator while data is being fetched
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 500,
      height: 300,
      fit: BoxFit.fill,
    );
  }
}
