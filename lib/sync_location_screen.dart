import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SyncLocationScreen extends StatefulWidget {
  final int userId; // Pass the User ID to this screen

  SyncLocationScreen({required this.userId});

  @override
  _SyncLocationScreenState createState() => _SyncLocationScreenState();
}

class _SyncLocationScreenState extends State<SyncLocationScreen> {
  bool isLoading = false;
  String? statusMessage;

  // Function to get the current location and sync data to API
  Future<void> syncLocationData() async {
    setState(() {
      isLoading = true;
      statusMessage = null;
    });

    try {
      // Get the current date and time
      String currentDateTime = DateTime.now().toIso8601String();

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          statusMessage = "Location services are disabled.";
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            statusMessage = "Location permissions are denied.";
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          statusMessage = "Location permissions are permanently denied.";
          isLoading = false;
        });
        return;
      }

      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Create the data payload
      Map<String, dynamic> data = {
        "userId": widget.userId,
        "dateTime": currentDateTime,
        "latitude": latitude,
        "longitude": longitude,
      };

      // API request
      final url =
          Uri.parse("http://103.215.194.85:6006/api/user/sync-location");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      // Check response status
      if (response.statusCode == 200) {
        setState(() {
          statusMessage = "Data synced successfully!";
        });
      } else {
        setState(() {
          statusMessage = "Failed to sync data. Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sync Location")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (statusMessage != null) ...[
                Text(statusMessage!,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                    )),
                SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: isLoading ? null : syncLocationData,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text("Click to Sync Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
