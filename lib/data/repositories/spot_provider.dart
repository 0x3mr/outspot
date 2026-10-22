import 'package:flutter/foundation.dart';

import '../../models/spot.dart';
import 'spot_repository.dart';

class SpotProvider extends ChangeNotifier {
  SpotProvider(this._repository);

  final SpotRepository _repository;
  List<Spot> _spots = [];
  bool _isLoading = false;
  String? _error;

  List<Spot> get spots => List.unmodifiable(_spots);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSpots() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _spots = await _repository.listSpots();
    } catch (exception) {
      _error = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
