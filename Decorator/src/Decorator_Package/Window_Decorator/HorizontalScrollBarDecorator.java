package Decorator_Package.Window_Decorator;

import Decorator_Package.Window;

public class HorizontalScrollBarDecorator extends WindowDecorator{

    public HorizontalScrollBarDecorator(Window windowToBeDecorated) {
        super(windowToBeDecorated);
    }

    private void drawHorizontalScrollBar(){
        System.out.println("Draw horizontal scroll bar");
    }

    @Override
    public void draw() {
        super.draw();
        drawHorizontalScrollBar();
    }

    @Override
    public String getDescription() {
        return super.getDescription() + " + including horizontal scroll bar";
    }
}
