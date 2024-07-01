import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor {
  var name: Text = "";
  public type StudentId = Nat32;

   public type Student = {
    firstName: Text;
    lastName: Text;
    age: Nat8;
    grado: Text;
    activo: Bool; 
  };

  // Inicializar la id alumno
  private stable var siguiente: StudentId = 0;
  //almacen de la infomación de los alumnos
  private stable var students: Trie.Trie<StudentId,Student> = Trie.empty();

// Crear alumno.
  public func newStudent(alumno : Student) : async  StudentId{
    let StudentId = siguiente;
    siguiente += 1;
    students := Trie.replace(
      students,
      key(StudentId), 
      Nat32.equal,
      ?alumno,
    ).0;
    return StudentId;
  };

 // Ver los estudiantes 
  public query func verStudent(studentId : StudentId) : async ?Student {
    let respuesta = Trie.find(students, key(studentId), Nat32.equal);
    return respuesta;
  };

    // Actualizar a los estudiambres.
  public func upStudent(studentId : StudentId, alumno : Student) : async Bool {
    let busqueda = Trie.find(students, key(studentId), Nat32.equal);
    let existe = Option.isSome(busqueda);
    if (existe) {
      students := Trie.replace(
        students,
        key(studentId),
        Nat32.equal,
        ?alumno,
      ).0;
    };
    return existe;
  };

// Borrar a estudiantes.
  public func deleteStudent(studentId : StudentId) : async Bool {
    let busqueda = Trie.find(students, key(studentId), Nat32.equal);
    let existe = Option.isSome(busqueda);
    if (existe) {
      students := Trie.replace(
        students,
        key(studentId),
        Nat32.equal,
        null,
      ).0;
    };
    return existe;
  };

  /**
   * Utilities
   */



  // Crea una clave trie a partir de un identificador de estudiante.

  private func key(x : StudentId) : Trie.Key<StudentId> {
    return { hash = x; key = x };
  };

};
