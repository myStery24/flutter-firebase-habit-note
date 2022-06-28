import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:habit_note/models/images_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../configs/constants.dart';
import '../main.dart';
import 'base_service.dart';

class ImagesService extends BaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  /// Reference to 'images' collection
  ImagesService({String? userID}) {
    ref = db.collection('images');
  }

  Stream<List<ImagesModel>> fetchImages() {
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).orderBy('createdAt', descending: true).snapshots().map((event) {
      /// Transforms the Firestore query [snapshot] into a list of [ImagesModel] instances
      return event.docs.map((e) => ImagesModel.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<ImagesModel>> images() {
    return ref
        .where('userId', isEqualTo: getStringAsync(USER_ID))
        .snapshots()
        .map((event) => event.docs
            .map((e) => ImagesModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  /// Add images to Firebase Storage (Method 1)
  Future<String> uploadImage(File? image) async {
    String imageUrl = '';

    if (image != null) {
      // creating a location in our firebase storage
      String fileName = basename(image.path);
      Reference storageRef = _storage
          .ref()
          .child("notesImage/${getStringAsync(USER_ID)}/$fileName");

      UploadTask uploadTask = storageRef.putFile(image);

      await uploadTask.then((e) async {
        await e.ref.getDownloadURL().then((value) async {
          imageUrl = value;
        });
      });
    }
    // log('network img');
    // log(imageUrl);

    return imageUrl;
  }

  /// (Method 1)
  Future<String> postImage(
      String uid, File file, String title, String description) async {
    // asking uid here because we don't want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String imageUrl = await uploadImage(file);
      String imageId = const Uuid().v1(); // creates unique id based on time
      ImagesModel post = ImagesModel(
        imageId: imageId,
        userId: uid,
        title: title,
        description: description,
        url: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      ref.doc(imageId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Add image to Firebase Storage (Method 2)
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// (Method 2)
  Future<String> uploadPost(
      String uid, Uint8List file, String title, String description) async {
    // asking uid here because we don't want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String imageUrl = await uploadImageToStorage('images', file, true);
      String imageId = const Uuid().v1(); // creates unique id based on time
      ImagesModel post = ImagesModel(
        imageId: imageId,
        userId: uid,
        title: title,
        description: description,
        url: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      ref.doc(imageId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
