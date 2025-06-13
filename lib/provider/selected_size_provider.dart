import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedSizeProvider =
    StateNotifierProvider<SelectedSizeProvider, String>((ref) {
  return SelectedSizeProvider();
});

class SelectedSizeProvider extends StateNotifier<String> {
  SelectedSizeProvider() : super('');

  void setSelectedSize(String size) {
    state = size;
  }

  void clearSelectedSize() {
    state = '';
  }

  String get getSelectedSize => state;
}
