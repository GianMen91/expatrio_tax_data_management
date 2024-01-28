import 'dart:io';

import 'package:coding_challenge/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('LoginService tests', () {
    late LoginService loginService;

    setUp(() {
      loginService = LoginService();
    });

    test('Successful login should return true', () async {
      // Mock successful response
      http.Client client = MockHttpClient((request) async {
        return http.Response(
          json.encode({'accessToken': 'fakeToken', 'userId': 'fakeUserId'}),
          200,
        );
      });

      final result = await loginService.login('test@example.com', 'password', MockBuildContext(), client);

      expect(result, isTrue);
    });

    test('Unsuccessful login should return false', () async {
      // Mock unsuccessful response
      http.Client client = MockHttpClient((request) async {
        return http.Response(
          json.encode({'message': 'Invalid credentials'}),
          401,
        );
      });

      final result = await loginService.login('test@example.com', 'wrongPassword', MockBuildContext(), client);

      expect(result, isFalse);
    });

    test('SocketException should return false', () async {
      // Mock socket exception
      http.Client client = MockHttpClient((request) async {
        throw SocketException('No internet connection');
      });

      final result = await loginService.login('test@example.com', 'password', MockBuildContext(), client);

      expect(result, isFalse);
    });

  });
}

class MockHttpClient extends http.Client {
  final Future<http.Response> Function(http.Request request) sendFn;

  MockHttpClient(this.sendFn);

  @override
  Future<http.Response> send(http.BaseRequest request) {
    return sendFn(request as http.Request);
  }
}

class MockBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
