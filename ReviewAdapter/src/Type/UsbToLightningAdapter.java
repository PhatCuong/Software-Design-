package Type;

import Type.Android.USBCharge;
import Type.Iphone.LightningCharge;

public class UsbToLightningAdapter implements LightningCharge {
    private final USBCharge usbCharge;

    public UsbToLightningAdapter(USBCharge usbCharge) {
        this.usbCharge = usbCharge;
    }

    @Override
    public void LightningCharge() {
        usbCharge.USBCharge();
    }

    @Override
    public void recharge() {
        usbCharge.recharge();
    }
}
