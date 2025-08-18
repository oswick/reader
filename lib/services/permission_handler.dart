import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermissions() async {
    if (Platform.isAndroid) {
      // Para Android 13+ (API 33+)
      if (await Permission.photos.request().isGranted ||
          await Permission.videos.request().isGranted ||
          await Permission.audio.request().isGranted) {
        return true;
      }
      
      // Para versiones anteriores
      var storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        return true;
      }

      var externalStorageStatus = await Permission.manageExternalStorage.request();
      return externalStorageStatus.isGranted;
    }
    return true; // Para iOS u otras plataformas
  }

  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      return await Permission.storage.isGranted ||
             await Permission.manageExternalStorage.isGranted ||
             await Permission.photos.isGranted;
    }
    return true;
  }
}