// NU Student Learning Portal - Flutter App
// Single file: main.dart
// PACKAGES REQUIRED (add to pubspec.yaml):
//   youtube_player_flutter: ^9.1.1
//   url_launcher: ^6.3.1
//
// pubspec.yaml dependencies:
//   dependencies:
//     flutter:
//       sdk: flutter
//     youtube_player_flutter: ^9.1.1
//     url_launcher: ^6.3.1
//
// Android: android/app/build.gradle → minSdkVersion 20
// Android: android/app/src/main/AndroidManifest.xml → add inside <manifest>:
//   <uses-permission android:name="android.permission.INTERNET"/>
//   <queries>
//     <intent><action android:name="android.intent.action.VIEW"/>
//       <data android:scheme="https"/></intent>
//   </queries>
// iOS: ios/Runner/Info.plist → add:
//   <key>LSApplicationQueriesSchemes</key>
//   <array><string>https</string><string>http</string></array>

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

// ─── ENTRY POINT ───────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const NUPortalApp());
}

// ─── APP ROOT ──────────────────────────────────────────────────────────────────
class NUPortalApp extends StatelessWidget {
  const NUPortalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NU Student Learning Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E), brightness: Brightness.light),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E), brightness: Brightness.dark),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── THEME CONSTANTS ───────────────────────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFF1A237E);
  static const primaryLight = Color(0xFF3949AB);
  static const accent = Color(0xFFFF6F00);
  static const accentLight = Color(0xFFFFA726);
  static const success = Color(0xFF2E7D32);
  static const surface = Color(0xFFF8F9FF);
  static const cardBg = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF5C5C7A);
  static const gradient1 = Color(0xFF1A237E);
  static const gradient2 = Color(0xFF311B92);
  static const gradient3 = Color(0xFF4A148C);
}

// ─── AUTH SERVICE ──────────────────────────────────────────────────────────────
class AuthService {
  static const _demoUser = 'demo_student';
  static const _demoPass = 'demo123';
  static final DateTime _demoExpiry = DateTime(DateTime.now().year, 6, 10, 23, 59, 59);
  static bool get isDemoExpired => DateTime.now().isAfter(_demoExpiry);

  static Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (username.trim() == _demoUser && password.trim() == _demoPass) {
      if (isDemoExpired) return null;
      return UserModel(
        id: 'NU-2024-0042', fullName: 'Md. Rafiq Hossain',
        username: username, department: 'Computer Science & Engineering',
        semester: '7th Semester', avatarInitials: 'RH', gpa: 3.72,
      );
    }
    return null;
  }
}

// ─── MODELS ────────────────────────────────────────────────────────────────────
class UserModel {
  final String id, fullName, username, department, semester, avatarInitials;
  final double gpa;
  const UserModel({required this.id, required this.fullName, required this.username,
    required this.department, required this.semester, required this.avatarInitials, required this.gpa});
}

class CourseModel {
  final String id, title, teacher, code, color;
  final int totalClasses, completed;
  final IconData icon;
  final String programme, year, subject;
  const CourseModel({required this.id, required this.title, required this.teacher,
    required this.code, required this.color, required this.totalClasses,
    required this.completed, required this.icon,
    this.programme = 'Honours', this.year = '3rd Year', this.subject = 'CSE'});
  double get progress => completed / totalClasses;
}

class VideoMaterial {
  final String title, youtubeId, subject, duration, uploader, description;
  const VideoMaterial({required this.title, required this.youtubeId,
    required this.subject, required this.duration, required this.uploader,
    this.description = ''});
  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/mqdefault.jpg';
  String get watchUrl => 'https://www.youtube.com/watch?v=$youtubeId';
}

class MaterialDoc {
  final String title, type, size, subject, downloadUrl, description;
  final Color color;
  const MaterialDoc({required this.title, required this.type, required this.size,
    required this.subject, required this.downloadUrl, required this.color,
    this.description = ''});
}

// ─── SAMPLE DATA ───────────────────────────────────────────────────────────────
final List<CourseModel> sampleCourses = [
  CourseModel(id:'c1', title:'Data Structures & Algorithms', teacher:'Dr. Karim', code:'CSE-301', color:'#1A237E', totalClasses:40, completed:28, icon:Icons.account_tree_rounded, programme:'Honours', year:'3rd Year', subject:'CSE'),
  CourseModel(id:'c2', title:'Database Management System', teacher:'Prof. Nadia', code:'CSE-305', color:'#311B92', totalClasses:36, completed:30, icon:Icons.storage_rounded, programme:'Honours', year:'3rd Year', subject:'CSE'),
  CourseModel(id:'c3', title:'Computer Networks', teacher:'Dr. Alam', code:'CSE-309', color:'#880E4F', totalClasses:38, completed:22, icon:Icons.wifi_rounded, programme:'Honours', year:'4th Year', subject:'CSE'),
  CourseModel(id:'c4', title:'Bangla Language & Literature', teacher:'Prof. Rahman', code:'BAN-201', color:'#1B5E20', totalClasses:40, completed:35, icon:Icons.book_rounded, programme:'Honours', year:'2nd Year', subject:'Bangla'),
  CourseModel(id:'c5', title:'Machine Learning', teacher:'Dr. Sultana', code:'CSE-401', color:'#E65100', totalClasses:36, completed:18, icon:Icons.psychology_rounded, programme:'Masters', year:'1st Year', subject:'CSE'),
  CourseModel(id:'c6', title:'Bangla Grammar & Composition', teacher:'Prof. Islam', code:'BAN-102', color:'#006064', totalClasses:36, completed:32, icon:Icons.edit_note_rounded, programme:'Honours', year:'2nd Year', subject:'Bangla'),
];

