import Type.*;

public class Client {
    public static void main (String args[]){
        Huawei huawei = new Huawei();
        USB usb = new LightningToUSBAdapter(huawei);
        usb.recharge();
        usb.USB();

        AndroidtoLightningAdapter androidtoLightningAdapter = new AndroidtoLightningAdapter();
        androidtoLightningAdapter.rechargeByLightning();
    }
}
