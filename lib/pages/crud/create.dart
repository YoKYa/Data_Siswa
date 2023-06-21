import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_siswa/components/my_button.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class CreateWidget extends StatefulWidget {
  const CreateWidget({super.key});

  @override
  State<CreateWidget> createState() => _CreateWidgetState();
}

class _CreateWidgetState extends State<CreateWidget> {
  String _valGender = "Laki-Laki"; //Ini untuk menyimpan value data gender
  final List _listGender = ["Laki-Laki", "Perempuan"]; //Array gender
  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final kelasController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Colors.white //change your color here
                ),
        title: const Center(
            child: Text(
          'MENAMBAH DATA SISWA',
          style: TextStyle(color: Colors.white),
        )),
        actions: const [
          SizedBox(width: 40),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                  // key: formKey,
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TAMBAH
                    const Text(
                      'Menambah Data Siswa',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    // NIS
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nomor Induk Siswa",
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: nisController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade600),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'NIS',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      validator: (value) => (value != null && value.length > 4)
                          ? 'Maksimal 4 digit'
                          : null,
                    ),
                    // Nama
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nama Lengkap",
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: namaController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade600),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Nama Lengkap',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),

                    // Jenis Kelamin
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Jenis Kelamin",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(1),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        //<-- SEE HERE
                      ),
                      child: DropdownButton(
                        icon: const Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        hint: const Text("Jenis Kelamin"),
                        value: _valGender,
                        items: _listGender.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valGender = value.toString();
                          });
                        },
                      ),
                    ),

                    // Kelas
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kelas",
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: kelasController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade600),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Kelas',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      validator: (value) => (value != null && value.length < 4)
                          ? 'Masukkan minimal 6 karakter'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      onTap: () {
                        createSiswa(
                            nis: nisController.text,
                            nama: namaController.text,
                            kelas: kelasController.text,
                            jk: _valGender.toString());
                        Navigator.pop(context);
                      },
                      hint: 'Tambah',
                    ),
                  ],
                ),
              )))),
    );
  }

  Future createSiswa(
      {required String nis,
      required String nama,
      required String kelas,
      required String jk}) async {
    final docSiswa = FirebaseFirestore.instance.collection('siswa').doc();
    final siswa =
        Siswa(id: docSiswa.id, nis: nis, nama: nama, kelas: kelas, jk: jk);
    final json = siswa.toJson();
    await docSiswa.set(json);
  }
}

class Siswa {
  String id;
  final String nis;
  final String nama;
  final String kelas;
  final String jk;

  Siswa(
      {this.id = '',
      required this.nis,
      required this.nama,
      required this.kelas,
      required this.jk});
  Map<String, dynamic> toJson() =>
      {'id': id, 'nis': nis, 'nama': nama, 'kelas': kelas, 'jk': jk};
}
