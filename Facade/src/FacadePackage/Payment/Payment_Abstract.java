package FacadePackage.Payment;

import FacadePackage.Booking_Package.Booking;
import FacadePackage.Player;

public abstract class Payment_Abstract {
    private Player player;

    public Payment_Abstract(Player player){
        this.player = player;
    }

    public void pay(Booking booking){
        System.out.println("Paid for: " + booking.getClass().getSimpleName());
    }

    public void refund(Booking booking){
        System.out.println("Refunded for: " + booking.getClass().getSimpleName());
    }
}
