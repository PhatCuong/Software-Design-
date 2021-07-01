import CommandPackage.IOrder;

import java.util.ArrayList;
import java.util.List;

public class Broker {
    private List<IOrder> orderList = new ArrayList<IOrder>();

    public void takeOrder(IOrder order){
        orderList.add(order);
    }

    public void placeOrder(){
        for( IOrder iOrder : orderList){
            iOrder.execute();
        }
        orderList.clear();
    }
}
