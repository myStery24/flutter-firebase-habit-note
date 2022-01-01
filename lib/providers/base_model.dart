import 'package:flutter/foundation.dart';

enum CurrentState { idle, loading, loaded, error }

class BaseModel extends ChangeNotifier {
  CurrentState _state = CurrentState.idle;
  CurrentState get state => _state;

  void setState(CurrentState state) {
    _state = state;
    notifyListeners();
  }
}