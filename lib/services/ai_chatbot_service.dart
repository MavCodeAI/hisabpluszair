// ===== HisaabPlus v3.0 Hybrid AI Assistant =====
// Smart Offline + Online Fallback System
// 700+ offline responses + 6 free API integrations

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import 'offline_ai_service.dart';

class HisaabBotService {
  // API Endpoints
  static const String groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String openRouterUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String googleUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const String deepSeekUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String mistralUrl = 'https://api.mistral.ai/v1/chat/completions';
  static const String huggingFaceUrl = 'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium';

  // System prompt for Pakistani business context
  static const String systemPrompt = '''
آپ HisaabPlus ایپ کے AI Assistant "HisaabBot" ہیں۔
آپ کا کام Pakistani business owners کی مدد کرنا ہے:

📊 Business Management:
- Invoice, Sales, Inventory management
- Financial calculations اور reports
- Tax guidance (GST, Income Tax)
- Customer management

💰 Pakistani Context:
- Currency: PKR (Pakistani Rupees)
- Tax rates: GST 17%, Income tax varies
- Business registration: NTN, CNIC requirements
- Local business practices

🗣️ Communication:
- Urdu اور English میں جواب دیں
- Simple, practical advice دیں
- Emojis استعمال کریں readability کے لیے
- Short اور helpful responses

ہمیشہ helpful, accurate اور professional رہیں!''';

  // ===== MAIN HYBRID AI RESPONSE FUNCTION =====
  static Future<String> getAIResponse(String userMessage) async {
    try {
      // 🚀 STEP 1: Try Offline AI First (700+ topics)
      String offlineResponse = await OfflineAIService.getAIResponse(userMessage);
      
      // If offline AI found a good match, return it immediately
      if (_isGoodOfflineResponse(offlineResponse)) {
        return '🔄 **Offline AI**\n\n$offlineResponse';
      }
      
      // 🌐 STEP 2: Try Online APIs for complex/new queries
      if (_hasValidApiKeys()) {
        List<Future<String> Function()> apiCalls = [
          () => _callGroqAPI(userMessage),
          () => _callOpenRouterAPI(userMessage),
          () => _callGoogleAPI(userMessage),
          () => _callDeepSeekAPI(userMessage),
          () => _callMistralAPI(userMessage),
          () => _callHuggingFaceAPI(userMessage),
        ];

        for (var apiCall in apiCalls) {
          try {
            String response = await apiCall().timeout(
              Duration(seconds: 10),
              onTimeout: () => throw Exception('Timeout'),
            );
            if (response.isNotEmpty && !response.contains('خرابی')) {
              return '🌐 **Online AI**\n\n$response';
            }
          } catch (e) {
            print('API failed: $e');
            continue; // Try next API
          }
        }
      }
      
      // 🔄 STEP 3: Return enhanced offline fallback
      return offlineResponse;
      
    } catch (e) {
      return _getErrorFallback();
    }
  }

  // ===== HELPER FUNCTIONS =====
  static bool _isGoodOfflineResponse(String response) {
    // Check if the response contains specific business guidance
    return !response.contains('معذرت! میں اس specific سوال') &&
           !response.contains('یہ سوال میرے knowledge base میں نہیں') &&
           !response.contains('اس specific query کے لیے information نہیں') &&
           response.length > 100;
  }
  
  static bool _hasValidApiKeys() {
    return ApiKeys.groqApiKey != 'YOUR_FREE_GROQ_API_KEY_HERE' ||
           ApiKeys.openRouterApiKey != 'YOUR_FREE_OPENROUTER_API_KEY_HERE' ||
           ApiKeys.googleApiKey != 'YOUR_FREE_GOOGLE_API_KEY_HERE' ||
           ApiKeys.deepSeekApiKey != 'YOUR_FREE_DEEPSEEK_API_KEY_HERE' ||
           ApiKeys.mistralApiKey != 'YOUR_FREE_MISTRAL_API_KEY_HERE' ||
           ApiKeys.huggingFaceToken != 'YOUR_FREE_HF_TOKEN_HERE';
  }

