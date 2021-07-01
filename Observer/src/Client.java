import Observer_Package.ILinesProcessor;
import Observer_Package.LinesCharactersCount;
import Observer_Package.LinesDisplay;
import Observer_Package.Source.ILinesSource;
import Observer_Package.Source.LinesSource;
import Observer_Package.UppercaseCharacters;

public class Client {
    public static void main (String[] args){
        System.out.println("Enter text: ");

        ILinesSource source = new LinesSource();

        ILinesProcessor display = new LinesDisplay(source);
        ILinesProcessor count = new LinesCharactersCount(source);
        ILinesProcessor uppercase = new UppercaseCharacters(source);

        source.detach(display);

        source.startProcessing();


    }
}
