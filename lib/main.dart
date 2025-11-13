import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.example.myapp/expenses');
  List<Map<String, dynamic>> _expenses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getExpenses();
  }

  Future<void> _getExpenses() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getExpenses');
      setState(() {
        _expenses = result.map((e) => Map<String, dynamic>.from(e)).toList();
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = "Failed to get expenses: '${e.message}'.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate summary data from the fetched expenses
    final double totalExpenses = _expenses.fold(0, (sum, item) => sum + (item['amount'] ?? 0.0));
    final int smallExpensesCount = _expenses.where((item) => (item['amount'] ?? 0.0) < 500).length;
    final int largeExpensesCount = _expenses.where((item) => (item['amount'] ?? 0.0) >= 500).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker', style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: Text('Loading Expenses from Native...'))
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    // Summary Card
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('Total Expenses', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('₹${totalExpenses.toStringAsFixed(2)}', style: GoogleFonts.robotoMono(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('< ₹500', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(smallExpensesCount.toString(), style: GoogleFonts.robotoMono(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('>= ₹500', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(largeExpensesCount.toString(), style: GoogleFonts.robotoMono(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Transaction List Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),

                    // Transaction List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          // The date is a string, so we need to parse it
                          final DateTime date = DateTime.parse(expense['date']);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            elevation: 2.0,
                            child: ListTile(
                              leading: const Icon(Icons.monetization_on_outlined, color: Colors.deepPurple, size: 40),
                              title: Text(expense['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(DateFormat.yMMMd().format(date)),
                              trailing: Text(
                                '₹${(expense['amount'] ?? 0.0).toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
