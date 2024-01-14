import 'package:flutter/material.dart';
import 'package:truber/screens/profile_page.dart';

import '../job_posting_provider.dart';

class JobApplicantsPage extends StatelessWidget {
  final JobPosting job;

  const JobApplicantsPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.job_name),
      ),
      body: ListView.builder(
        itemCount: job.applicants.length,
        itemBuilder: (context, index) {
          final applicantUsername = job.applicants[index];

          return ListTile(
            title: Text(applicantUsername),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      username: applicantUsername,
                      isEditable: false,
                    )
                ),
              );
            },
          );
        },
      ),
    );
  }
}
