package Composite_package;

import java.util.ArrayList;
import java.util.List;

public class Shape_Composite implements Shape {
    private final List<Shape> childShape = new ArrayList<>();

    public void add(Shape shape){
        childShape.add(shape);
    }

    public void add(List<Shape> compositeShape){
        childShape.addAll(compositeShape);
    }


    @Override
    public void print() {
        for(Shape shape : childShape){
            shape.print();
        }
    }
}
