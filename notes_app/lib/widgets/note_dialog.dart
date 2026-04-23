import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:image_picker/image_picker.dart';

class NoteDialog extends StatefulWidget {
  const NoteDialog({super.key, this.note});

  final Note? note;

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const NoteDialog();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NoteService.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada catatan.'));
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: snapshot.data!.map((document) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      // Tidak menggunakan 'const' karena membawa data 'document'
                      return NoteDialog(note: document);
                    },
                  );
                },
                child: Column(
                  children: [
                    document.imageUrl != null &&
                            Uri.parse(document.imageUrl!).isAbsolute
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              document.imageUrl!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 150,
                              // Menambahkan error builder jika gambar gagal dimuat
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
                          )
                        : Container(),
                    ListTile(
                      title: Text(
                        document.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(document.description),
                      trailing: InkWell(
                        onTap: () {
                          _showDeleteDialog(context, document);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Helper method untuk dialog hapus agar kode lebih bersih
  void _showDeleteDialog(BuildContext context, dynamic document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Yakin ingin menghapus data \'${document.title}\' ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                NoteService.deleteNote(
                  document,
                ).whenComplete(() => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }
}
