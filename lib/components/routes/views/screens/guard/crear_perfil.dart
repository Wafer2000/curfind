// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_null_comparison, library_private_types_in_public_api
import 'dart:ffi';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'nombre_curfind.dart';

class CrearPerfil extends StatefulWidget {
  const CrearPerfil({super.key});

  @override
  State<CrearPerfil> createState() => _CrearPerfilState();
}

class _CrearPerfilState extends State<CrearPerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color _backColor = _isSwitched == true
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];
          _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Stack(
            children: [
              //const NombreCurfind(),
              Scaffold(
                //resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  excludeHeaderSemantics: false,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Screens()),
                          );
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: NombreCurfind(),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      )
                    ],
                  ),
                ),
                backgroundColor: _backColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: FadeInUpBig(
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 15, 8),
                            child: SingleChildScrollView(
                              reverse: false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Inputs(),
                                  SizedBox(
                                    height: 19,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class Inputs extends StatefulWidget {
  const Inputs({super.key});

  @override
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
  ) async {
    final _descripcion = descripcionController.text;

    var _pref = PreferencesUser();

    if (_descripcion == null) {
    } else {
      _pref.description = _descripcion;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_pref.ultimateUid)
          .update({
        'descripcion': _descripcion,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Screens()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputs(
          descripcionController: _descripcionController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomGuardar(
          descripcionController: _descripcionController,
          onTap: () {
            _createAccount(context, _descripcionController);
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
  }) : _descripcionController = descripcionController;

  final TextEditingController _descripcionController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const InputEncabezado(),
            const SizedBox(height: 10),
            const InputFotoPerfil(),
            const SizedBox(height: 10),
            const Center(
              child: Row(
                children: [
                  InputFotoIzquierda(),
                  SizedBox(width: 5),
                  InputFotoCentro(),
                  SizedBox(width: 5),
                  InputFotoDerecha()
                ],
              ),
            ),
            const SizedBox(height: 10),
            InputDescripcion(descripcionController: _descripcionController),
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
  PlatformFile? _pickedFile;
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

  @override
  void dispose() {
    super.dispose();
  }

  Future uploadFile() async {
    setState(() {});

    final _path = 'Fotos de Perfil/${_pref.ultimateUid}/Foto de Perfil';
    final _file = File(_pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata(contentType: 'image/jpeg');

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload');

    if (_urlDowload != null) {
      _pref.photoPerfil = _urlDowload;

      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoPerfil': _urlDowload,
      });

      if (_result != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se subio correctamente la imagen'),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          _isLoading = false;
          _imageUrl = _urlDowload;
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

  Future<void> _selectFile([DocumentSnapshot? _documentSnapshot]) async {
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
      _pickedFile = _result.files.first;
    });

    uploadFile();
  }

  Future<void> _deleteImage() async {
    final _path = 'Fotos de Perfil/${_pref.ultimateUid}/Foto de Perfil';
    final _ref = FirebaseStorage.instance.ref().child(_path);
    await _ref.delete();

    final _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .update({
      'FotoPerfil': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se elimino correctamente la imagen'),
      duration: Duration(seconds: 1),
    ));

    setState(() {
      _pickedFile = null;
      _imageUrl = '';
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
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _selectFile();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _pickedFile != null
                        ? SizedBox(
                            width: 121.8,
                            height: 121.8,
                            child: CircleAvatar(
                              backgroundImage:
                                  FileImage(File(_pickedFile!.path!)),
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
                                  size: 80,
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
                        child: IconButton(
                          iconSize: 40,
                          icon:
                              Icon(_imageUrl != '' ? Icons.delete : Icons.edit),
                          color: _textColor,
                          onPressed: () {
                            if (_imageUrl != '') {
                              _deleteImage();
                            } else {
                              _selectFile();
                            }
                          },
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
  PlatformFile? _pickedFile;
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

  @override
  void dispose() {
    super.dispose();
  }

  Future uploadFile() async {
    setState(() {});

    final _path = 'Fotos de Encabezado/${_pref.ultimateUid}/Foto de Encabezado';
    final _file = File(_pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata(contentType: 'image/jpeg');

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      _pref.photoEncabezado = _urlDowload;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'Encabezado': _urlDowload,
      });
      if (_result != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se subio correctamente la imagen'),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          _isLoading = false;
          _imageUrl = _urlDowload;
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

  Future _selectFile() async {
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
      _pickedFile = _result.files.first;
    });

    uploadFile();
  }

  Future<void> _deleteImage() async {
    final _path = 'Fotos de Encabezado/${_pref.ultimateUid}/Foto de Encabezado';
    final _ref = FirebaseStorage.instance.ref().child(_path);
    await _ref.delete();

    final _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .update({
      'Encabezado': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se elimino correctamente la imagen'),
      duration: Duration(seconds: 1),
    ));

    setState(() {
      _pickedFile = null;
      _imageUrl = '';
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
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return InkWell(
            onTap: () async {
              _selectFile();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                _pickedFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 300,
                          height: 188.6,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: FileImage(File(_pickedFile!.path!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
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
                      ),
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 300,
                      height: 188.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color.fromARGB(19, 70, 70, 70)
                            .withOpacity(0.7),
                      ),
                      child: IconButton(
                        iconSize: 60,
                        icon: Icon(_imageUrl != '' ? Icons.delete : Icons.edit),
                        color: _textColor,
                        onPressed: () {
                          if (_imageUrl != '') {
                            _deleteImage();
                          } else {
                            _selectFile();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class InputFotoIzquierda extends StatefulWidget {
  const InputFotoIzquierda({
    super.key,
  });

  @override
  State<InputFotoIzquierda> createState() => _InputFotoIzquierdaState();
}

class _InputFotoIzquierdaState extends State<InputFotoIzquierda> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  final _pref = PreferencesUser();

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
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

  @override
  void dispose() {
    super.dispose();
  }

  Future uploadFile() async {
    final _path = 'Fotos de Izquierda/${_pref.ultimateUid}/Foto de Izquierda';
    final _file = File(_pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata(contentType: 'image/jpeg');

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      _pref.photoLeft = _urlDowload;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoIzquierda': _urlDowload,
      });

      if (_result != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se subio correctamente la imagen'),
          duration: Duration(seconds: 1),
        ));
        _imageUrl = _urlDowload;
      }
    }
    setState(() {
      _uploadTask = null;
    });
  }

  Future _selectFile() async {
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
      _pickedFile = _result.files.first;
    });

    uploadFile();
  }

  Future<void> _deleteImage() async {
    final _path = 'Fotos de Izquierda/${_pref.ultimateUid}/Foto de Izquierda';
    final _ref = FirebaseStorage.instance.ref().child(_path);
    await _ref.delete();

    final _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .update({
      'FotoIzquierda': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se elimino correctamente la imagen'),
      duration: Duration(seconds: 1),
    ));

    setState(() {
      _pickedFile = null;
      _imageUrl = '';
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
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _selectFile();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: 95,
                        height: 170,
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 100,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 95,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color.fromARGB(19, 70, 70, 70)
                                .withOpacity(0.7),
                          ),
                          child: IconButton(
                            iconSize: 40,
                            icon: Icon(
                                _imageUrl != '' ? Icons.delete : Icons.edit),
                            color: _textColor,
                            onPressed: () {
                              if (_imageUrl != '') {
                                _deleteImage();
                              } else {
                                _selectFile();
                              }
                            },
                          ),
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

class InputFotoCentro extends StatefulWidget {
  const InputFotoCentro({
    super.key,
  });

  @override
  State<InputFotoCentro> createState() => _InputFotoCentroState();
}

class _InputFotoCentroState extends State<InputFotoCentro> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? _pickedFile;
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
      _imageUrl = _documentSnapshot['FotoCentro'];
    });
  }

  Future uploadFile() async {
    setState(() {});

    final _path = 'Fotos de Centro/${_pref.ultimateUid}/Foto de Centro';
    final _file = File(_pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata(contentType: 'image/jpeg');

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      _pref.photoCenter = _urlDowload;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoCentro': _urlDowload,
      });

      if (_result != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se subio correctamente la imagen'),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          _isLoading = false;
          _imageUrl = _urlDowload;
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

  Future _selectFile() async {
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
      _pickedFile = _result.files.first;
    });

    uploadFile();
  }

  Future<void> _deleteImage() async {
    final _path = 'Fotos de Centro/${_pref.ultimateUid}/Foto de Centro';
    final _ref = FirebaseStorage.instance.ref().child(_path);
    await _ref.delete();

    final _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .update({
      'FotoCentro': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se elimino correctamente la imagen'),
      duration: Duration(seconds: 1),
    ));

    setState(() {
      _pickedFile = null;
      _imageUrl = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _selectFile();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _pickedFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 95,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: FileImage(File(_pickedFile!.path!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 95,
                              height: 170,
                              child: Image.network(
                                _imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                    Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 95,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color.fromARGB(19, 70, 70, 70)
                                .withOpacity(0.7),
                          ),
                          child: IconButton(
                            iconSize: 40,
                            icon: Icon(
                                _imageUrl != '' ? Icons.delete : Icons.edit),
                            color: _textColor,
                            onPressed: () {
                              if (_imageUrl != '') {
                                _deleteImage();
                              } else {
                                _selectFile();
                              }
                            },
                          ),
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

class InputFotoDerecha extends StatefulWidget {
  const InputFotoDerecha({
    super.key,
  });

  @override
  State<InputFotoDerecha> createState() => _InputFotoDerechaState();
}

class _InputFotoDerechaState extends State<InputFotoDerecha> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  final _focusNode = FocusNode();
  String _imageUrl = '';
  PlatformFile? _pickedFile;
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
      _imageUrl = _documentSnapshot['FotoDerecha'];
    });
  }

  Future uploadFile() async {
    setState(() {});

    final _path = 'Fotos de Derecha/${_pref.ultimateUid}/Foto de Derecha';
    final _file = File(_pickedFile!.path!);
    final _ref = FirebaseStorage.instance.ref().child(_path);

    final _metadata = SettableMetadata(contentType: 'image/jpeg');

    setState(() {
      _uploadTask = _ref.putFile(_file, _metadata);
    });

    final _snapshot = await _uploadTask!.whenComplete(() {});

    final _urlDowload = await _snapshot.ref.getDownloadURL();
    print('Dowload link: $_urlDowload ');

    if (_urlDowload != null) {
      _pref.photoRight = _urlDowload;
      final _result = _firestore
          .collection('Users')
          .doc(_pref.ultimateUid)
          .collection('ImagenesPerfil')
          .doc(_pref.ultimateUid)
          .update({
        'FotoDerecha': _urlDowload,
      });

      if (_result != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se subio correctamente la imagen'),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          _isLoading = false;
          _imageUrl = _urlDowload;
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

  Future _selectFile() async {
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
      _pickedFile = _result.files.first;
    });

    uploadFile();
  }

  Future<void> _deleteImage() async {
    final _path = 'Fotos de Derecha/${_pref.ultimateUid}/Foto de Derecha';
    final _ref = FirebaseStorage.instance.ref().child(_path);
    await _ref.delete();

    final _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .update({
      'FotoDerecha': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Se elimino correctamente la imagen'),
      duration: Duration(seconds: 1),
    ));

    setState(() {
      _pickedFile = null;
      _imageUrl = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  _selectFile();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _pickedFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 95,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: FileImage(File(_pickedFile!.path!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 95,
                              height: 170,
                              child: Image.network(
                                _imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                    Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 95,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color.fromARGB(19, 70, 70, 70)
                                .withOpacity(0.7),
                          ),
                          child: IconButton(
                            iconSize: 40,
                            icon: Icon(
                                _imageUrl != '' ? Icons.delete : Icons.edit),
                            color: _textColor,
                            onPressed: () {
                              if (_imageUrl != '') {
                                _deleteImage();
                              } else {
                                _selectFile();
                              }
                            },
                          ),
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
  String _descripcion = '';
  final _pref = PreferencesUser();

  @override
  void initState() {
    super.initState();
    _getDescription();
  }

  Future _getDescription() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _descripcion = _documentSnapshot['descripcion'];
      widget._descripcionController.text = _descripcion;
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
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return SizedBox(
            child: ListView(shrinkWrap: true, children: [
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
            ]),
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
}

class ButtomGuardar extends StatefulWidget {
  const ButtomGuardar({
    super.key,
    required TextEditingController descripcionController,
    this.onTap,
  }) : _descripcionController = descripcionController;

  final TextEditingController _descripcionController;
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
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          Color _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

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
