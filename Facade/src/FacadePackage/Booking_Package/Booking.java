package FacadePackage.Booking_Package;

import FacadePackage.Player;

public abstract class Booking {
    private Player player;

    public Booking(Player player){
        this.player = player;
    }

    public abstract void cancelBooking();
}
