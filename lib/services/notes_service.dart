import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:habit_note/model/notes_model.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

import '../main.dart';
import 'base_service.dart';

class NotesService extends BaseService {
  FirebaseStorage _storage = FirebaseStorage.instance;
  /// Reference to 'notes' collection
  NotesService({String? userID}) {
    ref = db.collection('notes');
  }

  /// Notes
  // Stream lets you to make changes in Firebase and update in app UI real-time
  Stream<List<NotesModel>> fetchNotes({String color = ''}) {
    // Get the snapshot of the document from Firebase and map to a list
    return color.isEmpty
        ? ref.where('collaborateWith', arrayContains: getStringAsync(USER_EMAIL)).orderBy('updatedAt', descending: true).snapshots().map(
            (event) {
              /// Transforms the Firestore query [snapshot] into a list of [NotesModel] instances
              return event.docs.map((e) => NotesModel.fromJson(e.data() as Map<String, dynamic>)).toList();
            },
          )
        : ref.where('collaborateWith', arrayContains: getStringAsync(USER_EMAIL)).where('color', isEqualTo: color).orderBy('updatedAt', descending: true).snapshots().map(
            (event) {
              return event.docs.map((e) => NotesModel.fromJson(e.data() as Map<String, dynamic>)).toList();
            },
          );
  }

  /// Add images
  Future<String> uploadImage(File? image) async {
    String imageUrl = '';

    if (image != null) {
      String fileName = basename(image.path);
      Reference storageRef = _storage.ref().child("notesImage/$fileName");

      UploadTask uploadTask = storageRef.putFile(image);

      await uploadTask.then((e) async {
        await e.ref.getDownloadURL().then((value) async {
          imageUrl = value;
        });
      });
    }
    log('network img');
    log(imageUrl);

    return imageUrl;
  }
}



