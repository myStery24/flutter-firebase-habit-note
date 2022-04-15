import 'package:cloud_firestore/cloud_firestore.dart';

/// Create collection, update, delete
abstract class BaseService {
  late CollectionReference ref;

  Future<DocumentReference> addDocument(Map<String, dynamic> data) async {
    var doc = await ref.add(data);
    doc.update({'id': doc.id}); // Update the document id
    return doc;
  }

  Future<void> addDocumentWithCustomId(
      String id, Map<String, dynamic> data) async {
    await ref.doc(id).set(data); // Create a document and overwrite everything on it on Firebase
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) =>
      ref.doc(id).update(data); // Update a specific field in a document on Firebase, not overwriting

  Future<void> removeDocument(String? id) =>
      ref.doc(id).delete(); // Delete a document from Firebase
}
