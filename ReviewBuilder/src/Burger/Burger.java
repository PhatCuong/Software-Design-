package Burger;

public class Burger {
    int cheese, meat, salad;
    boolean ketchup, murtard;

    public Burger(int cheese, int meat, int salad, boolean ketchup, boolean murtard) {
        this.cheese = cheese;
        this.meat = meat;
        this.salad = salad;
        this.ketchup = ketchup;
        this.murtard = murtard;
    }

    public Burger deliver() {
        System.out.println ("Burger has: " + cheese + " slices of cheese, " +
                                meat + " slices of meat, " +
                                "ketchup: " + ketchup +
                                " murtard: " + murtard);

        return this;
    }
}
