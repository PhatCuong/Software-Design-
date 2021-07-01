import items.ItemInterface;

import java.util.ArrayList;
import java.util.List;

public class Meal {
    private List<ItemInterface> itemsList = new ArrayList<ItemInterface>();

    public void addItem(ItemInterface itemInterface){
        itemsList.add(itemInterface);
    }

    public float getPrice(){
        float price = 0;

        for(ItemInterface items : itemsList){
            price += items.price();
        }

        return price;
    }

    public void displayMeal(){
        for(ItemInterface items : itemsList){
            System.out.println("Item: " + items.name());
            System.out.println("Packaging: " + items.packaging().pack());
            System.out.println("Price: " + items.price());
        }
    }
}
