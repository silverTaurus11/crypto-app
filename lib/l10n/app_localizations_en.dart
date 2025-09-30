// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_title => 'Crypto Prices';

  @override
  String get favorite_title => 'Favorite Coins';

  @override
  String get currentPrice => 'Current Price';

  @override
  String get symbol => 'Symbol';

  @override
  String get rank => 'Rank';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get volume24h => 'Volume (24Hr)';

  @override
  String get change24h => 'Change (24Hr)';

  @override
  String get minutes15 => '15 Minutes';

  @override
  String get hour1 => '1 Hour';

  @override
  String get day1 => '1 Day';
}
