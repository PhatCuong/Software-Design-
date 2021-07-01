package Observer_Package.Source;

import Observer_Package.ILinesProcessor;

import java.util.ArrayList;
import java.util.Scanner;

public class LinesSource implements ILinesSource {

    private String line;
    private ArrayList<ILinesProcessor> linesProcessors = new ArrayList<>();


    @Override
    public void startProcessing() {
        Scanner scanner = new Scanner(System.in);

        while (scanner.hasNextLine()){
            String line = scanner.nextLine();
            for(ILinesProcessor linesProc : linesProcessors){
                this.line = line;
                linesProc.update();
            }
        }

    }

    @Override
    public void attach(ILinesProcessor lineProc) {
        linesProcessors.add(lineProc);
    }

    @Override
    public void detach(ILinesProcessor lineProc) {
        linesProcessors.remove(lineProc);
    }

    @Override
    public String getState() {
        return this.line;
    }
}
