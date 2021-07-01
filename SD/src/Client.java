import java.security.InvalidParameterException;

public class Client{
    private ExampleServie exampleServie;

    Client(ExampleServie exampleServie){
        this.exampleServie = new ExampleServie();
    }

//    //Constructor injection
//    Client(ExampleServie exampleServie1){
//        if(exampleServie1 == null){
//            throw new InvalidParameterException();
//        }
//    }
//
//    //Interface injection
//    @Override
//    public void setService(ExampleServie exampleServie) {
//        this.exampleServie = exampleServie;
//    }

    //Setter injection
    public void setExampleServie(ExampleServie exampleServie){
        this.exampleServie = exampleServie;
    }

    public String greet(){
        return "Hello" + exampleServie.getName();
    }


}
