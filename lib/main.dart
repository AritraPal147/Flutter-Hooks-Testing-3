import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Removes all null values from an [Iterable] of any type.
///
/// calling [CompactMap] :
/// final values = [1, 2, null, 3];
/// final nonNullValues = values.compactMap(); -> will give an iterable [1, 2, 3]
/// final nonNullValues = values.compactMap((e) {
///   if (e != null && e > 10) { return e;}
///   else { return null;)
/// } -> conversion of iterable with conditions
extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>({E? Function(T?)? transform}) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Hooks Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

/// [url] is the url of a network image
const url = 'https://bit.ly/3qYOtDm';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [NetworkAssetBundle] Loads an image dynamically and
    /// gives the image back in the future.
    ///
    /// Images.network() does the same thing, but this format is used to
    /// demonstrate Flutter Hooks with Future
    ///
    /// [useFuture] does not persist the future in memory
    /// It just creates a Future for us and lets us consume that
    ///
    /// [useMemoized] stores the image in the cache and checks if the
    /// image is already in the cache or not.
    /// Basically creates a future and holds on to a complex object in cache
    final future = useMemoized(() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((data) => data.buffer.asUint8List())
        .then((data) => Image.memory(data)));

    /// [snapshot] actually consumes the future that is created by [useMemoized]
    final snapshot = useFuture(future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [snapshot.data].compactMap().toList(),
      ),
    );
  }
}