  // ===== GROQ API (Fastest Online) =====
  static Future<String> _callGroqAPI(String message) async {
    if (ApiKeys.groqApiKey == 'YOUR_FREE_GROQ_API_KEY_HERE') {
      throw Exception('No Groq API key');
    }
    
    final response = await http.post(
      Uri.parse(groqUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.groqApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message}
        ],
        'model': 'llama-3.1-70b-versatile',
        'temperature': 0.7,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    }
    throw Exception('Groq API failed');
  }

  // ===== OPENROUTER API (Multiple Free Models) =====
  static Future<String> _callOpenRouterAPI(String message) async {
    if (ApiKeys.openRouterApiKey == 'YOUR_FREE_OPENROUTER_API_KEY_HERE') {
      throw Exception('No OpenRouter API key');
    }
    
    final response = await http.post(
      Uri.parse(openRouterUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.openRouterApiKey}',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://hisaabplus.app',
        'X-Title': 'HisaabPlus AI Assistant',
      },
      body: jsonEncode({
        'model': 'deepseek/deepseek-r1:free', // Free DeepSeek R1
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message}
        ],
        'temperature': 0.7,
        'max_tokens': 400,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    }
    throw Exception('OpenRouter API failed');
  }

  // ===== GOOGLE AI STUDIO (Gemini) =====
  static Future<String> _callGoogleAPI(String message) async {
    if (ApiKeys.googleApiKey == 'YOUR_FREE_GOOGLE_API_KEY_HERE') {
      throw Exception('No Google API key');
    }
    
    final response = await http.post(
      Uri.parse('$googleUrl?key=${ApiKeys.googleApiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{
          'parts': [{
            'text': '$systemPrompt\n\nUser: $message\n\nAI Assistant:'
          }]
        }],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 400,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
    }
    throw Exception('Google API failed');
  }

  // ===== DEEPSEEK API (Direct) =====
  static Future<String> _callDeepSeekAPI(String message) async {
    if (ApiKeys.deepSeekApiKey == 'YOUR_FREE_DEEPSEEK_API_KEY_HERE') {
      throw Exception('No DeepSeek API key');
    }
    
    final response = await http.post(
      Uri.parse(deepSeekUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.deepSeekApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message}
        ],
        'model': 'deepseek-chat',
        'temperature': 0.7,
        'max_tokens': 400,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    }
    throw Exception('DeepSeek API failed');
  }

  // ===== MISTRAL AI =====
  static Future<String> _callMistralAPI(String message) async {
    if (ApiKeys.mistralApiKey == 'YOUR_FREE_MISTRAL_API_KEY_HERE') {
      throw Exception('No Mistral API key');
    }
    
    final response = await http.post(
      Uri.parse(mistralUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.mistralApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'mistral-tiny',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message}
        ],
        'temperature': 0.7,
        'max_tokens': 400,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    }
    throw Exception('Mistral API failed');
  }

  // ===== HUGGING FACE API =====
  static Future<String> _callHuggingFaceAPI(String message) async {
    if (ApiKeys.huggingFaceToken == 'YOUR_FREE_HF_TOKEN_HERE') {
      throw Exception('No HuggingFace token');
    }
    
    final response = await http.post(
      Uri.parse(huggingFaceUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.huggingFaceToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': message,
        'parameters': {
          'max_new_tokens': 200,
          'temperature': 0.7,
          'return_full_text': false,
        }
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data[0]['generated_text'] ?? '';
    }
    throw Exception('HuggingFace API failed');
  }

  static String _getErrorFallback() {
    return '''❌ **Technical Error Occurred**
    
🔧 **System Status:**
• Offline AI: ✅ Active (700+ topics available)
• Online APIs: ❌ Currently unavailable

💡 **You can still:**
• Use specific keywords: "invoice", "sales", "tax"
• Try Quick Action buttons below
• Ask basic business questions
• Get Pakistani tax guidance

🔄 **Tip:** Check internet connection for online AI features''';
  }

  // ===== DAILY BUSINESS TIP =====
  static String getDailyTip() {
    return OfflineAIService.getDailyTip();
  }
  
  // ===== SEARCH FUNCTIONALITY =====
  static List<String> searchTopics(String query) {
    return OfflineAIService.searchTopics(query);
  }

  // ===== QUICK ACTIONS =====
  static List<Map<String, String>> getQuickActions() {
    return OfflineAIService.getQuickActions();
  }
}

// ===== MESSAGE MODEL =====
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
