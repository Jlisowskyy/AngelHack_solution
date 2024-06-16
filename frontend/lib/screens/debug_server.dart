import 'package:flutter/material.dart';
import 'package:frontend/services/iclient_service.dart';
import 'package:logger/logger.dart';

class DebugServerTestPage extends StatefulWidget {
  final IClientService client;

  DebugServerTestPage({Key? key, required this.client}) : super(key: key);

  @override
  _DebugServerTestPageState createState() => _DebugServerTestPageState();
}

class _DebugServerTestPageState extends State<DebugServerTestPage> {
  final _endpointController = TextEditingController();
  String _response = "";
  bool _isLoading = false;
  final Logger _logger = Logger();

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
      _response = "";
    });

    try {
      final endpoint = _endpointController.text;
      final response = await widget.client.getRequest(endpoint);
      setState(() {
        _response = response.toString();
      });
    } catch (error) {
      _logger.e("Error sending request: $error");
      setState(() {
        _response = "Error: $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug Server Test"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _endpointController,
              decoration: InputDecoration(
                labelText: "API Endpoint",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendRequest,
              child: Text("Send Request"),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _response,
                        style: TextStyle(fontFamily: "monospace"),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
