// import "package:fbdb/fbdb.dart";
//
// void main() async {
//   FbDb db = await FbDb.attach(
//     host: "localhost",
//     database: "employee",
//     user: "SYSDBA",
//     password: "masterkey",
//   );
//   final q = db.query();
//   await q.openCursor(
//     sql: "select FIRST_NAME, LAST_NAME "
//         "from EMPLOYEE "
//         "order by LAST_NAME "
//         "rows 10 ",
//   );
//   await for (var r in q.rows()) {
//     print("${r['LAST_NAME']}, ${r['FIRST_NAME']}");
//   }
//   await q.close();
//   await db.detach();
// }