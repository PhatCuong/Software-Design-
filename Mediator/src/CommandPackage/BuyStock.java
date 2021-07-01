package CommandPackage;

import StockPackage.IStock;

public class BuyStock implements IOrder{
    private IStock stock;

    public BuyStock(IStock stock){
        this.stock = stock;
    }

    @Override
    public void execute() {
        stock.buy();
    }
}
