import 'package:frontend/model/response/token_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final _tableName = "token";
  final accessToken = "accessToken";
  final refreshToken = "refreshToken";
  final userId = "userId";
  final roleId = "roleId";
  final exp = "exp";

  Future<Database> getDatabase() async {
    final authDB = openDatabase(
      join(await getDatabasesPath(), 'token.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName($accessToken TEXT, $refreshToken TEXT, $exp INTEGER, $userId INTEGER, $roleId INTEGER)
        ''');
        return;
      },
      version: 1,
    );

    return authDB;
  }

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
      userId: tokenMaps[0][userId] as int,
      roleId: tokenMaps[0][roleId] as int,
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
