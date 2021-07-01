package items.Burger;

import Packaging.PackagingInterface;
import Packaging.Wrapper;
import items.ItemInterface;

public abstract class BurgerClass implements ItemInterface {

    @Override
    public PackagingInterface packaging(){
        return new Wrapper();
    }

    @Override
    public abstract float price();
}
