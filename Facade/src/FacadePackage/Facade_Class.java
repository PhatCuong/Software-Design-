package FacadePackage;

import FacadePackage.Booking_Package.Booking;
import FacadePackage.Payment.Payment_Abstract;

public class Facade_Class {
    private Booking booking;
    private Payment_Abstract payment;

    public Facade_Class(Payment_Abstract payment){
        this.payment = payment;
    }

    public void payBooking(Booking booking){
        this.booking = booking;
        payment.pay(booking);
    }

    public void cancelBooking(Booking booking){
        this.booking = booking;
        booking.cancelBooking();
        payment.refund(booking);
        this.booking = null;
    }
}
