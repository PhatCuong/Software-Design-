package Decorator_Package;

public class SimpleWindow implements Window
{
    @Override
    public void draw() {
        System.out.println("Draw Simple window");
    }

    @Override
    public String getDescription() {
        return "Simple Window";
    }
}
