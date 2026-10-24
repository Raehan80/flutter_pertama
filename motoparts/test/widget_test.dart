import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:motoparts/app.dart';

void main() {
  testWidgets('user can sign in, navigate, and sign out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MotoPartsApp());

    expect(find.text('Selamat datang\nkembali.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'raka@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Raka 👋'), findsOneWidget);
    expect(find.text('Ringkasan toko'), findsOneWidget);

    await tester.tap(find.text('Produk').last);
    await tester.pumpAndSettle();
    expect(find.text('Katalog produk'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah password'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'password123');
    await tester.enterText(find.byType(TextFormField).at(1), 'newpassword123');
    await tester.enterText(find.byType(TextFormField).at(2), 'newpassword123');
    await tester.ensureVisible(find.text('Simpan password'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan password'));
    await tester.pumpAndSettle();

    expect(find.text('Atur password'), findsNothing);
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang\nkembali.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'newpassword123');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Raka 👋'), findsOneWidget);
  });
}
