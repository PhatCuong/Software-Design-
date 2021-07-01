import Iterator.IteratorClass;
import Repository.NameRepository;

public class Client {
    public static void main(String args[]) {
        NameRepository nameRepository = new NameRepository();

        nameRepository.addName("Daniel");
        nameRepository.addName("Britta");
        nameRepository.addName("Alex");
        nameRepository.addName("Christine");

        //Print from left to right
        System.out.println("-----------Left to Right------------");
        for (IteratorClass iter = nameRepository.getLeftToRightIterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            System.out.println("Name: " + name);
        }

        //Print from right to left
        System.out.println("-----------Right to Left------------");
        for (IteratorClass iter = nameRepository.getRightToLeftIterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            System.out.println("Name: " + name);

        }

        //Find a name
        System.out.println("-----------Search Name------------");
        String nameToFind = "b";
        boolean found = false;
        for (IteratorClass iter = nameRepository.getLeftToRightIterator(); iter.hasNext(); ) {
            String name = (String) iter.next();
            if (name.equalsIgnoreCase(nameToFind)) {
                found = true;
                break;
            }
        }
        if (found) {
            System.out.println("Found " + nameToFind);
        } else {
            System.out.println("Not found " + nameToFind);
        }

        //Print in Alphabet Order
        System.out.println("-----------Alphabet Order------------");
        for (IteratorClass iter = nameRepository.getAlphabetOrder(); iter.hasNext(); ) {
            String name = (String) iter.next();
            System.out.println("Name: " + name);

        }
    }
}
