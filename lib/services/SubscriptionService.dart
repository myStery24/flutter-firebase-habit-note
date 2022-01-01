import 'package:mighty_notes/main.dart';
import 'package:mighty_notes/model/subscription_model.dart';
import 'package:mighty_notes/services/BaseService.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class SubscriptionService extends BaseService {
  SubscriptionService() {
    ref = db.collection('subscription');
  }

  Future<List<SubscriptionModel>> getSubscription() {
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).get().then((value) {
      return value.docs.map((e) => SubscriptionModel.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<SubscriptionModel>> subscription() {
    return ref.where('userId', isEqualTo: getStringAsync(USER_ID)).snapshots().map((event) => event.docs.map((e) => SubscriptionModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
