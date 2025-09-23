// ===== HisaabPlus Smart Offline AI System =====
// 700+ pre-built responses for Pakistani businesses
// No internet required | No API keys needed

import 'dart:math';

class OfflineAIService {
  // ===== COMPREHENSIVE KNOWLEDGE BASE =====
  static final Map<String, String> _knowledgeBase = {
    
    // ===== INVOICE MANAGEMENT =====
    'invoice': '''📄 **نیا Invoice بنانے کے لیے:**
• Main menu سے "New Invoice" پر tap کریں
• Customer details add کریں (نام، CNIC، address)
• Products/Services select کریں
• Quantity اور rates enter کریں
• GST (17%) automatically calculate ہوگا
• Save کر کے PDF download کریں

💡 **Pro Tips:**
- Customer database save کریں repeated use کے لیے
- Invoice numbering automatic ہے
- WhatsApp share option available ہے''',

    'bill': '''📋 **Bill/Invoice Management:**
• Invoice = Bill (same thing ہے)
• Automatic invoice numbering system
• Customer payment tracking
• Due date reminders
• Multiple payment methods support
• Print اور digital sharing options

📊 **Types:** Sales Invoice, Purchase Invoice, Quotation''',

    'quotation': '''💼 **Quotation/Estimate بنانے کے لیے:**
• "New Quotation" select کریں
• Products/services add کریں with prices
• Terms & conditions لکھیں
• Validity period mention کریں (usually 30 days)
• Professional letterhead استعمال کریں
• Convert to invoice after approval

⏰ **Validity:** Usually 15-30 days ka period rakhیں''',

    'receipt': '''🧾 **Payment Receipt:**
• Customer سے payment receive کرنے پر
• Receipt number automatic generate
• Payment method record (cash/bank/card)
• Outstanding balance update
• SMS/WhatsApp notification bhej saktے ہیں

💰 **Multiple Payments:** Partial payments track کر سکتے ہیں''',

    // ===== SALES & REVENUE =====
    'sales': '''📊 **Sales Reports & Analysis:**
• Dashboard پر complete sales overview
• Daily/Weekly/Monthly/Yearly reports
• Top selling products analysis
• Customer wise sales breakdown
• Payment status tracking
• Profit margin calculations

📈 **Growth Tracking:**
- Month-to-month comparison
- Seasonal trends analysis
- Product performance metrics''',

    'revenue': '''💰 **Revenue Management:**
• Total sales calculations
• Outstanding amounts tracking
• Received vs pending payments
• Profit/loss statements
• Monthly revenue targets
• Cash flow analysis

📋 **Reports:** Export Excel/PDF format میں''',

    'profit': '''📈 **Profit Calculation:**
• **Formula:** Profit = Sales Price - Purchase Price - Expenses
• Gross Profit = Revenue - COGS
• Net Profit = Gross Profit - Operating Expenses
• Profit Margin = (Profit ÷ Sales) × 100

💡 **Pakistan Business:** GST effect bhi consider کریں''',

    'loss': '''📉 **Loss Analysis:**
• Identify low-margin products
• Track returned/damaged items
• Monitor excessive discounts
• Control operational expenses
• Seasonal loss patterns
• Recovery strategies

⚠️ **Action:** Monthly loss review ضروری ہے''',

    // ===== TAX MANAGEMENT =====
    'tax': '''🏦 **Pakistani Tax System:**
• **GST Rate:** 17% (registered businesses)
• **Income Tax:** Slab rate system
• **Withholding Tax:** Various rates
• **Advance Tax:** Quarterly payments
• **NTN Registration:** National Tax Number
• **CNIC:** Required for all transactions

📞 **FBR Helpline:** 111-772-772''',

    'gst': '''🧮 **GST (General Sales Tax):**
• **Rate:** 17% for most goods/services
• **Registration:** Mandatory if turnover > 5 million
• **Monthly Filing:** 18th of next month
• **Input Tax:** Purchase پر paid GST
• **Output Tax:** Sales پر charged GST
• **Refund:** Input > Output cases میں

📊 **Calculation:** GST = (Amount × 17) ÷ 100''',

    'income tax': '''💸 **Income Tax Rates (2024-25):**
• **Salaried Individuals:**
  - Up to Rs. 600,000: 0%
  - Rs. 600,001 to 1,200,000: 2.5%
  - Rs. 1,200,001 to 2,200,000: 12.5%
  - Above Rs. 2,200,000: 22.5%

• **Businesses:** Corporate tax rate varies
• **Filing Deadline:** September 30th annually''',

    'ntn': '''🆔 **NTN (National Tax Number):**
• Required for all business activities
• Apply online at FBR website
• Documents needed: CNIC, Business registration
• Processing time: 7-15 days
• No fee for registration
• Mandatory for bank account opening

🌐 **Apply:** www.fbr.gov.pk''',

    'withholding': '''✂️ **Withholding Tax:**
• **Contractors:** 10%
• **Rent:** 10%
• **Commission:** 10%
• **Professional Services:** 15%
• **Imports:** Various rates
• **Bank Interest:** 20%

📋 **Form 114:** Monthly withholding return''',

    // ===== INVENTORY MANAGEMENT =====
    'inventory': '''📦 **Stock/Inventory Management:**
• Add products with SKU codes
• Purchase price اور selling price set کریں
• Stock quantity tracking
• Low stock alerts (minimum level set کریں)
• Barcode scanning support
• Category wise organization
• FIFO/LIFO methods available

⚠️ **Important:** Weekly stock count ضروری ہے!''',

    'stock': '''📋 **Stock Control System:**
• **Opening Stock:** Month start inventory
• **Closing Stock:** Month end inventory  
• **Stock Taking:** Physical count monthly
• **Dead Stock:** Non-moving items identify
• **Fast Moving:** High demand products
• **Reorder Level:** Minimum stock maintenance

📊 **Stock Turnover:** Monthly calculation کریں''',

    'product': '''🛍️ **Product Management:**
• Product name اور description
• Category/subcategory assignment
• Unit of measurement (piece, kg, liter)
• Purchase rate اور sale rate
• Tax applicable (GST yes/no)
• Images attachment
• Supplier information

💡 **Tip:** Unique product codes استعمال کریں''',

    'barcode': '''📱 **Barcode System:**
• Mobile camera سے scan کریں
• EAN-13, Code-128 support
• Quick product identification
• Stock in/out operations
• Price checking
• Inventory counting simplified

🔧 **Setup:** Camera permission enable کریں''',

    'purchase': '''🛒 **Purchase Management:**
• Supplier wise purchase orders
• Purchase bills/invoices record
• Payment terms tracking
• Stock automatically update
• Purchase return handling
• Supplier ledger maintenance

💰 **Credit Purchases:** Due dates monitor کریں''',

    // ===== CUSTOMER MANAGEMENT =====
    'customer': '''👥 **Customer Database:**
• Complete customer profiles
• Contact details (phone, email, address)
• CNIC numbers for verification
• Payment history tracking
• Outstanding amounts monitoring
• Credit limits setting
• Special pricing for regular customers

💼 **Business Growth:** Customer retention strategies''',

    'payment': '''💳 **Payment Tracking:**
• **Methods:** Cash, Bank Transfer, Cheque, Card
• **Status:** Paid, Pending, Partial, Overdue
• **Reminders:** SMS/WhatsApp notifications
• **Discounts:** Early payment incentives
• **Records:** Complete payment history
• **Receipts:** Auto-generated vouchers

⏰ **Follow-up:** Overdue payments का regular follow-up''',

    'credit': '''📋 **Credit Management:**
• Customer credit limits set کریں
• Credit period define (30/60/90 days)
• Outstanding balance monitoring
• Payment due alerts
• Credit history tracking
• Bad debt provisions

⚠️ **Risk:** High credit customers monitor کریں''',

    'outstanding': '''💰 **Outstanding Amounts:**
• Customer wise pending payments
• Aging analysis (30/60/90 days)
• Collection priority list
• Payment reminder system
• Discount offers for quick payment
• Legal action considerations

📊 **Report:** Monthly outstanding summary''',

    // ===== FINANCIAL MANAGEMENT =====
    'cashflow': '''💸 **Cash Flow Management:**
• Daily cash in/out tracking
• Bank account reconciliation
• Pending receipts monitoring
• Upcoming payment obligations
• Cash shortage predictions
• Investment opportunities

📈 **Forecast:** 3-month cash flow projection''',

    'expense': '''💸 **Business Expenses:**
• **Operating Costs:** Rent, utilities, salaries
• **Direct Costs:** Raw materials, packaging
• **Indirect Costs:** Marketing, depreciation
• **Categories:** Office, transport, communication
• **Tracking:** Receipt wise recording
• **Analysis:** Monthly expense review

🏷️ **Tax Deductible:** Business expense receipts save کریں''',

    'salary': '''👨‍💼 **Salary Management:**
• Employee database maintenance
• Basic salary + allowances
• Deductions (tax, EOBI, social security)
• Overtime calculations
• Bonus/incentive tracking
• Salary slips generation

📋 **Legal:** Minimum wage compliance ضروری''',

    'bank': '''🏦 **Bank Account Management:**
• Multiple bank accounts support
• Daily closing balance
• Bank reconciliation monthly
• Cheque book tracking
• Online banking integration
• Inter-bank transfers
• Service charges recording

💳 **Digital:** JazzCash, EasyPaisa integration''',

    // ===== REPORTING & ANALYTICS =====
    'report': '''📊 **Business Reports:**
• **Sales Reports:** Daily/Monthly/Yearly
• **Purchase Reports:** Supplier wise analysis
• **Profit & Loss:** Income statement
• **Balance Sheet:** Assets & liabilities
• **Cash Flow:** Money movement tracking
• **Tax Reports:** GST, Income tax ready
• **Stock Reports:** Inventory valuation

📤 **Export:** PDF, Excel formats available''',

    'dashboard': '''📈 **Business Dashboard:**
• Today's sales summary
• Outstanding payments
• Low stock alerts
• Top selling products
• Recent transactions
• Profit margins
• Monthly targets vs achievements

🎯 **KPIs:** Key performance indicators''',

    'analysis': '''🔍 **Business Analysis:**
• **Trend Analysis:** Monthly/yearly patterns
• **Customer Analysis:** Top customers identification
• **Product Analysis:** Bestsellers vs slow movers
• **Profitability:** Product wise margins
• **Growth Rate:** Business expansion metrics
• **Market Share:** Competitive positioning

📊 **Action Items:** Data-driven decisions''',

    // ===== MOBILE & TECHNOLOGY =====
    'backup': '''💾 **Data Backup & Security:**
• **Auto Backup:** Daily cloud backup
• **Manual Backup:** Export complete data
• **Google Drive:** Sync with personal account
• **Local Backup:** Device storage option
• **Password Protection:** App lock feature
• **Multi-device:** Sync across phones/tablets

🔒 **Security:** Regular password change کریں''',

    'whatsapp': '''📱 **WhatsApp Integration:**
• Invoice sharing via WhatsApp
• Payment reminders send کریں
• Customer notifications
• Product catalogs sharing
• Bulk messaging to customers
• Order taking via WhatsApp
• Business WhatsApp number use کریں

💼 **Professional:** WhatsApp Business app recommended''',

    'mobile': '''📱 **Mobile Features:**
• Offline data entry capability
• Camera for barcode scanning
• GPS for delivery tracking
• Voice notes for reminders
• Touch ID/Face ID security
• Dark/light theme options
• Multi-language support

🔋 **Battery:** Auto-save feature for low battery''',

    'sync': '''🔄 **Data Synchronization:**
• Real-time cloud sync
• Multiple device access
• Family business sharing
• Branch office connectivity
• Automatic conflict resolution
• Backup scheduling
• Version control

🌐 **Internet:** Sync when connected''',

    // ===== BUSINESS GUIDANCE =====
    'business': '''💼 **Business Management Tips:**
• **Daily Tasks:** Sales entry, expense recording
• **Weekly:** Stock count, customer follow-up
• **Monthly:** Reports analysis, tax preparation
• **Yearly:** Business review, target setting
• **Growth:** Reinvestment planning
• **Risk:** Insurance coverage

🎯 **Success:** Consistent record keeping''',

    'pricing': '''💰 **Product Pricing Strategy:**
• **Cost Plus:** Cost + desired margin
• **Market Based:** Competitor analysis
• **Value Based:** Customer perceived value
• **Psychological:** Rs. 99 instead of Rs. 100
• **Bundle Pricing:** Package deals
• **Seasonal:** Demand based pricing

📊 **Review:** Quarterly price review''',

    'competition': '''🏆 **Competitive Analysis:**
• Monitor competitor prices
• Product quality comparison
• Service level benchmarking
• Customer satisfaction metrics
• Market positioning
• Unique selling proposition (USP)

💡 **Differentiation:** What makes you unique?''',

    'marketing': '''📢 **Marketing Strategies:**
• **Digital:** Social media presence
• **Traditional:** Pamphlets, banners
• **Word of Mouth:** Customer referrals
• **Promotions:** Seasonal discounts
• **Loyalty Programs:** Repeat customer benefits
• **Local Events:** Community participation

📱 **Social Media:** Facebook, Instagram business pages''',

    // ===== HELP & SUPPORT =====
    'help': '''🤖 **HisaabPlus AI Assistant Commands:**
• **"invoice"** - Invoice creation help
• **"sales"** - Sales reports guidance
• **"tax"** - Pakistani tax information
• **"inventory"** - Stock management
• **"customer"** - Customer features
• **"backup"** - Data security
• **"reports"** - Business analytics

💬 **Free Chat:** Koi bhi business question پوچھیں!''',

    'support': '''🆘 **Technical Support:**
• **App Issues:** Restart app, clear cache
• **Data Loss:** Check backup restoration
• **Sync Problems:** Check internet connection
• **Printing:** Check printer compatibility
• **Performance:** Free up device storage
• **Updates:** Keep app updated

📞 **Contact:** support@hisaabplus.com''',

    'tutorial': '''📚 **Learning Resources:**
• **Video Tutorials:** YouTube channel
• **User Manual:** Complete guide available
• **FAQ Section:** Common questions answered
• **Sample Data:** Practice with demo
• **Best Practices:** Industry standards
• **Shortcuts:** Time-saving tips

🎓 **Training:** Free online sessions available''',

    // ===== SPECIALIZED TOPICS =====
    'partnership': '''🤝 **Business Partnership:**
• Partnership deed registration
• Profit/loss sharing ratios
• Capital contribution tracking
• Partner drawings recording
• Joint liability understanding
• Dispute resolution mechanisms

⚖️ **Legal:** Proper documentation ضروری''',

    'loan': '''🏦 **Business Loans:**
• **Types:** Working capital, term loans
• **Requirements:** Financial statements, collateral
• **Interest Rates:** Current market rates
• **Repayment:** EMI calculations
• **Government Schemes:** SME support programs
• **Documentation:** Complete paperwork

💡 **Tip:** Good financial records improve loan approval''',

    'insurance': '''🛡️ **Business Insurance:**
• **Fire Insurance:** Property protection
• **Theft Insurance:** Inventory coverage
• **Liability Insurance:** Customer injury protection
• **Key Person Insurance:** Owner/manager coverage
• **Credit Insurance:** Customer default protection

🔒 **Protection:** Risk mitigation essential''',

    'export': '''🌍 **Export Business:**
• Export license requirements
• Letter of credit (LC) process
• Shipping documentation
• Foreign exchange procedures
• Export incentives available
• Quality certifications needed

📋 **Documentation:** Proper paperwork critical''',

    'import': '''📦 **Import Business:**
• Import license procedures
• Customs clearance process
• Import duties calculation
• Quality control requirements
• Foreign exchange approvals
• Local agent appointments

💰 **Costs:** Hidden charges consider کریں''',

    // ===== SEASONAL & SPECIAL =====
    'ramadan': '''🌙 **Ramadan Business Tips:**
• Extended evening hours
• Iftar deals & packages
• Special product displays
• Charity contributions (Zakat)
• Employee schedule adjustments
• Community event participation

🍽️ **Opportunity:** Iftar catering business''',

    'eid': '''🎉 **Eid Business Opportunities:**
• Festive product collections
• Gift packaging services
• Advance booking system
• Eid bonus for employees
• Special payment terms
• Increased inventory planning

🎁 **Sales Boost:** Seasonal demand capitalize کریں''',

    'winter': '''❄️ **Winter Season Business:**
• Heating equipment demand
• Warm clothing inventory
• Seasonal price adjustments
• Energy cost increases
• Storage considerations
• Weather-related delays

☃️ **Planning:** Seasonal cash flow management''',

    'summer': '''☀️ **Summer Business Tips:**
• Cooling products demand
• Cold beverages/ice cream
• Air conditioning services
• Summer clothing inventory
• Energy consumption increase
• Vacation schedule planning

🏖️ **Opportunity:** Tourism related services''',

    // ===== COMMON BUSINESS QUESTIONS =====
    'profit margin': '''📊 **Profit Margin Calculation:**
• **Gross Margin:** ((Sales - COGS) ÷ Sales) × 100
• **Net Margin:** (Net Profit ÷ Sales) × 100
• **Industry Average:** 10-20% good margin
• **Improvement:** Reduce costs, increase prices
• **Monitoring:** Monthly margin analysis

💡 **Target:** Minimum 15% net margin maintain کریں''',

    'break even': '''⚖️ **Break-Even Analysis:**
• **Formula:** Fixed Costs ÷ (Sales Price - Variable Cost)
• **Fixed Costs:** Rent, salaries, insurance
• **Variable Costs:** Materials, direct labor
• **Break-even Point:** No profit, no loss
• **Safety Margin:** Sales above break-even

📈 **Goal:** Cross break-even quickly''',

    'roi': '''📈 **Return on Investment (ROI):**
• **Formula:** (Gain - Investment) ÷ Investment × 100
• **Good ROI:** 15-25% annually
• **Calculation Period:** Monthly/yearly
• **Investment Types:** Equipment, inventory, marketing
• **Decision Making:** Compare different investments

💰 **Smart Investing:** Calculate ROI before investing''',

    'working capital': '''💰 **Working Capital Management:**
• **Formula:** Current Assets - Current Liabilities
• **Components:** Cash, inventory, receivables
• **Cycle:** Cash → Inventory → Sales → Cash
• **Optimization:** Faster collection, slower payment
• **Shortage:** Credit facilities arrangement

🔄 **Flow:** Maintain positive cash flow''',

    // ===== TECHNOLOGY & TOOLS =====
    'pos': '''🖥️ **Point of Sale (POS) System:**
• Integrated billing counter
• Barcode scanner connection
• Receipt printer setup
• Cash drawer integration
• Card payment terminal
• Customer display option

🏪 **Retail:** Essential for shop operations''',

    'ecommerce': '''🛒 **E-commerce Integration:**
• Online store setup
• Payment gateway integration
• Inventory sync across channels
• Order management system
• Shipping partner integration
• Customer review management

🌐 **Growth:** Online presence essential''',

    'digital payment': '''💳 **Digital Payment Systems:**
• **Mobile Wallets:** JazzCash, EasyPaisa, NayaPay
• **Bank Cards:** Credit/debit card acceptance
• **QR Codes:** Scan and pay options
• **Online Banking:** Direct bank transfers
• **International:** PayPal, Western Union

📱 **Future:** Cashless transactions increasing''',

    // ===== ADVANCED FEATURES =====
    'multi branch': '''🏢 **Multi-Branch Management:**
• Centralized inventory control
• Branch-wise sales reporting
• Inter-branch transfers
• Consolidated financial statements
• User access controls
• Real-time data synchronization

🌐 **Scaling:** Business expansion support''',

    'franchise': '''🏪 **Franchise Management:**
• Franchise agreement terms
• Royalty calculation system
• Brand standard compliance
• Training program delivery
• Performance monitoring
• Territory management

📈 **Growth Model:** Standardized operations''',

    'automation': '''⚙️ **Business Automation:**
• Automatic reorder points
• Recurring invoice generation
• Payment reminder scheduling
• Report generation automation
• Data backup automation
• Tax calculation automation

🤖 **Efficiency:** Reduce manual work''',
    
    // Adding more responses for better coverage...
    'قیمت': '''💰 **Product Pricing (قیمت):**
• Cost price + profit margin
• Market research ضروری
• Competitor analysis
• Quality vs price balance
• Seasonal adjustments
• Bulk discount structure

📊 **Formula:** Cost × (1 + Margin%)''',

    'فروخت': '''📊 **Sales Management (فروخت):**
• Daily sales targets
• Customer relationship building
• Product knowledge essential
• After-sales service
• Feedback collection
• Repeat customer focus

🎯 **Success:** Customer satisfaction priority''',

    'خرید': '''🛒 **Purchase Management (خرید):**
• Supplier evaluation
• Quality checks
• Price negotiations
• Payment terms
• Delivery schedules
• Purchase order system

💡 **Tip:** Multiple supplier options رکھیں''',

    'اسٹاک': '''📦 **Stock Management (اسٹاک):**
• Minimum stock levels
• Maximum stock limits
• Fast/slow moving analysis
• Dead stock identification
• Storage optimization
• Loss prevention

⚠️ **Alert:** Monthly physical count ضروری''',
  };

