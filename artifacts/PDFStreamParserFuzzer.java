import java.io.IOException;
import org.apache.pdfbox.pdfparser.PDFStreamParser;


public class PDFStreamParserFuzzer {
    public static void fuzzerTestOneInput(byte[] input) {
        PDFStreamParser pdfStreamParser = new PDFStreamParser(input);

        try {
            pdfStreamParser.parse();
        } catch (IOException e) {
        }
    }
}

