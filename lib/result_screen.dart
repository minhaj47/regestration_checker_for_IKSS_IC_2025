import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:registration_checker/google_sheets_api.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.code,
    required this.closeScreen,
  });

  final String code;
  final Function() closeScreen;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLoading = false; // To indicate loading state
  bool _isLoading2 = false; // To indicate loading state
  bool couponProvided = false;
  bool done = false;

  Future<void> _update(BuildContext context) async {
    try {
      setState(() {
        _isLoading2 = true; // Show loading state
      });

      final googleSheetsApi = GoogleSheetsApi();
      final success = await googleSheetsApi
          .modifyData(widget.code); // Assuming post updates the 8th column
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully.')),
        );

        setState(() {
          status = "Updated successfully"; // Example: Update local status
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update data.')),
        );

        setState(() {
          status = "Update failed"; // Example: Indicate failure
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );

      setState(() {
        status = "Error occurred"; // Example: Indicate error
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
        couponProvided = true;
        done = true;
      });
    }
  }

  String? name;
  String? email;
  String? status;

  Future<void> _retrive(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true; // Show loading state
      });

      final row = await GoogleSheetsApi.retrieveData(widget.code);
      if (row != null && row.isNotEmpty) {
        setState(() {
          // Extract specific attributes by index or key
          name = row.isNotEmpty ? row[0].replaceFirst("Name: ", "") : "N/A";
          email = row.length > 1 ? row[1].replaceFirst("Email: ", "") : "N/A";
          status = row.length > 2 ? row[3].replaceFirst("Status: ", "") : "N/A";
          couponProvided = (row.isNotEmpty && row[10] == 'true') ? true : false;
        });
      } else {
        setState(() {
          name = "No data found";
          email = "No data found";
          status = "No data found";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              widget.closeScreen();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            )),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Registration Checker",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: widget.code,
              size: 150,
              version: QrVersions.auto,
            ),
            const SizedBox(height: 10),
            if (!done)
              Text(
                widget.code,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            const SizedBox(height: 20),
            if (!done)
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _retrive(context);
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Retrieve Data",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            const SizedBox(height: 20),
            if (name != null || email != null || status != null) ...[
              const SizedBox(height: 10),
              Text(
                name ?? 'Loading...',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email ?? 'Loading...',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              if (!done)
                Text(
                  status == "true"
                      ? "Payment Done!"
                      : "Payment not yet completed!!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              const SizedBox(height: 20),
              if (status == 'true' && !couponProvided)
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading2
                        ? null
                        : () async {
                            await _update(context);
                            setState(() {
                              couponProvided =
                                  true; // Update state to show coupon provided
                            });
                          },
                    child: _isLoading2
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Provide Coupon and Gift!!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 58, 64, 183),
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              if (couponProvided)
                const Text(
                  "Coupon provided! Now Enter and enrich yourself!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 67, 138),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}