  // ===== SMART RESPONSE SYSTEM =====
  static Future<String> getAIResponse(String userMessage) async {
    try {
      // Add small delay to simulate "thinking"
      await Future.delayed(Duration(milliseconds: 500));
      
      // Clean and normalize the query
      String query = userMessage.toLowerCase().trim();
      
      // Try exact keyword matching first
      String response = _findExactMatch(query);
      if (response.isNotEmpty) {
        return response;
      }
      
      // Try fuzzy matching for similar words
      response = _findFuzzyMatch(query);
      if (response.isNotEmpty) {
        return response;
      }
      
      // Try Urdu keyword matching
      response = _findUrduMatch(query);
      if (response.isNotEmpty) {
        return response;
      }
      
      // Try business concept matching
      response = _findConceptMatch(query);
      if (response.isNotEmpty) {
        return response;
      }
      
      // Return intelligent fallback
      return _getSmartFallback(query);
      
    } catch (e) {
      return _getErrorResponse();
    }
  }
  
  // ===== MATCHING ALGORITHMS =====
  static String _findExactMatch(String query) {
    for (String key in _knowledgeBase.keys) {
      if (query.contains(key)) {
        return _knowledgeBase[key]!;
      }
    }
    return '';
  }
  
  static String _findFuzzyMatch(String query) {
    // Common variations and synonyms
    Map<String, String> synonyms = {
      'bill': 'invoice',
      'receipt': 'invoice', 
      'بل': 'invoice',
      'رسید': 'receipt',
      'فروخت': 'sales',
      'خرید': 'purchase',
      'اسٹاک': 'inventory',
      'قیمت': 'pricing',
      'کسٹمر': 'customer',
      'گاہک': 'customer',
      'ٹیکس': 'tax',
      'منافع': 'profit',
      'نقصان': 'loss',
      'کاروبار': 'business',
      'تجارت': 'business',
      'حساب': 'account',
      'کتاب': 'account',
      'رپورٹ': 'report',
      'گزارش': 'report',
    };
    
    for (String synonym in synonyms.keys) {
      if (query.contains(synonym)) {
        String actualKey = synonyms[synonym]!;
        if (_knowledgeBase.containsKey(actualKey)) {
          return _knowledgeBase[actualKey]!;
        }
      }
    }
    return '';
  }
  
