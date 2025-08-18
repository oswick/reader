import 'package:flutter/material.dart';
import 'package:myapp/services/permission_handler.dart';
import 'package:myapp/widgets/list_pdf_item.dart';
import 'dart:io';
import '../services/file_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'pdf_view_screen.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  List<File> _pdfFiles = [];
  bool _isLoading = true;
  String _statusMessage = 'Solicitando permisos...';

  final PermissionService _permissionService = PermissionService();
  final FileService _fileService = FileService();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetFiles();
  }

  Future<void> _requestPermissionAndGetFiles() async {
    try {
      // Solicitar permisos según la versión de Android
      bool hasPermission = await _permissionService.requestStoragePermissions();

      if (hasPermission) {
        setState(() {
          _statusMessage = 'Buscando archivos PDF...';
        });
        await _getPdfFiles();
      } else {
        setState(() {
          _statusMessage =
              'Permisos denegados. No se pueden buscar archivos PDF.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _getPdfFiles() async {
    try {
      List<File> pdfFiles = await _fileService.searchPdfFiles();

      setState(() {
        _pdfFiles = pdfFiles;
        _isLoading = false;
        _statusMessage = pdfFiles.isEmpty
            ? 'No se encontraron archivos PDF'
            : 'Se encontraron ${pdfFiles.length} archivos PDF';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error al buscar archivos: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onRefresh() {
    setState(() {
      _pdfFiles.clear();
      _isLoading = true;
      _statusMessage = 'Buscando archivos PDF...';
    });
    _requestPermissionAndGetFiles();
  }

  void _onPdfTap(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewScreen(
          path: file.path,
          title: _fileService.getFileName(file.path),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Visor de PDF'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _onRefresh)],
      ),
      body: _isLoading
          ? LoadingWidget(message: _statusMessage)
          : _pdfFiles.isEmpty
          ? EmptyStateWidget(message: _statusMessage, onRetry: _onRefresh)
          : ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                final file = _pdfFiles[index];
                return PdfListItem(file: file, onTap: () => _onPdfTap(file));
              },
            ),
    );
  }
}
