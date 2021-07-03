package Type.Iphone;

public class iphoneXSMin implements LightningCharge{
    @Override
    public void LightningCharge() {
        System.out.println("Lightning is plugged in");
    }

    @Override
    public void recharge() {
        System.out.println("Charging by lightning");
    }
}
