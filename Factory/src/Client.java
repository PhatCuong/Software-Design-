import Type.Circle;
import Type.ShapeInterface;

public class Client {
    public static void main (String args[]){
        ShapeFactory shapeFactory = new ShapeFactory();
        ShapeInterface circle = shapeFactory.getShape("circle");
        circle.draw();
    }
}
