import 'package:flutter/material.dart';

import 'package:neat_alarm/services/notification_service.dart';

Future<void> showSoundDialog(
    BuildContext context, String? selectedSound, Function updateSound) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return SoundDialog(selectedSound, updateSound);
    },
  );
}

class SoundDialog extends StatefulWidget {
  final Function updateSound;
  final String? selectedSound;

  const SoundDialog(this.selectedSound, this.updateSound, {Key? key})
      : super(key: key);

  @override
  State<SoundDialog> createState() => _SoundDialogState();
}

class _SoundDialogState extends State<SoundDialog> {
  int _selectedIndex = 0;
  final _sounds = [];
  Map<String, String>? _soundsDict;

  @override
  void initState() {
    super.initState();
    _sounds.insert(0, 'Default Sound');
  }

  Future<void> _loadSoundsAsync() async {
    if (_soundsDict == null) {
      _soundsDict = await NotificationService().getAllSystemSounds();
      if (_soundsDict != null) {
        _sounds.addAll(_soundsDict!.keys);

        if (widget.selectedSound != null) {
          int tempIndex = _sounds.indexOf(widget.selectedSound);
          if (tempIndex >= 0) {
            setState(() {
              _selectedIndex = tempIndex;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadSoundsAsync(),
        builder: (context, snapshot) {
          return AlertDialog(
            title: const Text('Choose Sound'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                onPressed: () {
                  String soundName = _sounds[_selectedIndex];
                  String soundPath = _soundsDict![soundName] ?? '';
                  widget.updateSound(soundName, soundPath);
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Divider(),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _sounds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile(
                                title: Text(_sounds[index]),
                                value: index,
                                groupValue: _selectedIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                });
                          }),
                    ),
                    const Divider(),
                    TextField(
                      autofocus: false,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Selected: "${_sounds[_selectedIndex]}"',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
