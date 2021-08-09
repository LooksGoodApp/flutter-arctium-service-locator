import 'package:arctium/arctium.dart';
import 'package:flutter/material.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class Base {
  final id = UniqueKey().toString();
}

class A extends Base {}

class B extends Base {}

class C extends Base implements Disposable {
  final List<String> link;
  C(this.link);

  @override
  void onDispose() => link.add(id);
}

void main() {
  group("Registering and locating services", () {
    test('Add and read a single service', () {
      final arctium = Arctium.create();
      final a = A();
      arctium.register(a);
      expect(arctium<A>().id, a.id);
    });

    test('Adding and reading two services of different classes', () {
      final arctium = Arctium.create();
      final a = A();
      final b = B();
      arctium.register(a);
      arctium.register(b);
      expect(arctium<A>().id, a.id);
      expect(arctium<B>().id, b.id);
    });

    test('Adding and reading two instances of the same class', () {
      final arctium = Arctium.create();
      final a1 = A();
      final a2 = A();
      arctium.register(a1);
      arctium.register(a2);
      expect(arctium<A>().id, a2.id);
    });

    test('Adding and reading a service under its parent class type', () {
      final arctium = Arctium.create();
      final a = A();
      arctium.register<Base>(a);
      expect(arctium<Base>().id, a.id);
    });
  });
  group('Removing services', () {
    test('Adding two services and removing the last one', () async {
      final arctium = Arctium.create();
      final a1 = A();
      final a2 = A();
      arctium.register(a1);
      arctium.register(a2);
      arctium.remove<A>();
      await Future.delayed(Duration.zero);
      expect(arctium<A>().id, a1.id);
    });
  });
  group('Disposing service', () {
    test('Disposing single service', () async {
      final arctium = Arctium.create();
      final link = <String>[];
      final c = C(link);
      arctium.register(c);
      arctium.remove<C>();
      await Future.delayed(Duration.zero);
      expect(link, [c.id]);
    });

    test('Disposing two services in a followed order', () async {
      final arctium = Arctium.create();
      final link = <String>[];
      final c1 = C(link);
      final c2 = C(link);
      arctium.register(c1);
      arctium.register(c2);
      arctium.remove<C>();
      arctium.remove<C>();
      await Future.delayed(Duration.zero);
      expect(link, [c2.id, c1.id]);
    });
  });

  group('Working with different instances', () {
    test('Registering the same object in two instances', () {
      final first = Arctium.create();
      final second = Arctium.create();
      final a = A();
      first.register(a);
      second.register(a);
      expect(a.id, first<A>().id);
      expect(a.id, second<A>().id);
    });

    test('Registering disposable service and disposing its locator', () async {
      final arctium = Arctium.create();
      final link = <String>[];
      final disposable = C(link);
      arctium.register(disposable);
      await arctium.onDispose();
      expect(link, [disposable.id]);
    });
  });
}
