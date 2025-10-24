class Education {
  String school;
  String degree;
  String start;
  String end;

  Education({this.school = '', this.degree = '', this.start = '', this.end = ''});
}

class Experience {
  String title;
  String company;
  String start;
  String end;
  List<String> bullets;

  Experience({this.title = '', this.company = '', this.start = '', this.end = '', this.bullets = const []});
}

class Project {
  String name;
  String description;
  String link;

  Project({this.name = '', this.description = '', this.link = ''});
}

class Certification {
  String title;
  String organization;
  String year;

  Certification({this.title = '', this.organization = '', this.year = ''});
}

class Resume {
  String summary;
  List<Education> education;
  List<Experience> experience;
  List<Project> projects;
  List<Certification> certifications;
  List<String> skills;

  Resume({
    this.summary = '',
    List<Education>? education,
    List<Experience>? experience,
    List<Project>? projects,
    List<Certification>? certifications,
    List<String>? skills,
  })  : education = education ?? [],
        experience = experience ?? [],
        projects = projects ?? [],
        certifications = certifications ?? [],
        skills = skills ?? [];
}

