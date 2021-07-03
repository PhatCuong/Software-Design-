package Burger;

public class BurgerBuilder implements BurgerBuilderInterface {
    int cheese, meat, salad;
    boolean ketchup, mustard;

    @Override
    public BurgerBuilderInterface addMeat(int meatSlices) {
        this.meat = meatSlices;
        return this;
    }

    @Override
    public BurgerBuilderInterface addCheese(int cheeseSlices) {
        this.cheese = cheeseSlices;
        return this;
    }

    @Override
    public BurgerBuilderInterface addSalad(int pieces) {
        this.salad = pieces;
        return this;
    }

    @Override
    public BurgerBuilderInterface addKetchup() {
        this.ketchup = true;
        return this;
    }

    @Override
    public BurgerBuilderInterface addMustard() {
        this.mustard = true;
        return this;
    }

    @Override
    public Burger deliver() {
        return new Burger(cheese, meat, salad, ketchup, mustard).deliver();
    }
}