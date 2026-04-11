/// Diet recommendations based on BMI category and health context.
class DietRecommendation {
  final String category;
  final String title;
  final String description;
  final List<String> foodGroups;
  final List<String> mealsPerDay;
  final String macroBalance;
  final List<String> recommendations;

  DietRecommendation({
    required this.category,
    required this.title,
    required this.description,
    required this.foodGroups,
    required this.mealsPerDay,
    required this.macroBalance,
    required this.recommendations,
  });

  /// Get diet recommendation based on BMI value.
  static DietRecommendation getForBMI(double bmi) {
    if (bmi < 16) {
      return _severelyUnderweight();
    } else if (bmi < 17) {
      return _moderatelyUnderweight();
    } else if (bmi < 18.5) {
      return _mildlyUnderweight();
    } else if (bmi < 25) {
      return _normalWeight();
    } else if (bmi < 30) {
      return _overweight();
    } else if (bmi < 35) {
      return _obeseClassI();
    } else if (bmi < 40) {
      return _obeseClassII();
    } else {
      return _obeseClassIII();
    }
  }

  static DietRecommendation _severelyUnderweight() {
    return DietRecommendation(
      category: 'Severely Underweight',
      title: 'Nutrition Building Plan',
      description:
          'Focus on nutrient-dense, calorie-rich foods to support healthy weight gain and overall health.',
      foodGroups: [
        'Whole grains & legumes',
        'Nuts & seeds',
        'Avocados & healthy oils',
        'Dairy & proteins',
        'Fruits & vegetables'
      ],
      mealsPerDay: ['3 main meals', '2-3 nutritious snacks'],
      macroBalance: '55-60% carbs, 20-25% protein, 20-25% fat',
      recommendations: [
        'Eat calorie-dense meals: nuts, nut butters, seeds, whole milk products',
        'Include healthy fats: olive oil, coconut oil, avocados, fatty fish',
        'Combine complex carbs with protein at each meal',
        'Drink smoothies with protein powder, fruits, and nut butter',
        'Avoid empty calories; focus on nutritious, whole foods',
        'Consult a healthcare provider or registered dietitian',
        'Regular strength training to build muscle mass',
        'Monitor weight gain and adjust intake as needed'
      ],
    );
  }

  static DietRecommendation _moderatelyUnderweight() {
    return DietRecommendation(
      category: 'Moderately Underweight',
      title: 'Nutritious Weight Gain Diet',
      description:
          'Build a balanced diet with emphasis on nutrient-dense foods for healthy weight gain.',
      foodGroups: [
        'Whole grains',
        'Quality proteins',
        'Healthy fats',
        'Fruits & vegetables',
        'Dairy products'
      ],
      mealsPerDay: ['3 meals', '2-3 snacks'],
      macroBalance: '50-55% carbs, 20-25% protein, 20-25% fat',
      recommendations: [
        'Include protein at every meal: eggs, chicken, fish, legumes, tofu',
        'Add healthy fats: oils, nuts, seeds, avocados',
        'Choose whole grains over refined carbohydrates',
        'Eat regular meals and snacks to increase total intake',
        'Try protein-enriched snacks: yogurt, cheese, nuts',
        'Stay hydrated with water and nutritious beverages',
        'Include strength training 3-4 times per week',
        'Track calories to ensure adequate intake'
      ],
    );
  }

  static DietRecommendation _mildlyUnderweight() {
    return DietRecommendation(
      category: 'Mildly Underweight',
      title: 'Balanced Nutritious Diet',
      description:
          'Maintain a balanced, nutrient-rich diet to support optimal health and gradual weight gain if needed.',
      foodGroups: [
        'Lean proteins',
        'Whole grains',
        'Fruits & vegetables',
        'Healthy fats',
        'Low-fat dairy'
      ],
      mealsPerDay: ['3 balanced meals', '1-2 snacks'],
      macroBalance: '50-55% carbs, 20-25% protein, 20-25% fat',
      recommendations: [
        'Eat balanced meals with all food groups',
        'Include lean proteins: chicken, fish, legumes, low-fat dairy',
        'Choose whole grain breads, cereals, and pasta',
        'Eat 5+ servings of fruits and vegetables daily',
        'Include healthy fats in moderation: olive oil, nuts, avocados',
        'Stay hydrated: drink 8-10 glasses of water daily',
        'Engage in regular physical activity',
        'Regular health check-ups with healthcare provider'
      ],
    );
  }

  static DietRecommendation _normalWeight() {
    return DietRecommendation(
      category: 'Normal Weight',
      title: 'Maintenance & Wellness Diet',
      description:
          'Maintain your healthy weight with a balanced, varied diet and active lifestyle.',
      foodGroups: [
        'Lean proteins',
        'Whole grains',
        'Colorful vegetables',
        'Fruits',
        'Healthy fats',
        'Low-fat dairy'
      ],
      mealsPerDay: ['3 balanced meals', '1-2 healthy snacks'],
      macroBalance: '50-55% carbs, 20-25% protein, 20-25% fat',
      recommendations: [
        'Follow a balanced plate: ¼ protein, ¼ whole grains, ½ vegetables',
        'Eat diverse foods across all food groups',
        'Choose whole grains, lean proteins, and healthy fats',
        'Include colorful fruits and vegetables: aim for variety',
        'Limit added sugars, salt, and saturated fats',
        'Practice portion control',
        'Stay physically active: 150+ minutes moderate activity weekly',
        'Maintain regular check-ups and health monitoring'
      ],
    );
  }

