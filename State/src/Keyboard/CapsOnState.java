package Keyboard;

import java.util.Locale;

public class CapsOnState implements StateKeyboard{
    @Override
    public void tap(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case CAPSLOCK: {
                contextKeyboard.setState(new InitialState());
                break;
            }
            default:{
                System.out.println("CAPSLOCK: ON");
                System.out.println(key.toString().toUpperCase());
            }
        }
    }

    @Override
    public void hold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT: {
                contextKeyboard.setState(new InitialState());
                break;
            }
            default:{
                System.out.println("Unable to hold");
            }
        }
    }

    @Override
    public void unhold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT: {
                contextKeyboard.setState(new InitialState());
                break;
            }
            default:{
                System.out.println("Can only un-hold shift");
            }
        }
    }
}