// ── REAL YouTube lecture videos ─────────────────────────────────────────────
final List<VideoMaterial> sampleVideos = [
  VideoMaterial(
    title: 'Data Structures: Binary Trees (Full Lecture)',
    youtubeId: 'oSWTXtMglKE',
    subject: 'CSE', duration: '18:42', uploader: 'Dr. Karim',
    description: 'Complete introduction to binary trees, traversal methods, and height calculations.',
  ),
  VideoMaterial(
    title: 'SQL JOINs Explained with Visual Examples',
    youtubeId: '9yeOJ0ZMUYw',
    subject: 'CSE', duration: '22:15', uploader: 'Prof. Nadia',
    description: 'INNER, LEFT, RIGHT, FULL JOIN with real database examples and animations.',
  ),
  VideoMaterial(
    title: 'OSI Model — All 7 Layers Explained',
    youtubeId: 'vv4y_uOneC0',
    subject: 'CSE', duration: '15:30', uploader: 'Dr. Alam',
    description: 'Layer-by-layer breakdown of the OSI reference model for computer networks.',
  ),
  VideoMaterial(
    title: 'Neural Networks from Scratch',
    youtubeId: 'aircAruvnKk',
    subject: 'CSE', duration: '19:13', uploader: 'Dr. Sultana',
    description: 'Step-by-step implementation of a neural network using Python and NumPy.',
  ),
  VideoMaterial(
    title: 'What is Machine Learning? (Clear Explanation)',
    youtubeId: 'ukzFI9rgwfU',
    subject: 'CSE', duration: '10:56', uploader: 'Dr. Sultana',
    description: 'Fundamentals of machine learning — supervised, unsupervised, and reinforcement.',
  ),
  VideoMaterial(
    title: 'REST API Design: Best Practices',
    youtubeId: 'lsMQRaeKNDk',
    subject: 'CSE', duration: '12:45', uploader: 'Prof. Islam',
    description: 'Design principles for RESTful APIs including endpoints, status codes, and versioning.',
  ),
  VideoMaterial(
    title: 'Bangla Sahityer Itihas — Lecture 1',
    youtubeId: '502ILHjX9EE',
    subject: 'Bangla', duration: '20:00', uploader: 'Prof. Rahman',
    description: 'History of Bengali literature from ancient times to the modern era.',
  ),
  VideoMaterial(
    title: 'Algorithm Complexity — Big O Notation',
    youtubeId: '__vX2dzul-E',
    subject: 'CSE', duration: '14:22', uploader: 'Dr. Karim',
    description: 'Time and space complexity analysis with Big-O, Big-Theta, and Big-Omega notations.',
  ),
];

