import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khetihar/models/crop.dart';
import 'package:khetihar/pages/farmer/addcrop.dart';
import 'package:khetihar/pages/farmer/crop_detail.dart';
import 'package:velocity_x/velocity_x.dart';

class YourCrops extends StatefulWidget {
  @override
  State<YourCrops> createState() => YourCropsState();
}

class YourCropsState extends State<YourCrops> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    final cropJson = await rootBundle.loadString("assets/files/crop.json");
    final decodedData = jsonDecode(cropJson);
    var cropsData = decodedData["crops"];
    print(cropsData);
    CropCatalog.crops =
        List.from(cropsData).map<Crop>((item) => Crop.fromMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCrop(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          padding: Vx.m2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (CropCatalog.crops != null && CropCatalog.crops.isNotEmpty)
                CropList().py0().expand()
              else
                CircularProgressIndicator().centered().expand()
            ],
          ),
        ),
      ),
    );
  }
}

class CropList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: CropCatalog.crops.length,
      itemBuilder: (context, index) {
        final crop = CropCatalog.crops[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropDetail(crop: crop),
            ),
          ),
          child: CropItem(crop: crop),
        );
      },
    );
  }
}

class CropItem extends StatelessWidget {
  final Crop crop;

  const CropItem({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Row(
        children: [
          Hero(
            tag: Key(crop.id.toString()),
            child: CropImage(
              image: crop.image,
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              crop.name.text.lg.color(context.accentColor).bold.make(),
              "Base Price: ${crop.price}"
                  .text
                  .textStyle(context.captionStyle)
                  .make(),
              "Stock Available : ${crop.stock}"
                  .text
                  .textStyle(context.captionStyle)
                  .make(),
              10.heightBox,
            ],
          ))
        ],
      ),
    ).color(context.cardColor).rounded.square(150).make().py16();
  }
}

class CropImage extends StatelessWidget {
  final String image;

  const CropImage({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
    ).box.rounded.p8.color(context.canvasColor).make().p16().w40(context);
  }
}
