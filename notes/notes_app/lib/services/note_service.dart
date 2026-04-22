import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/note.dart';
import 'package:path/path.dart' as path;

class NoteService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _notesCollection = _database.collection(
    'notes',
  );
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // CREATE
  static Future<void> addNote(Note note) async {
    try {
      Map<String, dynamic> data = {
        'title': note.title,
        'description': note.description,
        'image_url': note.imageUrl,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };
      await _notesCollection.add(data);
    } catch (e) {
      rethrow;
    }
  }

  // READ (Stream)
  static Stream<List<Note>> getNotesList() {
    // Menambahkan orderBy agar catatan terurut berdasarkan waktu terbaru
    return _notesCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Note(
              id: doc.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              imageUrl: data['image_url'] ?? '',
              createdAt: data['created_at'] as Timestamp?,
              updatedAt: data['updated_at'] as Timestamp?,
            );
          }).toList();
        });
  }

  // UPDATE
  static Future<void> updateNote(Note note) async {
    try {
      Map<String, dynamic> dataToUpdate = {
        'title': note.title,
        'description': note.description,
        'image_url': note.imageUrl,
        // 'created_at' TIDAK boleh diupdate di sini agar tanggal asli tetap ada
        'updated_at': FieldValue.serverTimestamp(),
      };
      await _notesCollection.doc(note.id).update(dataToUpdate);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE
  static Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  // UPLOAD IMAGE
  static Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');

      // Proses upload
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Ambil URL setelah selesai
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error upload image: $e");
      return null;
    }
  }
}
