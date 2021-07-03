import Burger.BurgerBuilder;

public class BurgerDirector {
    public void fullTopping(BurgerBuilder burgerBuilder){
        burgerBuilder.addCheese(1);
        burgerBuilder.addMeat(1);
        burgerBuilder.addSalad(1);
        burgerBuilder.addKetchup();
        burgerBuilder.addMustard();
        System.out.println("Full topping burger: ");
        burgerBuilder.deliver();
    }

    public void cheeseBurger(BurgerBuilder burgerBuilder){
        burgerBuilder.addCheese(1);
        burgerBuilder.addMeat(1);
        burgerBuilder.addSalad(1);
        burgerBuilder.addMustard();
        System.out.println("Cheese burger: ");
        burgerBuilder.deliver();
    }
}
