import Type.Android;
import Type.Lightning;
import Type.USB;
import Type.iphone;

public class LightningToUSBAdapter implements USB {
    private final Lightning lightning;

    public LightningToUSBAdapter(Lightning lightning) {
        this.lightning = lightning;
    }

    @Override
    public void recharge() {
        lightning.rechange();
    }

    @Override
    public void USB() {
        lightning.Lightning();
    }
}
