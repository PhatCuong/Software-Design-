package Composite_package;

public class Shape_Leaf implements Shape{

    String s;

    public Shape_Leaf (String s){
        this.s = s;
    }

    @Override
    public void print() {
        System.out.println("Leaf: " + s + " is displayed");
    }
}
