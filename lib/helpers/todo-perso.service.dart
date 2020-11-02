import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TodoPersoService {
  static String url = '/url_des_todos_de_la_liste_perso';

  static Future getApiUrl() async {
    await DotEnv().load('.env');
    return DotEnv().env['API_URL'] + url;
  }

  static Future addTodoPerso(body) async {
    String url = await getApiUrl();
    return await http.post(url);
  }
}
