import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_siswa/components/my_button.dart';

class Update extends StatefulWidget {
  const Update(
      {super.key,
      required this.id,
      required this.nis,
      required this.nama,
      required this.kelas,
      required this.jk});
  final String id, nama, kelas, nis, jk;

  Future<Object> readSiswa() async {
    final docSiswa = FirebaseFirestore.instance.collection('siswa').doc(id);
    final snapshot = await docSiswa.get();
    if (snapshot.exists) {
      return Siswa.fromJson(snapshot.data()!);
    } else {
      return const Text('Data Tidak Ada');
    }
  }

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late String siswaid;
  late String siswanis;
  late String siswanama;
  late String siswakelas;

  @override
  void initState() {
    super.initState();

    nisController.text = widget.nis;
    namaController.text = widget.nama;
    kelasController.text = widget.kelas;
  }

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
            'MENGUBAH DATA SISWA',
            style: TextStyle(color: Colors.white),
          )),
          actions: const [
            SizedBox(width: 40),
          ],
        ),
        body: FutureBuilder(
            future: widget.readSiswa(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Ada Kesalahan');
              } else if (snapshot.hasData) {
                final siswa = snapshot.data;
                return siswa == null
                    ? const Center(
                        child: Text('Tidak Ada SIswa'),
                      )
                    : buildUpdateSiswa(siswa);
              } else {
                return const Text("Tidak Ada data");
              }
            }));
  }

  Widget buildUpdateSiswa(siswa) => Padding(
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
                  'Mengubah Data Siswa',
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
                    value: widget.jk,
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
                    updateSiswa(
                        nis: nisController.text,
                        nama: namaController.text,
                        kelas: kelasController.text,
                        jk: _valGender.toString());
                    Navigator.pop(context);
                  },
                  hint: 'Update',
                ),
              ],
            ),
          ))));
  Future updateSiswa(
      {required String nis,
      required String nama,
      required String kelas,
      required String jk}) async {
    final docSiswa =
        FirebaseFirestore.instance.collection('siswa').doc(widget.id);
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
  static Siswa fromJson(Map<String, dynamic> json) => Siswa(
        id: json['id'],
        nis: json['nis'],
        nama: json['nama'],
        kelas: json['kelas'],
        jk: json['jk'],
      );
}