  static DietRecommendation _overweight() {
    return DietRecommendation(
      category: 'Overweight',
      title: 'Healthy Weight Loss Diet',
      description:
          'Achieve gradual weight loss through balanced nutrition and regular physical activity. Aim for 0.5-1 kg per week.',
      foodGroups: [
        'Lean proteins',
        'High-fiber vegetables',
        'Whole grains',
        'Fruits',
        'Healthy fats (limited)',
        'Low-fat dairy'
      ],
      mealsPerDay: ['3 balanced meals', '1-2 light snacks'],
      macroBalance: '50-55% carbs, 25-30% protein, 20-25% fat',
      recommendations: [
        'Create a modest calorie deficit (300-500 calories below maintenance)',
        'Prioritize protein: keeps you full longer, supports muscle retention',
        'Choose high-fiber foods: vegetables, whole grains, legumes',
        'Drink water before meals to aid portion control',
        'Reduce liquid calories: sugary drinks, alcohol, high-calorie coffee drinks',
        'Limit processed foods, fried foods, and added sugars',
        'Practice mindful eating: eat slowly, recognize fullness cues',
        'Combine with 150+ minutes moderate activity per week',
        'Consider consulting a registered dietitian'
      ],
    );
  }

  static DietRecommendation _obeseClassI() {
    return DietRecommendation(
      category: 'Obese Class I',
      title: 'Structured Weight Loss Program',
      description:
          'Begin a structured approach to weight loss with professional guidance. Aim for gradual, sustainable weight loss.',
      foodGroups: [
        'Lean proteins',
        'Non-starchy vegetables',
        'Whole grains (limited)',
        'Fruits (limited)',
        'Minimal healthy fats',
        'Low-fat dairy'
      ],
      mealsPerDay: ['3 moderate meals', '1-2 light snacks'],
      macroBalance: '45-50% carbs, 30-35% protein, 20-25% fat',
      recommendations: [
        'Create a significant calorie deficit (500-750 calories) for 0.5-1.5 kg/week loss',
        'Increase protein to preserve muscle during weight loss',
        'Fill half your plate with non-starchy vegetables',
        'Choose whole grains in controlled portions',
        'Eliminate sugary drinks, desserts, and fried foods',
        'Plan and prepare meals at home',
        'Track food intake using an app or food diary',
        'Exercise 200+ minutes per week (mix cardio and strength)',
        'Get 7-9 hours quality sleep nightly',
        'Consult healthcare provider or registered dietitian',
        'Consider behavioral support or weight loss programs'
      ],
    );
  }

  static DietRecommendation _obeseClassII() {
    return DietRecommendation(
      category: 'Obese Class II',
      title: 'Medical Weight Loss Program',
      description:
          'Implement a medical-supervised weight loss plan with comprehensive lifestyle changes and professional support.',
      foodGroups: [
        'Lean proteins',
        'Non-starchy vegetables',
        'Limited whole grains',
        'Minimal fruits',
        'Minimal oils & fats',
        'Low-fat dairy'
      ],
      mealsPerDay: ['3 smaller meals', '1-2 minimal snacks'],
      macroBalance: '40-45% carbs, 35-40% protein, 20% fat',
      recommendations: [
        'Consult with healthcare provider and registered dietitian urgently',
        'Create structured meal plans with professional guidance',
        'Focus on high-protein, low-calorie meals',
        'Base meals on vegetables and lean protein',
        'Severely limit refined carbs, sugars, and processed foods',
        'Avoid alcohol and sugary beverages completely',
        'Keep detailed food diary',
        'Aim for 250+ minutes exercise weekly (start gradually if needed)',
        'Consider weight loss medications under medical supervision',
        'Address emotional eating and stress management',
        'Aim for 0.5-1 kg weight loss per week maximum',
        'Regular medical monitoring and follow-ups'
      ],
    );
  }

  static DietRecommendation _obeseClassIII() {
    return DietRecommendation(
      category: 'Obese Class III (Severe)',
      title: 'Intensive Medical Weight Loss',
      description:
          'Requires medical supervision. A comprehensive, multidisciplinary approach with significant lifestyle modification.',
      foodGroups: [
        'Very lean proteins',
        'Non-starchy vegetables only',
        'Minimal whole grains',
        'No fruits initially',
        'Minimal fats',
        'Skim dairy'
      ],
      mealsPerDay: ['3 small, controlled meals'],
      macroBalance: '35-40% carbs, 40-45% protein, 15-20% fat',
      recommendations: [
        'SEEK IMMEDIATE MEDICAL CONSULTATION - this requires professional oversight',
        'Work with endocrinologist, cardiologist, and registered dietitian',
        'Consider bariatric surgery consultation if appropriate',
        'Follow strict, medically-supervised meal plans',
        'Focus on protein and vegetables; eliminate processed foods entirely',
        'No sugary foods, drinks, or high-calorie items',
        'May require medication support alongside diet',
        'Start with gentle activity (walking) as tolerated',
        'Psychological counseling for behavioral support',
        'Regular medical monitoring and lab work',
        'Address underlying health conditions (diabetes, hypertension, etc.)',
        'Join weight loss support groups',
        'Be patient - sustainable weight loss is a long-term journey'
      ],
    );
  }
}
