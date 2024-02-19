import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab3_201139/CalendarPage.dart';
import 'NotificationController.dart';
import 'NotificationService.dart';
import 'exam.dart';
import 'ExamPage.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3_201139/Map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "basic_notif",
      channelDescription: "basic notification channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "basic_channel_group", channelGroupName: "basic_group")
  ]);

  bool isAllowedToSendNotification =
  await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.amber,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            textStyle: TextStyle(fontSize: 18.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
    );
  }
}

class MainListScreen extends StatefulWidget {
  const MainListScreen({Key? key});

  @override
  _MainListScreenState createState() => _MainListScreenState();
}

class _MainListScreenState extends State<MainListScreen> {
  final List<Exam> exams = [
    Exam(
      course: 'Data Science',
      timestamp: DateTime.now(),
      description: 'Data science is the study of data to extract meaningful insights for business. It is a multidisciplinary approach that combines principles and practices from the fields of mathematics, statistics, artificial intelligence, and computer engineering to analyze large amounts of data.', // New field
      classroom: 'lab-3',
      professor: 'Dimitar Trajanov'
    ),
    Exam(
      course: 'Mobile Information Systems',
      timestamp: DateTime.now(),
      description: 'Mobile information systems (MIS) can be defined as information systems in which access to information resources and services is gained through end-user terminals that are easily movable in space, operable no matter what the location and typically, provided with wireless connection. ', // New field
      classroom: 'lab-2',
      professor: 'Petre Lameski'
    ),
  ];

  bool _isLocationBasedNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();


    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceiveMethod,
        onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceiveMethod,
        onNotificationCreatedMethod:
          NotificationController.onNotificationCreateMethod,
        onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayed);
    NotificationService().scheduleNotificationsForExistingExams(exams);
  }

  void _scheduleNotificationsForExistingExams() {
    for (int i = 0; i < exams.length; i++) {
      _scheduleNotification(exams[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _openCalendar,
          ),
          IconButton(onPressed: _openMap, icon: const Icon(Icons.map)),
          IconButton(
            icon: const Icon(Icons.alarm_add),
            color: _isLocationBasedNotificationsEnabled
                ? Colors.amberAccent
                : Colors.grey,
            onPressed: _toggleLocationNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => FirebaseAuth.instance.currentUser != null
                ? _addExamFunction(context)
                : _navigateToSignInPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(5),
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 30, color: Colors.white),
                  SizedBox(height: 5), // Added for spacing
                  Text(exam.course, style: TextStyle(fontSize: 14.0, color: Colors.white), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                  Text('Date: ${exam.timestamp.toString().split(' ')[0]}', style: TextStyle(fontSize: 12.0, color: Colors.white), textAlign: TextAlign.center),
                  Text('Time: ${exam.timestamp.toString().split(' ')[1]}', style: TextStyle(fontSize: 12.0, color: Colors.white), textAlign: TextAlign.center),
                  Text('Description: ${exam.description}', style: TextStyle(fontSize: 12.0, color: Colors.white), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 5),
                  Text('Classroom: ${exam.classroom}', style: TextStyle(fontSize: 12.0, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleLocationNotifications() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Based Notifications"),
          content: _isLocationBasedNotificationsEnabled
              ? const Text("You have turned off location-based notifications")
              : const Text("You have turned on location-based notifications"),
          actions: [
            TextButton(
              onPressed: () {
                NotificationService().toggleLocationNotification();
                setState(() {
                  _isLocationBasedNotificationsEnabled =
                  !_isLocationBasedNotificationsEnabled;
                });
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  void _openMap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapWidget()));
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(exams: exams),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> _addExamFunction(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: ExamPage(
              addExam: _addExam,
            ),
          );
        });
  }

  void _addExam(Exam exam) {
    setState(() {
      exams.add(exam);
      _scheduleNotification(exam);
    });
  }

  void _scheduleNotification(Exam exam) {
    final int notificationId = exams.indexOf(exam);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: notificationId,
            channelKey: "basic_channel",
            title: exam.course,
            body: "You have an exam tomorrow!"),
        schedule: NotificationCalendar(
            day: exam.timestamp.subtract(const Duration(days: 1)).day,
            month: exam.timestamp.subtract(const Duration(days: 1)).month,
            year: exam.timestamp.subtract(const Duration(days: 1)).year,
            hour: exam.timestamp.subtract(const Duration(days: 1)).hour,
            minute: exam.timestamp.subtract(const Duration(days: 1)).minute));
  }
}

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({Key? key, required this.isLogin});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog(
            "Login Successful", "You have successfully logged in!");
        _navigateToHome();
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog(
            "Registration Successful", "You have successfully registered!");
        _navigateToLogin();
      }
    } catch (e) {
      _showErrorDialog(
          "Authentication Error", "Error during authentication: $e");
    }
  }

  void _showSuccessDialog(String title, String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _navigateToLogin() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _navigateToRegister() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isLogin ? const Text("Login") : const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authAction,
              child: Text(
                widget.isLogin ? "Sign In" : "Register",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (!widget.isLogin)
              TextButton(
                onPressed: _navigateToLogin,
                child: const Text('Already have an account? Login'),
              ),
            if (widget.isLogin)
              TextButton(
                onPressed: _navigateToRegister,
                child: const Text('Create an account'),
              ),
            TextButton(
              onPressed: _navigateToHome,
              child: const Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
