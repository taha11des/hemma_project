import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const HammaApp());
}

class HammaApp extends StatelessWidget {
  const HammaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'همة',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Cairo',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network('https://thumbs.dreamstime.com/b/sign-language-symbol-illustration-sign-language-symbol-illustration-witha-white-background-129675344.jpg',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'همة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الدروس'),
            Tab(text: 'المهارات الرئيسية'),
            Tab(text: 'تحويل الصوت'),
            Tab(text: "الرئيسية"),
          ],
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 100, 2, 95),
        elevation: 0,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LessonsTab(),
          SkillsTab(),
          AudioConversionTab(),
        ],
      ),
    );
  }
}

class LessonsTab extends StatelessWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return LessonCard(lesson: lessons[index]);
        },
      ),
    );
  }
}

class Lesson {
  final String title;
  final Duration duration;
  final String difficulty;
  final String description;
  final String videoUrl;

  Lesson({
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.videoUrl,
  });
}

final List<Lesson> lessons = [
  Lesson(
    title: 'مقدمة في لغة الإشارة',
    duration: const Duration(minutes: 30),
    difficulty: 'مبتدئ',
    description: 'تعلم أساسيات لغة الإشارة',
    videoUrl: 'assets/videos/intro_sign_language.mp4',
  ),
  Lesson(
    title: 'الحروف والأرقام',
    duration: const Duration(minutes: 45),
    difficulty: 'مبتدئ',
    description: 'تدريب على الحروف والأرقام',
    videoUrl: 'assets/videos/letters_numbers.mp4',
  ),
  Lesson(
    title: 'محادثات يومية',
    duration: const Duration(hours: 1, minutes: 30),
    difficulty: 'متوسط',
    description: 'مواقف وحوارات يومية',
    videoUrl: 'assets/videos/daily_conversations.mp4',
  ),
];

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'مبتدئ':
        return Colors.green;
      case 'متوسط':
        return Colors.orange;
      case 'متقدم':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailScreen(lesson: lesson),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 4),
                  Text('${lesson.duration.inMinutes} دقيقة'),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getDifficultyColor(lesson.difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lesson.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                lesson.description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_outline,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 4),
                Text('${lesson.duration.inMinutes} دقيقة'),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(lesson.difficulty),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lesson.difficulty,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              lesson.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Start lesson implementation
              },
              child: const Text('ابدأ الدرس'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'مبتدئ':
        return Colors.green;
      case 'متوسط':
        return Colors.orange;
      case 'متقدم':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لماذا منصتنا؟',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSection([
            'أدوات شاملة تجمع بين التعليم والتكنولوجيا لخدمة الصم والسمع.',
            'الدورات التفاعلية: دروس فيديو منظمة حسب المستويات (مبتدئ، متوسط، متقدم) مع تمارين تفاعلية.',
            'تحويل الكلام إلى نص: خدمة فورية تحول الكلام المباشر أو التسجيلات الصوتية إلى نص واضح وقابل للبحث والمشاركة.',
            'المهارات التقنية: تعلم مهارات عملية مثل البرمجة والتصميم والعمل الحر لتوسيع فرصك المهنية.',
            'تتبع التقدم: نظام ذكي لحفظ تقدمك وتتبع إنجازاتك، مع شهادات رقمية عند الإنجاز.',
        ]),
          const SizedBox(height: 30),
          const Text(
            'من نخدم؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSection([
            'الصم وضعاف السمع: تحويل المحاضرات والمحادثات إلى نص مكتوب للوصول السهل للمعلومات.',
            'الطلاب الجامعيون: نسخ المحاضرات الصوتية وتسهيل الدراسة بنصوص قابلة للبحث.',
            'العائلة والأصدقاء: تعلم لغة الإشارة للتواصل بشكل أفضل وأسهل مع الأحباء.',
            'المعلمون والمدربون: أدوات فعالة لتدريس لغة الإشارة وتقديم محتوى متاح.',
            'المؤسسات التعليمية: حلول شاملة لدعم الطلاب الصم وتوفير بيئة تعليمية عادلة.',
            'المترجمون: أدوات مساعدة لتسهيل عمل الترجمة، توفيراً للوقت والجهد.',
        ]),
        ],
      ),
    );
  }

  Widget _buildSection(List<String> texts) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: texts
              .map((text) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class AudioConversionTab extends StatefulWidget {
  const AudioConversionTab({super.key});

  @override
  State<AudioConversionTab> createState() => _AudioConversionTabState();
}

class _AudioConversionTabState extends State<AudioConversionTab> {
  late SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denied
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        // ignore: avoid_print
        onStatus: (val) => print('onStatus: $val'),
        // ignore: avoid_print
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: Theme.of(context).primaryColor,
                    endRadius: 75.0,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      onPressed: _listen,
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isListening ? 'جاري الاستماع...' : 'اضغط على الميكروفون للبدء',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _text.isEmpty ? 'ابدأ التحدث...' : _text,
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (_confidence > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'الثقة: ${(_confidence * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement text to sign language conversion
                  },
                  icon: const Icon(Icons.sign_language),
                  label: const Text('تحويل إلى لغة الإشارة'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement save functionality
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ النص'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
