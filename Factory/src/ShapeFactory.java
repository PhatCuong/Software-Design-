import Type.Circle;
import Type.Rectangle;
import Type.ShapeInterface;

public class ShapeFactory {
    public ShapeInterface getShape(String shape) {
        if (shape == "circle") {
            return new Circle();
        } else if (shape == "rec") {
            return new Rectangle();
        }
        return null;
    }
}
