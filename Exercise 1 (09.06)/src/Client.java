import Repo.NameRepo;

public class Client {
    public static void main(String args[]){
        NameRepo nameRepo = new NameRepo();

        //Print from left to right
        System.out.println("--------------------Left to Right--------------------");
        for(int i = 0; i < nameRepo.names.length; i++){
            System.out.println(nameRepo.names[i]);
        }

        //Print from right to left
        System.out.println("--------------------Right to Left--------------------");
        for(int j = nameRepo.names.length - 1 ; j >= 0; j--){
            System.out.println(nameRepo.names[j]);
        }
    }
}
