import Composite_package.Shape;
import Composite_package.Shape_Composite;
import Composite_package.Shape_Leaf;

public class Client {
    public static void main (String args[]){
        Shape_Leaf shape1 = new Shape_Leaf("1");
        Shape_Leaf shape2 = new Shape_Leaf("2");
        Shape_Leaf shape3 = new Shape_Leaf("3");

        Shape_Composite shapeComposite1 = new Shape_Composite();
        shapeComposite1.add(shape1);
        shapeComposite1.add(shape2);

        Shape_Composite shapeComposite2 = new Shape_Composite();
        shapeComposite2.add(shape3);

        Shape_Composite shapeComposite = new Shape_Composite();
        shapeComposite.add(shapeComposite1);
        shapeComposite.add(shapeComposite2);

        System.out.println("----------------------------------");
        shapeComposite.print();

        System.out.println("----------------------------------");
        shapeComposite1.print();

        System.out.println("----------------------------------");
        shapeComposite2.print();

    }
}
