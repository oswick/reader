import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      // Request storage permission - permission_handler will handle version differences
      final status = await Permission.storage.request();
      
      if (status.isGranted) {
        return true;
      }
      
      // If storage permission failed, try manage external storage (for Android 11+)
      if (status.isDenied || status.isPermanentlyDenied) {
        try {
          final manageStatus = await Permission.manageExternalStorage.request();
          return manageStatus.isGranted;
        } catch (e) {
          // manageExternalStorage might not be available on all versions
          print("MANAGE_EXTERNAL_STORAGE not available: $e");
        }
      }
      
      return false;
    } catch (e) {
      print("Error requesting storage permissions: $e");
      return false;
    }
  }

  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      // Check if we have basic storage permission
      if (await Permission.storage.isGranted) {
        return true;
      }
      
      // Check if we have manage external storage permission (Android 11+)
      try {
        if (await Permission.manageExternalStorage.isGranted) {
          return true;
        }
      } catch (e) {
        // manageExternalStorage might not be available on all versions
      }
      
      return false;
    } catch (e) {
      print("Error checking storage permissions: $e");
      return false;
    }
  }
}