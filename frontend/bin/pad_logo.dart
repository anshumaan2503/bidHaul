import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/new logo.png');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }

  final rawImage = img.decodeImage(file.readAsBytesSync());
  if (rawImage == null) {
    print('Failed to decode image');
    return;
  }

  // Create a 512x512 canvas
  const canvasSize = 512;
  // Make logo fit within ~340x340 (which leaves ~25% safe padding all around)
  const targetSize = 340;

  final resizedLogo = img.copyResize(rawImage, width: targetSize, height: targetSize, interpolation: img.Interpolation.linear);

  final canvas = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0)); // Transparent

  final offsetX = (canvasSize - targetSize) ~/ 2;
  final offsetY = (canvasSize - targetSize) ~/ 2;

  img.compositeImage(canvas, resizedLogo, dstX: offsetX, dstY: offsetY);

  final outputFile = File('assets/images/new_logo_padded.png');
  outputFile.writeAsBytesSync(img.encodePng(canvas));
  print('Successfully created padded logo at ${outputFile.path}');
}
