public class SingletonClass {
    private static SingletonClass singletonClass = null;
    public String s = "Hello Phat";

    private SingletonClass(){
        System.out.println(s);
    };


    public static SingletonClass getInstance(){
        if(singletonClass == null){
            return new SingletonClass();
        }
        return singletonClass;
    }
}