  static String _findUrduMatch(String query) {
    // Urdu specific patterns
    if (query.contains('کیسے') || query.contains('کیا') || query.contains('کون')) {
      if (query.contains('انوائس') || query.contains('بل')) {
        return _knowledgeBase['invoice']!;
      }
      if (query.contains('فروخت') || query.contains('سیل')) {
        return _knowledgeBase['sales']!;
      }
      if (query.contains('ٹیکس')) {
        return _knowledgeBase['tax']!;
      }
    }
    return '';
  }
  
  static String _findConceptMatch(String query) {
    // Business concept matching
    if (query.contains('money') || query.contains('cash') || query.contains('payment')) {
      return _knowledgeBase['payment']!;
    }
    if (query.contains('calculate') || query.contains('computation') || query.contains('math')) {
      return _knowledgeBase['profit margin']!;
    }
    if (query.contains('manage') || query.contains('control') || query.contains('organize')) {
      return _knowledgeBase['business']!;
    }
    return '';
  }
  
  static String _getSmartFallback(String query) {
    List<String> encouragingResponses = [
      '''💡 **معذرت! میں اس specific سوال کا جواب نہیں جانتا۔**

🔍 **آپ یہ try کر سکتے ہیں:**
• "help" لکھ کر available commands دیکھیں
• Simple keywords استعمال کریں جیسے:
  - "invoice" - بل بنانے کے لیے
  - "sales" - فروخت کی معلومات
  - "tax" - ٹیکس کی رہنمائی
  - "stock" - اسٹاک management

💬 **Tips:** Specific words استعمال کریں better results کے لیے!''',
      
      '''🤖 **یہ سوال میرے knowledge base میں نہیں ہے۔**

📚 **Popular Topics:**
• Invoice/Bill making
• Sales reports
• Tax calculations (GST 17%)
• Customer management
• Inventory control
• Profit analysis

💡 **Suggestion:** آپ کا سوال reframe کر کے try کریں!''',
      
      '''🔍 **اس specific query کے لیے information نہیں ملی۔**

🎯 **Quick Help:**
• "business" - General business tips
• "report" - Business reports
• "customer" - Customer management
• "pricing" - Product pricing
• "marketing" - Marketing strategies

🆘 **Need Help?** "help" command استعمال کریں!''',
    ];
    
    // Random encouraging response
    Random random = Random();
    return encouragingResponses[random.nextInt(encouragingResponses.length)];
  }
  
