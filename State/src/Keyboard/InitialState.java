package Keyboard;

public class InitialState implements StateKeyboard{
    @Override
    public void tap(ContextKeyboard contextKeyboard, Key key) {
        switch (key) {
            case CAPSLOCK: {
                contextKeyboard.setState(new CapsOnState());
                break;
            }
            case SHIFT: {
                System.out.println("Tap on shilft key has no effect");
                break;
            }
            default:{
                System.out.println("Initial");
                System.out.println(key.toString().toLowerCase());

            }
        }

    }

    @Override
    public void hold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT:{
                contextKeyboard.setState(new ShiftKeyDown());
                break;
            }
            default:{
                System.out.println("Hold on key different from shilft key has no effect");
            }
        }
    }

    @Override
    public void unhold(ContextKeyboard contextKeyboard, Key key) {
        switch (key){
            case SHIFT:{
                if(contextKeyboard.getClass().getSimpleName() == "ShiftKeyDown") {
                    contextKeyboard.setState(new CapsOnState());
                }
                else if(contextKeyboard.getClass().getSimpleName() == "CapsOnState"){
                    contextKeyboard.setState(new CapsOnState());
                }
                else {
                    System.out.println("Can not un-hold if not hold");
                }
                break;
            }
            default: {
                System.out.println("Initial");
            }
        }
    }
}
