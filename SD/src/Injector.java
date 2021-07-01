
public class Injector {
    public static void main(String args[]){
        ExampleServie exampleServie = new ExampleServie();
        Client client = new Client(exampleServie);
        System.out.println(client.greet());
    }
}