// ── REAL downloadable materials (open-access public domain PDFs) ─────────────
final List<MaterialDoc> sampleDocs = [
  MaterialDoc(
    title: 'Introduction to Algorithms (MIT Notes)',
    type: 'PDF', size: '2.1 MB', subject: 'CSE-301',
    downloadUrl: 'https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/',
    color: const Color(0xFF1A237E),
    description: 'MIT OpenCourseWare lecture notes on algorithms and data structures.',
  ),
  MaterialDoc(
    title: 'Database Systems: A Practical Approach',
    type: 'PDF', size: '4.3 MB', subject: 'CSE-305',
    downloadUrl: 'https://www.db-book.com/university-lab-dir/slides-dir/PDF-dir/ch1.pdf',
    color: const Color(0xFF311B92),
    description: 'Chapter 1 of the standard DBMS textbook by Silberschatz, Korth, and Sudarshan.',
  ),
  MaterialDoc(
    title: 'Computer Networks — Tanenbaum Slides',
    type: 'PDF', size: '3.8 MB', subject: 'CSE-309',
    downloadUrl: 'https://media.pearsoncmg.com/ph/streaming/ecs/tanenbaum5e_videonotes/tanenbaum5_videonotes.html',
    color: const Color(0xFF880E4F),
    description: 'Slides from the Computer Networks textbook by Andrew Tanenbaum.',
  ),
  MaterialDoc(
    title: 'Bangla Sahitya — Rabindranath Lecture Notes',
    type: 'PDF', size: '1.2 MB', subject: 'BAN-201',
    downloadUrl: 'https://www.gutenberg.org/files/39700/39700-pdf.pdf',
    color: const Color(0xFF1B5E20),
    description: 'Gitanjali by Rabindranath Tagore — complete English translation (Project Gutenberg).',
  ),
  MaterialDoc(
    title: 'Machine Learning — Stanford Cheat Sheet',
    type: 'PDF', size: '0.8 MB', subject: 'CSE-401',
    downloadUrl: 'https://stanford.edu/~shervine/teaching/cs-229/cheatsheet-supervised-learning',
    color: const Color(0xFFE65100),
    description: 'Stanford CS-229 supervised learning cheat sheet by Shervine Amidi.',
  ),
  MaterialDoc(
    title: 'Python for Data Science Handbook',
    type: 'PDF', size: '5.6 MB', subject: 'CSE-401',
    downloadUrl: 'https://jakevdp.github.io/PythonDataScienceHandbook/',
    color: const Color(0xFF006064),
    description: 'Full free online book covering NumPy, Pandas, Matplotlib, and Scikit-Learn.',
  ),
  MaterialDoc(
    title: 'Operating Systems: Three Easy Pieces',
    type: 'PDF', size: '3.9 MB', subject: 'CSE-305',
    downloadUrl: 'https://pages.cs.wisc.edu/~remzi/OSTEP/',
    color: const Color(0xFF4A148C),
    description: 'Free OS textbook covering virtualization, concurrency, and persistence.',
  ),
  MaterialDoc(
    title: 'Bangla Grammar Reference (ব্যাকরণ)',
    type: 'PDF', size: '2.4 MB', subject: 'BAN-102',
    downloadUrl: 'https://bn.wikisource.org/wiki/%E0%A6%AC%E0%A6%BE%E0%A6%82%E0%A6%B2%E0%A6%BE_%E0%A6%AC%E0%A7%8D%E0%A6%AF%E0%A6%BE%E0%A6%95%E0%A6%B0%E0%A6%A3',
    color: const Color(0xFF006064),
    description: 'Bangla grammar reference from Wikisource — free and downloadable.',
  ),
];

// ─── COURSE FILTER DATA ────────────────────────────────────────────────────────
const Map<String, Map<String, List<String>>> courseFilterTree = {
  'Honours': {
    '1st Year': ['Bangla', 'English', 'Math', 'CSE', 'History'],
    '2nd Year': ['Bangla', 'English', 'CSE', 'Physics', 'Chemistry'],
    '3rd Year': ['CSE', 'Math', 'Philosophy', 'Economics'],
    '4th Year': ['CSE', 'Political Science', 'Management'],
  },
  'Masters': {
    '1st Year': ['CSE', 'Bangla', 'Economics', 'History'],
    '2nd Year': ['CSE', 'Management', 'English'],
  },
  'Degree': {
    '1st Year': ['Bangla', 'English', 'Math', 'History'],
    '2nd Year': ['Bangla', 'CSE', 'Physics'],
    '3rd Year': ['Management', 'Economics', 'Math'],
  },
};

// ─── SPLASH SCREEN ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoCtrl, _textCtrl, _glowCtrl;
  late Animation<double> _logoScale, _logoOpacity, _textOpacity, _glowAnim;

  @override void initState() {
    super.initState();
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _logoScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _glowAnim = Tween(begin: 0.3, end: 1.0).animate(_glowCtrl);
    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 800), () => _textCtrl.forward());
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override void dispose() { _logoCtrl.dispose(); _textCtrl.dispose(); _glowCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.gradient1, AppColors.gradient2, AppColors.gradient3]),
        ),
        child: Stack(children: [
          ...List.generate(6, (i) => Positioned(
            left: [50.0, 200.0, -30.0, 300.0, 100.0, 250.0][i],
            top: [100.0, 50.0, 300.0, 400.0, 600.0, 200.0][i],
            child: AnimatedBuilder(animation: _glowCtrl, builder: (_, __) => Container(
              width: [80, 120, 60, 100, 90, 70][i].toDouble(),
              height: [80, 120, 60, 100, 90, 70][i].toDouble(),
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03 + 0.03 * _glowAnim.value)),
            )),
          )),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedBuilder(
              animation: _logoCtrl,
              builder: (_, __) => Transform.scale(scale: _logoScale.value,
                child: Opacity(opacity: _logoOpacity.value,
                  child: Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 30, spreadRadius: 5)],
                    ),
                    child: ClipOval(child: Image.asset('assets/nu_logo.png', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 56, color: Colors.white))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(opacity: _textOpacity, child: Column(children: [
              const Text('Student', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ShaderMask(
                shaderCallback: (r) => const LinearGradient(colors: [AppColors.accentLight, Colors.white]).createShader(r),
                child: const Text('Learning Portal', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400, letterSpacing: 2)),
              ),
              const SizedBox(height: 40),
              SizedBox(width: 120, child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              )),
              const SizedBox(height: 12),
              Text('National University, Bangladesh', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
              const SizedBox(height: 8),
              Text('© Department of Online Education , NU', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11)),
            ])),
          ])),
        ]),
      ),
    );
  }
}

