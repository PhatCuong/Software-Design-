package items.ColdDrink;

import Packaging.Bottle;
import Packaging.PackagingInterface;
import items.ItemInterface;

public abstract class ColdDrinkClass implements ItemInterface {
    @Override
    public PackagingInterface packaging() {
        return new Bottle();
    }

    @Override
    public abstract float price();
}
