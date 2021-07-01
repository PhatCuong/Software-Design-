package Observer_Package;

import Observer_Package.Source.ILinesSource;

public class LinesCharactersCount extends ILinesProcessor {

    public LinesCharactersCount(ILinesSource source) {
        super(source);
        source.attach(this);
    }

    @Override
    public void update() {
        String line = source.getState();
        System.out.println("Character count: " + line.length());
    }
}
