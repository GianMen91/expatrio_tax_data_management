import 'package:coding_challenge/screens/tax_data_screen.dart';
import 'package:coding_challenge/services/tax_data_service.dart';
import 'package:coding_challenge/widgets/tax_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaxDataService extends Mock implements TaxDataService {}

void main() {
  group('TaxDataScreen tests', () {
    late TaxDataScreen taxDataScreen;
    late MockTaxDataService mockTaxDataService;

    setUp(() {
      mockTaxDataService = MockTaxDataService();
      taxDataScreen = TaxDataScreen(
        accessToken: 'fakeToken',
        customerId: 1,
      );
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: taxDataScreen));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.text("Uh-Oh!"), findsOneWidget);
      expect(find.text("We need your tax data for you to access your account."), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Update Tax Data button triggers modal', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: taxDataScreen));

      // Mock the TaxDataService
      when(mockTaxDataService.getTaxData(any, any)).thenAnswer((_) async => []);

      // Tap the "UPDATE YOUR TAX DATA" button
      await tester.tap(find.text('UPDATE YOUR TAX DATA'));
      await tester.pumpAndSettle();

      // Verify that the TaxDataService was called
      verify(mockTaxDataService.getTaxData(any, any)).called(1);

      // Verify that the modal bottom sheet is displayed
      expect(find.byType(ModalBottomSheet), findsOneWidget);

    });
  });
}
