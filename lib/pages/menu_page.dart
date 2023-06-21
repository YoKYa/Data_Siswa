import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_siswa/pages/crud/create.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:data_siswa/pages/crud/read.dart';
import 'package:data_siswa/pages/crud/update.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'KELOLA DATA SISWA',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateWidget()),
            )
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder<List<Siswa>>(
            stream: readSiswa(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Ada kesalahan! ${snapshot.error}');
              } else if (snapshot.hasData) {
                final siswa = snapshot.data!;
                return ListView(
                  children: siswa.map(buildSiswa).toList(),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget buildSiswa(Siswa siswa) => Card(
          child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Text(siswa.nis)),
            title: Text(siswa.nama),
            subtitle: Text(siswa.kelas),
          ),
          const Divider(
            color: Colors.grey,
            height: 5,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Read(
                              id: siswa.id,
                            )),
                  );
                },
                icon: const Icon(Icons.remove_red_eye),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Update(
                            id: siswa.id,
                            nis: siswa.nis,
                            nama: siswa.nama,
                            kelas: siswa.kelas,
                            jk: siswa.jk)),
                  );
                },
                icon: const Icon(Icons.mode_edit_outline_outlined),
              ),
              IconButton(
                onPressed: () {
                  final docSiswa = FirebaseFirestore.instance
                      .collection('siswa')
                      .doc(siswa.id);
                  docSiswa.delete();
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          )
        ],
      ));

  Stream<List<Siswa>> readSiswa() => FirebaseFirestore.instance
      .collection('siswa')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Siswa.fromJson(doc.data())).toList());
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
