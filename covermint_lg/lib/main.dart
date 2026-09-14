import 'package:flutter/material.dart';

import 'app_router.dart';
import 'core/api/dio_client.dart';
import 'core/auth/auth_state.dart';
import 'core/auth/auth_storage.dart';
import 'core/theme.dart';
import 'features/register/data/covermint_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = AuthStorage();
  final authState = AuthState(storage);
  await authState.restore();
  final repository = CovermintRepository(DioClient(authState).dio);
  runApp(CovermintApp(authState: authState, repository: repository));
}

class CovermintApp extends StatelessWidget {
  final AuthState authState;
  final CovermintRepository repository;

  const CovermintApp({
    super.key,
    required this.authState,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final router = createRouter(authState, repository);
    return MaterialApp.router(
      title: 'Covermint LG',
      debugShowCheckedModeBanner: false,
      theme: CovermintTheme.light,
      routerConfig: router,
    );
  }
}
