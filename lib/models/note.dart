class Note {
  int? _id;
  late String _title;
  late String _description;
  late String _date;
  late int _priority;

  // Constructor for creating a Note without ID
  Note(this._title, this._date, this._priority, [this._description = '']);

  // Constructor for creating a Note with ID
  Note.withId(this._id, this._title, this._date, this._priority, [this._description = '']);

  // Getters
  int? get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  // Setters with validation
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  // Convert Note object to Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  // Create Note object from Map
  Note.fromMapObject(Map<String, dynamic> map) {
  _id = map['id'];
  this._title = map['title'];
  this._description = map['description'];
  this._priority = map['priority'];
  this._date = map['date'];
}
}
