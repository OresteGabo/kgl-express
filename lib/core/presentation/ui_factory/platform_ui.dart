import 'dart:io';
import 'package:kgl_express/core/presentation/ui_factory/ui_factory.dart';

import 'android_factory.dart';
import 'ios_factory.dart';
class AppUI {
  static UIFactory get factory => Platform.isIOS ? IosFactory() : AndroidFactory();
}