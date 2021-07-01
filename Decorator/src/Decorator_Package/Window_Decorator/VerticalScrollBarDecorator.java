package Decorator_Package.Window_Decorator;

import Decorator_Package.Window;

public class VerticalScrollBarDecorator extends WindowDecorator{

    public VerticalScrollBarDecorator(Window windowToBeDecorated) {
        super(windowToBeDecorated);
    }

    private void drawVerticalScrollBar(){
        System.out.println("Draw vertical Scrollbar");
    }

    @Override
    public void draw() {
        super.draw();
        drawVerticalScrollBar();
    }

    @Override
    public String getDescription() {
        return super.getDescription() + " + including vertical scroll bar";
    }
}
