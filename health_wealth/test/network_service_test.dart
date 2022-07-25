import 'package:health_wealth/model/snack_api.dart';
import 'package:health_wealth/services/network_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'network_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Network Service', () {
    group('getSnackInfo', () {
      test(
          'returns a List of SnackAPIs if the http call completes successfully',
          () async {
        final mockClient = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(
                '{"items": [{"name": "test", "calories" : 0}]}', 200));

        final result = await NetworkService.getSnackInfo('Test', mockClient);

        expect(result, isA<List<SnackAPI>>());
      });
      test('returns null if the http call completes with an error ', () async {
        final mockClient = MockClient();

        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await NetworkService.getSnackInfo('Test', mockClient);

        expect(result, null);
      });
    });
  });
}
