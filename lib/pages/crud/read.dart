import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Read extends StatefulWidget {
  const Read({super.key, required this.id});
  final String id;

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
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Colors.white //change your color here
                ),
        title: const Text(
          'Data Siswa',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
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
                : buildSiswa(siswa);
          } else {
            return const Text("Tidak Ada data");
          }
        },
      ),
    );
  }

  Widget buildSiswa(siswa) => Card(
          child: Column(
        children: [
          const SizedBox(height: 50),
          const Center(
              child: Text(
            'Data Siswa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          )),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                const Text(
                  "Nama",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 75),
                const Text(':  ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(siswa.nama,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                const Text(
                  "NIS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 90),
                const Text(':  ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(siswa.nis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                const Text(
                  "Jenis Kelamin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5),
                const Text(':  ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(siswa.jk,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                const Text(
                  "Kelas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 78),
                const Text(':  ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(siswa.kelas,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600))
              ],
            ),
          )
        ],
      ));
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

  static Siswa fromJson(Map<String, dynamic> json) => Siswa(
        id: json['id'],
        nis: json['nis'],
        nama: json['nama'],
        kelas: json['kelas'],
        jk: json['jk'],
      );
}
