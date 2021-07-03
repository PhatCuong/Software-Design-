package Type;

import Type.Android.USBCharge;
import Type.Iphone.LightningCharge;

public class LightningToUSBAdapter implements USBCharge {
    private final LightningCharge lightningCharge;

    public LightningToUSBAdapter(LightningCharge lightningCharge) {
        this.lightningCharge = lightningCharge;
    }

    @Override
    public void USBCharge() {
        lightningCharge.LightningCharge();
    }

    @Override
    public void recharge() {
        lightningCharge.recharge();
    }
}
