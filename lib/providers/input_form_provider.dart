import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_condition.dart';
import '../models/pregnancy_status.dart';

/// Biological sex selection for BMI / metric calculations.
enum Gender { male, female }

/// All state captured by the Calculate tab.
///
/// Living in a [Notifier] instead of widgets means:
///  - UI stays declarative (no `setState` for form fields),
///  - the form survives tab switches inside the [IndexedStack],
///  - Phase 1 inputs (waist/neck/hip/RHR) drop in without new setters per widget.
class InputFormState {
  const InputFormState({
    this.gender,
    this.isMetric = true,
    this.heightCm = 170,
    this.weightKg = 70,
    this.age = 25,
    this.selectedConditions = const [],
    this.pregnancyStatus = PregnancyStatus.notApplicable,
    this.prePregnancyWeight,
    this.isSaving = false,
    this.waistCm,
    this.neckCm,
    this.hipCm,
    this.restingHeartRate,
  });

  final Gender? gender;
  final bool isMetric;
  final int heightCm;
  final int weightKg;
  final int age;
  final List<HealthCondition> selectedConditions;
  final PregnancyStatus pregnancyStatus;
  final double? prePregnancyWeight;
  final bool isSaving;

  /// Advanced body metrics (Phase 1) — optional inputs.
  final double? waistCm;
  final double? neckCm;
  final double? hipCm;
  final int? restingHeartRate;

  bool get isFemale => gender == Gender.female;

  InputFormState copyWith({
    Gender? gender,
    bool? isMetric,
    int? heightCm,
    int? weightKg,
    int? age,
    List<HealthCondition>? selectedConditions,
    PregnancyStatus? pregnancyStatus,
    double? prePregnancyWeight,
    bool? isSaving,
    double? waistCm,
    double? neckCm,
    double? hipCm,
    int? restingHeartRate,
  }) {
    return InputFormState(
      gender: gender ?? this.gender,
      isMetric: isMetric ?? this.isMetric,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      selectedConditions: selectedConditions ?? this.selectedConditions,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
      isSaving: isSaving ?? this.isSaving,
      waistCm: waistCm ?? this.waistCm,
      neckCm: neckCm ?? this.neckCm,
      hipCm: hipCm ?? this.hipCm,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
    );
  }
}

/// Form state for the Calculate tab (see [InputFormState]).
class InputFormNotifier extends Notifier<InputFormState> {
  @override
  InputFormState build() => const InputFormState();

  void setGender(Gender? value) => state = state.copyWith(gender: value);
  void setIsMetric(bool value) => state = state.copyWith(isMetric: value);
  void setHeight(int value) => state = state.copyWith(heightCm: value);
  void setWeight(int value) => state = state.copyWith(weightKg: value);
  void setAge(int value) => state = state.copyWith(age: value);
  void setSaving(bool value) => state = state.copyWith(isSaving: value);

  void toggleCondition(HealthCondition condition) {
    final current = List<HealthCondition>.from(state.selectedConditions);
    if (current.contains(condition)) {
      current.remove(condition);
    } else {
      current.add(condition);
    }
    state = state.copyWith(selectedConditions: current);
  }

  void setPregnancyStatus(PregnancyStatus status) {
    state = state.copyWith(pregnancyStatus: status);
  }

  void setPrePregnancyWeight(double? value) {
    state = state.copyWith(prePregnancyWeight: value);
  }

  void setWaistCm(double? value) => state = state.copyWith(waistCm: value);
  void setNeckCm(double? value) => state = state.copyWith(neckCm: value);
  void setHipCm(double? value) => state = state.copyWith(hipCm: value);
  void setRestingHeartRate(int? value) =>
      state = state.copyWith(restingHeartRate: value);

  /// Pre-fill height/weight from a wearable snapshot (Sprint 3.1).
  void applyWearable({double? heightCm, double? weightKg}) {
    state = state.copyWith(
      heightCm: heightCm?.round() ?? state.heightCm,
      weightKg: weightKg?.round() ?? state.weightKg,
    );
  }

  void reset() => state = const InputFormState();
}

final inputFormProvider =
    NotifierProvider<InputFormNotifier, InputFormState>(InputFormNotifier.new);
