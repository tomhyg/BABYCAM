import 'package:flutter/material.dart';
import '../../ui/theme/app_color_schemes.dart';

enum MonitoringState {
  inactive,
  listening,
  talking,
  intercom,
}

extension MonitoringStateExtension on MonitoringState {
  String get label {
    switch (this) {
      case MonitoringState.inactive:
        return 'Monitoring';
      case MonitoringState.listening:
        return 'Écoute';
      case MonitoringState.talking:
        return 'Parler';
      case MonitoringState.intercom:
        return 'Intercom';
    }
  }

  Color get color {
    switch (this) {
      case MonitoringState.inactive:
        return Colors.grey;
      case MonitoringState.listening:
        return AppColorSchemes.monitoringListening;
      case MonitoringState.talking:
        return AppColorSchemes.monitoringTalking;
      case MonitoringState.intercom:
        return AppColorSchemes.monitoringIntercom;
    }
  }

  IconData get icon {
    switch (this) {
      case MonitoringState.inactive:
        return Icons.headset_off;
      case MonitoringState.listening:
        return Icons.headset;
      case MonitoringState.talking:
        return Icons.mic;
      case MonitoringState.intercom:
        return Icons.record_voice_over;
    }
  }
}
