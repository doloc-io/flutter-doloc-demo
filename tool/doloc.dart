import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final sourceFile = args.firstOrNull ?? 'lib/l10n/app_en.arb';
  final resultFile = args.skip(1).firstOrNull ?? 'lib/l10n/app_de.arb';
  final apiToken = args.skip(2).firstOrNull ?? Platform.environment['API_TOKEN'];
  if (apiToken == null) {
    stderr.writeln('Error: provide API_TOKEN as 3rd argument or environment variable!');
    exit(1);
  }

  final boundary = '----dartFormBoundary${DateTime.now().millisecondsSinceEpoch}';

  final body = StringBuffer();
  void addFilePart(String name, String filePath) {
    body
      ..write('--$boundary\r\n')
      ..write('Content-Disposition: form-data; name="$name"; filename="${filePath.split('/').last}"\r\n')
      ..write('Content-Type: application/octet-stream\r\n\r\n')
      ..write(utf8.decode(File(filePath).readAsBytesSync()))
      ..write('\r\n');
  }
  addFilePart('source', sourceFile);
  addFilePart('target', resultFile);
  body.write('--$boundary--\r\n');

  final request = await HttpClient().postUrl(Uri.parse('https://test.api.doloc.io'))
    ..headers.set(HttpHeaders.contentTypeHeader, 'multipart/form-data; boundary=$boundary')
    ..headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiToken')
    ..add(utf8.encode(body.toString()));

  final response = await request.close();
  if (response.statusCode == 200) {
    File(resultFile).writeAsBytesSync(await response.fold<List<int>>([], (p, e) => p..addAll(e)));
    print('result written to $resultFile');
  } else {
    stderr.writeln('Request failed with status: ${response.statusCode}');
    await response.transform(utf8.decoder).forEach(stderr.writeln);
    exit(2);
  }
}
