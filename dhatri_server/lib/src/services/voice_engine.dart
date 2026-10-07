import 'dart:typed_data';

/// Speech in and out for the care call. Implemented by `SarvamVoice`.
abstract class VoiceEngine {
  /// Hindi transcript of [audio] (AAC/M4A or WAV, under 30 s). Empty if silent.
  Future<String> transcribe(Uint8List audio);

  /// WAV audio of [text] spoken in Hindi.
  Future<ByteData> speak(String text);
}
