import 'package:equatable/equatable.dart';

class SocialLink extends Equatable {
  const SocialLink({
    required this.id,
    required this.label,
    required this.displayText,
    required this.launchUrl,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String displayText;
  final String launchUrl;
  final String iconKey;

  @override
  List<Object?> get props => [id, label, displayText, launchUrl, iconKey];
}
