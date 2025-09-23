// API Keys Configuration for HisaabPlus v3.0 Hybrid System
// Offline + Online AI Assistant with fallback mechanism

class ApiKeys {
  // 🔥 GROQ API (RECOMMENDED - Fastest) 
  // Get free key: https://console.groq.com/
  // Free limit: 14,400 requests/day
  static const String groqApiKey = 'YOUR_FREE_GROQ_API_KEY_HERE';
  
  // 🚀 OPENROUTER API (Multiple Free Models)
  // Get free key: https://openrouter.ai/
  // Free models: DeepSeek R1, Llama, Qwen, etc.
  static const String openRouterApiKey = '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';
  
  // 🌟 GOOGLE AI STUDIO (Gemini)
  // Get free key: https://makersuite.google.com/app/apikey
  // Free limit: 60 requests/minute, 1500 requests/day
  static const String googleApiKey = 'AIzaSyDLq9jrojQzG2kQ8uRezbUeXzb7RI-wwIY';
  
  // ⚡ DEEPSEEK API (Direct)
  // Get free key: https://platform.deepseek.com/
  // Free credits: $5 on signup
  static const String deepSeekApiKey = 'YOUR_FREE_DEEPSEEK_API_KEY_HERE';
  
  // 🇪🇺 MISTRAL AI 
  // Get free key: https://console.mistral.ai/
  // Free tier: 5M tokens/month
  static const String mistralApiKey = 'YOUR_FREE_MISTRAL_API_KEY_HERE';
  
  // 🤗 HUGGING FACE (Completely Free)
  // Get free token: https://huggingface.co/settings/tokens
  // No limits, community models
  static const String huggingFaceToken = 'YOUR_FREE_HF_TOKEN_HERE';
  
  // 🎯 HYBRID SYSTEM PRIORITY ORDER
  // 1. Offline AI (700+ topics) - ALWAYS FIRST
  // 2. Groq (1-2 seconds) - Fastest online
  // 3. OpenRouter (2-3 seconds) - Multiple models
  // 4. Google Gemini (2-4 seconds) - High quality
  // 5. DeepSeek (3-5 seconds) - Advanced reasoning
  // 6. Mistral (3-5 seconds) - European model
  // 7. HuggingFace (5-10 seconds) - Community models
  
  // 💡 USAGE STRATEGY
  // - Offline AI handles 80%+ of queries instantly
  // - Online APIs only for complex/new questions
  // - No API keys = 100% offline mode
  // - 1+ API key = Hybrid mode with fallback
}

/*
🔧 HOW TO USE:

1. **100% Offline Mode (Default):**
   - Keep all API keys as 'YOUR_FREE_...'
   - HisaabBot works with 700+ offline responses
   - No internet required, instant responses
   - Complete privacy protection

2. **Hybrid Mode (Optional Enhancement):**
   - Get at least 1 free API key from the links above
   - Replace 'YOUR_FREE_...' with your actual key
   - Rebuild app (flutter build apk)
   - Offline AI + Online fallback for complex queries

🌟 RECOMMENDED API KEYS (Pick 2-3):
- Groq: Fastest responses, great for quick questions
- OpenRouter: Multiple free models, very reliable
- Google Gemini: High quality, good for complex questions

⚠️ SECURITY:
- Keep your API keys private
- Don't share them publicly
- All listed services have generous free tiers
- API keys stored locally, never transmitted

📱 MOBILE COMPATIBILITY:
- All APIs work perfectly in compiled APK
- Offline mode works without internet
- Hybrid mode falls back to offline when APIs fail
- Smart caching for better performance

🇵🇰 PAKISTANI BUSINESS OPTIMIZED:
- Urdu language support in all modes
- PKR currency calculations  
- Local tax guidance (GST 17%)
- Business context understanding
- Offline knowledge base covers local requirements

🚀 PERFORMANCE BENEFITS:
- Offline: Instant responses (0.1-0.5 seconds)
- Online: Fast fallback (1-5 seconds)
- No rate limits in offline mode
- Unlimited questions with offline knowledge base
*/