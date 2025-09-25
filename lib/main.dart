import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/splash_screen.dart';
import 'screens/invoice/edit_invoice_screen.dart';
import 'providers/invoice_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/supplier_provider.dart';
import 'providers/stock_movement_provider.dart';
import 'providers/purchase_order_provider.dart';
import 'providers/reports_provider.dart';
import 'utils/database_helper.dart';
import 'models/invoice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handling to surface any silent errors on devices where VM service cannot bind
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Also print to console
    // ignore: avoid_print
    print('FlutterError: \\n"+details.toStringShort()+"\\n'+details.exceptionAsString());
  };
  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // ignore: avoid_print
    print('Uncaught zone error: $error\n$stack');
    return true; // handled
  };
  
  runZonedGuarded(() async {
    // Initialize database factory per-platform
    if (kIsWeb) {
      // Web uses the FFI web shim
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop uses sqflite_common_ffi
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      // Android/iOS: use default sqflite implementation (do not override)
    }
    // ignore: avoid_print
    print('App starting...');
    runApp(const HisaabPlusApp());
  }, (error, stack) {
    // ignore: avoid_print
    print('Zoned error: $error\n$stack');
  });
}

class HisaabPlusApp extends StatelessWidget {
  const HisaabPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => StockMovementProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseOrderProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: MaterialApp(
        title: 'HisaabPlus - حساب پلس',
        debugShowCheckedModeBanner: false,
        theme: _buildModernTheme(),
        home: const SplashScreen(),
        routes: {
          '/edit_invoice': (context) {
            final invoice = ModalRoute.of(context)!.settings.arguments as Invoice;
            return EditInvoiceScreen(invoice: invoice);
          },
        },
      ),
    );
  }

  ThemeData _buildModernTheme() {
    const primaryColor = Color(0xFF1A73E8); // Modern Google Blue
    const secondaryColor = Color(0xFF34A853); // Modern Green
    const surfaceColor = Color(0xFFF8F9FA); // Light gray surface
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        // background: backgroundColor, // Deprecated - using surface instead
      ),
      scaffoldBackgroundColor: surfaceColor,
      
      // Mobile-optimized AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20, // Reduced for mobile
          fontWeight: FontWeight.w700,
          color: Color(0xFF202124),
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF5F6368),
          size: 24,
        ),
      ),
      
      // Mobile-optimized Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Reduced for mobile
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced margins
      ),
      
      // Mobile-optimized Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.black26,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Better touch targets
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(88, 48), // Minimum touch target
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(64, 40),
        ),
      ),
      
      // Mobile-optimized FAB Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      
      // Modern Input Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 16,
        ),
      ),
      
      // Modern Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Color(0xFF202124),
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202124),
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202124),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202124),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202124),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF202124),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5F6368),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5F6368),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5F6368),
        ),
      ),
      
      // Modern List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Modern Divider Theme
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Colors.grey.shade200,
        space: 1,
      ),
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
