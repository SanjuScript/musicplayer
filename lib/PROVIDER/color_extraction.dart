import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ArtworkColorProvider extends ChangeNotifier {
  PaletteGenerator? _paletteGenerator;
  PaletteGenerator? get paletteGenerator => _paletteGenerator;

  List<Color> _imageColors = [Colors.black, Colors.black];
  List<Color> get imageColors => _imageColors;

  Color _dominantColor = Colors.black;
  Color? get dominantColor => _dominantColor;

  Future<void> extractArtworkColors(
      Uint8List? artworkData, bool isDarkMode) async {
    if (artworkData == null) {
      _dominantColor = isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
      notifyListeners();
      return;
    }

    _paletteGenerator = await PaletteGenerator.fromImageProvider(
      MemoryImage(artworkData),
      size: const Size(500, 500),
      maximumColorCount: 20,
    );

    if (_paletteGenerator != null) {
      Color? dominantColor = _paletteGenerator!.dominantColor?.color;
      List<Color>? colorList = _paletteGenerator!.colors.toList();
      if (dominantColor != null) {
        double luminance = dominantColor.computeLuminance();

        double opacity = luminance > 0.5 ? 0.2 : 0.8;
        _imageColors = colorList;
        _dominantColor = dominantColor.withOpacity(opacity);
      } else {
        _dominantColor =
            isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
      }
    } else {
      _dominantColor = isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
    }

    notifyListeners();
  }

  Future<List<Color>> extractImageColors(List<Uint8List?> imageList) async {
    List<Color> colors = [];
    for (Uint8List? imageData in imageList) {
      if (imageData != null) {
        PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
          MemoryImage(imageData),
          size: const Size(250, 250),
          maximumColorCount: 20,
        );
        colors.addAll(palette.colors);
      }
    }
    return colors;
  }
}
