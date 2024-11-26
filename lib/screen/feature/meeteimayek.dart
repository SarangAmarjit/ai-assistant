import 'package:ai_assistant/controller/meeteimayekcontroler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeiteiMayekConverter extends StatefulWidget {
  const MeiteiMayekConverter({super.key});

  @override
  _MeiteiMayekConverterState createState() => _MeiteiMayekConverterState();
}

class _MeiteiMayekConverterState extends State<MeiteiMayekConverter> {
  final TextEditingController _controller = TextEditingController();
  String _outputText = "";

  // Dummy converter function for demonstration
  String convertToMeiteiMayek(String input) {
    // Replace with actual Meitei Mayek conversion logic
    return input
        .replaceAll("sidi", "ꯁꯤꯗꯤ")
        .replaceAll("eisu", "ꯑꯩꯁꯨ")
        .replaceAll("meitei", "ꯃꯩꯇꯩ")
        .replaceAll("myek", "ꯃꯦꯛ")
        .replaceAll("eeb", "ꯑꯦꯕ")
        .replaceAll("heirni", "ꯍꯩꯔꯅꯤ")
        .replaceAll("bu", "ꯄꯨ")
        .replaceAll(".", "।");
  }

  @override
  Widget build(BuildContext context) {
    MeeteiMayekController mayekController = Get.put(MeeteiMayekController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meitei Mayek Converter"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Input Text (type Manipuri using English letters):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(hintStyle: TextStyle(color:  Color.fromARGB(255, 194, 193, 193)),
                  border: OutlineInputBorder(),
                  hintText: "Type here...",
                ),
                onChanged: (text) {
                  setState(() {
                    _outputText = mayekController.transliterate(text);
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Output Text in Meitei Mayek:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  _outputText.isNotEmpty
                      ? _outputText
                      : "Converted text will appear here",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MeiteiMayekFont',
                      color: _outputText.isNotEmpty
                          ? Colors.black
                          : Color.fromARGB(255, 194, 193, 193)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
