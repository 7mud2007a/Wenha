import 'dart:ui' as ui;

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


class JellyLoader extends StatefulWidget {
  const JellyLoader({
    super.key,
    this.color = WenhaApp.burgundy,
    this.size = 40,
  });

  final Color color;
  final double size;

  @override
  State<JellyLoader> createState() => _JellyLoaderState();
}

class _JellyLoaderState extends State<JellyLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size / 2,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final phase = _controller.value;
          final pulse = (phase < .5 ? phase : 1 - phase) * 2;
          final offset = widget.size * .375 * pulse;
          final scale = .65 + (.35 * (1 - pulse));

          return Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 4.5,
                  sigmaY: 4.5,
                ),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size / 2,
                  child: Stack(
                    children: [
                      Positioned(
                        left: widget.size * .25 - offset,
                        top: 0,
                        child: Transform.scale(
                          scale: scale,
                          child: _blob(),
                        ),
                      ),
                      Positioned(
                        left: widget.size * .25 + offset,
                        top: 0,
                        child: Transform.scale(
                          scale: scale,
                          child: _blob(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Crisp center keeps the loader readable while the blurred
              // blobs create the soft "jelly" ooze effect from the original.
              Container(
                width: widget.size * .22,
                height: widget.size * .22,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob() {
    return Container(
      width: widget.size * .5,
      height: widget.size * .5,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class WenhaNetworkLoader extends StatelessWidget {
  const WenhaNetworkLoader({
    super.key,
    this.message = 'عم نحاول نتصل...',
    this.color = WenhaApp.burgundy,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            JellyLoader(color: color),
            const SizedBox(height: 14),
            Text(
              message,
              style: const TextStyle(
                color: WenhaApp.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final query = TextEditingController();
  String type = 'الكل', category = 'الكل', governorate = 'الكل';
  final items = const [
    {'title':'آيفون أسود','type':'ضايع','category':'موبايل','gov':'دمشق','place':'المزة','date':'اليوم'},
    {'title':'محفظة جلدية','type':'لقيته','category':'محفظة','gov':'حلب','place':'الجميلية','date':'أمس'},
    {'title':'ربطة مفاتيح','type':'ضايع','category':'مفاتيح','gov':'حمص','place':'الحمرا','date':'منذ يومين'},
  ];
  @override void dispose(){ query.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final results = items.where((x) {
      final q = query.text.trim();
      return (q.isEmpty || x['title']!.contains(q)) && (type=='الكل'||x['type']==type) && (category=='الكل'||x['category']==category) && (governorate=='الكل'||x['gov']==governorate);
    }).toList();
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: const Text('دوّر على شي'), backgroundColor: WenhaApp.beige, foregroundColor: WenhaApp.green),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        TextField(controller:query,onChanged:(_)=>setState((){}),decoration:InputDecoration(hintText:'اكتب اسم الغرض...',prefixIcon:const Icon(Icons.search),filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none))),
        const SizedBox(height:14),
        Wrap(spacing:8,children:['الكل','ضايع','لقيته'].map((v)=>ChoiceChip(label:Text(v),selected:type==v,onSelected:(_)=>setState(()=>type=v))).toList()),
        const SizedBox(height:12),
        DropdownButtonFormField<String>(value:category,decoration:_dec('التصنيف'),items:const ['الكل','موبايل','محفظة','مفاتيح','وثائق','حقيبة','إلكترونيات','أخرى'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>category=v??category)),
        const SizedBox(height:10),
        DropdownButtonFormField<String>(value:governorate,decoration:_dec('المحافظة'),items:const ['الكل','دمشق','ريف دمشق','حلب','حمص','حماة','اللاذقية','طرطوس','إدلب','درعا','السويداء','دير الزور','الرقة','الحسكة'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>governorate=v??governorate)),
        const SizedBox(height:20),
        Text('النتائج: ' + results.length.toString(),style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800,color:WenhaApp.green)),
        const SizedBox(height:8),
        ...results.map((x)=>Card(elevation:0,margin:const EdgeInsets.only(bottom:10),child:ListTile(
          leading:CircleAvatar(backgroundColor:WenhaApp.beige,child:Icon(Icons.inventory_2_outlined,color:WenhaApp.green)),
          title:Text(x['title']!,style:const TextStyle(fontWeight:FontWeight.w800)),
          subtitle:Text(x['type']!+' • '+x['category']!+'\n'+x['gov']!+' - '+x['place']!+' • '+x['date']!),isThreeLine:true,onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ReportDetailsScreen(item:x))),
          trailing:const Icon(Icons.chevron_left),
        ))),
      ]),
    ));
  }
  InputDecoration _dec(String label)=>InputDecoration(labelText:label,filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none));
}

class ReportDetailsScreen extends StatelessWidget {
  final Map<String,String> item;
  const ReportDetailsScreen({super.key,required this.item});
  @override Widget build(BuildContext context){
    return Directionality(textDirection:TextDirection.rtl,child:Scaffold(
      appBar:AppBar(title:const Text('تفاصيل البلاغ'),backgroundColor:WenhaApp.beige,foregroundColor:WenhaApp.green),
      body:ListView(padding:const EdgeInsets.all(18),children:[
        Container(height:210,decoration:BoxDecoration(color:WenhaApp.beige,borderRadius:BorderRadius.circular(20)),child:Icon(Icons.inventory_2_outlined,size:90,color:WenhaApp.green)),
        const SizedBox(height:18),
        Text(item['title']!,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w800,color:WenhaApp.green)),
        const SizedBox(height:14),
        _info('نوع البلاغ',item['type']!),
        _info('التصنيف',item['category']!),
        _info('المحافظة',item['gov']!),
        _info('المنطقة',item['place']!),
        _info('التاريخ',item['date']!),
        const SizedBox(height:18),
        Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:const Text('معلومات التحقق الخاصة لا تظهر هنا. يتم استخدامها فقط للتأكد من ملكية الغرض عند المطابقة.',style:TextStyle(height:1.6))),
        const SizedBox(height:22),
        SizedBox(height:52,child:ElevatedButton.icon(
          onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChatScreen())),
          icon:const Icon(Icons.chat_bubble_outline),label:const Text('تواصل مع صاحب البلاغ'),
        )),
      ]),
    ));
  }
  Widget _info(String a,String b)=>Padding(padding:const EdgeInsets.only(bottom:10),child:Row(children:[SizedBox(width:90,child:Text(a,style:const TextStyle(fontWeight:FontWeight.w700))),Expanded(child:Text(b))]));
}


