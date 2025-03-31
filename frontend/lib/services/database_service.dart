import 'package:frontend/model/response/token_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final _tableName = "token";
  final _sessionTable = "session";
  final accessToken = "accessToken";
  final refreshToken = "refreshToken";
  final exp = "exp";
  final mapboxSessionId = "mapboxSessionId";

  Future<Database> getDatabase() async {
    final authDB = openDatabase(
      join(await getDatabasesPath(), 'token.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName($accessToken TEXT, $refreshToken TEXT, $exp INTEGER)
        ''');

        // await db.execute("CREATE TABLE $_sessionTable($mapboxSessionId TEXT)");

        // await db.insert(
        //   _sessionTable,
        //   {mapboxSessionId: Uuid().v4()},
        //   conflictAlgorithm: ConflictAlgorithm.replace,
        // );
        return;
      },
      version: 1,
    );

    return authDB;
  }

  // Future<String> getMapboxSession() async {
  //   final db = await getDatabase();
  //   List<Map<String, Object?>> sessionMaps =
  //       await db.query(_sessionTable, limit: 1);

  //   if (sessionMaps.isEmpty) {
  //     return Future.error("Session is empty");
  //   }

  //   return sessionMaps[0][mapboxSessionId] as String;
  // }

  Future<TokenResponse> getToken() async {
    final db = await getDatabase();

    List<Map<String, Object?>> tokenMaps = await db.query(_tableName, limit: 1);

    if (tokenMaps.isEmpty) {
      return Future.error("Session expired");
    }

    return TokenResponse(
      accessToken: tokenMaps[0][accessToken] as String,
      refreshToken: tokenMaps[0][refreshToken] as String,
      expiryDate: tokenMaps[0][exp] as int,
    );
  }

  Future<void> insert(TokenResponse token) async {
    final db = await getDatabase();

    await db.delete(_tableName);

    await db.insert(
      _tableName,
      token.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final db = await getDatabase();

    await db.delete(_tableName);
  }
}
