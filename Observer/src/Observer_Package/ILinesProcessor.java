package Observer_Package;

import Observer_Package.Source.ILinesSource;

public abstract class ILinesProcessor {
    protected ILinesSource source;

    public ILinesProcessor(ILinesSource source){
        this.source = source;
    }

    public abstract void update();
}
