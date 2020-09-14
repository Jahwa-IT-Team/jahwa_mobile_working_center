import 'package:dynamic_treeview/dynamic_treeview.dart'; // Menu Data Model

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

//Menu Data Model
class MenuDataModel implements BaseData {
  final int id;
  final int parentId;
  String name;

  ///Any extra data you want to get when tapped on children
  Map<String, dynamic> extras;
  MenuDataModel({this.id, this.parentId, this.name, this.extras});
  @override
  String getId() {
    return this.id.toString();
  }

  @override
  Map<String, dynamic> getExtraData() {
    return this.extras;
  }

  @override
  String getParentId() {
    return this.parentId.toString();
  }

  @override
  String getTitle() {
    return this.name;
  }
}