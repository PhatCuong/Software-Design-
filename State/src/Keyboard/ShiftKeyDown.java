package Keyboard;

public class ShiftKeyDown implements StateKeyboard{

    @Override
    public void tap(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case CAPSLOCK: {
                contextKeyboard.setState(new InitialState());
                System.out.println("Shift key: Down");
                System.out.println("Tap on Capslock has no effect");
                break;
            } case SHIFT:{
                System.out.println("Shift key: Down");
                System.out.println("Tap on shift key is not possible");
            } default:{
                System.out.println("Shift key: Down");
                System.out.println(key.toString().toUpperCase());
            }
        }
    }

    @Override
    public void hold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT:{
                System.out.println("Unable to hold");
                break;
            }
            default:{
                System.out.println("Can only shift only");
            }
        }
    }

    @Override
    public void unhold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT:{
                contextKeyboard.setState(new CapsOnState());
                break;
            }
            default:{
                System.out.println("Unholding state, shift is not possible");
            }
        }
    }
}
