// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "ikss-ic",
  "private_key_id": "a47925cc91993f330833ceb35d735fbe94557ff9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCxpPTXR+lkByGX\nn4jxHnpx5S577LC+Z1iX+5yHrh89kdo757vaLWB9902xVfqcH7jieqYfpwGTrFwY\nG5rKRT+Haqt7cx8H/4L9T+BKXu5zIrUnaZHJwtFbYcoZdDMVzbb9bYoscZa8ZFlA\nCoRVU0NZs4BICktW0CIkkK5qEKDGb2X8tKdJgAyn+qpoh2L3jyfVmimiz10ZyTyW\nCpGpCBryf0fMPK48bUGARRznpySePF4LfEgpVyBIocDy+t6wtBUEoujmisvMISJp\nJpLCSjBTvyVUESgbPZypto+RZDJMNYjxVX/echBtUwz1UE/Xh/rHB6Ao6BsmG2X5\nZEMdyVTRAgMBAAECggEAEI/sFzwy+X/5X6JgnqEJp8pxxzJd7MqZhcX60I2T3RDW\n828wt5qJHLAXaW62Mvh5gNK63/LuoImD0T2Vn2vNt1Q4e7B+gVI5sLX8l9fPoc1n\nwq5tiLg7U6qY2z8Br56NLoXtdCT8+ZXeL6yArQHaeCerpfZ2aA13TshscngYEpf9\nQ3NfzZvTkSCjenMbuUlafvENI8xSrGl5YVocfEh8CJZjq6rY2iMUkNHSkXh4uvXQ\n4F7WDrQ2b0QLKATDe3FH3sx4/aD3g/cvZZSL5dq1PlipSQK56ppF56IUwh4yOIku\nIo6WUoIthwLNhUcuxmmM4T8Pd7BWbIlyC3SkMGI/nwKBgQDstfspUz4P3ntYJcdq\ncw7Ky9qgCPi7SJt3fjh6SGUhQikf4Qpjl6XMnd8lQSNvgNBaVLHbmIeIsS4Og7wk\nRJmT1KZJYd7MFSHDdRq/tfMkmwMslcc4Dv5ukgcKZmU2lklFMIg7CsszMWQsGk6F\ngsKIbcayevgaOLqVTudsGyR3lwKBgQDAHspk2/DWvT2g9+ApYZ5dNQ+mHIZfMoj/\nBgH1et2avUWok4S5Ty26AVnn18Up6eoFT/HWrRSQO4etp9hC2jvXg4B53LpdF8zO\neRf9UeDVz7ZEohr5SVF5lOHw9ipTa4nKqq9Gf6ePnH4lJt4elvvC6XBh2bboH03s\nRgRUeJLj1wKBgDdmF9QCIWJBZYipvtQQ/YNE1nPh5aSfR5NdvQYRb2mrPEizuGS6\nlxkeUZ08c3ijIyAg9kc4mW/KV8cZ2ax7SZ4phIlkGGqW/4HpJEt939vPU5zZqPhb\nufxSvMcYU9PEtH028Isw6YGfq5wOxBXHFpQrbPdUhEBOyowrHUpVx+EdAoGAJpBH\nqhUn88LKsxvuaAALTMRQ3tQM+ODo9N/c1syR3PSvHdZ2psfI8vRAerQqBG7KpcRV\nU/UsEoOQiYAOfeTWbD0eNdfjpLoZRzyxXwznZ6Oo/3/WkEFyVEhZTgfrmREV+JNo\nWWtYVBBilcyGe3dtE8PN5iZQe6mE969aQSZuvcMCgYBfJn05dHe5RJS6/HVQZ78U\n38d7zrD5CKNF9f1A/t29y2YZm8z0QmZAKzEgRVbinRYPK5KIYIOYsXga/ckKCyWO\n+z9T3oov7G6tw1YIPwYHaq76GA/2px68Fz36n9zP+x+1Q+P49lxAIaJUyjxz2UHI\nLIiVh8NhGvlRqqYyOAHjHQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "ikss-checker@ikss-ic.iam.gserviceaccount.com",
  "client_id": "106008090374236670939",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ikss-checker%40ikss-ic.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
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
