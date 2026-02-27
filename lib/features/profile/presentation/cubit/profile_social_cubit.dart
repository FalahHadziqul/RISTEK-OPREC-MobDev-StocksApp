import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/utils/external_link_launcher.dart';
import 'package:mobile/features/profile/data/datasources/profile_social_local_data_source.dart';
import 'package:mobile/features/profile/domain/entities/social_link.dart';

part 'profile_social_state.dart';

class ProfileSocialCubit extends Cubit<ProfileSocialState> {
  ProfileSocialCubit({
    required ProfileSocialLocalDataSource localDataSource,
    required ExternalLinkLauncher externalLinkLauncher,
  }) : _localDataSource = localDataSource,
       _externalLinkLauncher = externalLinkLauncher,
       super(const ProfileSocialState());

  final ProfileSocialLocalDataSource _localDataSource;
  final ExternalLinkLauncher _externalLinkLauncher;

  void loadSocialLinks() {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    final links = _localDataSource.getSocialLinks();
    emit(state.copyWith(socialLinks: links, isLoading: false));
  }

  Future<void> onSocialTapped(SocialLink socialLink) async {
    emit(state.copyWith(clearErrorMessage: true));

    final didLaunch = await _externalLinkLauncher.launch(socialLink.launchUrl);
    if (!didLaunch) {
      emit(
        state.copyWith(
          errorMessage: 'Could not open ${socialLink.label}. Please try again.',
        ),
      );
    }
  }

  void clearErrorMessage() {
    emit(state.copyWith(clearErrorMessage: true));
  }
}
