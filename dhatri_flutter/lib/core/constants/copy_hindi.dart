/// Authentic Hindi copy constants for Dhatri voice check-ins & elderly dialogs.
class CopyHindi {
  static const String appName = 'धात्री';
  static const String tagline = 'आपका स्वास्थ्य साथी';

  // Voice Call States
  static const String stateConnected = 'कॉल कनेक्ट हो गया है';
  static const String stateDhatriSpeaking = 'धात्री बोल रही हैं...';
  static const String stateYourTurn = 'आपकी बारी — बोलिए';
  static const String stateListening = 'सुन रहे हैं...';
  static const String stateThinking = 'सोच रहे हैं...';

  // Simulated 2-turn Script
  // Turn 1
  static const String greetingQuestion = 'नमस्ते रमेश जी। आज आप कैसा महसूस कर रहे हैं?';
  
  // Patient Quick Answer Chips
  static const String patientAnsWeakness = 'थोड़ा कमजोर महसूस कर रहा हूं।';
  static const String patientAnsGood = 'आज ठीक महसूस कर रहा हूं।';
  static const String patientAnsMedicineTaken = 'शाम की दवा ले ली है।';
  static const String patientAnsDizzy = 'थोड़ा चक्कर जैसा लग रहा है।';

  // Turn 2 (Patient Memory Context Retrieval)
  static const String memoryContextRecallNotice =
      '3 दिन पहले की कमजोरी की रिपोर्ट को याद किया गया';
  static const String followUpWithMemory =
      'आपने 3 दिन पहले भी कमजोरी की बात कही थी। क्या आज यह पहले से ज्यादा लग रही है?';

  static const String patientSecondResponse = 'हां, चलने में भी परेशानी हो रही है।';

  // Closing Turn
  static const String closingThankYou =
      'धन्यवाद रमेश जी। मैंने यह नोट कर लिया है और आपकी बेटी अनन्या को सूचित कर दिया है। अपना ध्यान रखिए।';

  // Patient Action Buttons
  static const String takeNow = '✓ अभी लें (TAKE NOW)';
  static const String takenConfirmed = '✓ ले ली (TAKEN)';
  static const String saving = 'सेव हो रहा है...';
  static const String saved = 'सेव हो गया';
  static const String remindLater = 'बाद में याद दिलाएं';
  static const String talkToDhatri = 'धात्री से बात करें';
  static const String callCaregiver = 'बेटी को कॉल करें';
  static const String emergency = 'आपातकालीन (112)';
}

