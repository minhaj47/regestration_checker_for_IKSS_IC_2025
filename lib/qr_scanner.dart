import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:registration_checker/result_screen.dart';

const bgColor = Color(0xfffafafa);

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Registration Checker for\nIKSS Islamic Conference 2025",
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Expanded(
                child: Column(
              children: [
                Text(
                  "Place the QR code",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "Scanning will be started automatically",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            )),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                      returnImage: true,
                    ),
                    onDetect: (BarcodeCapture capture) {
                      // Retrieve the list of detected barcodes
                      final List<Barcode> barcodes = capture.barcodes;
                      // final Uint8List? image = capture.image;

                      final String code = barcodes[0].rawValue ?? "---";
                      isScanCompleted = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            code: code,
                            closeScreen: closeScreen,
                          ),
                        ),
                      );
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: bgColor,
                    borderColor: Colors.blue,
                    scanAreaSize: const Size(280, 280),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Developed by\nMd. Minhajul Haque (CSE - 20)",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
