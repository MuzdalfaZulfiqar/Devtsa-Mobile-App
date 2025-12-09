// lib/services/onboarding_api.dart

import '../models/onboarding_data.dart';
import 'api_client.dart';

class OnboardingApi {
  static final OnboardingApi _instance = OnboardingApi._();
  OnboardingApi._();
  factory OnboardingApi() => _instance;

  final ApiClient _client = ApiClient();

  /// GET /api/users/onboarding
  Future<OnboardingData> fetchOnboarding() async {
    final json = await _client.getJson('/api/users/onboarding');
    return OnboardingData.fromJson(json);
  }

  /// POST /api/users/onboarding
  ///
  /// `complete = true` when user finishes sign-up + onboarding.
  Future<OnboardingData> saveOnboarding(
    OnboardingData data, {
    bool complete = false,
  }) async {
    final body = data.toJson(complete: complete);

    final json = await _client.postJson(
      '/api/users/onboarding',
      body: body,
    );

    // backend: { msg: "...", user: {...} }
    final updatedUser = json['user'] as Map<String, dynamic>?;

    if (updatedUser != null) {
      final merged = <String, dynamic>{
        'name': updatedUser['name'],
        'email': updatedUser['email'],
        'phone': updatedUser['phone'],
        'experienceLevel': updatedUser['experienceLevel'],
        'primaryRole': updatedUser['primaryRole'],
        'topSkills': updatedUser['topSkills'],
        'githubUrl': updatedUser['githubUrl'],
        'resumeUrl': updatedUser['resumeUrl'],
        'onboardingCompleted': updatedUser['onboardingCompleted'],
        'updatedAt': updatedUser['updatedAt'],
      };

      return OnboardingData.fromJson(merged);
    }

    // fallback: re-fetch
    return fetchOnboarding();
  }

}
