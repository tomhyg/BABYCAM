import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class IntercomService {
  final String serverIp;
  final int serverPort;
  
  // WebRTC
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCDataChannel? _dataChannel;
  bool _isTalking = false;

  IntercomService({
    required this.serverIp,
    this.serverPort = 8080, // Port par défaut de votre API
  });

  Future<void> initialize() async {
    // Demander les permissions
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('La permission du microphone est nécessaire pour la fonction interphone');
    }
  }

  Future<void> startTalking() async {
    if (_isTalking) return;

    try {
      // Informer le serveur que nous commençons à parler
      final response = await http.post(
        Uri.parse('http://$serverIp:$serverPort/api/intercom/start'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur serveur: ${response.body}');
      }
      
      // 1. Créer la connexion WebRTC
      final rtcConfig = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ]
      };
      
      _peerConnection = await createPeerConnection(rtcConfig);
      
      // 2. Obtenir accès au microphone
      final mediaConstraints = {
        'audio': true,
        'video': false
      };
      
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      
      // 3. Ajouter les pistes audio locales à la connexion
      _localStream!.getAudioTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });
      
      // 4. Créer un canal de données (pour la signalisation)
      _dataChannel = await _peerConnection!.createDataChannel(
        'intercom',
        RTCDataChannelInit()
          ..ordered = true
          ..maxRetransmits = 30
      );
      
      _dataChannel!.onMessage = (RTCDataChannelMessage message) {
        debugPrint('Message reçu: ${message.text}');
      };
      
      // 5. Créer une offre SDP
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      // 6. Envoyer l'offre au serveur
      final sdpOffer = {
        'sdp': offer.sdp,
        'type': offer.type,
      };
      
      await http.post(
        Uri.parse('http://$serverIp:$serverPort/api/webrtc/offer'),
        headers: {'Content-Type': 'application/json'},
        body: '{"offer": ${sdpOffer.toString()}}',
      );
      
      _isTalking = true;
      debugPrint('Interphone WebRTC activé');
    } catch (e) {
      await _cleanupWebRTC();
      debugPrint('Erreur lors du démarrage de l\'interphone: $e');
      throw e;
    }
  }

  Future<void> stopTalking() async {
    if (!_isTalking) return;
    
    try {
      // Informer le serveur que nous arrêtons de parler
      await http.post(
        Uri.parse('http://$serverIp:$serverPort/api/intercom/stop'),
        headers: {'Content-Type': 'application/json'},
      );
      
      await _cleanupWebRTC();
      _isTalking = false;
      debugPrint('Interphone désactivé');
    } catch (e) {
      debugPrint('Erreur lors de l\'arrêt de l\'interphone: $e');
    }
  }

  Future<void> _cleanupWebRTC() async {
    // Fermer la connexion WebRTC
    if (_dataChannel != null) {
      await _dataChannel!.close();
      _dataChannel = null;
    }
    
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }
    
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) async {
        await track.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
  }

  bool get isTalking => _isTalking;

  void dispose() {
    stopTalking();
  }
}