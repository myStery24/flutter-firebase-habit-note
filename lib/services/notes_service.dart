import 'package:habit_note/model/notes_model.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'base_service.dart';

class NotesService extends BaseService {
  NotesService({String? userID}) {
    ref = db.collection('notes');
  }

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
}
