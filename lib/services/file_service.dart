import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<List<File>> searchPdfFiles() async {
    List<File> pdfFiles = [];
    
    try {
      // Buscar en múltiples directorios
      List<Directory> directories = await _getSearchDirectories();
      
      for (Directory directory in directories) {
        if (await directory.exists()) {
          await _searchPdfInDirectory(directory, pdfFiles);
        }
      }

      return pdfFiles;
    } catch (e) {
      print('Error al buscar archivos PDF: $e');
      return [];
    }
  }

  Future<List<Directory>> _getSearchDirectories() async {
    List<Directory> directories = [];
    
    try {
      // Directorio de documentos de la app
      final appDocDir = await getApplicationDocumentsDirectory();
      directories.add(appDocDir);
      
      // Directorio externo (si está disponible)
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directories.add(externalDir);
      }
      
      // Directorios comunes de Android
      if (Platform.isAndroid) {
        // Almacenamiento interno emulado
        directories.add(Directory('/storage/emulated/0/Download'));
        directories.add(Directory('/storage/emulated/0/Documents'));
        directories.add(Directory('/storage/emulated/0'));
        
        // Intentar acceder a directorios de tarjeta SD
        try {
          final List<Directory>? externalDirs = await getExternalStorageDirectories();
          if (externalDirs != null) {
            for (var dir in externalDirs) {
              // Navegar hacia arriba para acceder a la raíz de la tarjeta SD
              String path = dir.path;
              List<String> pathParts = path.split('/');
              if (pathParts.length >= 4) {
                String sdCardPath = '/${pathParts[1]}/${pathParts[2]}/${pathParts[3]}';
                directories.add(Directory(sdCardPath));
              }
            }
          }
        } catch (e) {
          print('Error accediendo a almacenamiento externo: $e');
        }
      }
    } catch (e) {
      print('Error obteniendo directorios: $e');
    }
    
    return directories;
  }

  Future<void> _searchPdfInDirectory(Directory directory, List<File> pdfFiles) async {
    try {
      await for (FileSystemEntity entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          // Verificar que el archivo sea accesible
          try {
            if (await entity.exists()) {
              pdfFiles.add(entity);
            }
          } catch (e) {
            // Ignorar archivos inaccesibles
            continue;
          }
        }
      }
    } catch (e) {
      // Ignorar directorios inaccesibles
      print('No se puede acceder a: ${directory.path} - $e');
    }
  }

  String getFileName(String path) {
    return path.split('/').last;
  }

  String getFileSize(File file) {
    try {
      int bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Desconocido';
    }
  }
}