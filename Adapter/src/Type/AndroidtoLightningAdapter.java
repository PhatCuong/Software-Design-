package Type;

public class AndroidtoLightningAdapter extends Android implements LightningPhone {

    @Override
    public void rechargeByLightning() {
        System.out.println("Android Phone is being recharged by Lightning");
        USB();
    }
}
