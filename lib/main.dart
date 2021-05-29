import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  List<String> _files = [];

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths.first.extension);
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
      _files.add(_fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('File Picker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('Get documents'),
                onPressed: _openFileExplorer,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: Expanded(
                  //child: Text(_fileName.toString()),

                  child: ListView.builder(
                    itemCount: _files.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            color: Colors.greenAccent[100],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.image),
                                Text(_files[Index]),
                                Icon(Icons.close),
                              ],
                            )),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
