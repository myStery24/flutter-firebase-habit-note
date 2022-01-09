import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_note/model/user_model.dart';

import '../main.dart';
import 'base_service.dart';

class UserDBService extends BaseService {
  UserDBService() {
    ref = db.collection('users');
  }

  Future<UserModel> getUserById(String id) {
    return ref.where('id', isEqualTo: id).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<UserModel> getUserByEmail(String? email) {
    return ref.where('email', isEqualTo: email).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref.limit(1).where('loginType', isEqualTo: loginType).where('email', isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<bool> isUserExists(String? id) async {
    return await getUserByEmail(id).then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
  }
}