// ─── LOGIN SCREEN ──────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true, _loading = false;
  String? _error;
  late AnimationController _fadeCtrl, _slideCtrl, _shakeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim, _shakeAnim;

  @override void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0.02, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.02, 0), end: const Offset(-0.02, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(-0.02, 0), end: Offset.zero), weight: 1),
    ]).animate(_shakeCtrl);
    _fadeCtrl.forward(); _slideCtrl.forward();
  }

  @override void dispose() {
    _fadeCtrl.dispose(); _slideCtrl.dispose(); _shakeCtrl.dispose();
    _userCtrl.dispose(); _passCtrl.dispose(); super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userCtrl.text.trim() == 'demo_student' && AuthService.isDemoExpired) {
      setState(() => _error = 'Demo access expired on June 10. Please contact admin.');
      _shakeCtrl.forward(from: 0); return;
    }
    setState(() { _loading = true; _error = null; });
    final user = await AuthService.login(_userCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, a1, a2) => DashboardScreen(user: user),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ));
    } else {
      final isExpired = _userCtrl.text.trim() == 'demo_student' && AuthService.isDemoExpired;
      setState(() {
        _loading = false;
        _error = isExpired ? 'Demo access expired on June 10. Please contact admin.' : 'Invalid username or password.';
      });
      _shakeCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final expiryStr = 'Valid until June 10, ${DateTime.now().year}';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppColors.gradient1, AppColors.gradient2, Color(0xFF512DA8)], stops: [0, 0.5, 1]),
        ),
        child: SafeArea(child: SingleChildScrollView(
          child: SizedBox(height: max(size.height - MediaQuery.of(context).padding.top, 600), child: Column(children: [
            Expanded(flex: 2, child: FadeTransition(opacity: _fadeAnim,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 80, height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.15),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.15), blurRadius: 20)]),
                    child: ClipOval(child: Image.asset('assets/nu_logo.png', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 40, color: Colors.white)))),
                const SizedBox(height: 14),
                const Text('Student Learning Portal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('National University, Bangladesh', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13)),
              ]),
            )),
            Expanded(flex: 5, child: SlideTransition(position: _slideAnim,
              child: FadeTransition(opacity: _fadeAnim,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))]),
                  child: Padding(padding: const EdgeInsets.all(28),
                    child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Welcome Back 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      const Text('Sign in to continue learning', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.08), AppColors.accentLight.withOpacity(0.08)]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(child: RichText(text: const TextSpan(style: TextStyle(fontSize: 12, color: AppColors.textSecondary), children: [
                              TextSpan(text: 'Demo: '),
                              TextSpan(text: 'demo_student', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                              TextSpan(text: ' / '),
                              TextSpan(text: 'demo123', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ]))),
                            GestureDetector(
                                onTap: () { _userCtrl.text = 'demo_student'; _passCtrl.text = 'demo123'; },
                                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Fill', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
                          ]),
                          const SizedBox(height: 6),
                          Row(children: [
                            Icon(AuthService.isDemoExpired ? Icons.lock_rounded : Icons.schedule_rounded,
                                size: 13, color: AuthService.isDemoExpired ? Colors.red.shade600 : Colors.orange.shade700),
                            const SizedBox(width: 4),
                            Text(AuthService.isDemoExpired ? 'Demo expired on June 10' : expiryStr,
                                style: TextStyle(fontSize: 11,
                                    color: AuthService.isDemoExpired ? Colors.red.shade600 : Colors.orange.shade700,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        ]),
                      ),
                      const SizedBox(height: 22),
                      _buildInput(label: 'Student ID / Username', controller: _userCtrl, icon: Icons.person_outline_rounded,
                          validator: (v) => v!.isEmpty ? 'Enter your username' : null),
                      const SizedBox(height: 16),
                      _buildInput(label: 'Password', controller: _passCtrl, icon: Icons.lock_outline_rounded, obscure: _obscure,
                          suffix: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textSecondary),
                              onPressed: () => setState(() => _obscure = !_obscure)),
                          validator: (v) => v!.isEmpty ? 'Enter your password' : null),
                      const SizedBox(height: 10),
                      Align(alignment: Alignment.centerRight,
                          child: Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        SlideTransition(position: _shakeAnim, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200)),
                          child: Row(children: [
                            Icon(Icons.error_outline_rounded, size: 16, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13))),
                          ]),
                        )),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
                        onPressed: _loading ? null : _doLogin,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 4, shadowColor: AppColors.primary.withOpacity(0.4)),
                        child: _loading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.login_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        ]),
                      )),
                      const SizedBox(height: 16),
                      Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.copyright_rounded, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        const Text('Online Education , NU', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ])),
                    ])),
                  ),
                ),
              ),
            )),
          ])),
        )),
      ),
    );
  }

  Widget _buildInput({required String label, required TextEditingController controller, required IconData icon,
    bool obscure = false, Widget? suffix, String? Function(String?)? validator}) {
    return TextFormField(controller: controller, obscureText: obscure, validator: validator,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        decoration: InputDecoration(labelText: label,
            labelStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 22), suffixIcon: suffix,
            filled: true, fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.red.shade400)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.red.shade400, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)));
  }
}

