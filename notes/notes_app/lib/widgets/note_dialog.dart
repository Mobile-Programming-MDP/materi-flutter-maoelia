import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/note_service.dart';

class NoteDialog extends StatefulWidget {
  final Note?
  note; // Menambahkan parameter untuk menerima catatan yang akan diedit

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
}
