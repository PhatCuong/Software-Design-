package Observer_Package.Source;

import Observer_Package.ILinesProcessor;

public interface ILinesSource {
    public void startProcessing();
    public void attach(ILinesProcessor iLinesProcessor);
    public void detach(ILinesProcessor iLinesProcessor);
    public String getState();

}