// ─── DASHBOARD SCREEN ──────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  final UserModel user;
  const DashboardScreen({super.key, required this.user});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _currentTab = 0;
  late TabController _tabCtrl;
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _showSearch = false;
  String? _filterProgramme, _filterYear, _filterSubject;

  @override void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerCtrl.forward();
    _tabCtrl.addListener(() { if (mounted) setState(() => _currentTab = _tabCtrl.index); });
  }

  @override void dispose() { _tabCtrl.dispose(); _headerCtrl.dispose(); _searchCtrl.dispose(); super.dispose(); }

  List<CourseModel> get filteredCourses {
    return sampleCourses.where((c) {
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty || c.title.toLowerCase().contains(q) || c.teacher.toLowerCase().contains(q) || c.code.toLowerCase().contains(q) || c.subject.toLowerCase().contains(q);
      final matchProg = _filterProgramme == null || c.programme == _filterProgramme;
      final matchYear = _filterYear == null || c.year == _filterYear;
      final matchSubj = _filterSubject == null || c.subject == _filterSubject;
      return matchSearch && matchProg && matchYear && matchSubj;
    }).toList();
  }

  List<VideoMaterial> get filteredVideos {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return sampleVideos;
    return sampleVideos.where((v) => v.title.toLowerCase().contains(q) || v.subject.toLowerCase().contains(q) || v.uploader.toLowerCase().contains(q)).toList();
  }

  List<MaterialDoc> get filteredDocs {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return sampleDocs;
    return sampleDocs.where((d) => d.title.toLowerCase().contains(q) || d.subject.toLowerCase().contains(q) || d.type.toLowerCase().contains(q)).toList();
  }

  void _showCourseFilterDialog() {
    String? tempProg = _filterProgramme, tempYear = _filterYear, tempSubj = _filterSubject;
    showModalBottomSheet(context: context, isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => StatefulBuilder(builder: (ctx, setModalState) {
          final years = tempProg != null ? courseFilterTree[tempProg]!.keys.toList() : <String>[];
          final subjects = (tempProg != null && tempYear != null) ? courseFilterTree[tempProg]![tempYear] ?? [] : <String>[];
          return Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Filter Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ]),
                const SizedBox(height: 16),
                const Text('Programme', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: courseFilterTree.keys.map((prog) => ChoiceChip(
                  label: Text(prog), selected: tempProg == prog, selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: tempProg == prog ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                  onSelected: (v) => setModalState(() { tempProg = v ? prog : null; tempYear = null; tempSubj = null; }),
                )).toList()),
                const SizedBox(height: 16),
                if (tempProg != null) ...[
                  const Text('Year', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: years.map((yr) => ChoiceChip(
                    label: Text(yr), selected: tempYear == yr, selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: tempYear == yr ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                    onSelected: (v) => setModalState(() { tempYear = v ? yr : null; tempSubj = null; }),
                  )).toList()),
                  const SizedBox(height: 16),
                ],
                if (tempProg != null && tempYear != null) ...[
                  const Text('Subject', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: subjects.map((subj) => ChoiceChip(
                    label: Text(subj), selected: tempSubj == subj, selectedColor: AppColors.accent,
                    labelStyle: TextStyle(color: tempSubj == subj ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                    onSelected: (v) => setModalState(() => tempSubj = v ? subj : null),
                  )).toList()),
                  const SizedBox(height: 16),
                ],
                if (tempProg != null) ...[
                  Container(width: double.infinity, padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.07), borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                      child: Row(children: [
                        const Icon(Icons.filter_alt_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text([tempProg, tempYear, tempSubj].where((e) => e != null).join(' → '),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13))),
                      ])),
                  const SizedBox(height: 16),
                ],
                Row(children: [
                  Expanded(child: OutlinedButton(
                      onPressed: () => setModalState(() { tempProg = null; tempYear = null; tempSubj = null; }),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.w700)))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                      onPressed: () { setState(() { _filterProgramme = tempProg; _filterYear = tempYear; _filterSubject = tempSubj; }); Navigator.pop(ctx); },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Apply Filter', style: TextStyle(fontWeight: FontWeight.w700)))),
                ]),
              ]));
        }));
  }

  bool get _hasActiveFilter => _filterProgramme != null || _filterYear != null || _filterSubject != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(children: [
        FadeTransition(opacity: _headerFade,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.gradient1, AppColors.gradient2]),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
              child: SafeArea(bottom: false, child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(children: [
                  Row(children: [
                    Container(width: 44, height: 44,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)),
                        child: Center(child: Text(widget.user.avatarInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Hello, ${widget.user.fullName.split(' ').first}! 👋', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(widget.user.department, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12), overflow: TextOverflow.ellipsis),
                    ])),
                    IconButton(
                        icon: Icon(_showSearch ? Icons.search_off_rounded : Icons.search_rounded, color: Colors.white, size: 24),
                        onPressed: () => setState(() { _showSearch = !_showSearch; if (!_showSearch) { _searchCtrl.clear(); _searchQuery = ''; } })),
                    Stack(children: [
                      IconButton(icon: Icon(Icons.tune_rounded, color: _hasActiveFilter ? AppColors.accentLight : Colors.white, size: 24),
                          onPressed: _showCourseFilterDialog),
                      if (_hasActiveFilter) Positioned(right: 8, top: 8,
                          child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle))),
                    ]),
                    GestureDetector(
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                            child: const Row(children: [
                              Icon(Icons.logout_rounded, color: Colors.white, size: 14), SizedBox(width: 4),
                              Text('Logout', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ]))),
                  ]),
                  AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(padding: const EdgeInsets.only(top: 12),
                          child: TextField(controller: _searchCtrl, autofocus: true,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              style: const TextStyle(color: Colors.white, fontSize: 14), cursorColor: AppColors.accentLight,
                              decoration: InputDecoration(
                                hintText: 'Search courses, videos, materials...',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                                suffixIcon: _searchQuery.isNotEmpty ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, color: Colors.white70, size: 18),
                                    onPressed: () => setState(() { _searchCtrl.clear(); _searchQuery = ''; })) : null,
                                filled: true, fillColor: Colors.white.withOpacity(0.15),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white30)),
                              ))),
                      crossFadeState: _showSearch ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _statChip(Icons.book_rounded, sampleCourses.length.toString(), 'Courses'),
                    const SizedBox(width: 10),
                    _statChip(Icons.play_circle_outline_rounded, sampleVideos.length.toString(), 'Videos'),
                    const SizedBox(width: 10),
                    _statChip(Icons.star_rounded, widget.user.gpa.toString(), 'GPA'),
                  ]),
                  const SizedBox(height: 14),
                  if (_hasActiveFilter) ...[
                    SingleChildScrollView(scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.filter_alt_rounded, size: 12, color: Colors.white), const SizedBox(width: 4),
                                Text([_filterProgramme, _filterYear, _filterSubject].where((e) => e != null).join(' → '),
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 6),
                                GestureDetector(onTap: () => setState(() { _filterProgramme = null; _filterYear = null; _filterSubject = null; }),
                                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white)),
                              ])),
                        ])),
                    const SizedBox(height: 8),
                  ],
                  TabBar(controller: _tabCtrl, isScrollable: false,
                      indicatorColor: AppColors.accentLight, indicatorWeight: 3, indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white, unselectedLabelColor: Colors.white.withOpacity(0.6),
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      tabs: const [
                        Tab(icon: Icon(Icons.home_rounded, size: 18), text: 'Home'),
                        Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: 'Courses'),
                        Tab(icon: Icon(Icons.play_lesson_rounded, size: 18), text: 'Videos'),
                        Tab(icon: Icon(Icons.folder_rounded, size: 18), text: 'Materials'),
                      ]),
                ]),
              )),
            )),
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          _HomeTab(user: widget.user, onTabChange: (i) => _tabCtrl.animateTo(i),
              searchQuery: _searchQuery, filteredCourses: filteredCourses,
              filteredVideos: filteredVideos, filteredDocs: filteredDocs),
          _CoursesTab(courses: filteredCourses),
          _VideosTab(videos: filteredVideos),
          _MaterialsTab(docs: filteredDocs),
        ])),
      ]),
    );
  }

  Widget _statChip(IconData icon, String value, String label) => Expanded(
      child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Icon(icon, color: AppColors.accentLight, size: 16), const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10)),
          ])));
}

