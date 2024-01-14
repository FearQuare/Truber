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
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('jobs').get();

      final List<JobPosting> postings = querySnapshot.docs.map((doc) {
        try {
          return JobPosting.fromFirestore(doc);
        } catch (e) {
          print('Error creating JobPosting from doc: ${doc.id}, error: $e');
          return null; // Return null if there's an error.
        }
      }).where((job) => job != null).cast<JobPosting>().toList(); // Filter out any nulls.

      setState(() {
        jobPostings = postings;
      });
    } catch (e) {
      print('Error fetching job postings: $e');
      // Handle the error or show a message to the user.
    }
  }


  void _onItemTapped(int index) {
    if (index == 1) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  username: userProvider.username,
                  isEditable: true,
                )),
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
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: jobPostings.length,
        itemBuilder: (context, index) {
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
                        job.applyForJob(userProvider.username).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Applied to ${job.job_name}'))
                          );
                        });
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
        isJobPoster: widget.isJobPoster,
      ),
    );
  }
}
