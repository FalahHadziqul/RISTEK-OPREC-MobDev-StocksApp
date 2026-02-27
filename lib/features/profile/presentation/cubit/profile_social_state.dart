part of 'profile_social_cubit.dart';

class ProfileSocialState extends Equatable {
  const ProfileSocialState({
    this.socialLinks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<SocialLink> socialLinks;
  final bool isLoading;
  final String? errorMessage;

  ProfileSocialState copyWith({
    List<SocialLink>? socialLinks,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProfileSocialState(
      socialLinks: socialLinks ?? this.socialLinks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [socialLinks, isLoading, errorMessage];
}
