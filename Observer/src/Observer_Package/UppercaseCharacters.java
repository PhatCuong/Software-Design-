package Observer_Package;

import Observer_Package.Source.ILinesSource;

public class UppercaseCharacters extends ILinesProcessor {

    public UppercaseCharacters(ILinesSource source) {
        super(source);
        source.attach(this);
    }

    @Override
    public void update() {
        String line = source.getState();
        System.out.println("Uppercase: " + line.toUpperCase());
    }
}
