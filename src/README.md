# highlight_on_update [![pub version][pub-version-img]][pub-version-url]

🔦 A text widget that is getting highlighted when the text is updated.

<img width=300 src="https://user-images.githubusercontent.com/33932162/174478855-dd13f305-ef44-4a00-b98e-198a1513d3ba.gif"/>

## Example

Check out the [example](https://github.com/nivisi/highlight_on_update/blob/develop/src/example/lib/main.dart).

## Getting started

### pub

Add the package to pubspec.yaml:

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

_TODO: Describe params and theming..._

<!-- References -->
[pub-version-img]: https://img.shields.io/badge/pub-v0.0.1+3-0175c2?logo=flutter
[pub-version-url]: https://pub.dev/packages/highlight_on_update
