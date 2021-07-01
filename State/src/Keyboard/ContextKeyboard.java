package Keyboard;


public class ContextKeyboard {
    public StateKeyboard stateKeyboard;

    public ContextKeyboard() {
        this.stateKeyboard = new InitialState();
    }

    public void setState(StateKeyboard stateKeyboard) {
        this.stateKeyboard = stateKeyboard;
    }

    public void tap(Key key) {
        stateKeyboard.tap(this, key);
    }

    public void hold(Key key) {
        stateKeyboard.hold(this, key);
    }

    public void unhold(Key key) {
        stateKeyboard.unhold(this, key);
    }
}
