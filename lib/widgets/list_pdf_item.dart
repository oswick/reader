import 'package:flutter/material.dart';
import 'dart:io';
import '../services/file_service.dart';

class PdfListItem extends StatelessWidget {
  final File file;
  final VoidCallback onTap;
  final FileService _fileService = FileService();

  PdfListItem({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
          size: 40,
        ),
        title: Text(
          _fileService.getFileName(file.path),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file.path,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              _fileService.getFileSize(file),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: onTap,
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}