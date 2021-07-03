import Type.Android.SamsungPhone;
import Type.Android.USBCharge;
import Type.Iphone.*;
import Type.LightningToUSBAdapter;
import Type.UsbToLightningAdapter;

public class Client {
    public static void main (String args[]){

        iphoneXSMin iphoneXSMin = new iphoneXSMin();
        USBCharge usbCharge = new LightningToUSBAdapter(iphoneXSMin);

        usbCharge.recharge();
        usbCharge.USBCharge();

        SamsungPhone samsungPhone = new SamsungPhone();
        LightningCharge lightningCharge = new UsbToLightningAdapter(samsungPhone);
        lightningCharge.LightningCharge();
        lightningCharge.recharge();

    }
}

