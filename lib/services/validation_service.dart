import 'dart:core';

/// Validation service for user input validation and sanitization.
/// 
/// Provides comprehensive validation for email, password, and health-related inputs
/// to prevent injection attacks and ensure data integrity.
class ValidationService {
  // Email validation regex - follows RFC 5322 standard
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation - at least 8 chars, mixed case, number, special char
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // Phone number validation - international format
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  // Name validation - letters, spaces, hyphens, apostrophes only
  static final RegExp _nameRegex = RegExp(
    r"^[a-zA-Zà-ÿÀ-ÿ\s\-']+$",
  );

  /// Validate email address format and constraints.
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();
    
    if (trimmedEmail.isEmpty) {
      return 'Email cannot be empty or whitespace only';
    }

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return 'Invalid email format';
    }

    if (trimmedEmail.length > 254) {
      return 'Email is too long (max 254 characters)';
    }

    // Check for suspicious patterns
    if (_containsSuspiciousPatterns(trimmedEmail)) {
      return 'Email contains invalid characters';
    }

    return null;
  }

  /// Validate password strength and format.
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (password.length > 128) {
      return 'Password is too long (max 128 characters)';
    }

    if (!_passwordRegex.hasMatch(password)) {
      return 'Password must contain uppercase, lowercase, number, and special character';
    }

    // Check for common weak passwords
    if (_isCommonPassword(password)) {
      return 'Password is too common. Please choose a stronger password';
    }

    return null;
  }

  /// Validate phone number format.
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }

    final trimmedPhone = phone.trim();
    
    if (!_phoneRegex.hasMatch(trimmedPhone)) {
      return 'Invalid phone number format. Use international format: +1234567890';
    }

    return null;
  }

  /// Validate user name format.
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }

    final trimmedName = name.trim();
    
    if (trimmedName.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (trimmedName.length > 100) {
      return 'Name is too long (max 100 characters)';
    }

    if (!_nameRegex.hasMatch(trimmedName)) {
      return 'Name contains invalid characters';
    }

    return null;
  }

  /// Validate height input (in centimeters).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateHeight(int height) {
    if (height < 50) {
      return 'Height must be at least 50 cm';
    }

    if (height > 300) {
      return 'Height must be less than 300 cm';
    }

    return null;
  }

  /// Validate weight input (in kilograms).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateWeight(int weight) {
    if (weight < 20) {
      return 'Weight must be at least 20 kg';
    }

    if (weight > 300) {
      return 'Weight must be less than 300 kg';
    }

    return null;
  }

  /// Validate age input (in years).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateAge(int age) {
    if (age < 2) {
      return 'Age must be at least 2 years';
    }

    if (age > 120) {
      return 'Age must be less than 120 years';
    }

    return null;
  }

  /// Validate waist circumference input (in centimeters).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateWaistCircumference(double waistCm) {
    if (waistCm < 40) {
      return 'Waist circumference must be at least 40 cm';
    }

    if (waistCm > 200) {
      return 'Waist circumference must be less than 200 cm';
    }

    return null;
  }

  /// Validate neck circumference input (in centimeters).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateNeckCircumference(double neckCm) {
    if (neckCm < 20) {
      return 'Neck circumference must be at least 20 cm';
    }

    if (neckCm > 60) {
      return 'Neck circumference must be less than 60 cm';
    }

    return null;
  }

  /// Validate hip circumference input (in centimeters).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateHipCircumference(double hipCm) {
    if (hipCm < 50) {
      return 'Hip circumference must be at least 50 cm';
    }

    if (hipCm > 250) {
      return 'Hip circumference must be less than 250 cm';
    }

    return null;
  }

  /// Validate blood pressure values.
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateBloodPressure(int systolic, int diastolic) {
    if (systolic < 60 || systolic > 300) {
      return 'Systolic pressure must be between 60-300 mmHg';
    }

    if (diastolic < 40 || diastolic > 200) {
      return 'Diastolic pressure must be between 40-200 mmHg';
    }

    if (diastolic >= systolic) {
      return 'Diastolic pressure must be less than systolic pressure';
    }

    return null;
  }

  /// Validate blood glucose level (mg/dL).
  /// 
  /// Returns null if valid, error message otherwise.
  static String? validateBloodGlucose(double glucoseLevel) {
    if (glucoseLevel < 20 || glucoseLevel > 600) {
      return 'Blood glucose must be between 20-600 mg/dL';
    }

    return null;
  }

  /// Sanitize string input by removing potentially dangerous characters.
  /// 
  /// Removes SQL injection attempts, XSS attempts, and other malicious patterns.
  static String sanitizeString(String input) {
    // Remove potential SQL injection patterns
    String sanitized = input
        .replaceAll(RegExp(r'[";\\]'), '')
        .replaceAll(RegExp(r'\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|EXEC)\b', caseSensitive: false), '');
    
    // Remove potential XSS patterns
    sanitized = sanitized
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
    
    return sanitized.trim();
  }

  /// Sanitize numeric input to ensure it's within safe bounds.
  static int sanitizeInt(String input, {int min = 0, int max = 1000000}) {
    try {
      final value = int.parse(input);
      return value.clamp(min, max);
    } catch (e) {
      return min; // Return minimum value on parse error
    }
  }

  /// Check if string contains suspicious patterns that might indicate attacks.
  static bool _containsSuspiciousPatterns(String input) {
    final suspiciousPatterns = [
      '../',       // Directory traversal
      '<script',   // XSS attempt
      'javascript:', // XSS attempt
      'onerror=',  // XSS attempt
      'onload=',   // XSS attempt
      'data:',     // Potential data URI attack
      'vbscript:', // VBScript injection
    ];

    final lowerInput = input.toLowerCase();
    return suspiciousPatterns.any((pattern) => 
      lowerInput.contains(pattern.toLowerCase())
    );
  }

  /// Check if password is a common weak password.
  static bool _isCommonPassword(String password) {
    final commonPasswords = {
      'password', '123456', '12345678', 'qwerty', 'abc123',
      'monkey', 'master', 'dragon', '111111', 'baseball',
      'iloveyou', 'trustno1', 'sunshine', 'princess', 'admin',
      'welcome', 'shadow', 'ashley', 'football', 'jesus',
      'michael', 'ninja', 'mustang', 'password1',
    };

    return commonPasswords.contains(password.toLowerCase());
  }

  /// Validate input length constraints.
  static String? validateLength(String input, {int min = 0, int max = 1000}) {
    if (input.length < min) {
      return 'Input must be at least $min characters';
    }

    if (input.length > max) {
      return 'Input must be less than $max characters';
    }

    return null;
  }

  /// Validate that two string inputs match (useful for password confirmation).
  static String? validateMatch(String value1, String value2, String fieldName) {
    if (value1 != value2) {
      return '$fieldName does not match';
    }

    return null;
  }
}