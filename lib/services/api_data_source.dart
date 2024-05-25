import 'base_network.dart';
import '../model/kopi_model.dart';

class ApiDataSource {
  static final ApiDataSource _instance = ApiDataSource._internal();

  factory ApiDataSource() {
    return _instance;
  }

  ApiDataSource._internal();

  Future<Map<String, dynamic>> loadCategory() async {
    return await BaseNetwork.get("/categories");
  }

  Future<Map<String, dynamic>> loadFilter(String id) async {
    return await BaseNetwork.get("/filter?c=$id");
  }

  Future<Map<String, dynamic>> loadLookup(String id) async {
    return await BaseNetwork.get("/lookup?i=$id");
  }

  Future<List<JenisKopi>> loadKopis() async {
    final response = await BaseNetwork.get("/kopis");
    if (response.containsKey('data')) {
      final List<dynamic> kopisJson = response['data'];
      return kopisJson.map((json) => JenisKopi.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load kopis");
    }
  }
}
