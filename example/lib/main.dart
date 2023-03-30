import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:text_to_pdf/text_to_pdf.dart';
// import 'package:text_to_pdf/text_to_pdf.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? file;

  generatePdf() async {
    final content = await rootBundle.loadString('assets/content.txt');
    final fontData = await rootBundle.load('assets/Helvetica.ttf');
    final font = Font.ttf(fontData);

    final textToPDF = TextToPDF();
    const documentName = "kodega";
    final pdf = await textToPDF.generatePDF(
      content: content,
      fileName: documentName,
      pageFormat: PdfPageFormat.standard,
      numOfWordsPerPage: 600,
      font: font,
    );

    setState(() {
      file = pdf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.picture_as_pdf_outlined),
        onPressed: () async {
          await generatePdf();
        },
      ),
      body: file == null ? Container() : PDFDocumentViewer(file: file!),
    );
  }
}

class PDFDocumentViewer extends StatefulWidget {
  const PDFDocumentViewer({super.key, required this.file});

  final File file;

  @override
  State<PDFDocumentViewer> createState() => _PDFDocumentViewerState();
}

class _PDFDocumentViewerState extends State<PDFDocumentViewer> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.file.path),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(controller: _pdfController);
  }
}
