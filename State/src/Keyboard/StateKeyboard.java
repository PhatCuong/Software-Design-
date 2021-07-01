package Keyboard;

public interface StateKeyboard {
    public void tap(ContextKeyboard contextKeyboard, Key key);
    public void hold(ContextKeyboard contextKeyboard, Key key);
    public void unhold(ContextKeyboard contextKeyboard, Key key);
}
