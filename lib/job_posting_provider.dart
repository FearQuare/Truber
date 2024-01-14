import 'package:cloud_firestore/cloud_firestore.dart';

class JobPosting {
  final String job_name;
  final String job_description;
  final String job_poster;
  final List<dynamic> applicants;
  final String docId;

  JobPosting({
    required this.job_name,
    required this.job_description,
    required this.job_poster,
    required this.applicants,
    required this.docId,
  });

  factory JobPosting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return JobPosting(
      job_name: data['job_name'],
      job_description: data['job_description'],
      job_poster: data['job_poster'],
      applicants: List.from(data['applicants']),
      docId: doc.id,
    );
  }

  // a method to check if user has already applied for the job
  bool hasApplied(String username) {
    return applicants.contains(username);
  }

  // add an applicant to the job
  Future<void> applyForJob(String username) async {
    if(!hasApplied(username)) {
      applicants.add(username);
      // Update firestore
      await FirebaseFirestore.instance.collection('jobs').doc(docId).update({
        'applicants': FieldValue.arrayUnion([username])
      });
    }
  }
}
