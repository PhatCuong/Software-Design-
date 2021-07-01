package StockPackage;

public class GGIStock extends IStock {

    public GGIStock(int quantity) {
        super(quantity);
    }

    @Override
    public void buy() {
        System.out.println( quantity + " Google stocks: Bought");
    }

    @Override
    public void sell() {
        System.out.println( quantity + " Google stocks: Sold");
    }
}
