import FacadePackage.Booking_Package.Badminton;
import FacadePackage.Booking_Package.Booking;
import FacadePackage.Facade_Class;
import FacadePackage.Payment.Debit_Card;
import FacadePackage.Payment.Payment_Abstract;
import FacadePackage.Player;

public class Client {
    public static void main (String args[]){
        Player phat = new Player("Phat");
        Booking booking = new Badminton(phat);
        Payment_Abstract debitCard = new Debit_Card(phat);

        Facade_Class facade = new Facade_Class(debitCard);

        facade.payBooking(booking);
        facade.cancelBooking(booking);

    }
}
