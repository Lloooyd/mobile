import 'package:mobile/model/studentModel.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  var student = StudentModel().obs;

  void setStudent(value) async {
    student.value = value;
  }
}