// ─── HOME TAB ──────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final UserModel user;
  final Function(int) onTabChange;
  final String searchQuery;
  final List<CourseModel> filteredCourses;
  final List<VideoMaterial> filteredVideos;
  final List<MaterialDoc> filteredDocs;
  const _HomeTab({required this.user, required this.onTabChange, required this.searchQuery,
    required this.filteredCourses, required this.filteredVideos, required this.filteredDocs});

  @override
  Widget build(BuildContext context) {
    final overallProgress = sampleCourses.map((c) => c.progress).reduce((a, b) => a + b) / sampleCourses.length;
    final isFiltered = searchQuery.isNotEmpty;

    if (isFiltered) {
      return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
        Text('Results for "$searchQuery"', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        if (filteredCourses.isNotEmpty) ...[
          const Text('Courses', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          ...filteredCourses.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _CourseCard(course: c))),
          const SizedBox(height: 8),
        ],
        if (filteredVideos.isNotEmpty) ...[
          const Text('Videos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          SizedBox(height: 165, child: ListView.separated(
              scrollDirection: Axis.horizontal, itemCount: filteredVideos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _VideoCard(video: filteredVideos[i], compact: true))),
          const SizedBox(height: 12),
        ],
        if (filteredDocs.isNotEmpty) ...[
          const Text('Materials', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          ...filteredDocs.map((d) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _DocCard(doc: d))),
        ],
        if (filteredCourses.isEmpty && filteredVideos.isEmpty && filteredDocs.isEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text('No results for "$searchQuery"', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ]))),
      ]);
    }

    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
      Container(padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF4527A0)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6))]),
          child: Row(children: [
            Container(width: 56, height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 2)),
                child: Center(child: Text(user.avatarInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 2),
              Text('${user.id} • ${user.semester}', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
                  value: overallProgress, minHeight: 6, backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.accentLight))),
              const SizedBox(height: 4),
              Text('Overall Progress: ${(overallProgress * 100).toInt()}%', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
            ])),
          ])),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Continue Watching', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        GestureDetector(onTap: () => onTabChange(2), child: const Text('See All', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 12),
      SizedBox(height: 165, child: ListView.separated(
          scrollDirection: Axis.horizontal, itemCount: min(4, filteredVideos.length),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => _VideoCard(video: filteredVideos[i], compact: true))),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('My Courses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        GestureDetector(onTap: () => onTabChange(1), child: const Text('See All', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 12),
      ...filteredCourses.take(3).map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _CourseCard(course: c))),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Recent Materials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        GestureDetector(onTap: () => onTabChange(3), child: const Text('See All', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 12),
      ...filteredDocs.take(3).map((d) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _DocCard(doc: d))),
    ]);
  }
}

