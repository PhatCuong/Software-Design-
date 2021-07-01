package Observer_Package;

import Observer_Package.Source.ILinesSource;

public class LinesDisplay extends ILinesProcessor {

    public LinesDisplay(ILinesSource source) {
        super(source);
        source.attach(this);
    }

    @Override
    public void update() {
        String line = source.getState();
        System.out.println("Text: " + line);
    }
}
