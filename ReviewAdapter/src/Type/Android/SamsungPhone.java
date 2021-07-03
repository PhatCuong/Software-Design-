package Type.Android;

public class SamsungPhone implements USBCharge{
    @Override
    public void USBCharge() {
        System.out.println("USB is plugged in");
    }

    @Override
    public void recharge() {
        System.out.println("Charging with USB");
    }
}
