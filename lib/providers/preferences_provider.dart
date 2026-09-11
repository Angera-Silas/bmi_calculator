import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User preference snapshot.
class PreferencesState {
  const PreferencesState({this.isMetricUnits = true});

  /// true = metric (cm/kg), false = imperial (ft/lbs).
  final bool isMetricUnits;

  PreferencesState copyWith({bool? isMetricUnits}) => PreferencesState(
        isMetricUnits: isMetricUnits ?? this.isMetricUnits,
      );
}

/// Persisted user preferences (unit system — more to come).
class PreferencesNotifier extends Notifier<PreferencesState> {
  static const String _keyMetricUnits = 'prefs_metric_units';

  @override
  PreferencesState build() {
    _load();
    return const PreferencesState(isMetricUnits: true);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(_keyMetricUnits);
    if (stored != null && stored != state.isMetricUnits) {
      state = state.copyWith(isMetricUnits: stored);
    }
  }

  Future<void> setIsMetricUnits(bool value) async {
    state = state.copyWith(isMetricUnits: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMetricUnits, value);
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, PreferencesState>(
        PreferencesNotifier.new);
