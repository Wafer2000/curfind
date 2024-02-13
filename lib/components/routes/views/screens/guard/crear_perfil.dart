// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/components/routes/views/screens/guard/perfil.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';

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

    Color backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          _isSwitched = snapshot.data?['Estado'];
          backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backColor,
            body: const Stack(
              children: [
                OptionsPerfil(),
              ],
            ),
          );
        });
  }
}

class NombreCurfind extends StatelessWidget {
  const NombreCurfind({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FadeInUp(
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: 200, child: Image.asset('assets/nombre_curfind.png'))),
      ),
    ]);
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
            reverse: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20,
                ),
                NombreCurfind(),
                SizedBox(
                  height: 10,
                ),
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
    final descripcion = descripcionController.text;
    final instagram = instagramController.text;
    final tiktok = tiktokController.text;
    final x = xController.text;

    var pref = PreferencesUser();

    if (descripcion == null) {
    } else {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(pref.ultimateUid)
          .update({
        'descripcion': descripcion,
        'instagram': instagram,
        'tiktok': tiktok,
        'x': x,
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
        const SizedBox(height: 40),
        CustomInputs(
          descripcionController: _descripcionController,
          instagramController: _instagramController,
          tiktokController: _tiktokController,
          xController: _xController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomLogin(
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
            InputDescripcion(descripcionController: _descripcionController),
            const SizedBox(height: 10),
            InputInstagram(instagramController: _instagramController),
            const SizedBox(height: 10),
            InputTikTok(tiktokController: _tiktokController),
            const SizedBox(height: 10),
            InputX(xController: _xController),
            const SizedBox(height: 10),
            const InputFotoPerfil(),
          ],
        ),
      ),
    );
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
  final focusNode = FocusNode();
  String? _descripcionErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return ListView(shrinkWrap: true, children: [
      TextField(
        focusNode: focusNode,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        controller: widget._descripcionController,
        style: TextStyle(
            color: TextColor.purple().color,
            fontSize: 18,
            fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: 'Descripcion',
          labelStyle: TextStyle(
              color: TextColor.purple().color,
              fontSize: 15,
              fontFamily: 'Poppins'),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: TextColor.purple().color, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: TextColor.purple().color, width: 2),
          ),
          errorText: _descripcionErrorText,
        ),
        onChanged: (value) {
          setState(() {
            _descripcionErrorText = InputValidator.validateDescripcion(value);
          });
        },
        maxLines: null,
      ),
    ]);
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
  final focusNode = FocusNode();
  String? _instagramErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            onTapOutside: (event) {
              focusNode.unfocus();
            },
            controller: widget._instagramController,
            style: TextStyle(
                color: TextColor.purple().color,
                fontSize: 18,
                fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'Instagram',
              labelStyle: TextStyle(
                  color: TextColor.purple().color,
                  fontSize: 15,
                  fontFamily: 'Poppins'),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
              ),
              errorText: _instagramErrorText,
            ),
            onChanged: (value) {
              setState(() {
                _instagramErrorText = InputValidator.validateInstagram(value);
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
  final focusNode = FocusNode();
  String? _tiktokErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            onTapOutside: (event) {
              focusNode.unfocus();
            },
            controller: widget._tiktokController,
            style: TextStyle(
                color: TextColor.purple().color,
                fontSize: 18,
                fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'Tiktok',
              labelStyle: TextStyle(
                  color: TextColor.purple().color,
                  fontSize: 15,
                  fontFamily: 'Poppins'),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
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
  final focusNode = FocusNode();
  String? _xErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            onTapOutside: (event) {
              focusNode.unfocus();
            },
            controller: widget._xController,
            style: TextStyle(
                color: TextColor.purple().color,
                fontSize: 18,
                fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'X',
              labelStyle: TextStyle(
                  color: TextColor.purple().color,
                  fontSize: 15,
                  fontFamily: 'Poppins'),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: TextColor.purple().color, width: 2),
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
  final focusNode = FocusNode();
  String imageUrl = '';

  Future<void> _uploadImage([DocumentSnapshot? documentSnapshot]) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var pref = PreferencesUser();
    final now = DateTime.now();
    final hsubida = DateFormat('HH:mm:ss').format(now);
    final fsubida = DateFormat('yyyy-MM-dd').format(now);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Elije una foto de perfil')),
                Center(
                  child: IconButton(
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file == null) return;
                        String fileName =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDireImages =
                            referenceRoot.child('Fotos de Perfil');
                        Reference referenceImageaToUpload =
                            referenceDireImages.child(fileName);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Subiendo imagen'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Espere mientras subimos su imagen.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        try {
                          await referenceImageaToUpload
                              .putFile(File(file.path));
                          final imageUrl =
                              await referenceImageaToUpload.getDownloadURL();
                          Navigator.pop(context);
                          // Hacer algo con la URL de la imagen
                        } catch (error) {
                          Navigator.pop(context);
                          // Manejar el error
                        }
                      },
                      icon: const Icon(Icons.camera_alt)),
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(pref.ultimateUid)
                        .update({
                      'hsubidaf': hsubida,
                      'fsubidaf': fsubida,
                      'foto': imageUrl
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Se subio correctamente la imagen'),
                    ));
                  },
                  child: const Text('Guardar'),
                ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return Row(
      children: [
        Text(
          'Foto de Perfil:',
          style: TextStyle(
            color: TextColor.purple().color,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
          ),
          onPressed: () async {
            _uploadImage();
          },
        ),
      ],
    );
  }
}

class InputValidator {
  static String? validateDescripcion(String value) {
    if (value.isEmpty) {
      return 'Debe agrega una descripcion';
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

class ButtomLogin extends StatelessWidget {
  const ButtomLogin({
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
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        height: 45,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: WallpaperColor.white().color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
          child: Text('Guardar',
              style: TextStyle(
                color: TextColor.purple().color,
                fontSize: 21,
                decoration: TextDecoration.underline,
                decorationColor: TextColor.purple().color,
                fontFamily: 'Poppins',
              )),
        ),
      ),
    );
  }
}
