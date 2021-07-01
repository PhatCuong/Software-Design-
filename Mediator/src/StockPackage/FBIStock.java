package StockPackage;

public class FBIStock extends IStock {

    public FBIStock(int quantity) {
        super(quantity);
    }

    @Override
    public void buy() {
        System.out.println( quantity + " Facbook stocks: Bought");
    }

    @Override
    public void sell(){
        System.out.println( quantity + " Facbook stocks: Sold");
    }
}
