import 'package:flutter/material.dart';

void main() {
  runApp(const WenhaApp());
}

class WenhaApp extends StatelessWidget {
  const WenhaApp({super.key});

  static const burgundy = Color(0xFF6C151E);
  static const green = Color(0xFF0F3D3A);
  static const beige = Color(0xFFF5DABF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وينها؟',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFCF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: burgundy,
          primary: burgundy,
          secondary: green,
          surface: const Color(0xFFFFFCF8),
        ),
        fontFamily: 'sans',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'وينها؟',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: WenhaApp.beige,
          foregroundColor: WenhaApp.green,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 12),
              Text(
                'ضايع منك شي؟',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: WenhaApp.green,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'يمكن حدا لاقيه.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'دوّر على غرض مفقود أو موجود...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.search,
                      title: 'دوّر على شي',
                      color: WenhaApp.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen(type: 'lost'))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_circle_outline,
                      title: 'شي ضاع مني',
                      color: WenhaApp.burgundy,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen(type: 'found'))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.inventory_2_outlined,
                title: 'لقيت شي',
                color: WenhaApp.green,
                wide: true,
                onTap: () {},
              ),
              const SizedBox(height: 28),
              Text(
                'أحدث البلاغات',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: WenhaApp.green,
                    ),
              ),
              const SizedBox(height: 12),
              const _EmptyReports(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.wide = false,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: wide ? 18 : 22,
          ),
          child: Row(
            mainAxisAlignment: wide
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.find_in_page_outlined, size: 42, color: WenhaApp.green),
          SizedBox(height: 10),
          Text(
            'لسا ما في بلاغات هون',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'أول ما نضيف البلاغات رح تظهر هون.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.type});
  final String type;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final secretController = TextEditingController();
  String category = 'موبايل';
  String governorate = 'دمشق';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLost = widget.type == 'lost';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLost ? 'بلاغ عن غرض ضايع' : 'بلاغ عن غرض لقيته'),
          backgroundColor: WenhaApp.beige,
          foregroundColor: WenhaApp.green,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(isLost ? 'شو ضاع منك؟' : 'شو لقيت؟', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: WenhaApp.green)),
            const SizedBox(height: 18),
            _field(titleController, 'اسم الغرض', 'مثلاً: آيفون، محفظة، مفاتيح...'),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: category,
              decoration: _decoration('التصنيف'),
              items: const ['موبايل', 'محفظة', 'مفاتيح', 'وثائق', 'حقيبة', 'إلكترونيات', 'أخرى']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => category = v ?? category),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: governorate,
              decoration: _decoration('المحافظة'),
              items: const ['دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'إدلب', 'درعا', 'السويداء', 'دير الزور', 'الرقة', 'الحسكة']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => governorate = v ?? governorate),
            ),
            const SizedBox(height: 14),
            _field(descriptionController, 'الوصف', 'اكتب تفاصيل تساعد على تمييز الغرض', maxLines: 4),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: WenhaApp.beige.withValues(alpha: .45), borderRadius: BorderRadius.circular(14)),
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.lock_outline, color: WenhaApp.green), SizedBox(width: 10),
                Expanded(child: Text('تفصيل تحقق سري: اكتب معلومة لا تظهر للناس، نستخدمها لاحقاً للتأكد من الملكية.')),
              ]),
            ),
            const SizedBox(height: 10),
            _field(secretController, 'تفصيل التحقق السري', 'مثلاً: خدش مخفي أو محتوى خاص', maxLines: 2),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: isLost ? WenhaApp.burgundy : WenhaApp.green, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تجهيز البلاغ — الربط مع قاعدة البيانات بالخطوة القادمة.')));
              },
              icon: const Icon(Icons.check),
              label: const Text('نشر البلاغ', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none));

  Widget _field(TextEditingController controller, String label, String hint, {int maxLines = 1}) => TextField(controller: controller, maxLines: maxLines, decoration: _decoration(label).copyWith(hintText: hint));
}
