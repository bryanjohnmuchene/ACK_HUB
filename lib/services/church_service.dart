import '../src/auth/api_client.dart';

class ChurchService {
  final ApiClient _api = ApiClient();

  // ================= PROVINCES =================

  Future<List<Map<String, dynamic>>> getProvinces(
    String accessToken,
  ) async {
    return _api.getList(
      '/church/provinces',
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> createProvince(
    String name,
    String accessToken,
  ) async {
    return _api.post(
      '/church/provinces',
      {
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> updateProvince(
    String provinceId,
    String name,
    String accessToken,
  ) async {
    return _api.put(
      '/church/provinces/$provinceId',
      {
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> deleteProvince(
    String provinceId,
    String accessToken,
  ) async {
    return _api.delete(
      '/church/provinces/$provinceId',
      accessToken: accessToken,
    );
  }

  // ================= DIOCESES =================

  Future<List<Map<String, dynamic>>> getDioceses(
    String provinceId,
    String accessToken,
  ) async {
    return _api.getList(
      '/church/provinces/$provinceId/dioceses',
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> createDiocese(
    String provinceId,
    String name,
    String accessToken,
  ) async {
    return _api.post(
      '/church/dioceses',
      {
        'provinceId': provinceId,
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> updateDiocese(
    String dioceseId,
    String provinceId,
    String name,
    String accessToken,
  ) async {
    return _api.put(
      '/church/dioceses/$dioceseId',
      {
        'provinceId': provinceId,
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> deleteDiocese(
    String dioceseId,
    String accessToken,
  ) async {
    return _api.delete(
      '/church/dioceses/$dioceseId',
      accessToken: accessToken,
    );
  }

  // ================= PARISHES =================

  Future<List<Map<String, dynamic>>> getParishes(
    String dioceseId,
    String accessToken,
  ) async {
    return _api.getList(
      '/church/dioceses/$dioceseId/parishes',
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> createParish(
    String dioceseId,
    String name,
    String accessToken,
  ) async {
    return _api.post(
      '/church/parishes',
      {
        'dioceseId': dioceseId,
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> updateParish(
    String parishId,
    String dioceseId,
    String name,
    String accessToken,
  ) async {
    return _api.put(
      '/church/parishes/$parishId',
      {
        'dioceseId': dioceseId,
        'name': name,
      },
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> deleteParish(
    String parishId,
    String accessToken,
  ) async {
    return _api.delete(
      '/church/parishes/$parishId',
      accessToken: accessToken,
    );
  }
}