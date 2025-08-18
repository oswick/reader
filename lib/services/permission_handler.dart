import 'dart:io';
import 'package:flutter/services.dart';

class PermissionService {
  static const MethodChannel _channel = MethodChannel('document_permission');

  Future<bool> requestStoragePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      final bool result = await _channel.invokeMethod('requestDocumentPermission');
      return result;
    } on PlatformException catch (e) {
      print("Error solicitando permiso de documentos: ${e.message}");
      return false;
    }
  }

  Future<bool> hasStoragePermission() async {
    // Siempre devolver true ya que el permiso se solicita cuando es necesario
    return true;
  }
}