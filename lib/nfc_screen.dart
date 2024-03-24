import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  State<StatefulWidget> createState() => NfcScreenState();
}

class NfcScreenState extends State<NfcScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  bool isReading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nfc Reader')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        constraints: const BoxConstraints.expand(),
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) =>
                                Text('${value ?? ''}'),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GridView.count(
                        padding: const EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          isReading
                              ? const Text('Waiting for tag...')
                              : ElevatedButton(
                                  onPressed: _tagRead,
                                  child: const Text('Tap to Read'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _tagRead() {
    setState(() => isReading = true);
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        result.value = tag.data;
        NfcManager.instance.stopSession();
        setState(() => isReading = false);
      },
    );
  }
}
