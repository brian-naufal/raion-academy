import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

const Color primaryColor = Color(0xFF176B55);
const Color backgroundColor = Color(0xFFF5F7F5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dompetku',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: Color(0xFF202923),
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Expense {
  final String title;
  final String category;
  final String note;
  final int amount;
  final DateTime date;

  const Expense({
    required this.title,
    required this.category,
    required this.note,
    required this.amount,
    required this.date,
  });
}

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<ExpenseCategory> expenseCategories = [
  ExpenseCategory(
    name: 'Makanan',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFFFA726),
  ),
  ExpenseCategory(
    name: 'Transport',
    icon: Icons.directions_bus_rounded,
    color: Color(0xFF42A5F5),
  ),
  ExpenseCategory(
    name: 'Belanja',
    icon: Icons.shopping_bag_rounded,
    color: Color(0xFFAB72D5),
  ),
  ExpenseCategory(
    name: 'Lainnya',
    icon: Icons.widgets_rounded,
    color: Color(0xFF26A69A),
  ),
];

String formatRupiah(int amount) {
  final digits = amount.toString();
  final result = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    result.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      result.write('.');
    }
  }

  return 'Rp$result';
}

String formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

IconData iconForCategory(String category) {
  for (final item in expenseCategories) {
    if (item.name == category) return item.icon;
  }
  return Icons.receipt_long_rounded;
}

Color colorForCategory(String category) {
  for (final item in expenseCategories) {
    if (item.name == category) return item.color;
  }
  return primaryColor;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int balance = 500000;

  final List<Expense> expenses = [
    Expense(
      title: 'Nasi ayam',
      category: 'Makanan',
      note: 'Makan siang',
      amount: 18000,
      date: DateTime(2026, 10, 18, 12, 15),
    ),
    Expense(
      title: 'Ojek online',
      category: 'Transport',
      note: 'Perjalanan ke kampus',
      amount: 12000,
      date: DateTime(2026, 10, 18, 9, 10),
    ),
    Expense(
      title: 'Kopi susu',
      category: 'Makanan',
      note: 'Kopi sebelum kelas',
      amount: 15000,
      date: DateTime(2026, 10, 18, 8, 5),
    ),
    Expense(
      title: 'Pulsa',
      category: 'Lainnya',
      note: 'Paket internet',
      amount: 25000,
      date: DateTime(2026, 10, 17, 19, 30),
    ),
  ];

  Future<void> openAddExpensePage() async {
    final Expense? newExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (newExpense == null) return;

    setState(() {
      expenses.insert(0, newExpense);
      balance -= newExpense.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Home sengaja tidak menggunakan AppBar sesuai penugasan.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/Foto Formal Gilmar (B.Hitam).png',
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 58,
                          height: 58,
                          color: const Color(0xFFDCEBE4),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 34,
                            color: primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Agil! 👋',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202923),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Yuk, atur pengeluaranmu.',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 28,
                    color: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Kartu sisa saldo.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa saldo kamu',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: openAddExpensePage,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Catat Pengeluaran'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const SectionHeading(
                title: 'Kategori',
                subtitle: 'Pilih kategori pengeluaranmu',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final category in expenseCategories)
                    Expanded(child: CategoryItem(category: category)),
                ],
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeading(
                    title: 'Riwayat Pengeluaran',
                    subtitle: 'Catatan uang yang sudah keluar',
                  ),
                  Text(
                    '${expenses.length} transaksi',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE9EEEA)),
                ),
                child: expenses.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('Belum ada pengeluaran.')),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < expenses.length; i++) ...[
                            ExpenseTile(expense: expenses[i]),
                            if (i != expenses.length - 1)
                              const Divider(
                                height: 1,
                                color: Color(0xFFEDF0ED),
                              ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202923),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

// Widget buatan sendiri ini digunakan berulang kali untuk 4 kategori.
class CategoryItem extends StatelessWidget {
  final ExpenseCategory category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(category.icon, color: category.color, size: 27),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final categoryColor = colorForCategory(expense.category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              iconForCategory(expense.category),
              color: categoryColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${expense.category} • ${formatTime(expense.date)}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- ${formatRupiah(expense.amount)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCE5555),
            ),
          ),
        ],
      ),
    );
  }
}

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedCategory = expenseCategories.first.name;
  String? amountError;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveExpense() {
    final amountText = amountController.text.trim();
    final amount = int.tryParse(amountText);

    if (amount == null || amount <= 0) {
      setState(() {
        amountError = 'Masukkan nominal lebih dari Rp0.';
      });
      return;
    }

    final note = noteController.text.trim();
    final category = expenseCategories.firstWhere(
      (item) => item.name == selectedCategory,
    );

    final newExpense = Expense(
      title: note.isEmpty ? category.name : note,
      category: selectedCategory,
      note: note,
      amount: amount,
      date: DateTime.now(),
    );

    // Kirim transaksi ke Home, lalu tutup halaman ini.
    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Berapa yang kamu keluarkan?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E9E3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Rp',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) {
                          if (amountError != null) {
                            setState(() => amountError = null);
                          }
                        },
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (amountError != null) ...[
                const SizedBox(height: 8),
                Text(
                  amountError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 28),

              const Text(
                'Pilih kategori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenseCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.35,
                ),
                itemBuilder: (context, index) {
                  final category = expenseCategories[index];
                  final isSelected = selectedCategory == category.name;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        selectedCategory = category.name;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category.color.withValues(alpha: 0.14)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? category.color
                              : const Color(0xFFE4EAE5),
                          width: isSelected ? 1.7 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(category.icon, color: category.color, size: 23),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: category.color,
                              size: 19,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              const Text(
                'Catatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                minLines: 3,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Contoh: makan siang bareng teman',
                  filled: true,
                  fillColor: Colors.white,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE4EAE5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE4EAE5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveExpense,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text(
                    'Simpan Pengeluaran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
