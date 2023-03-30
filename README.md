## A simple package to get the pdf file from strings

```
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
}
```
