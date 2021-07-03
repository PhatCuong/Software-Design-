package Burger;

public interface BurgerBuilderInterface {
    BurgerBuilderInterface addMeat(int meatSlices);
    BurgerBuilderInterface addCheese(int cheeseSlices);
    BurgerBuilderInterface addSalad(int pieces);

    BurgerBuilderInterface addKetchup();
    BurgerBuilderInterface addMustard();

    Burger deliver();
}
