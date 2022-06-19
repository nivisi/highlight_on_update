# highlight_on_update [![pub version][pub-version-img]][pub-version-url]

🔦 A Text widget that highlights itself when getting updated.

<img width=300 src="https://user-images.githubusercontent.com/33932162/174478855-dd13f305-ef44-4a00-b98e-198a1513d3ba.gif"/>

## Getting started

### pub

Add packages to pubspec.yaml:

```
dependencies:
  highlight_on_update:
```

### Use it!

```dart
Row(
  children: [
    const Text(
      'Current price: \$',
      style: TextStyle(fontSize: 20),
    ),
    HighlightOnUpdateText(
      _priceText, // This text will be highlighted when updated.
      style: const TextStyle(fontSize: 20),
    ),
  ],
),
```

For a show case, check the example.

<!-- References -->
[pub-version-img]: https://img.shields.io/badge/pub-v0.0.1-green
[pub-version-url]: https://pub.dev/packages/highlight_on_update