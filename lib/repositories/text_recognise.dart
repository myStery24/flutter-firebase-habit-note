import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:habit_note/model/data_layer.dart';

class MlService {
  Future<List<RecognizedText>> getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
    await textDetector.processImage(inputImage);

    List<RecognizedText> recognizedList = [];

    for (TextBlock block in recognisedText.blocks) {
      recognizedList.add(
          RecognizedText(lines: block.lines, block: block.text.toLowerCase()));
    }

    return recognizedList;
  }
}