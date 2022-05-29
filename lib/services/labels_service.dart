import 'package:nb_utils/nb_utils.dart';

import '../configs/constants.dart';
import '../main.dart';
import '../models/labels_model.dart';
import 'base_service.dart';

class LabelsService extends BaseService {
  LabelsService() {
    ref = db.collection('labels');
  }

  Future<List<LabelsModel>> getLabels() {
    // Get a snapshot of document by user id
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).get().then((value) {
      return value.docs.map((e) => LabelsModel.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<LabelsModel>> labels() {
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).snapshots().map((event) => event.docs.map((e) => LabelsModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
