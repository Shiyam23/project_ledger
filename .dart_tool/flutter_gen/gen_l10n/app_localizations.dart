import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @repetition.
  ///
  /// In en, this message translates to:
  /// **'Repetition'**
  String get repetition;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get see_more;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again!'**
  String get something_went_wrong;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @response_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get response_success;

  /// No description provided for @response_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get response_error;

  /// No description provided for @no_category_error.
  ///
  /// In en, this message translates to:
  /// **'No Categories available. Please create a category to add a new transaction!'**
  String get no_category_error;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @tab_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tab_overview;

  /// No description provided for @tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// No description provided for @tab_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tab_new;

  /// No description provided for @noRepetition.
  ///
  /// In en, this message translates to:
  /// **'No Repetition'**
  String get noRepetition;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @everyMonth.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get everyMonth;

  /// No description provided for @everyYear.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get everyYear;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @day_s.
  ///
  /// In en, this message translates to:
  /// **'day(s)'**
  String get day_s;

  /// No description provided for @month_s.
  ///
  /// In en, this message translates to:
  /// **'month(s)'**
  String get month_s;

  /// No description provided for @year_s.
  ///
  /// In en, this message translates to:
  /// **'year(s)'**
  String get year_s;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'until'**
  String get until;

  /// Label for 'Income/Expense' tab on the top of 'New Transaction' screen. Should be short to not force resize or wrap.
  ///
  /// In en, this message translates to:
  /// **'Income/Expense'**
  String get income_expense;

  /// Label for 'Reset' button on 'New Transaction' screen. Must be upper case if possible.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Label for 'Save as template' checkbox on 'New Transaction' screen
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get saveAsTemplate;

  /// Label for 'Name' textfield on 'New Transaction' screen
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameTextFieldLabel;

  /// Label for 'End date' textfield on 'New Transaction' screen
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// Label for 'Select Repetition' title on 'New Transaction' screen
  ///
  /// In en, this message translates to:
  /// **'Select Repetition'**
  String get selectRepetition;

  /// No description provided for @transaction_added.
  ///
  /// In en, this message translates to:
  /// **'Transaction added'**
  String get transaction_added;

  /// No description provided for @transaction_noname.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name!'**
  String get transaction_noname;

  /// No description provided for @transaction_nocategory.
  ///
  /// In en, this message translates to:
  /// **'Please choose a category!'**
  String get transaction_nocategory;

  /// No description provided for @transaction_nodate.
  ///
  /// In en, this message translates to:
  /// **'Please choose a date!'**
  String get transaction_nodate;

  /// No description provided for @transaction_noaccount.
  ///
  /// In en, this message translates to:
  /// **'Please choose an account!'**
  String get transaction_noaccount;

  /// No description provided for @transaction_general_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong! Please try again.'**
  String get transaction_general_error;

  /// No description provided for @repetition_number_error.
  ///
  /// In en, this message translates to:
  /// **'Please provide a number'**
  String get repetition_number_error;

  /// No description provided for @no_templates_available.
  ///
  /// In en, this message translates to:
  /// **'No templates available'**
  String get no_templates_available;

  /// Description for 'No template available on template screen which appears after clicking on the information button. The reference 'Save as template' should be consistent with 'saveAsNewTemplate' in this file.
  ///
  /// In en, this message translates to:
  /// **'Add new templates by creating a new transaction and checking the \"Save as template\" box.'**
  String get no_templates_available_description;

  /// No description provided for @delete_template.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get delete_template;

  /// No description provided for @delete_template_error_description.
  ///
  /// In en, this message translates to:
  /// **'Problem occured while deleting this template. Please try again!'**
  String get delete_template_error_description;

  /// No description provided for @no_repetition_available.
  ///
  /// In en, this message translates to:
  /// **'No repetition available'**
  String get no_repetition_available;

  /// Description for 'No repetition available on repetition screen which appears after clicking on the information button.
  ///
  /// In en, this message translates to:
  /// **'Create a new transaction and choose the corresponding repetition.'**
  String get no_repetition_available_description;

  /// No description provided for @no_transactions_yet.
  ///
  /// In en, this message translates to:
  /// **'No transactions available'**
  String get no_transactions_yet;

  /// No description provided for @create_invoice.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get create_invoice;

  /// No description provided for @top_five_categories.
  ///
  /// In en, this message translates to:
  /// **'Top 5 categories'**
  String get top_five_categories;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @create_backup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get create_backup;

  /// No description provided for @import_backup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get import_backup;

  /// No description provided for @creating_backup.
  ///
  /// In en, this message translates to:
  /// **'Creating backup'**
  String get creating_backup;

  /// No description provided for @importing_backup.
  ///
  /// In en, this message translates to:
  /// **'Importing backup'**
  String get importing_backup;

  /// No description provided for @backup_corrupted.
  ///
  /// In en, this message translates to:
  /// **'Backup File corrupted'**
  String get backup_corrupted;

  /// No description provided for @backup_corrupted_description.
  ///
  /// In en, this message translates to:
  /// **'The Backup File you chose is corrupted. Please choose another backup file.'**
  String get backup_corrupted_description;

  /// No description provided for @no_transactions_this_month.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this month'**
  String get no_transactions_this_month;

  /// No description provided for @ad.
  ///
  /// In en, this message translates to:
  /// **'Werbung'**
  String get ad;

  /// No description provided for @transactions_tab.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions_tab;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @view_mode.
  ///
  /// In en, this message translates to:
  /// **'View Mode'**
  String get view_mode;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @viewmode_list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewmode_list;

  /// No description provided for @viewmode_graph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get viewmode_graph;

  /// No description provided for @sort_date_desc.
  ///
  /// In en, this message translates to:
  /// **'Date descending'**
  String get sort_date_desc;

  /// No description provided for @sort_date_asc.
  ///
  /// In en, this message translates to:
  /// **'Date ascending'**
  String get sort_date_asc;

  /// No description provided for @sort_amount_desc.
  ///
  /// In en, this message translates to:
  /// **'Amount descending'**
  String get sort_amount_desc;

  /// No description provided for @sort_amount_asc.
  ///
  /// In en, this message translates to:
  /// **'Amount ascending'**
  String get sort_amount_asc;

  /// No description provided for @sort_name_desc.
  ///
  /// In en, this message translates to:
  /// **'Name descending'**
  String get sort_name_desc;

  /// No description provided for @sort_name_asc.
  ///
  /// In en, this message translates to:
  /// **'Name ascending'**
  String get sort_name_asc;

  /// No description provided for @sort_category_desc.
  ///
  /// In en, this message translates to:
  /// **'Category descending'**
  String get sort_category_desc;

  /// No description provided for @sort_category_asc.
  ///
  /// In en, this message translates to:
  /// **'Category ascending'**
  String get sort_category_asc;

  /// No description provided for @list_empty.
  ///
  /// In en, this message translates to:
  /// **'List of transactions is empty!'**
  String get list_empty;

  /// No description provided for @generating_invoice.
  ///
  /// In en, this message translates to:
  /// **'Generating invoice'**
  String get generating_invoice;

  /// No description provided for @category_chart.
  ///
  /// In en, this message translates to:
  /// **'Category Chart'**
  String get category_chart;

  /// No description provided for @delete_transaction_s.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction(s) ?'**
  String get delete_transaction_s;

  /// Information for the user for delete confirmation. This is the string shown before the number of selected transactions. Must not include space at the end.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that you want to delete the'**
  String get delete_transaction_description_prefix;

  /// Information for the user for delete confirmation. This is the string shown after the number of selected transactions. Must not include space in the beginning.
  ///
  /// In en, this message translates to:
  /// **'selected transaction(s)? This operation cannot be reversed!'**
  String get delete_transaction_description_suffix;

  /// No description provided for @edit_name.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get edit_name;

  /// No description provided for @change_category.
  ///
  /// In en, this message translates to:
  /// **'Change category'**
  String get change_category;

  /// No description provided for @change_date.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get change_date;

  /// No description provided for @change_amount.
  ///
  /// In en, this message translates to:
  /// **'Change amount'**
  String get change_amount;

  /// No description provided for @enter_new_name.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enter_new_name;

  /// No description provided for @new_amount.
  ///
  /// In en, this message translates to:
  /// **'New amount'**
  String get new_amount;

  /// No description provided for @only_one_edit_description.
  ///
  /// In en, this message translates to:
  /// **'You can only edit one transaction at a time.'**
  String get only_one_edit_description;

  /// No description provided for @empty_amount_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Empty amount not allowed'**
  String get empty_amount_not_allowed;

  /// No description provided for @required_format.
  ///
  /// In en, this message translates to:
  /// **'Format:'**
  String get required_format;

  /// No description provided for @loading_ad.
  ///
  /// In en, this message translates to:
  /// **'Loading ad'**
  String get loading_ad;

  /// No description provided for @no_transactions_available.
  ///
  /// In en, this message translates to:
  /// **'No transactions available'**
  String get no_transactions_available;

  /// No description provided for @no_transactions_available_description.
  ///
  /// In en, this message translates to:
  /// **'Please change the filter settings, the account or add new transactions.'**
  String get no_transactions_available_description;

  /// No description provided for @change_icon.
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get change_icon;

  /// No description provided for @new_name.
  ///
  /// In en, this message translates to:
  /// **'Enter a new name'**
  String get new_name;

  /// No description provided for @select_background.
  ///
  /// In en, this message translates to:
  /// **'Select background color'**
  String get select_background;

  /// No description provided for @select_icon.
  ///
  /// In en, this message translates to:
  /// **'Select icon'**
  String get select_icon;

  /// No description provided for @add_new_account.
  ///
  /// In en, this message translates to:
  /// **'Add new account'**
  String get add_new_account;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @delete_selected_account_description.
  ///
  /// In en, this message translates to:
  /// **'A selected account can not be deleted. Please select another account before deleting this.'**
  String get delete_selected_account_description;

  /// No description provided for @delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get delete_account_title;

  /// No description provided for @delete_account_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that you want to delete this account? All transactions associated with this account will be deleted permanently!'**
  String get delete_account_description;

  /// No description provided for @account_already_exists_title.
  ///
  /// In en, this message translates to:
  /// **'Account with this name already exists'**
  String get account_already_exists_title;

  /// No description provided for @account_already_exists_prefix.
  ///
  /// In en, this message translates to:
  /// **'You already have an account with the name '**
  String get account_already_exists_prefix;

  /// No description provided for @account_already_exists_suffix.
  ///
  /// In en, this message translates to:
  /// **'. You can not have two accounts with the same name.'**
  String get account_already_exists_suffix;

  /// No description provided for @account_template_name.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get account_template_name;

  /// No description provided for @account_already_exists.
  ///
  /// In en, this message translates to:
  /// **'An account with an identical name already exists.'**
  String get account_already_exists;

  /// No description provided for @currency_prefix.
  ///
  /// In en, this message translates to:
  /// **'Currency: '**
  String get currency_prefix;

  /// No description provided for @add_new_category.
  ///
  /// In en, this message translates to:
  /// **'Add new category'**
  String get add_new_category;

  /// No description provided for @delete_category.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get delete_category;

  /// No description provided for @category_template_name.
  ///
  /// In en, this message translates to:
  /// **'My Category'**
  String get category_template_name;

  /// No description provided for @category_already_exists.
  ///
  /// In en, this message translates to:
  /// **'A category with an identical name already exists.'**
  String get category_already_exists;

  /// No description provided for @category_already_exists_title.
  ///
  /// In en, this message translates to:
  /// **'Category with this name already exists'**
  String get category_already_exists_title;

  /// No description provided for @category_already_exists_prefix.
  ///
  /// In en, this message translates to:
  /// **'You already have a category with the name '**
  String get category_already_exists_prefix;

  /// No description provided for @category_already_exists_suffix.
  ///
  /// In en, this message translates to:
  /// **'. You can not have two categories with the same name.'**
  String get category_already_exists_suffix;

  /// No description provided for @delete_category_title.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get delete_category_title;

  /// No description provided for @delete_category_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that you want to delete this category? All transactions associated with this category will be deleted permanently!'**
  String get delete_category_description;

  /// No description provided for @repetition_tab.
  ///
  /// In en, this message translates to:
  /// **'Standing orders'**
  String get repetition_tab;

  /// No description provided for @repetition_details_title.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get repetition_details_title;

  /// No description provided for @repetition_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get repetition_name;

  /// No description provided for @repetition_starting_date.
  ///
  /// In en, this message translates to:
  /// **'Starting date:'**
  String get repetition_starting_date;

  /// No description provided for @repetition_next_due_date.
  ///
  /// In en, this message translates to:
  /// **'Next due date:'**
  String get repetition_next_due_date;

  /// No description provided for @repetition_end_date.
  ///
  /// In en, this message translates to:
  /// **'End date:'**
  String get repetition_end_date;

  /// No description provided for @repetition_total_transactions.
  ///
  /// In en, this message translates to:
  /// **'Total transactions:'**
  String get repetition_total_transactions;

  /// No description provided for @repetition_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total amount:'**
  String get repetition_total_amount;

  /// No description provided for @repetition_show_details.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get repetition_show_details;

  /// No description provided for @repetition_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete standing order'**
  String get repetition_delete;

  /// No description provided for @repetition_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete standing order?'**
  String get repetition_delete_title;

  /// No description provided for @repetition_delete_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that you want to delete this standing order? Transactions added by this standing order will not be deleted.'**
  String get repetition_delete_description;

  /// No description provided for @repetition_delete_error_description.
  ///
  /// In en, this message translates to:
  /// **'Problem occured while deleting this standing order. Please try again!'**
  String get repetition_delete_error_description;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @generated_by.
  ///
  /// In en, this message translates to:
  /// **'Generated by '**
  String get generated_by;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
