import 'package:nb_utils/nb_utils.dart';

import '../configs/constants.dart';
import '../main.dart';
import '../models/subscription_model.dart';
import 'base_service.dart';

class SubscriptionService extends BaseService {
  SubscriptionService() {
    ref = db.collection('subscription');
  }

  Future<List<SubscriptionModel>> getSubscription() {
    // Get a snapshot of document by user id
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).get().then((value) {
      return value.docs.map((e) => SubscriptionModel.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<SubscriptionModel>> subscription() {
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).snapshots().map((event) => event.docs.map((e) => SubscriptionModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
