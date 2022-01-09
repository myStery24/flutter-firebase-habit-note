import 'package:flutter/material.dart';
import 'package:habit_note/providers/base_model.dart';
import 'package:habit_note/providers/image_provider.dart';
import 'package:habit_note/providers/text_provider.dart';
import 'package:habit_note/screens/ocr/components/UploadImageButton.dart';
import 'package:provider/provider.dart';

import 'components/DisplayImage.dart';
import 'components/ResultPage.dart';

/// TODO: Fix Error
class TextRecognitionScreen extends StatelessWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image to Text (OCR)'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25.0,
            ),
            MultiProvider(
              providers: [
                Consumer<ImageViewModel>(
                  builder: (_, imageProvider, __) =>
                      (imageProvider.state == CurrentState.loading)
                          ? const Center(child: CircularProgressIndicator())
                          : (imageProvider.state == CurrentState.loaded)
                              ? Column(
                                  children: [
                                    DisplayImage(imageProvider.image.imagePath),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    UploadImageButton(
                                        text: 'Get another image',
                                        onTap: imageProvider.getImage)
                                  ],
                                )
                              : UploadImageButton(
                                  text: 'Upload image',
                                  onTap: imageProvider.getImage),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Consumer2<TextViewModel, ImageViewModel>(
              builder: (_, textProvider, imageProvider, __) => ElevatedButton(
                onPressed: (imageProvider.image == null)
                    ? null
                    : () {
                        textProvider.getText();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ResultPage()));
                      },
                child: const Text('Get text'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
