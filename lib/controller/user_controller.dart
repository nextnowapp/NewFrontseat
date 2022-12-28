import 'package:get/get.dart';

class UserDetailsController extends GetxController {
  var _id = 0.obs;
  var _roleId = 0.obs;
  var _role = ''.obs;
  var _schoolId = ''.obs;
  var _fullName = ''.obs;
  var _email = ''.obs;
  var _mobile = ''.obs;
  var _dob = ''.obs;
  var _photo = ''.obs;
  var _age = 0.obs;
  var _genderId = 0.obs;
  var _gender = ''.obs;
  var _designation = ''.obs;
  var _zoom = 0.obs;
  var _is_administrator = ''.obs;
  var _user_type = ''.obs;
  var _token = ''.obs;
  var _isLogged = false.obs;
  var _schoolUrl = ''.obs;

  //define getter and setter
  get id => this._id.value;
  set id(value) => this._id.value = value;

  get roleId => this._roleId.value;
  set roleId(value) => this._roleId.value = value;

  get role => this._role.value;
  set role(value) => this._role.value = value;

  get schoolId => this._schoolId.value;
  set schoolId(value) => this._schoolId.value = value;

  get fullName => this._fullName.value;
  set fullName(value) => this._fullName.value = value;

  get email => this._email.value;
  set email(value) => this._email.value = value;

  get mobile => this._mobile.value;
  set mobile(value) => this._mobile.value = value;

  get dob => this._dob.value;
  set dob(value) => this._dob.value = value;

  get photo => this._photo.value;
  set photo(value) => this._photo.value = value;

  get age => this._age.value;
  set age(value) => this._age.value;

  get genderId => this._genderId.value;
  set genderId(value) => this._genderId.value = value;

  get gender => this._gender.value;
  set gender(value) => this._gender.value = value;

  get designation => this._designation.value;
  set designation(value) => this._designation.value = value;

  get zoom => this._zoom.value;
  set zoom(value) => this._zoom.value = value;

  get is_administrator => this._is_administrator.value;
  set is_administrator(value) => this._is_administrator.value = value;

  get user_type => this._user_type.value;
  set user_type(value) => this._user_type.value = value;

  get token => this._token.value;
  set token(value) => this._token.value = value;

  get isLogged => this._isLogged.value;
  set isLogged(value) => this._isLogged.value = value;

  get schoolUrl => this._schoolUrl.value;
  set schoolUrl(value) => this._schoolUrl.value = value;

  //function to reset the values
  void reset() {
    _id.value = 0;
    _roleId.value = 0;
    _role.value = '';
    _schoolId.value = '';
    _fullName.value = '';
    _email.value = '';
    _mobile.value = '';
    _dob.value = '';
    _photo.value = '';
    _age.value = 0;
    _genderId.value = 0;
    _gender.value = '';
    _designation.value = '';
    _zoom.value = 0;
    _is_administrator.value = '';
    _user_type.value = '';
    _token.value = '';
    _isLogged.value = false;
    _schoolUrl.value = '';
  }

  //function to print the values
  void printValues() {
    print('id: ${_id.value}');
    print('roleId: ${_roleId.value}');
    print('role: ${_role.value}');
    print('schoolId: ${_schoolId.value}');
    print('fullName: ${_fullName.value}');
    print('email: ${_email.value}');
    print('mobile: ${_mobile.value}');
    print('dob: ${_dob.value}');
    print('photo: ${_photo.value}');
    print('age: ${_age.value}');
    print('genderId: ${_genderId.value}');
    print('gender: ${_gender.value}');
    print('designation: ${_designation.value}');
    print('zoom: ${_zoom.value}');
    print('is_administrator: ${_is_administrator.value}');
    print('user_type: ${_user_type.value}');
    print('token: ${_token.value}');
    print('isLogged: ${_isLogged.value}');
    print('schoolUrl: ${_schoolUrl.value}');
  }
}
