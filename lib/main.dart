import 'dart:io';
import 'package:agora_token_service/agora_token_service.dart';

void main() async {
  // Crie um servidor HTTP
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  // Imprima o endereço e a porta do servidor
  print('Listening on ${server.address}:${server.port}');

  // Defina o manipulador de solicitação
  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  // Verifique se a solicitação é para a rota '/fetchToken'
  if (request.uri.path == '/fetchToken') {
    final appId = 'f45114030e0e449e990f4af741bf393c';
    final appCertificate = 'cddac3768f824ddc9c4cdd7d03fad282';
    final channelName = 'ToNaRede';
    final uid = '0';
    final role = RtcRole.publisher;

    final expirationInSeconds = 3600;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTimestamp = currentTimestamp + expirationInSeconds;

    final token = RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      uid: uid,
      role: role,
      expireTimestamp: expireTimestamp,
    );

    // Defina o cabeçalho de resposta
    request.response.headers.contentType = ContentType.json;

    // Envie o token como resposta
    request.response.write('{"token": "$token"}');

    // Feche a resposta
    request.response.close();
  } else {
    // Se a solicitação não for para '/fetchToken', retorne um erro 404
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('Not Found');
    request.response.close();
  }
}
