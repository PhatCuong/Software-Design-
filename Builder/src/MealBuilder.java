import items.Burger.ChickenBurger;
import items.Burger.VegBurger;
import items.ColdDrink.Coke;
import items.ColdDrink.Pepsi;

public class MealBuilder {
    public Meal prepareVegMeal(){
        Meal meal = new Meal();
        meal.addItem(new VegBurger());
        meal.addItem(new Coke());
        return meal;
    }
    public Meal prepareNonVegMeal(){
        Meal meal = new Meal();
        meal.addItem(new ChickenBurger());
        meal.addItem(new Pepsi());
        return meal;
        }
}
