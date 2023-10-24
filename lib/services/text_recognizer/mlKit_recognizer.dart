import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'text_recognizer.dart';

class MLKitTextRecognizer extends ITextRecognizer {
  late TextRecognizer recognizer;

  MLKitTextRecognizer() {
    recognizer = TextRecognizer();
  }

  void dispose() {
    recognizer.close();
  }

  @override
  Future<String> processImage(String imgPath) async {
    var myText = "";
    final image = InputImage.fromFile(File(imgPath));
    final recognized = await recognizer.processImage(image);
    myText = reformatTextHorizontallyWithOutLineBreak(recognized.blocks);
    debugPrint("Final $myText");

    return myText;
  }
}

String reformatTextHorizontallyWithOutLineBreak(List<TextBlock> textBlocks) {
  double threshold = 20.0; // Adjust as needed based on the characteristics of your text and images.
  textBlocks.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

  List<String> horizontalLines = [];
  List<String> currentLine = [];

  for (TextBlock block in textBlocks) {
    if (currentLine.isEmpty || block.boundingBox.top - currentLine.last.length < threshold) {
      currentLine.add(block.text);
    } else {
      horizontalLines.add(currentLine.join(' ')); // Join text in the current line.
      currentLine = [block.text];
    }
  }

  horizontalLines.add(currentLine.join(' '));
  return horizontalLines.join(' ');
}
