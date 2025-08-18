import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfViewerScreen(),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  List<FileSystemEntity> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetFiles();
  }

  Future<void> _requestPermissionAndGetFiles() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _getPdfFiles();
    } else {
      print("Permiso denegado");
    }
  }

  Future<void> _getPdfFiles() async {
    final directory = Directory('/storage/emulated/0');
    List<FileSystemEntity> pdfFiles = [];

    await for (var entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.pdf')) {
        pdfFiles.add(entity);
      }
    }

    setState(() {
      _pdfFiles = pdfFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: _pdfFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pdfFiles[index].path.split('/').last),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewScreen(path: _pdfFiles[index].path),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class PdfViewScreen extends StatelessWidget {
  final String path;

  PdfViewScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ),
    );
  }
}
