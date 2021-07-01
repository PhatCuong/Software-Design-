public class Client {
    public static void main(String args[]){

        //For vegterian food
        MealBuilder vegMealBuilder = new MealBuilder();
        Meal vegMeal = vegMealBuilder.prepareVegMeal();
        vegMeal.displayMeal();
        System.out.println("---------------Total: " + vegMeal.getPrice() + "---------------");
    }
}
