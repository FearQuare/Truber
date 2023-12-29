class JobPosting {
  final String job_name;
  final String job_description;
  final String job_poster;
  final List<dynamic> applicants;

  JobPosting({
    required this.job_name,
    required this.job_description,
    required this.job_poster,
    required this.applicants,
  });
}
