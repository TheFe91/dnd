import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

enum Screen { main, ale, maryel, fra, manu }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

  runApp(
    const MaterialApp(home: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterMidi flutterMidi = FlutterMidi();
  late final TextEditingController textEditingController;
  Screen screen = Screen.main;

  Future<void> setupMIDIPlugin() async {
    flutterMidi.unmute();
    ByteData byte = await rootBundle.load("assets/piano.sf2");
    flutterMidi.prepare(sf2: byte);
  }

  @override
  void initState() {
    super.initState();
    setupMIDIPlugin();
    textEditingController = TextEditingController()..addListener(onControllerChangedListener);
  }

  @override
  void dispose() {
    textEditingController
      ..removeListener(onControllerChangedListener)
      ..dispose();
    super.dispose();
  }

  void onControllerChangedListener() {
    if (textEditingController.text == '112143' && Platform.isIOS) {
      setState(() {
        screen = Screen.ale;
      });
    } else if (textEditingController.text == '112143' && Platform.isAndroid) {
      setState(() {
        screen = Screen.manu;
      });
    } else if (textEditingController.text == '1165432') {
      setState(() {
        screen = Screen.fra;
      });
    } else if (textEditingController.text == '443121') {
      setState(() {
        screen = Screen.maryel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen == Screen.main
          ? Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Inserire il codice segreto',
                  ),
                ),
              ),
            )
          : screen == Screen.ale
              ? Ale(flutterMidi)
              : screen == Screen.fra
                  ? Fra(flutterMidi)
                  : screen == Screen.manu
                      ? Manu(flutterMidi)
                      : Maryel(flutterMidi),
    );
  }
}

class Ale extends StatelessWidget {
  final FlutterMidi flutterMidi;

  const Ale(this.flutterMidi, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 63,
                label: '1',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 65,
                label: '2',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 67,
                label: '3',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 68,
                label: '4',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Manu extends StatelessWidget {
  final FlutterMidi flutterMidi;

  const Manu(this.flutterMidi, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 63,
                label: '1',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 65,
                label: '2',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 68,
                label: '3',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 70,
                label: '4',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Fra extends StatelessWidget {
  final FlutterMidi flutterMidi;

  const Fra(this.flutterMidi, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 63,
                label: '1',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 65,
                label: '2',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 67,
                label: '3',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 68,
                label: '4',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 72,
                label: '5',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 75,
                label: '6',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Maryel extends StatelessWidget {
  final FlutterMidi flutterMidi;

  const Maryel(this.flutterMidi, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 68,
                label: '1',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 70,
                label: '2',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 72,
                label: '3',
              ),
              Bell(
                flutterMidi: flutterMidi,
                midiNote: 73,
                label: '4',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bell extends StatelessWidget {
  final FlutterMidi flutterMidi;
  final int midiNote;
  final String label;

  const Bell({
    required this.flutterMidi,
    required this.midiNote,
    required this.label,
    super.key,
  });

  /// Send a NOTE ON message
  playNote() {
    flutterMidi.playMidiNote(midi: midiNote);
  }

  /// Send a NOTE OFF message
  stopNote() {
    flutterMidi.stopMidiNote(midi: midiNote);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => playNote(),
      onTapUp: (_) => stopNote(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(CupertinoIcons.bell, size: 100),
          Text(
            label,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
