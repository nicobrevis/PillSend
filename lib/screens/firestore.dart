import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getMedicamento() async {
  List<Map<String, dynamic>> medicamento = [];
  CollectionReference collectionReferenceMedicamento =
      database.collection('Medicamento');
  QuerySnapshot queryMedicamento = await collectionReferenceMedicamento.get();

  for (var documento in queryMedicamento.docs) {
    medicamento.add(documento.data() as Map<String, dynamic>);
  }

  return medicamento;
}

Future<void> addMedicamento(String name, String dosis, String frecuencia,
    String duracion, String inicio, String fin) async {
  await database.collection('Medicamento').add({
    'nombre': name,
    'dosis': dosis,
    'frecuencia': frecuencia,
    'duracion': duracion,
    'inicio': inicio,
    'final': fin,
  });
}

Future<List<Map<String, dynamic>>> getPaciente() async {
  List<Map<String, dynamic>> paciente = [];
  CollectionReference collectionReferencePaciente =
      database.collection('pacientes');
  QuerySnapshot queryPaciente = await collectionReferencePaciente.get();

  for (var documento in queryPaciente.docs) {
    paciente.add(documento.data() as Map<String, dynamic>);
  }

  return paciente;
}

Future<void> addPaciente(String nombre, String edad) async {
  await database.collection('pacientes').add({
    'nombre': nombre,
    'edad': edad,
  });
}

Future<List<Map<String, dynamic>>> getAdminRut() async {
  List<Map<String, dynamic>> rutList = [];
  CollectionReference collectionReferenceRut = database.collection('admin');
  QuerySnapshot queryRut = await collectionReferenceRut.get();

  for (var documento in queryRut.docs) {
    rutList.add(documento.data() as Map<String, dynamic>);
  }

  return rutList;
}

Future<List<Map<String, dynamic>>> getBarato() async {
  List<Map<String, dynamic>> barato = [];
  CollectionReference collectionReferenceBarato =
      database.collection('medicamentoBarato');
  QuerySnapshot queryBarato = await collectionReferenceBarato.get();

  for (var documento in queryBarato.docs) {
    barato.add(documento.data() as Map<String, dynamic>);
  }

  return barato;
}
