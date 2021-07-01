package Repository;

import Iterator.Container;
import Iterator.IteratorClass;


import java.util.ArrayList;

public class NameRepository implements Container {
    public ArrayList<String> names = new ArrayList<>();

    public void addName(String name) {
        names.add(name);
    }

    @Override
    public IteratorClass getLeftToRightIterator() {
        return new LeftToRightIterator();
    }

    @Override
    public IteratorClass getRightToLeftIterator() {
        return new RightToLeftIterator();
    }

    @Override
    public IteratorClass getAlphabetOrder() {
        return new AlphabetOrderIterator();
    }

    private class LeftToRightIterator implements IteratorClass {

        int i = 0;

        @Override
        public boolean hasNext() {
            if (i < names.size()) {
                return true;
            }
            return false;
        }

        @Override
        public Object next() {

            if (this.hasNext()) {
                return names.get(i++);
            }
            return null;
        }
    }

    public class RightToLeftIterator implements IteratorClass {

        int i = names.size() - 1;

        @Override
        public boolean hasNext() {
            if (i >= 0) {
                return true;
            }
            return false;
        }

        @Override
        public Object next() {

            if (this.hasNext()) {
                return names.get(i--);
            }
            System.out.println("Null");
            return null;
        }
    }

    private class AlphabetOrderIterator implements IteratorClass {
        int i = 0;
        int size = names.size();
        String temp = null;

        @Override
        public boolean hasNext() {
            if (i >= 0 && i < size) {
                return true;
            }
            return false;
        }

        @Override
        public Object next() {
            if(this.hasNext()){
                for(int j = i + 1; j < size; j++){
                    if(names.get(i).compareToIgnoreCase(names.get(j)) > 0){
                        temp = names.get(i);
                        names.set(i, names.get(j));
                        names.set(j,temp);
                    }
                }
                return names.get(i++);
            }
            return null;
        }

    }
}
