class Student {
  int id;
  String name;
  String mail;

  Student(this.id, this.name, this.mail);

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student(
      data["ID"],
      '${data["Name"]} ${data["FirstSurname"]} ${data["SecondSurname"]}',
      data["Mail"],
    );
  }
}

class Tutor {
  int id;
  String name;
  String mail;
  List<Student> myStudents = [];

  Tutor(this.id, this.name, this.mail);

  // Constructor factory para crear una instancia de Tutor desde un mapa
  factory Tutor.fromMap(Map<String, dynamic> data) {
    return Tutor(
      data["ID"],
      '${data["Name"]} ${data["FirstSurname"]} ${data["SecondSurname"]}',
      data["Mail"],
    );
  }

  void addStudent(Map<String, dynamic> data) {
    if (data.containsKey("Student")) {
      myStudents.add(Student(
          data["ID"],
          '${data["Name"]} ${data["FirstSurname"]} ${data["SecondSurname"]}',
          data["Mail"]));
    }
  }
}
