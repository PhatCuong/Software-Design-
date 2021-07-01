package StockPackage;

public abstract class IStock {
    public int quantity;

    public IStock(int quantity){
        this.quantity = quantity;
    }

    public abstract void buy();
    public abstract void sell();
}