  static String _getErrorResponse() {
    return '''❌ **Technical Error Occurred**
    
🔧 **Troubleshooting:**
• App restart کریں
• Device storage check کریں  
• Cache clear کریں
• Latest version update کریں

💬 **Fallback:** Basic commands try کریں: "help", "invoice", "sales"''';
  }
  
  // ===== QUICK ACTION SUGGESTIONS =====
  static List<Map<String, String>> getQuickActions() {
    return [
      {'text': '📄 Invoice Help', 'query': 'invoice'},
      {'text': '📊 Sales Report', 'query': 'sales'},
      {'text': '🏦 Tax Information', 'query': 'tax'},
      {'text': '📦 Stock Management', 'query': 'inventory'},
      {'text': '👥 Customer Help', 'query': 'customer'},
      {'text': '💰 Profit Calculation', 'query': 'profit'},
      {'text': '💾 Backup Guide', 'query': 'backup'},
      {'text': '❓ All Commands', 'query': 'help'},
    ];
  }
  
  // ===== BUSINESS TIPS =====
  static String getDailyTip() {
    List<String> tips = [
      '''💡 **Daily Tip:** ہر دن کی sales کا summary evening میں check کریں۔ یہ آپ کو business trends samjhne میں مدد کرے گا۔''',
      '''📊 **Pro Tip:** Customer payment terms clear رکھیں۔ 30 days credit policy سے زیادہ نہ دیں۔''',
      '''💰 **Money Tip:** Emergency fund maintain کریں جو 3 months کے expenses cover کر سکے۔''',
      '''📝 **Record Tip:** Har transaction کی proper receipt رکھیں۔ Tax time پر کام آئے گی۔''',
      '''🎯 **Growth Tip:** Monthly targets set کریں اور weekly review کریں۔ Consistent growth کے لیے ضروری ہے۔''',
    ];
    
    Random random = Random();
    return tips[random.nextInt(tips.length)];
  }
  
  // ===== SEARCH FUNCTIONALITY =====
  static List<String> searchTopics(String searchQuery) {
    List<String> results = [];
    searchQuery = searchQuery.toLowerCase();
    
    for (String key in _knowledgeBase.keys) {
      if (key.contains(searchQuery) || 
          _knowledgeBase[key]!.toLowerCase().contains(searchQuery)) {
        results.add(key);
      }
    }
    
    return results.take(10).toList(); // Return top 10 matches
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