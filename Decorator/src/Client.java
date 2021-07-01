import Decorator_Package.SimpleWindow;
import Decorator_Package.Window;
import Decorator_Package.Window_Decorator.BorderWindowDecorator;
import Decorator_Package.Window_Decorator.HorizontalScrollBarDecorator;
import Decorator_Package.Window_Decorator.VerticalScrollBarDecorator;

public class Client {
    public static void main (String args[]){
        Window decoratedWindow = new BorderWindowDecorator (
                                        new HorizontalScrollBarDecorator(
                                                new VerticalScrollBarDecorator(
                                                        new SimpleWindow())));

        System.out.println(decoratedWindow.getDescription());

        decoratedWindow.draw();

    }
}
