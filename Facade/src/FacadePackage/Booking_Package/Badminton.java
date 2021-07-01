package FacadePackage.Booking_Package;

import FacadePackage.Player;

public class Badminton extends Booking {

    public Badminton(Player player) {
        super(player);
    }

    @Override
    public void cancelBooking() {
        System.out.println("The booking is canceled");
    }

}
