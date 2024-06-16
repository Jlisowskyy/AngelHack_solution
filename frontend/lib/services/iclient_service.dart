abstract class IClientService {
  Future<dynamic> getRequest(String endpoint);
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body);
}
