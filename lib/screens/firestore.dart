import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore database = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

/*Future<String?> buscarUsuarioPorNombre(String nombre) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si encontramos un usuario con el nombre dado, retornamos su email
        return querySnapshot.docs[0]['email'];
      } else {
        // Si no se encontró ningún usuario con el nombre dado
        return null;
      }
    } else {
      // Si el usuario no está autenticado
      return null;
    }
  } catch (e) {
    // Manejar errores si los hay
    print('Error al buscar usuario: $e');
    return null;
  }
}*/

Future<void> asociarDatosAUsuario( String email, String rut) async {
  User? user = auth.currentUser;
  if (user != null) {
    String uid = user.uid;
    try {
      // Crear un documento en la colección 'usuarios' con el UID como identificador
      await database.collection('usuarios').doc(uid).set({
        
        'email': email,
        'rut':rut
        // Puedes agregar más campos según tus necesidades
      });
      print('Datos asociados al usuario con UID: $uid');
    } catch (e) {
      print('Error al asociar datos al usuario: $e');
    }
  } else {
    print('Usuario no autenticado');
  }
}

Future<List<Map<String, dynamic>>> getMedicamento() async {
  List<Map<String, dynamic>> medicamento = [];
  CollectionReference collectionReferenceMedicamento =
      database.collection('rutRegistro');
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
  CollectionReference collectionReferenceRut = database.collection('rutRegistro');
  QuerySnapshot queryRut = await collectionReferenceRut.get();

  for (var documento in queryRut.docs) {
    rutList.add(documento.data() as Map<String, dynamic>);
  }

  return rutList;
}

Future<List<Map<String, dynamic>>> getCorreo() async {
  List<Map<String, dynamic>> rutList = [];
  CollectionReference collectionReferenceRut = database.collection('rutRegistro');
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
