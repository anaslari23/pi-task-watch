import 'package:pi_task_watch/exports.dart';
import 'package:pi_task_watch/rust/api/take_full_screenshot.dart';
import 'package:pi_task_watch/utils/compress_image.dart';

Future<String> captureScreenshot() async {
  if (GetPlatform.isAndroid || GetPlatform.isIOS) {
    print('🔵 Skipping screenshot on mobile platform');
    return '';
  }
  //
  print('🔵 Starting screenshot capture process...');

  String? rawImage;
  String? compressedImage;

  print('🔵 Platform check: isWindows = ${GetPlatform.isWindows}');

  if (GetPlatform.isWindows) {
    print('🔵 Using Windows full fallback screenshot chain...');
    try {
      // Use the Rust backend's full Windows fallback chain instead of relying
      // only on NirCmd, which may be blocked by Defender/SmartScreen.
      print('🔵 Attempting Rust-based Windows screenshot fallbacks...');
      rawImage = await takeFullScreenshot();
      print('✅ Windows screenshot captured successfully');
    } catch (e) {
      print('❌ Windows screenshot failed: $e');
      // This should rarely happen as the Rust implementation has multiple
      // fallbacks, but bubble the error so the tracker can log and continue.
      print('🔄 All Windows methods exhausted, screenshot failed');
      rethrow;
    }
  } else {
    print('🔵 Using cross-platform screenshot method...');
    rawImage = await takeFullScreenshot();
    print('✅ Cross-platform screenshot captured successfully');
  }

  print('🔵 Starting image compression...');
  compressedImage = compressBase64Image(rawImage);
  print('✅ Image compression completed');

  print('🔵 Screenshot capture process finished successfully');
  return compressedImage;
}
