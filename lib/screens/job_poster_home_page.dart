import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truber/job_posting_provider.dart';
import 'package:truber/screens/create_job_page.dart';
import 'package:truber/screens/profile_page.dart';
import 'package:truber/user_provider.dart';
import 'package:truber/widgets/navigation_bar.dart';
import 'package:truber/screens/job_applicants_page.dart';

class JobPosterHomePage extends StatefulWidget {
  final bool isJobPoster;

  const JobPosterHomePage({super.key, this.isJobPoster = true});

  @override
  State<StatefulWidget> createState() => _JobPosterHomePageState();
}

class _JobPosterHomePageState extends State<JobPosterHomePage> {
  int _selectedIndex = 0;
  List<JobPosting> _postedJobs = [];

  void _onItemTapped(int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(
          username: userProvider.username,
          isEditable: true,
        )),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateJobPage()),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPostedJobs();
  }

  void fetchPostedJobs() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final jobPosterName = '${userProvider.name} ${userProvider.surname}';

    final querySnapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where('job_poster', isEqualTo: jobPosterName)
        .get();

    setState(() {
      _postedJobs = querySnapshot.docs
          .map((doc) => JobPosting.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobButtons = _postedJobs.map((job) => Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => JobApplicantsPage(job: job),),);
          },
          child: Text(job.job_name)),
    )).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Poster Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(jobButtons.isNotEmpty)
              ...jobButtons
            else
              const Padding(padding: EdgeInsets.all(16), child: Text('No jobs posted yet.'),)
          ],
        ),
      ),
      bottomNavigationBar: TruberNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
        isJobPoster: true,
      ),
    );
  }
}
