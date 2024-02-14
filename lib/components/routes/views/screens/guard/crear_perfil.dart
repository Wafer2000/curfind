// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_null_comparison
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CrearPerfil extends StatefulWidget {
  const CrearPerfil({super.key});

  @override
  State<CrearPerfil> createState() => _CrearPerfilState();
}

class _CrearPerfilState extends State<CrearPerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];
          _backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: _backColor,
            body: const Stack(
              children: [
                OptionsPerfil(),
              ],
            ),
          );
        });
  }
}

class NombreCurfind extends StatefulWidget {
  const NombreCurfind({
    super.key,
  });

  @override
  State<NombreCurfind> createState() => _NombreCurfindState();
}

class _NombreCurfindState extends State<NombreCurfind> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;
    

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Stack(children: [
            FadeInUp(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      width: 200,
                      child: Image.asset(
                        'assets/nombre_curfind.png',
                        color: _textColor,
                      ))),
            ),
          ]);
        });
  }
}

class OptionsPerfil extends StatelessWidget {
  const OptionsPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUpBig(
        child: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 15, 8),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 5,
                ),
                NombreCurfind(),
                Inputs(),
                SizedBox(
                  height: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Inputs extends StatefulWidget {
  const Inputs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputsState createState() => _InputsState();
}

class _InputsState extends State<Inputs> {
  final _descripcionController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _xController = TextEditingController();

  void _createAccount(
    BuildContext context,
    TextEditingController descripcionController,
    TextEditingController instagramController,
    TextEditingController tiktokController,
    TextEditingController xController,
  ) async {
    final _descripcion = descripcionController.text;
    final _instagram = instagramController.text;
    final _tiktok = tiktokController.text;
    final _x = xController.text;

    var _pref = PreferencesUser();

    if (_descripcion == null) {
    } else {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_pref.ultimateUid)
          .update({
        'descripcion': _descripcion,
        'instagram': _instagram,
        'tiktok': _tiktok,
        'x': _x,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Screens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CustomInputs(
          descripcionController: _descripcionController,
          instagramController: _instagramController,
          tiktokController: _tiktokController,
          xController: _xController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomGuardar(
          descripcionController: _descripcionController,
          instagramController: _instagramController,
          tiktokController: _tiktokController,
          xController: _xController,
          onTap: () {
            _createAccount(context, _descripcionController,
                _instagramController, _tiktokController, _xController);
          },
        ),
      ],
    );
  }
}

class CustomInputs extends StatelessWidget {
  const CustomInputs({
    super.key,
    required TextEditingController descripcionController,
    required TextEditingController instagramController,
    required TextEditingController tiktokController,
    required TextEditingController xController,
  })  : _descripcionController = descripcionController,
        _instagramController = instagramController,
        _tiktokController = tiktokController,
        _xController = xController;

  final TextEditingController _descripcionController;
  final TextEditingController _instagramController;
  final TextEditingController _tiktokController;
  final TextEditingController _xController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const InputFotoPerfil(),
            const SizedBox(height: 10),
            const InputEncabezado(),
            InputDescripcion(descripcionController: _descripcionController),
            const SizedBox(height: 10),
            InputInstagram(instagramController: _instagramController),
            const SizedBox(height: 10),
            InputTikTok(tiktokController: _tiktokController),
            const SizedBox(height: 10),
            InputX(xController: _xController),
          ],
        ),
      ),
    );
  }
}

class InputFotoPerfil extends StatefulWidget {
  const InputFotoPerfil({
    super.key,
  });

  @override
  State<InputFotoPerfil> createState() => _InputFotoPerfilState();
}

