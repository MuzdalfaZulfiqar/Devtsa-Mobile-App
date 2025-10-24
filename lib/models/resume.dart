class Education {
  String school, degree, start, end;
  Education({
    this.school = '',
    this.degree = '',
    this.start = '',
    this.end = '',
  });
}

class Experience {
  String title, company, start, end;
  List<String> bullets;
  Experience({
    this.title = '',
    this.company = '',
    this.start = '',
    this.end = '',
    this.bullets = const [],
  });
}

class Resume {
  String summary;
  List<Education> education;
  List<Experience> experience;
  List<String> skills;
  Resume({
    this.summary = '',
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
  });
}
