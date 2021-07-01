import Keyboard.Key;
import Keyboard.ContextKeyboard;

public class Client {
    public static void main (String args[]){
        ContextKeyboard keyboardClass = new ContextKeyboard();


        keyboardClass.tap(Key.CAPSLOCK);
        keyboardClass.tap(Key.Q);//Q

        keyboardClass.hold(Key.SHIFT);
        keyboardClass.tap(Key.Q);//q

        keyboardClass.unhold(Key.SHIFT);
        keyboardClass.tap(Key.Q); //q



    }
}
