import Burger.Burger;
import Burger.BurgerBuilder;

public class Client {
    public static void main(String args[]){
        BurgerDirector burgerDirector = new BurgerDirector();
        BurgerBuilder burgerBuilder = new BurgerBuilder();

        burgerDirector.fullTopping(burgerBuilder);
        burgerDirector.cheeseBurger(burgerBuilder);

        //Custom Burger
        System.out.println("Custom Burger: ");
        Burger optionalBurger = new BurgerBuilder().addMeat(2).addCheese(3).addKetchup().deliver();
    }
}
