// ignore_for_file: use_rethrow_when_possible, avoid_print, prefer_const_declarations

import 'dart:convert';
import 'package:employee_app/model/EmployeeData.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://crudcrud.com/api/1729e8e51155498ea3bee5b9a676da25/unicorns';

  Future<List<DataModel>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => DataModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      throw e;
    }
  }

  Future<DataModel> addEmployee(DataModel employee) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),// it is used to convert the API URL string into a Uri.
        headers: {'Content-Type': 'application/json'},// specify the content type as JSON.
        body: jsonEncode(employee.toJson()),
      );

      if (response.statusCode == 201) {
        return DataModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add employee. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding employee: $e');
      throw e;
    }
  }

Future<DataModel> updateEmployee(String id, DataModel updatedEmployee) async {
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),//constructs the complete URL for updating the specific employee.
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedEmployee.toJson()),
    );

    if (response.statusCode == 200) {
      return DataModel.fromJson(json.decode(response.body));//This constructor is responsible for creating a DataModel object from JSON data.
    } else {
      throw Exception('Failed to update employee. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating employee: $e');
    throw e;
  }
}

Future<void> deleteEmployee(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Employee with ID $id deleted successfully!');
      
    } else if (response.statusCode == 404) {
      throw Exception('Employee with ID $id not found');
    } else {
      
      throw Exception('Failed to delete employee. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting employee: $e');
    throw e;
  }
}

}




