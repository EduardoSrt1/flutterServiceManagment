// lib/main.dart
import 'package:atendimentos_app/core/injection.dart';
import 'package:atendimentos_app/presentation/pages/create_page.dart';
import 'package:atendimentos_app/presentation/pages/details_page.dart';
import 'package:atendimentos_app/presentation/pages/list_page.dart';
import 'package:atendimentos_app/presentation/pages/perform_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/cubits/atendimento_cubit.dart';

import 'domain/entity/atendimento.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura TODAS as dependências (incluindo SqliteDataSource)
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atendimentos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (context) => getIt<AtendimentoCubit>()..loadAtendimentos(),
        child: const AtendimentoListPage(),
      ),
      routes: {
        '/list': (context) => BlocProvider(
              create: (context) =>
                  getIt<AtendimentoCubit>()..loadAtendimentos(),
              child: const AtendimentoListPage(),
            ),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/create':
            final atendimento = settings.arguments as Atendimento?;
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => getIt<AtendimentoCubit>(),
                child: CreateAtendimentoPage(atendimento: atendimento),
              ),
            );

          case '/edit':
            final atendimento = settings.arguments as Atendimento?;
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => getIt<AtendimentoCubit>(),
                child: CreateAtendimentoPage(atendimento: atendimento),
              ),
            );

          case '/details':
            final atendimento = settings.arguments as Atendimento;
            return MaterialPageRoute(
              builder: (context) => AtendimentoDetailsPage(
                atendimento: atendimento,
              ),
            );

          case '/perform':
            final atendimento = settings.arguments as Atendimento;
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => getIt<AtendimentoCubit>(),
                child: PerformAtendimentoPage(atendimento: atendimento),
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
