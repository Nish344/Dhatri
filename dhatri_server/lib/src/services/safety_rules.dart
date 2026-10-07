/// Emergency phrases in Hindi, Hinglish and English. Checked on the raw
/// transcript so a model miss can never suppress a severe alert.
const emergencyPhrases = [
  // chest pain
  'सीने में दर्द', 'छाती में दर्द', 'seene mein dard', 'chhati mein dard',
  'chest pain',
  // breathlessness
  'सांस नहीं', 'साँस नहीं', 'सांस लेने में', 'साँस लेने में', 'सांस फूल',
  'साँस फूल', 'दम घुट', 'saans nahi', 'saans lene mein', 'saans phool',
  'breathless', "can't breathe", 'cannot breathe',
  // fainting
  'बेहोश', 'behosh', 'faint',
  // a fall
  'गिर गया',
  'गिर गई',
  'गिर गयी',
  'गिर पड़ा',
  'गिर पड़ी',
  'gir gaya',
  'gir gayi',
  'gir pada', 'gir padi', 'i fell',
];

/// Returns the emergency phrases found in [transcript], empty when none.
List<String> scanEmergency(String transcript) {
  final text = transcript.toLowerCase();
  return [
    for (final p in emergencyPhrases)
      if (text.contains(p)) p,
  ];
}
