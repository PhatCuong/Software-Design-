package CommandPackage;

import StockPackage.IStock;

public class SellStock implements IOrder{
    private IStock stock;

    public SellStock(IStock stock){
        this.stock = stock;
    }

    @Override
    public void execute() {
        stock.sell();
    }
}