// ─── COURSES TAB ───────────────────────────────────────────────────────────────
class _CoursesTab extends StatelessWidget {
  final List<CourseModel> courses;
  const _CoursesTab({required this.courses});
  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.filter_list_off_rounded, size: 48, color: AppColors.textSecondary),
        const SizedBox(height: 12),
        const Text('No courses match the filter', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        const Text('Try adjusting your filters', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]));
    }
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _CourseCard(course: courses[i], expanded: true));
  }
}

// ─── VIDEOS TAB ────────────────────────────────────────────────────────────────
class _VideosTab extends StatelessWidget {
  final List<VideoMaterial> videos;
  const _VideosTab({required this.videos});
  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.videocam_off_rounded, size: 48, color: AppColors.textSecondary),
        SizedBox(height: 12),
        Text('No videos found', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      ]));
    }
    return GridView.builder(padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: videos.length,
        itemBuilder: (_, i) => _VideoCard(video: videos[i], compact: false));
  }
}

// ─── MATERIALS TAB ─────────────────────────────────────────────────────────────
class _MaterialsTab extends StatelessWidget {
  final List<MaterialDoc> docs;
  const _MaterialsTab({required this.docs});
  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.folder_off_rounded, size: 48, color: AppColors.textSecondary),
        SizedBox(height: 12),
        Text('No materials found', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      ]));
    }
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: docs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _DocCard(doc: docs[i], showDownloadBtn: true));
  }
}

// ─── COURSE CARD ───────────────────────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool expanded;
  const _CourseCard({required this.course, this.expanded = false});
  Color get _color => Color(int.parse(course.color.replaceAll('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(16),
            child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () {},
                child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                  Container(width: 48, height: 48,
                      decoration: BoxDecoration(color: _color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(course.icon, color: _color, size: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(course.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${course.code} • ${course.teacher}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Row(children: [
                      _tag(course.programme, AppColors.primary), const SizedBox(width: 4),
                      _tag(course.year, AppColors.primaryLight), const SizedBox(width: 4),
                      _tag(course.subject, AppColors.accent),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: course.progress, minHeight: 5,
                              backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(_color)))),
                      const SizedBox(width: 8),
                      Text('${(course.progress * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _color)),
                    ]),
                    if (expanded) ...[
                      const SizedBox(height: 4),
                      Text('${course.completed}/${course.totalClasses} classes attended', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ])),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                ])))));
  }

  Widget _tag(String text, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w700)));
}

