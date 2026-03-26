import 'network_models.dart';

abstract interface class NetworkClient {
  Future<NetworkResponse> execute(NetworkRequest request);
}