class _InputFotoPerfilState extends State<InputFotoPerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? pickedFile;
  UploadTask? _uploadTask;
  final _pref = PreferencesUser();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future _getImageUrl() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _imageUrl = _documentSnapshot['FotoPerfil'];
    });
  }

  Future uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    final _path = 'Fotos de Perfil/${_pref.ultimateUid}/Foto de Perfil';
    final _file = File(pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata();

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload');

    if (_urlDowload != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoPerfil': _urlDowload ,
      });

      if (_result != null) {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    setState(() {
      _uploadTask = null;
    });
  }

  Future selectFile() async {
    final _result = await FilePicker.platform.pickFiles();
    if (_result == null) return;

    if (_result.files.single.path != null &&
        // ignore: unnecessary_cast
        (_result.files.single.path! as String).endsWith('.svg')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se permiten archivos SVG'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      pickedFile = _result.files.first;
      _isLoading = true;
    });

    uploadFile();
  }

  Future<void> _uploadImage([DocumentSnapshot? _documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text('Elije una foto de perfil')),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () async {
                            selectFile();
                          },
                          icon: const Icon(Icons.camera_alt)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _uploadImage();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    pickedFile != null
                        ? SizedBox(
                            width: 121.8,
                            height: 121.8,
                            child: CircleAvatar(
                              backgroundImage:
                                  FileImage(File(pickedFile!.path!)),
                              radius: 15,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              _imageUrl,
                              width: 121.8,
                              height: 121.8,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                    Positioned(
                      child: Container(
                        width: 121.8,
                        height: 121.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(19, 70, 70, 70)
                              .withOpacity(0.7),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 50,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class InputEncabezado extends StatefulWidget {
  const InputEncabezado({
    super.key,
  });

  @override
  State<InputEncabezado> createState() => _InputEncabezadoState();
}

class _InputEncabezadoState extends State<InputEncabezado> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? pickedFile;
  UploadTask? _uploadTask;
  final _pref = PreferencesUser();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future _getImageUrl() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _imageUrl = _documentSnapshot['Encabezado'];
    });
  }

  Future uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    final _path = 'Fotos de Perfil/${_pref.ultimateUid}/Foto de Perfil';
    final _file = File(pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata();

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'Encabezado': _urlDowload ,
      });

      if (_result != null) {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    setState(() {
      _uploadTask = null;
    });
  }

  Future selectFile() async {
    final _result = await FilePicker.platform.pickFiles();
    if (_result == null) return;

    if (_result.files.single.path != null &&
        // ignore: unnecessary_cast
        (_result.files.single.path! as String).endsWith('.svg')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se permiten archivos SVG'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      pickedFile = _result.files.first;
      _isLoading = true;
    });

    uploadFile();
  }

  Future<void> _uploadImage([DocumentSnapshot? _documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text('Elije una foto para el encabezado')),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () async {
                            selectFile();
                          },
                          icon: const Icon(Icons.camera_alt)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _uploadImage();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    pickedFile != null
                        ? Container(
                            width: 300,
                            height: 188.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: FileImage(File(pickedFile!.path!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 300,
                            height: 188.6,
                            child: Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.landscape,
                                  color: Colors.grey,
                                  size: 200,
                                );
                              },
                            ),
                          ),
                    Positioned(
                      child: Container(
                        width: 300,
                        height: 188.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color.fromARGB(19, 70, 70, 70)
                              .withOpacity(0.7),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 60,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class InputIzquierda extends StatefulWidget {
  const InputIzquierda({
    super.key,
  });

  @override
  State<InputIzquierda> createState() => _InputIzquierdaState();
}

class _InputIzquierdaState extends State<InputIzquierda> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? pickedFile;
  UploadTask? _uploadTask;
  final _pref = PreferencesUser();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future _getImageUrl() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _imageUrl = _documentSnapshot['FotoIzquierda'];
    });
  }

  Future uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    final _path = 'Fotos de Perfil/${_pref.ultimateUid}/Foto de Perfil';
    final _file = File(pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata();

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoIzquierda': _urlDowload ,
      });

      if (_result != null) {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    setState(() {
      _uploadTask = null;
    });
  }

  Future selectFile() async {
    final _result = await FilePicker.platform.pickFiles();
    if (_result == null) return;

    if (_result.files.single.path != null &&
        // ignore: unnecessary_cast
        (_result.files.single.path! as String).endsWith('.svg')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se permiten archivos SVG'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      pickedFile = _result.files.first;
      _isLoading = true;
    });

    uploadFile();
  }

  Future<void> _uploadImage([DocumentSnapshot? _documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text('Elije una foto')),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () async {
                            selectFile();
                          },
                          icon: const Icon(Icons.camera_alt)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _uploadImage();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    pickedFile != null
                        ? Container(
                            width: 300,
                            height: 188.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: FileImage(File(pickedFile!.path!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 300,
                            height: 188.6,
                            child: Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.landscape,
                                  color: Colors.grey,
                                  size: 200,
                                );
                              },
                            ),
                          ),
                    Positioned(
                      child: Container(
                        width: 300,
                        height: 188.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color.fromARGB(19, 70, 70, 70)
                              .withOpacity(0.7),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 60,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class InputDescripcion extends StatefulWidget {
  const InputDescripcion({
    required TextEditingController descripcionController,
    super.key,
  }) : _descripcionController = descripcionController;

  final TextEditingController _descripcionController;

  @override
  State<InputDescripcion> createState() => _InputDescripcionState();
}

class _InputDescripcionState extends State<InputDescripcion> {
  final _focusNode = FocusNode();
  String? _descripcionErrorText;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return ListView(shrinkWrap: true, children: [
            TextField(
              focusNode: _focusNode,
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              controller: widget._descripcionController,
              style: TextStyle(
                  color: _textColor, fontSize: 18, fontFamily: 'Poppins'),
              decoration: InputDecoration(
                labelText: 'Descripcion',
                labelStyle: TextStyle(
                    color: _textColor, fontSize: 15, fontFamily: 'Poppins'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: _textColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: _textColor, width: 2),
                ),
                errorText: _descripcionErrorText,
              ),
              onChanged: (value) {
                setState(() {
                  _descripcionErrorText =
                      InputValidator.validateDescripcion(value);
                });
              },
              maxLength: 50,
              maxLines: null,
            ),
          ]);
        });
  }
}