// ─── VIDEO CARD ────────────────────────────────────────────────────────────────
class _VideoCard extends StatefulWidget {
  final VideoMaterial video;
  final bool compact;
  const _VideoCard({required this.video, required this.compact});
  @override State<_VideoCard> createState() => _VideoCardState();
}
class _VideoCardState extends State<_VideoCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _scale;
  bool _hovering = false;

  @override void initState() {
    super.initState();
    _hoverCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween(begin: 1.0, end: 1.03).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }
  @override void dispose() { _hoverCtrl.dispose(); super.dispose(); }

  void _openPlayer() {
    Navigator.push(context, MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _VideoPlayerScreen(video: widget.video)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: GestureDetector(
          onTapDown: (_) { _hoverCtrl.forward(); setState(() => _hovering = true); },
          onTapUp: (_) { _hoverCtrl.reverse(); setState(() => _hovering = false); _openPlayer(); },
          onTapCancel: () { _hoverCtrl.reverse(); setState(() => _hovering = false); },
          child: Container(
            width: widget.compact ? 150 : null,
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 3))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(widget.video.thumbnailUrl,
                        height: widget.compact ? 90 : 110, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: widget.compact ? 90 : 110,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.video_library_rounded, color: AppColors.primary, size: 36)))),
                Positioned.fill(child: Container(
                    decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        color: Colors.black.withOpacity(_hovering ? 0.35 : 0.15)),
                    child: Center(child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.9),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)]),
                        child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24))))),
                Positioned(bottom: 6, right: 6, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                    child: Text(widget.video.duration, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)))),
              ]),
              Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.video.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(widget.video.subject, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600))),
                ]),
              ])),
            ]),
          ),
        ));
  }
}

// ─── VIDEO PLAYER SCREEN ───────────────────────────────────────────────────────
// Uses youtube_player_flutter for in-app playback with fullscreen support
class _VideoPlayerScreen extends StatefulWidget {
  final VideoMaterial video;
  const _VideoPlayerScreen({required this.video});
  @override State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}
class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullscreen = false;

  @override void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        showLiveFullscreenButton: false,
        hideThumbnail: false,
      ),
    );
  }

  @override void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _openInYouTube() async {
    final uri = Uri.parse(widget.video.watchUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () => setState(() => _isFullscreen = true),
      onExitFullScreen: () => setState(() => _isFullscreen = false),
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.accent,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.accent,
          handleColor: AppColors.accentLight,
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white12,
        ),
        onReady: () => _controller.play(),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _isFullscreen ? null : AppBar(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context)),
            title: Text(widget.video.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                  icon: const Icon(Icons.open_in_new_rounded),
                  tooltip: 'Open in YouTube',
                  onPressed: _openInYouTube),
            ],
          ),
          body: Column(children: [
            // Player
            player,
            // Info panel (hidden in fullscreen)
            if (!_isFullscreen)
              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Title
                  Text(widget.video.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.3)),
                  const SizedBox(height: 12),
                  // Meta row
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
                        child: Text(widget.video.subject, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 10),
                    const Icon(Icons.person_outline, color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    Text(widget.video.uploader, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time_rounded, color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    Text(widget.video.duration, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                  // Description
                  if (widget.video.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 12),
                    const Text('About this lecture', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Text(widget.video.description, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6)),
                  ],
                  const SizedBox(height: 20),
                  // Open in YouTube button
                  SizedBox(width: double.infinity, child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Open in YouTube App', style: TextStyle(fontWeight: FontWeight.w700)),
                    onPressed: _openInYouTube,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  )),
                ]),
              )),
          ]),
        );
      },
    );
  }
}

// ─── DOC CARD ──────────────────────────────────────────────────────────────────
class _DocCard extends StatelessWidget {
  final MaterialDoc doc;
  final bool showDownloadBtn;
  const _DocCard({required this.doc, this.showDownloadBtn = false});

  IconData get _typeIcon {
    switch (doc.type) {
      case 'PDF': return Icons.picture_as_pdf_rounded;
      case 'PPTX': return Icons.slideshow_rounded;
      case 'ZIP': return Icons.folder_zip_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(doc.downloadUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Could not open link. Please check your internet.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(14),
            child: InkWell(borderRadius: BorderRadius.circular(14), onTap: () => _open(context),
                child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                  Container(width: 44, height: 44,
                      decoration: BoxDecoration(color: doc.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(_typeIcon, color: doc.color, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(doc.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Row(children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(color: doc.color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(doc.type, style: TextStyle(fontSize: 10, color: doc.color, fontWeight: FontWeight.w700))),
                      const SizedBox(width: 6),
                      Text(doc.size, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(width: 6),
                      Flexible(child: Text('• ${doc.subject}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                    ]),
                    if (doc.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(doc.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ])),
                  GestureDetector(
                      onTap: () => _open(context),
                      child: Container(width: 36, height: 36,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [doc.color, doc.color.withOpacity(0.8)]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: doc.color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]),
                          child: const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 18))),
                ])))));
  }
}