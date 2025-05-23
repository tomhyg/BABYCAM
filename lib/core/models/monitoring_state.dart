// lib/core/models/monitoring_state.dart

import 'package:flutter/material.dart';
import '../../ui/theme/app_colors.dart';  // ✅ Import corrigé

enum MonitoringState {
  listening,
  talking,
  intercom,
  inactive,
}

extension MonitoringStateExtension on MonitoringState {
  String get displayName {
    switch (this) {
      case MonitoringState.listening:
        return 'Écoute active';
      case MonitoringState.talking:
        return 'Communication';
      case MonitoringState.intercom:
        return 'Intercom';
      case MonitoringState.inactive:
        return 'Inactif';
    }
  }

  String get description {
    switch (this) {
      case MonitoringState.listening:
        return 'Surveillance audio en cours';
      case MonitoringState.talking:
        return 'Communication bidirectionnelle active';
      case MonitoringState.intercom:
        return 'Mode intercom activé';
      case MonitoringState.inactive:
        return 'Surveillance désactivée';
    }
  }

  IconData get icon {
    switch (this) {
      case MonitoringState.listening:
        return Icons.hearing;
      case MonitoringState.talking:
        return Icons.record_voice_over;
      case MonitoringState.intercom:
        return Icons.speaker_phone;
      case MonitoringState.inactive:
        return Icons.volume_off;
    }
  }

  Color get color {
    switch (this) {
      case MonitoringState.listening:
        return AppColors.monitoringListening;  // ✅ Corrigé
      case MonitoringState.talking:
        return AppColors.monitoringTalking;    // ✅ Corrigé
      case MonitoringState.intercom:
        return AppColors.monitoringIntercom;   // ✅ Corrigé
      case MonitoringState.inactive:
        return Colors.grey;
    }
  }

  bool get isActive {
    return this != MonitoringState.inactive;
  }

  bool get requiresMicrophone {
    return this == MonitoringState.talking || this == MonitoringState.intercom;
  }

  bool get requiresSpeaker {
    return this == MonitoringState.talking || this == MonitoringState.intercom;
  }
}