import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../configuration/assets.dart';

class AssetsLoader {
  static late final ByteData dayNightButton;

  static initAssetsLoaders() async {
    dayNightButton = await rootBundle.load(AssetsLink.DayNightButton);
  }
}
