// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "paste_your_credentials_here",
}
  ''';

  static const _spreadsheetId = '1ZjzlYaekxUggxtX4tz7Zkb5HMDltqHktBh2hyXHdbzA';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  Future<void> init() async {
    try {
      log('no i am not');
      final ss = await _gsheets.spreadsheet(_spreadsheetId);
      log('yes i am');
      _worksheet = ss.worksheetByTitle('Sheet1');
      if (_worksheet == null) throw Exception('Worksheet not found.');
      log('Google Sheets initialized.');
    } catch (e) {
      log('Error initializing Google Sheets: $e');
    }
  }

  static Future<void> insertData(String data) async {
    try {
      if (_worksheet == null) throw Exception('Worksheet is not initialized.');
      await _worksheet!.values.appendRow([data]);
      print('Data inserted: $data');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  static Future<List<String>?> retrieveData(String key,
      {int keyColumnIndex = 2}) async {
    try {
      // Ensure worksheet is initialized
      if (_worksheet == null) {
        throw Exception('Worksheet is not initialized.');
      }

      // Fetch all rows from the worksheet
      final rows = await _worksheet!.values.allRows();
      if (rows.isEmpty) {
        log('No data found in the worksheet.');
        return null; // Return null if no rows are present
      }

      // Search for the key in the specified column
      for (var row in rows) {
        if (row.length > keyColumnIndex &&
            (row[keyColumnIndex] == key ||
                row[keyColumnIndex] == key.substring(1))) {
          print('Data retrieved for key "$key": $row');
          return row; // Return the entire row
        }
      }

      log('Key "$key" not found in column $keyColumnIndex.');
      return null; // Return null if key not found
    } catch (e) {
      // Log the error and return null
      log('Error retrieving data: $e');
      return null;
    }
  }

  Future<bool> modifyData(String key,
      {int keyColumnIndex = 2, int targetColumnIndex = 10}) async {
    try {
      // Ensure worksheet is initialized
      if (_worksheet == null) {
        throw Exception('Worksheet is not initialized.');
      }

      // Fetch all rows from the worksheet
      final rows = await _worksheet!.values.allRows();
      if (rows.isEmpty) {
        log('No data found in the worksheet.');
        return false; // Return false if no rows are present
      }

      // Search for the key in the specified column
      for (var row in rows) {
        if (row.length > keyColumnIndex &&
            (row[keyColumnIndex] == key ||
                row[keyColumnIndex] == key.substring(1))) {
          // Modify the target column value to 'true'
          if (row.length > targetColumnIndex) {
            row[targetColumnIndex] = 'true';
            print('done');
          } else {
            // Handle the case where the target column doesn't exist
            print('Target column index $targetColumnIndex is out of bounds.');
            return false;
          }

          // Update the row in the worksheet
          await _worksheet!.values.insertRow(
            rows.indexOf(row) + 1, // Adjust for 1-based indexing
            row,
          );

          print('Data modified for key "$key": $row');
          return true;
        }
      }

      log('Key "$key" not found in column $keyColumnIndex.');
      return false; // Return false if key not found
    } catch (e) {
      // Log the error and return false
      log('Error modifying data: $e');
      return false;
    }
  }
}
