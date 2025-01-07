import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_challenge/src/modules/tasks/data/repositories/task_hive_repository_impl.dart';
import 'package:task_challenge/src/modules/tasks/domain/models/search_task_filter_model.dart';
import 'package:task_challenge/src/modules/tasks/domain/models/task_model.dart';
import 'package:uuid/uuid.dart';

import 'task_hive_repository_impl_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  String hiveBoxName = 'tasks';
  var searchFilter = SearchTaskFilterModel();

  late final MockHiveInterface mockHiveInterface;
  late final MockBox mockHiveBox;
  late final TaskHiveRepositoryImpl repository;

  final tasks = [
    TaskModel(
      id: Uuid().v4(),
      title: 'Escrever testes unitários',
      description: 'Escreva testes unitários para a aplicação.',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Escrever testes de integração',
      description: 'Escreva testes de integração para a aplicação.',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Escrever testes de widget',
      description: 'Escreva testes de widget para a aplicação.',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Escrever testes de UI',
      description: 'Escreva testes de UI para a aplicação.',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Escrever testes de e2e',
      description: 'Escreva testes de e2e para a aplicação.',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar documentação da arquitetura do projeto',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Refatorar código',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Implementar Firebase Crashlytics',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Implementar Firebase Analytics',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Implementar Autenticação',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Implementar GoRouter',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar injeção de dependência',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar Dark Mode',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Corrigir responsividade',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de responsividade',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de performance',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de acessibilidade',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de SEO',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de segurança',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de internacionalização',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de localização',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de cache',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de banco de dados',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de rede',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de notificações',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de push notifications',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de background fetch',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de background sync',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de geolocalização',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de câmera',
      finished: false,
    ),
    TaskModel(
      id: Uuid().v4(),
      title: 'Criar testes de galeria',
      finished: false,
    ),
  ];

  setUpAll(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockBox();
    repository = TaskHiveRepositoryImpl(hive: mockHiveInterface);

    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockHiveBox);
  });

  test('Should get all cached tasks on page 1', () async {
    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockHiveBox);

    when(mockHiveBox.get(any, defaultValue: anyNamed('defaultValue')))
        .thenReturn(jsonEncode(tasks.map((e) => e.toJson()).toList()));

    final response = await repository.fetch(
      filter: searchFilter,
    );

    final result = response.getOrNull();

    expect(response.isSuccess(), true);
    expect(result!.data,
        tasks.skip(searchFilter.skip).take(searchFilter.pageSize));
    expect(result.pageNumber, searchFilter.pageNumber);
    expect(result.pageSize, searchFilter.pageSize);
    verify(mockHiveInterface.openBox(hiveBoxName));
  });

  test('Should get all cached tasks on page 2', () async {
    searchFilter = searchFilter.copyWith(
      pageNumber: 2,
    );

    when(mockHiveBox.get(any, defaultValue: anyNamed('defaultValue')))
        .thenReturn(jsonEncode(tasks.map((e) => e.toJson()).toList()));

    final response = await repository.fetch(
      filter: searchFilter,
    );

    final result = response.getOrNull();

    expect(response.isSuccess(), true);
    expect(result!.data,
        tasks.skip(searchFilter.skip).take(searchFilter.pageSize));
    expect(result.pageNumber, searchFilter.pageNumber);
    expect(result.pageSize, searchFilter.pageSize);
    verify(mockHiveInterface.openBox(hiveBoxName));
  });

  test('Should insert the task into the cache', () async {
    when(mockHiveBox.get(any, defaultValue: anyNamed('defaultValue')))
        .thenReturn(jsonEncode(tasks.map((e) => e.toJson()).toList()));

    when(mockHiveBox.put(any, any)).thenAnswer((_) => Future.value());

    final task = TaskModel(
      id: Uuid().v4(),
      title: 'Title',
      finished: false,
    );

    final response = await repository.insert(task);

    expect(response.isSuccess(), true);
    verify(mockHiveBox.put('tasks', any)).called(1);
    verify(mockHiveInterface.openBox(hiveBoxName));
  });

  test('Should update task in cache', () async {
    when(mockHiveBox.get(any, defaultValue: anyNamed('defaultValue')))
        .thenReturn(jsonEncode(tasks.map((e) => e.toJson()).toList()));

    when(mockHiveBox.put(any, any)).thenAnswer((_) => Future.value());

    final updatedTask = tasks.first.copyWith(
      finished: true,
    );

    final response = await repository.update(updatedTask);

    final result = response.getOrNull();

    expect(response.isSuccess(), true);
    expect(result, updatedTask);
    verify(mockHiveBox.put('tasks', any)).called(1);
    verify(mockHiveInterface.openBox(hiveBoxName));
  });

  test('Should throw an exception if you try to update a non-existent task',
      () async {
    when(mockHiveBox.get(any, defaultValue: anyNamed('defaultValue')))
        .thenReturn(jsonEncode(tasks.map((e) => e.toJson()).toList()));

    when(mockHiveBox.put(any, any)).thenAnswer((_) => Future.value());

    final updatedTask = tasks.first.copyWith(
      id: 'invalid_id',
      finished: true,
    );

    final response = await repository.update(updatedTask);

    expect(response.isError(), true);
    verifyNever(mockHiveBox.put('tasks', any));
    verify(mockHiveInterface.openBox(hiveBoxName));
  });
}
