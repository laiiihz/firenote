import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get add_group => "add group";
  String get all_group => "GROUP ALL";
  String get appName => "FireNote";
  String get blue => "blue";
  String get blue_grey => "blue_grey";
  String get blue_with_green => "blue_with_green";
  String get choose_color => "choose color";
  String get clear_all_note => "clear all note";
  String get create_note => "new note";
  String get create_time_pre => "create time:";
  String get dark_orange => "dark_orange";
  String get deep_purple => "deep_purple";
  String get enter_title => "ENTER TITLE";
  String get experiment_settings => "experiment_settings";
  String get green => "green";
  String get grey => "grey";
  String get honey => "honey";
  String get immersive_mode => "IMMERSIVE MODE";
  String get immersive_mode_off => "IMMERSIVE MODE OFF";
  String get immersive_mode_on => "IMMERSIVE MODE ON";
  String get light_blue => "light_blue";
  String get light_green => "light_green";
  String get lime => "lime";
  String get new_text => "Right Bottom Start New Note";
  String get night_mode => "NIGHT MODE";
  String get night_mode_off => "NIGHT MODE OFF";
  String get night_mode_on => "NIGHT MODE ON";
  String get nulls => "NULL";
  String get orange => "orange";
  String get pink => "pink";
  String get pop_about => "About";
  String get pop_menu => "Menu";
  String get pop_settings => "Settings";
  String get red => "red";
  String get reminder_time => "reminder time:";
  String get smile => "^_^";
  String get teal => "teal";
  String get theme_color => "Theme Color";
  String get title_note => "TITLE";
  String get update_note => "update note";
  String get update_time => "update time:";
  String get welcome_and_use => "Welcome";
}

class $en extends S {
  const $en();
}

class $zh extends S {
  const $zh();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get theme_color => "主题色";
  @override
  String get pink => "粉色";
  @override
  String get immersive_mode_on => "开启沉浸模式";
  @override
  String get create_time_pre => "创建时间:";
  @override
  String get create_note => "新建备忘";
  @override
  String get nulls => "不可用";
  @override
  String get night_mode => "夜间模式";
  @override
  String get blue_grey => "蓝灰色";
  @override
  String get smile => "^_^";
  @override
  String get red => "红色";
  @override
  String get clear_all_note => "清除所有备忘";
  @override
  String get update_time => "更新时间:";
  @override
  String get welcome_and_use => "欢迎使用";
  @override
  String get honey => "蜂蜜色";
  @override
  String get dark_orange => "深橘色";
  @override
  String get experiment_settings => "实验性功能";
  @override
  String get reminder_time => "提醒时间:";
  @override
  String get night_mode_on => "开启夜间模式";
  @override
  String get green => "绿色";
  @override
  String get choose_color => "选择颜色";
  @override
  String get appName => "FireNote";
  @override
  String get lime => "lime";
  @override
  String get blue_with_green => "蓝绿色";
  @override
  String get update_note => "更新备忘";
  @override
  String get deep_purple => "深紫色";
  @override
  String get enter_title => "输入你的标题";
  @override
  String get light_blue => "亮蓝色";
  @override
  String get teal => "靛青";
  @override
  String get all_group => "所有";
  @override
  String get pop_menu => "菜单";
  @override
  String get grey => "灰色";
  @override
  String get orange => "橘色";
  @override
  String get title_note => "标题";
  @override
  String get pop_about => "关于";
  @override
  String get add_group => "添加分组";
  @override
  String get new_text => "右下角点击开始新建";
  @override
  String get immersive_mode => "沉浸模式";
  @override
  String get blue => "蓝色";
  @override
  String get night_mode_off => "关闭夜间模式";
  @override
  String get light_green => "亮绿色";
  @override
  String get immersive_mode_off => "关闭沉浸模式";
  @override
  String get pop_settings => "设置";
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", ""),
      Locale("zh", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          return SynchronousFuture<S>(const $en());
        case "zh":
          return SynchronousFuture<S>(const $zh());
        default:
          // NO-OP.
      }
    }
    return SynchronousFuture<S>(const S());
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
