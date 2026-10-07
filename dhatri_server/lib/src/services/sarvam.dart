import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import 'voice_engine.dart';

class SarvamException implements Exception {
  SarvamException(this.message);
  final String message;
  @override
  String toString() => 'SarvamException: $message';
}

class SarvamVoice implements VoiceEngine {
  SarvamVoice(this._apiKey, {http.Client? client})
    : _http = client ?? http.Client();

  factory SarvamVoice.of(Session session) {
    final key = session.serverpod.getPassword('sarvamApiKey');
    if (key == null || key.isEmpty) {
      throw StateError('sarvamApiKey is missing from config/passwords.yaml');
    }
    return SarvamVoice(key);
  }

  final String _apiKey;
  final http.Client _http;

  static final _env = Platform.environment;
  final sttModel = _env['SARVAM_STT_MODEL'] ?? 'saaras:v3';
  final ttsModel = _env['SARVAM_TTS_MODEL'] ?? 'bulbul:v3';
  final speaker = _env['SARVAM_SPEAKER'] ?? 'priya';

  /// Spoken lines by `speaker|text`. Fixed greetings and closings repeat on
  /// every call, so this saves a round trip per turn.
  static final _speechCache = <String, ByteData>{};

  static const _base = 'https://api.sarvam.ai';
  static const _timeout = Duration(seconds: 20);

  @override
  Future<String> transcribe(Uint8List audio) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$_base/speech-to-text'))
          ..headers['api-subscription-key'] = _apiKey
          ..fields['model'] = sttModel
          ..fields['language_code'] = 'hi-IN'
          ..files.add(
            http.MultipartFile.fromBytes('file', audio, filename: 'answer.m4a'),
          );
    if (sttModel == 'saaras:v3') request.fields['mode'] = 'transcribe';

    final response = await http.Response.fromStream(
      await _http.send(request).timeout(_timeout),
    );
    final body = _decode(response);
    return (body['transcript'] as String? ?? '').trim();
  }

  @override
  Future<ByteData> speak(String text) async {
    final key = '$speaker|$text';
    final cached = _speechCache[key];
    if (cached != null) return cached;

    final response = await _http
        .post(
          Uri.parse('$_base/text-to-speech'),
          headers: {
            'api-subscription-key': _apiKey,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'text': text,
            'language_code': 'hi-IN',
            'model': ttsModel,
            'speaker': speaker,
            'pace': 0.9,
          }),
        )
        .timeout(_timeout);
    final audios = _decode(response)['audios'] as List?;
    if (audios == null || audios.isEmpty) {
      throw SarvamException('text-to-speech returned no audio');
    }
    final wav = ByteData.sublistView(base64Decode(audios.first as String));
    // ponytail: unbounded only in theory; dynamic replies rarely repeat, so cap
    // by clearing. Swap for an LRU if memory ever shows up in Cloud metrics.
    if (_speechCache.length > 200) _speechCache.clear();
    _speechCache[key] = wav;
    return wav;
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode != 200) {
      throw SarvamException('HTTP ${response.statusCode}: ${response.body}');
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
