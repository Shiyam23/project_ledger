import 'dart:io';
import 'package:flutter/material.dart' show BuildContext, Color;
import 'package:flutter/services.dart';
import 'package:better_open_file/better_open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dollavu/models/currencies.dart';
import 'package:dollavu/services/DateTimeFormatter.dart';
import 'package:printing/printing.dart';
import '../../models/Transaction.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Invoice {
  Invoice({
    required this.transactions,
    required Color color
  }) : 
  color = PdfColor.fromInt(color.value),
  lightColor = PdfColor.fromInt(0xFF577691);

  final List<Transaction> transactions;
  final PdfColor color;
  final PdfColor lightColor;

  static const _darkColor = PdfColors.blueGrey800;

  double get _totalExpenses => transactions
    .where((t) => t.isExpense)
    .map((t) => t.amount)
    .fold<double>(0, (a,b) => a + b) * -1;

  double get _totalIncomes => transactions
    .where((t) => !t.isExpense)
    .map((t) => t.amount)
    .fold<double>(0, (a,b) => a + b);

  double get _total => _totalIncomes + _totalExpenses;

  String get currencyCode => transactions.first.account.currencyCode;

  double get _grandTotal => _total;

  late final pw.Font pacifico;
  late final pw.Font fontawesome;
  late final PdfPageFormat pageFormat;

  Future<Uint8List> _buildPdf(BuildContext materialContext) async {
    // Create a PDF document.
    final doc = pw.Document();

    pacifico = await PdfGoogleFonts.pacificoRegular();
    final Uint8List fontData = (await rootBundle.load("assets/fa-solid-900.ttf")).buffer.asUint8List() ;
    fontawesome = pw.Font.ttf(fontData.buffer.asByteData());
    final double cm = PdfPageFormat.cm;
    
    pageFormat = PdfPageFormat(
      21.0 * cm, 29.7 * cm, 
      marginTop: 0,
      marginBottom: 1 * cm,
      marginLeft: 0,
      marginRight: 0,
    );

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: (context) => _buildHeader(context, materialContext),
        footer: (context) => _buildFooter(context, materialContext),
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        build: (context) => [
          _contentTable(context, materialContext),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context, BuildContext materialContext) {
    return pw.Column(
      children: [
        pw.CustomPaint(
          painter: _topPainter,
          size: PdfPoint(pageFormat.width, 6 * PdfPageFormat.cm),
          child: pw.SizedBox(
            width: pageFormat.width,
            height: 6 * PdfPageFormat.cm,
            child: pw.Transform.translate(
              offset: PdfPoint(1.5 * PdfPageFormat.cm, - 1 * PdfPageFormat.cm),
              child: pw.Text(
                'Dollavu',
                tightBounds: true,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  font: pacifico,
                  fontSize: 50,
                )
              )
            )
          )
        ),
        _getTitle(context, materialContext),
        pw.SizedBox(height: 1 * PdfPageFormat.cm)
      ],
    );
  }

  pw.Widget _getTitle(pw.Context context, BuildContext materialContext) {
    pw.Widget sideInformation = _getSideInformation(context, materialContext);
    if (context.pageNumber == 1) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              AppLocalizations.of(materialContext)!.invoice.toUpperCase(),
              tightBounds: true,
              style: pw.TextStyle(
                color: color,
                fontWeight: pw.FontWeight.bold,
                fontSize: 40,
              )
            ),
            sideInformation
          ]
        )
      );
    } else {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: pw.EdgeInsets.only(right: 2 * PdfPageFormat.cm),
        child: sideInformation
      );
    }
  }

  pw.Widget _buildFooter(pw.Context context, BuildContext materialContext) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(right: 2 * PdfPageFormat.cm),
      child: pw.Expanded(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                text: AppLocalizations.of(materialContext)!.generated_by,
                children: [
                  pw.TextSpan(
                    text: "Dollavu",
                    style: pw.TextStyle(
                      font: pacifico
                    )
                  )
                ]
              ),
              textAlign: pw.TextAlign.right,
            ),
          ]
        )
      )
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.SizedBox(
      width: pageFormat.width - PdfPageFormat.cm * 4,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 10,
                color: _darkColor,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Income:'),
                      pw.Text(_formatCurrency(_totalIncomes)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Expense:'),
                      pw.Text(_formatCurrency(_totalExpenses)),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Divider(color: color),
                  pw.DefaultTextStyle(
                    style: pw.TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total:'),
                        pw.Text(_formatCurrency(_grandTotal)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  pw.Widget _contentTable(pw.Context context, BuildContext materialContext) {
    var tableHeaders = [
      AppLocalizations.of(materialContext)!.nameTextFieldLabel,
      AppLocalizations.of(materialContext)!.date,
      AppLocalizations.of(materialContext)!.category,
      AppLocalizations.of(materialContext)!.account,
      AppLocalizations.of(materialContext)!.amount
    ];

    return pw.SizedBox(
      width: pageFormat.width - 4 * PdfPageFormat.cm,
      child: pw.Table(
        border: null,
        children: [
          pw.TableRow(
            repeat: true,
            decoration: pw.BoxDecoration(
              color: color
            ),
            children: tableHeaders.map((e) => 
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(
                  e,
                  textAlign: e ==  AppLocalizations.of(materialContext)!.amount ? 
                    pw.TextAlign.right : pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                  )
                )
              )
            ).toList()
          ),
          ...transactions.map((t) {
            pw.EdgeInsets padding = pw.EdgeInsets.symmetric(vertical: 15, horizontal: 5);
            pw.Icon categoryIcon = pw.Icon(
              pw.IconData(t.category.icon!.iconData.icon!.codePoint),
              font: fontawesome,
              color: PdfColors.white,
              size: 10
            );
            int categoryBackgroundColor = t.category.icon!.iconData.backgroundColorInt ?? color.toInt();
            pw.Icon accountIcon = pw.Icon(
              pw.IconData(t.account.icon.iconData.icon!.codePoint),
              font: fontawesome,
              color: PdfColors.white,
              size: 10
            );
            int accountBackgroundColor = t.account.icon.iconData.backgroundColorInt ?? color.toInt();
            return pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: lightColor
                  ),
                )
              ),
              children: [
                pw.Padding(
                  padding: padding,
                  child: pw.Text(t.name)
                ),
                pw.Padding(
                  padding: padding,
                  child: pw.Text(t.date.format()),
                ),
                pw.Padding(
                  padding: padding,
                  child: pw.Row(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.zero,
                        height: 20,
                        width: 20,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: PdfColor.fromInt(categoryBackgroundColor)
                        ),
                        child: categoryIcon
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(t.category.name!)
                    ],
                  )
                ),
                pw.Padding(
                  padding: padding,
                  child: pw.Row(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.zero,
                        height: 20,
                        width: 20,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: PdfColor.fromInt(accountBackgroundColor)
                        ),
                        child: accountIcon
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(t.account.name)
                    ],
                  )
                ),
                pw.Padding(
                  padding: padding,
                  child: pw.Expanded(
                    child: pw.Text(
                      _formatCurrency(t.amount, t.isExpense),
                      textAlign: pw.TextAlign.right
                    )
                  )
                ),
              ]
            );
          }).toList()
        ]
      )
    );
  }

  String _formatCurrency(double amount, [bool? isExpense]) {
  if (isExpense == null) isExpense = amount < 0;
  return (isExpense ? "- " : "+ ") + formatCurrency(currencyCode, amount.abs());
  }

  Future<void> openInvoice(BuildContext materialContext) async {
    Directory temp = await getTemporaryDirectory();
    final file = File("${temp.path}/example.pdf");
    Uint8List pdfData = await this._buildPdf(materialContext);
    await file.writeAsBytes(pdfData);
    OpenFile.open('${temp.path}/example.pdf');
  }

  _topPainter(PdfGraphics canvas, PdfPoint size) {
    canvas
      ..saveContext()
      ..setFillColor(color)
      ..moveTo(0, size.y / 2)
      ..curveTo(size.x / 5, size.y * 0, size.x/2, size.y * 0.75, size.x, size.y/2)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..closePath()
      ..fillPath()
      ..restoreContext();
  }

  pw.Widget _getSideInformation(pw.Context context, BuildContext materialContext) {
    return pw.DefaultTextStyle(
      style: pw.TextStyle(
        color: color,
        fontSize: 15,
      ),
      child: pw.Table(
        tableWidth: pw.TableWidth.min,
        border: null,
        children: [
          pw.TableRow(
            children: [
              pw.Text( AppLocalizations.of(materialContext)!.date
                , textAlign: pw.TextAlign.right),
              pw.SizedBox(width: 10),
              pw.Text(DateTime.now().format(), textAlign: pw.TextAlign.right)
            ]
          ),
          pw.TableRow(
            children: [
              pw.Text(AppLocalizations.of(materialContext)!.page
                , textAlign: pw.TextAlign.right),
              pw.SizedBox(width: 10),
              pw.Text(
                '${context.pageNumber.toString()}/${context.pagesCount.toString()}',
                textAlign: pw.TextAlign.right
              )
            ]
          )
        ]
      )
    );
  }
}

