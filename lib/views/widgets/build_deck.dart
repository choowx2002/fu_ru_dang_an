import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/utils/image_merger.dart';

class BuildDeckPanel extends StatelessWidget {
  const BuildDeckPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 90,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 250,
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "构筑栏",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("这里是 BuildPanel 独立 Widget 内容"),
              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    List<String> frontUrls = [
                      'https://cdn.playloltcg.com//lol/2025/06/2025-06-09/56057814d8d046808536ef12e8f77346.png',
                      'https://cdn.playloltcg.com//lol/2025/06/2025-06-09/56057814d8d046808536ef12e8f77346.png',
                      'https://cdn.playloltcg.com//lol/2025/06/2025-06-09/56057814d8d046808536ef12e8f77346.png',
                    ];
                    List<String> backUrls = [
                      'https://res.cloudinary.com/dclplrpby/image/upload/v1750947278/back-blue_oafw9b.png',
                      'https://res.cloudinary.com/dclplrpby/image/upload/v1750947278/back-blue_oafw9b.png',
                      'https://res.cloudinary.com/dclplrpby/image/upload/v1750947278/back-blue_oafw9b.png',
                    ];
                    final frontSheet = await ImageMergerWebService.merge(
                      imageUrls: frontUrls,
                    );
                    ImageMergerWebService.download(
                      frontSheet,
                      "front_sheet.png",
                    );

                    final backSheet = await ImageMergerWebService.merge(
                      imageUrls: backUrls,
                    );
                    ImageMergerWebService.download(backSheet, "back_sheet.png");
                  },
                  child: const Text("生成前后合图"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
