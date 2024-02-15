import ballerina/http;
import ballerina/lang.'string as string0;

table<Reservation> key(reservationId) reservationsTable = table [];

http:Client roomsClient = check new ("http://localhost:8080/rooms");

service /hotel on new http:Listener(9090) {

    resource function post bookings(ReservationRequest[] payload) returns InternalServerErrorErrorResponse|Reservation[] {
        Reservation[] reservations = [];
        do {
            foreach ReservationRequest request in payload {
                boolean availability = check roomsClient->/availability.get(roomtype = request.reservationDetails.roomType, count = request.reservationDetails.totalGuests);
                if !availability {
                    return {
                        body: {error_message: "No rooms available"}
                    };

                }
                Reservation reservation = transform(request);
                if !reservationsTable.hasKey(request.reservationId) {
                    reservationsTable.add(reservation);
                    reservations.push(reservation);
                }

            }
            return reservations;
        } on fail {
            return {
                body: {error_message: "Error in getting room availability"}
            };
        }
    }

    resource function get bookings() returns Reservation[] {
        return reservationsTable.toArray();
    }
}

type InternalServerErrorErrorResponse record {|
    *http:InternalServerError;
    ErrorResponse body;
|};

type Address record {
    string street;
    string city;
    string state;
    string zipCode;
};

type Guest record {
    string firstName;
    string lastName;
    string email;
    string phoneNumber;
    Address address;
};

type ReservationDetails record {
    string checkInDate;
    string checkOutDate;
    string roomType;
    int totalNights;
    int totalGuests;
    string[] amenities;
    decimal dayRate;
};

type ReservationRequest record {
    string reservationId;
    Guest guest;
    ReservationDetails reservationDetails;
};

//Outuput

type User record {
    string name;
    string email;
    string phoneNumber;
};

type ReservationSummary record {
    string checkInDate;
    string checkOutDate;
    string roomType;
    int totalGuests;
    decimal totalCost;
    string additionalServices;
};

type Reservation record {
    readonly string reservationId;
    User user;
    ReservationSummary reservationSummary;
};

function transform(ReservationRequest reservationRequest) returns Reservation => {
    reservationId: reservationRequest.reservationId,
    user: {
        name: reservationRequest.guest.firstName + " " + reservationRequest.guest.lastName,
        email: reservationRequest.guest.email,
        phoneNumber: reservationRequest.guest.phoneNumber
    },
    reservationSummary: {
        checkInDate: reservationRequest.reservationDetails.checkInDate,
        checkOutDate: reservationRequest.reservationDetails.checkOutDate,
        roomType: reservationRequest.reservationDetails.roomType,
        totalGuests: reservationRequest.reservationDetails.totalGuests,
        totalCost: reservationRequest.reservationDetails.totalNights * reservationRequest.reservationDetails.dayRate,
        additionalServices: string0:'join(",", ...reservationRequest.reservationDetails.amenities)
    }
};

type ErrorResponse record {
    string error_message;
};
