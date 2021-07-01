package Type;

public class Android implements USB{
    @Override
    public void recharge() {
        System.out.println("Charging by MicroUSB");
    }

    @Override
    public void USB() {
        System.out.println("Connection to USB charge");
    }
}