class HandoverScreen extends StatelessWidget {
  const HandoverScreen({super.key});
  @override Widget build(BuildContext context){
    return Directionality(
      textDirection:TextDirection.rtl,
      child:Scaffold(
        appBar:AppBar(title:const Text('تأكيد التسليم'),backgroundColor:WenhaApp.beige,foregroundColor:WenhaApp.green),
        body:Padding(
          padding:const EdgeInsets.all(22),
          child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
            const Icon(Icons.handshake_outlined,size:80,color:WenhaApp.green),
            const SizedBox(height:18),
            const Text('تم الاتفاق على التسليم باليد؟',textAlign:TextAlign.center,style:TextStyle(fontSize:23,fontWeight:FontWeight.w800,color:WenhaApp.green)),
            const SizedBox(height:12),
            const Text('بعد استلام الغرض، يمكن للطرفين تأكيد إتمام التسليم.'),
            const Spacer(),
            SizedBox(height:52,child:ElevatedButton(
              onPressed:()=>showDialog(context:context,builder:(_)=>AlertDialog(
                title:const Text('تم التسليم'),
                content:const Text('تم تسجيل تأكيد التسليم بنجاح.'),
                actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('تمام'))],
              )),
              child:const Text('تأكيد استلام الغرض'),
            )),
          ]),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState()=>_ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen>{
  final controller=TextEditingController();
  final messages=<String>['مرحبا، شفت البلاغ وحابب أتأكد من الغرض.'];
  @override void dispose(){controller.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    return Directionality(
      textDirection:TextDirection.rtl,
      child:Scaffold(
        appBar:AppBar(title:const Text('المحادثة'),backgroundColor:WenhaApp.beige,foregroundColor:WenhaApp.green),
        body:Column(children:[
          Expanded(
            child:ListView.builder(
              padding:const EdgeInsets.all(16),
              itemCount:messages.length,
              itemBuilder:(context,i)=>Align(
                alignment:Alignment.centerRight,
                child:Container(
                  margin:const EdgeInsets.only(bottom:10),
                  padding:const EdgeInsets.all(12),
                  decoration:BoxDecoration(color:WenhaApp.beige,borderRadius:BorderRadius.circular(14)),
                  child:Text(messages[i]),
                ),
              ),
            ),
          ),
          SafeArea(
            child:Padding(
              padding:const EdgeInsets.fromLTRB(12,6,12,12),
              child:Row(children:[
                Expanded(child:TextField(
                  controller:controller,
                  decoration:InputDecoration(
                    hintText:'اكتب رسالة...',
                    filled:true,
                    fillColor:Colors.white,
                    border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none),
                  ),
                )),
                const SizedBox(width:8),
                IconButton(
                  onPressed:(){
                    if(controller.text.trim().isEmpty)return;
                    setState((){
                      messages.add(controller.text.trim());
                      controller.clear();
                    });
                  },
                  icon:const Icon(Icons.send),
                  color:WenhaApp.green,
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
