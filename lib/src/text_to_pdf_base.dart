import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class TextToPDF {
  /// generate a pdf file from a string
  /// [content] is the string to be converted to pdf
  /// [fileName] is the name of the pdf file
  /// [numOfWordsPerPage] is the number of words per page
  /// [pageFormat] is the page format of the pdf file
  /// [return] is the pdf file
  /// [return] is null if the file is not generated
  /// [font] is the font of the pdf file
  Future<File?> generatePDF({
    required String content,
    String? fileName,
    int numOfWordsPerPage = 1200,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    Font? font,
  }) async {
    final pdfName =
        fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
    final pdfDoc = Document();
    final List<String> words = content.split(' ');
    int numOfPages = (words.length / numOfWordsPerPage).ceil();

// Load font file

    for (int i = 0; i < numOfPages; i++) {
      final List<String> currentPageWords = words.sublist(
          i * numOfWordsPerPage,
          (i * numOfWordsPerPage) + numOfWordsPerPage > words.length
              ? words.length
              : (i * numOfWordsPerPage) + numOfWordsPerPage);
      final String currentPageText = currentPageWords.join(' ');
      pdfDoc.addPage(
        Page(
          pageFormat: pageFormat,
          build: (Context context) {
            return RichText(
                text: TextSpan(
                    text: currentPageText, style: TextStyle(font: font)));
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$pdfName.pdf");
    // clear the file if it exists
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(await pdfDoc.save());
    return file;
  }
}
