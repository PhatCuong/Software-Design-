import CommandPackage.BuyStock;
import CommandPackage.SellStock;
import StockPackage.FBIStock;
import StockPackage.GGIStock;
import StockPackage.IStock;


public class Client {
    public static void main(String args[]){
        IStock stockFB = new FBIStock(10);
        IStock stockGG = new GGIStock(20);

        BuyStock buyStockOrder = new BuyStock(stockFB);
        SellStock sellStockOrder = new SellStock(stockGG);

        Broker broker = new Broker();
        broker.takeOrder(buyStockOrder);
        broker.takeOrder(sellStockOrder);

        broker.placeOrder();
    }
}
