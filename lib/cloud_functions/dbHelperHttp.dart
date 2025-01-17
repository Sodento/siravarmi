import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DbHelperHttp {
  Future<List<dynamic>> getBarberList() async {
    var url =
        Uri.parse('https://testforsiravarmi.000webhostapp.com/getBarbers.php');
    http.Response response = await http.get(url);

    var data = jsonDecode(response.body);

    return data;
  }

  Future<LinkedHashMap<String, dynamic>> tryLogin(
      String mail, String pass) async {
    String url = 'https://testforsiravarmi.000webhostapp.com/login.php';
    var response = await http.post(Uri.parse(url), body: {
      'mail': mail, //get the username text
      'password': pass //get password text
    });
    var data = jsonDecode(response.body);
    return data;
  }

  Future tryRegister(String mail, String pass, String name, String surname,
      bool gender) async {
    String url = 'https://testforsiravarmi.000webhostapp.com/register.php';
    String genderInput = "";
    if (gender) {
      genderInput = "1";
    } else {
      genderInput = "0";
    }

    var response = await http.post(Uri.parse(url), body: {
      'mail': mail, //get the username text
      'password': pass, //get password text
      'name': name,
      'surname': surname,
      'gender': genderInput,
    });
    var data = response.body;

    print(response.body);
    return data;
  }

  Future<List<dynamic>> getAppointmentList(int userId) async {
    var url = Uri.parse(
        'https://testforsiravarmi.000webhostapp.com/getAppointmentsFromUser.php');
    http.Response response =
        await http.post(url, body: {'userId': userId.toString()});

    var data = jsonDecode(response.body);
    return data;
  }

  Future<LinkedHashMap<String,dynamic>> getUserFromAssessment(int userId) async {
    var url = Uri.parse(
        'https://testforsiravarmi.000webhostapp.com/getUserFromAssessment.php');
    http.Response response =
        await http.post(url, body: {'userId': userId.toString()});


    var data = jsonDecode(response.body);
    return data;
  }

  Future<List<dynamic>> getAssessmentList(int barberId) async {
    var url = Uri.parse(
        'https://testforsiravarmi.000webhostapp.com/getAssessmentsFromBarber.php');
    http.Response response =
    await http.post(url, body: {'barberId': barberId.toString()});


    var data = jsonDecode(response.body);
    return data;
  }

}
