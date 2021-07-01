package items.Burger;

public class VegBurger extends BurgerClass{
    @Override
    public String name() {
        return "Veg burger";
    }

    @Override
    public float price() {
        return 15;
    }
}
