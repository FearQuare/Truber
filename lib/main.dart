import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truber/screens/profile_page.dart';
import 'package:truber/widgets/navigation_bar.dart';
import 'package:truber/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'job_posting_provider.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Truber Jobs',
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isJobPoster;
  const MyHomePage({super.key, required this.title, this.isJobPoster = false});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<JobPosting> jobPostings = [];

  Future<void> fetchJobPostings() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('jobs').get();

    final List<JobPosting> postings = [];
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final jobPosting = JobPosting(
        job_name: data['job_name'],
        job_description: data['job_description'],
        job_poster: data['job_poster'],
        applicants: data['applicants'],
      );
      postings.add(jobPosting);
    }
    setState(() {
      jobPostings = postings;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchJobPostings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount:jobPostings.length,
        itemBuilder: (context, index){
          final job = jobPostings[index];
          return Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(job.job_name),
                  subtitle: Text(job.job_description),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Posted by: ${job.job_poster}'),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          // later we'll implement here
                        },
                        child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: TruberNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
