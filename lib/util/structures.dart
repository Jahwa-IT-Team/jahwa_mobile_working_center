class User {
  final String EntCode; final String EntName;
  final String DeptCode; final String DeptName;
  final String EmpCode; final String Name;
  final String RollPstn; final String Position;
  final String Role; final String Title;
  final String PayGrade; final String Level;
  final String Email; final String Photo;
  final int Auth; final String EntGroup;
  final String OfficeTel; final String Mobile;

  User(this.EntCode, this.EntName, this.DeptCode, this.DeptName, this.EmpCode, this.Name, this.RollPstn, this.Position, this.Role, this.Title, this.PayGrade, this.Level, this.Email, this.Photo, this.Auth, this.EntGroup, this.OfficeTel, this.Mobile);

  User.fromJson(Map<String, dynamic> json)

    : EntCode = json['EntCode'], EntName = json['EntName'],
      DeptCode = json['DeptCode'], DeptName = json['DeptName'],
      EmpCode = json['EmpCode'], Name = json['Name'],
      RollPstn = json['RollPstn'], Position = json['Position'],
      Role = json['Role'], Title = json['Title'],
      PayGrade = json['PayGrade'], Level = json['Level'],
      Email = json['Email'], Photo = json['Photo'],
      Auth = json['Auth'], EntGroup = json['EntGroup'],
      OfficeTel = json['OfficeTel'], Mobile = json['Mobile'];

  Map<String, dynamic> toJson() =>
  {
    'EntCode' : EntCode, 'EntName' : EntName,
    'DeptCode' : DeptCode, 'DeptName' : DeptName,
    'EmpCode' : EmpCode, 'Name' : Name,
    'RollPstn' : RollPstn, 'Position' : Position,
    'Role' : Role, 'Title' : Title,
    'PayGrade' : PayGrade, 'Level' : Level,
    'Email' : Email, 'Photo' : Photo,
    'Auth' : Auth, 'EntGroup' : EntGroup,
    'OfficeTel' : OfficeTel, 'Mobile' : Mobile,
  };
}

class Language {
  final String Lang; final String LangCode;
  Language(this.Lang, this.LangCode);
  Language.fromJson(Map<String, dynamic> json) : Lang = json['Lang'], LangCode = json['LangCode'];
  Map<String, dynamic> toJson() => {'Lang' : Lang, 'LangCode' : LangCode, };
}