class InputInstagram extends StatefulWidget {
  const InputInstagram({
    required TextEditingController instagramController,
    super.key,
  }) : _instagramController = instagramController;

  final TextEditingController _instagramController;

  @override
  State<InputInstagram> createState() => _InputInstagramState();
}

class _InputInstagramState extends State<InputInstagram> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String? _instagramErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                  controller: widget._instagramController,
                  style: TextStyle(
                      color: _textColor, fontSize: 18, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'Instagram',
                    labelStyle: TextStyle(
                        color: _textColor, fontSize: 15, fontFamily: 'Poppins'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    errorText: _instagramErrorText,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _instagramErrorText =
                          InputValidator.validateInstagram(value);
                    });
                  },
                ),
              ),
              IconButton(
                icon: Image.asset('assets/instagram_icon.png', height: 29.2),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

class InputTikTok extends StatefulWidget {
  const InputTikTok({
    required TextEditingController tiktokController,
    super.key,
  }) : _tiktokController = tiktokController;

  final TextEditingController _tiktokController;

  @override
  State<InputTikTok> createState() => _InputTikTokState();
}

class _InputTikTokState extends State<InputTikTok> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String? _tiktokErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                  controller: widget._tiktokController,
                  style: TextStyle(
                      color: _textColor, fontSize: 18, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'Tiktok',
                    labelStyle: TextStyle(
                        color: _textColor, fontSize: 15, fontFamily: 'Poppins'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    errorText: _tiktokErrorText,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _tiktokErrorText = InputValidator.validateTiktok(value);
                    });
                  },
                ),
              ),
              IconButton(
                icon: Image.asset('assets/tiktok_icon.png', height: 29.2),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

class InputX extends StatefulWidget {
  const InputX({
    required TextEditingController xController,
    super.key,
  }) : _xController = xController;

  final TextEditingController _xController;

  @override
  State<InputX> createState() => _InputXState();
}

class _InputXState extends State<InputX> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String? _xErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                  controller: widget._xController,
                  style: TextStyle(
                      color: _textColor, fontSize: 18, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'X',
                    labelStyle: TextStyle(
                        color: _textColor, fontSize: 15, fontFamily: 'Poppins'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _textColor, width: 2),
                    ),
                    errorText: _xErrorText,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _xErrorText = InputValidator.validateX(value);
                    });
                  },
                ),
              ),
              IconButton(
                icon: Image.asset('assets/x_icon.png', height: 29.2),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

class InputValidator {
  static String? validateDescripcion(String value) {
    if (value.isEmpty) {
      return 'Debe agrega una descripcion';
    } else if (value.length > 50) {
      return 'Descripcion no puede tener más de 50 caracteres';
    }
    return null;
  }

  static String? validateInstagram(String value) {
    if (value.isEmpty) {
      return 'Debe colocar un link, o sino descative la opcion';
    }
    return null;
  }

  static String? validateTiktok(String value) {
    if (value.isEmpty) {
      return 'Debe colocar un link, o sino descative la opcion';
    }
    return null;
  }

  static String? validateX(String value) {
    if (value.isEmpty) {
      return 'Debe colocar un link, o sino descative la opcion';
    }
    return null;
  }
}

class ButtomGuardar extends StatefulWidget {
  const ButtomGuardar({
    super.key,
    required TextEditingController descripcionController,
    required TextEditingController instagramController,
    required TextEditingController tiktokController,
    required TextEditingController xController,
    this.onTap,
  })  : _descripcionController = descripcionController,
        _instagramController = instagramController,
        _tiktokController = tiktokController,
        _xController = xController;

  final TextEditingController _descripcionController;
  final TextEditingController _instagramController;
  final TextEditingController _tiktokController;
  final TextEditingController _xController;
  final VoidCallback? onTap;

  @override
  State<ButtomGuardar> createState() => _ButtomGuardarState();
}

class _ButtomGuardarState extends State<ButtomGuardar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          return Center(
            child: SizedBox(
              width: 270,
              height: 45,
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _backColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text('Guardar',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 21,
                      decoration: TextDecoration.underline,
                      decorationColor: _textColor,
                      fontFamily: 'Poppins',
                    )),
              ),
            ),
          );
        });
  }
}
