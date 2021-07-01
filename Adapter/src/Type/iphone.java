package Type;

public class iphone implements Lightning{
    @Override
    public void Lightning() {
        System.out.println("Connection to iphone charge");
    }

    @Override
    public void rechange() {
        System.out.println("Charging by lightning");
    }
}
