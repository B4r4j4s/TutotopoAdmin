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

  void showStudent() {
    for (Student student in myStudents) {
      print(student.name);
    }
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

class Appointment {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  String sName;
  String sMail;
  String sCode;
  String tName;
  String tMail;
  String tCode;
  String reason;
  DateTime? appointmentDateTime;
  String? place;
  String category;
  String status;

  Appointment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.sName,
    required this.sMail,
    required this.sCode,
    required this.tName,
    required this.tMail,
    required this.tCode,
    required this.reason,
    required this.appointmentDateTime,
    this.place,
    required this.category,
    required this.status,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    /*if (map["CreatedAt"] == null) {
      map["CreatedAt"] = DateTime.now();
    }
    if (map["UpdatedAt"] == null) {
      map["UpdatedAt"] = DateTime.now();
    }if (map["DeletedAt"] == null) {
      map["DeletedAt"] = DateTime.now();
    }*/
    String c = "Category";
    if (map["Place"] == null) {
      map["Place"] = 'Nulo';
    }
    if (map[c] == null) {
      c = "CategoryType";
    }

    return Appointment(
      id: map["ID"],
      createdAt: DateTime.parse(map["CreatedAt"]),
      updatedAt: DateTime.parse(map["UpdatedAt"]),
      deletedAt:
          map["DeletedAt"] != null ? DateTime.parse(map["DeletedAt"]) : null,
      sName: map["StudentName"] +
          ' ' +
          map["StudentFirstSurname"] +
          ' ' +
          map["StudentSecondSurname"],
      sMail: map["StudentMail"],
      sCode: map["StudentCode"],
      tName: map["TutorName"] +
          ' ' +
          map["TutorFirstSurname"] +
          ' ' +
          map["TutorSecondSurname"],
      tMail: map["TutorMail"],
      tCode: map["TutorCode"],
      reason: map["Reason"],
      appointmentDateTime: map["AppointmentDateTime"] != null
          ? DateTime.parse(map["AppointmentDateTime"])
          : null,
      place: map["Place"],
      category: map[c],
      status: map["Status"],
    );
  }

  static List<Appointment> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Appointment.fromMap(map)).toList();
  }
}

class IndividualBar {
  final int x;
  final double y;
  final String lb;

  IndividualBar({required this.x, required this.y, required this.lb});
}
