package Decorator_Package.Window_Decorator;

import Decorator_Package.Window;

public class BorderWindowDecorator extends WindowDecorator{

    public BorderWindowDecorator(Window windowToBeDecorated) {
        super(windowToBeDecorated);
    }

    private void drawBorderWindow(){
        System.out.println("Draw border window");
    }

    @Override
    public void draw() {
        super.draw();
        drawBorderWindow();
    }

    @Override
    public String getDescription() {
        return super.getDescription() + " + including border";
    }
}
