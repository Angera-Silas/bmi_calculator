import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected tab index for the InputPage bottom navigation.
class TabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int index) => state = index;
}

final inputTabIndexProvider =
    NotifierProvider<TabIndexNotifier, int>(TabIndexNotifier.new);
