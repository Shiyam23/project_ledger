import 'package:flutter/material.dart' show Color, Brightness, ColorScheme, TextTheme, ThemeData, TextStyle;

class LightTheme {
  LightTheme._();

  // Static color names for light theme

  static const Color grey = Color(0xff2f3840);
  static const Color darkGrey = Color(0xff23292f);

  static const Color white = Color(0xfff0f1f5);
  static const Color darkWhite = Color(0xffdcdfe8);

  static const Color red = Color(0xffa6001c);

  // ColorScheme arguments associated to color names

  static const Color primary = grey;
  static const Color primaryVariant = darkGrey;

  static const Color secondary = white;
  static const Color secondaryVariant = darkWhite;

  static const Color surface = darkWhite;
  static const Color background = white;

  static const Color error = red;

  static const Color onPrimary = white;
  static const Color onSecondary = grey;

  static const Color onSurface = darkGrey;
  static const Color onBackground = grey;

  static const Color onError = white;

  static const Brightness brightness = Brightness.light;

  // ColorScheme from arguments

  static const ColorScheme colorScheme = ColorScheme(
    primary: primary,
    primaryVariant: primaryVariant,

    secondary: secondary,
    secondaryVariant: secondaryVariant,

    surface: surface,

    background: background,

    error: error,

    onPrimary: onPrimary,
    onSecondary: onSecondary,

    onSurface: onSurface,
    onBackground: onBackground,

    onError: onError,

    brightness: brightness,
  );

  // TextStyles

  static const TextStyle display4 = TextStyle();
  static const TextStyle display3 = TextStyle();
  static const TextStyle display2 = TextStyle();
  static const TextStyle display1 = TextStyle();

  static const TextStyle headline = TextStyle();

  static const TextStyle title = TextStyle();

  static const TextStyle subhead = TextStyle();

  static const TextStyle body2 = TextStyle();
  static const TextStyle body1 = TextStyle();

  static const TextStyle caption = TextStyle();

  static const TextStyle button = TextStyle();

  static const TextStyle overline = TextStyle();

  static const TextStyle subtitle = TextStyle();

  // TextTheme from TextStyles

  static const TextTheme textTheme = TextTheme(
    display4: display4,
    display3: display3,
    display2: display2,
    display1: display1,

    headline: headline,

    title: title,

    subhead: subhead,

    body2: body2,
    body1: body1,

    caption: caption,

    button: button,

    subtitle: subtitle,

    overline: overline,
  );

  // ThemeData from colorScheme and textTheme

  static ThemeData get themeData => ThemeData.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      );
}
