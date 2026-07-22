CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i READ-ONLY.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

    METHODS get_output
      RETURNING
        VALUE(r_output) TYPE string_table.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF st_details,
        DepartureAirport   TYPE /dmo/airport_from_id,
        DestinationAirport TYPE /dmo/airport_to_id,
        AirlineName        TYPE /dmo/carrier_name,
      END OF st_details.

    TYPES:
      BEGIN OF st_airport,
        AirportID TYPE /dmo/airport_id,
        Name      TYPE /dmo/airport_name,
      END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
      WITH NON-UNIQUE DEFAULT KEY.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    DATA details       TYPE st_details.

    CLASS-DATA airports TYPE tt_airports.

ENDCLASS.


CLASS lcl_connection IMPLEMENTATION.

  METHOD class_constructor.

    SELECT FROM /dmo/i_airport
      FIELDS AirportID,
             Name
      INTO TABLE @airports.

  ENDMETHOD.


  METHOD constructor.

    IF i_carrier_id IS INITIAL
       OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    SELECT SINGLE
      FROM /dmo/i_connection
      FIELDS DepartureAirport,
             DestinationAirport,
             \_Airline-Name AS AirlineName
      WHERE AirlineID    = @i_carrier_id
        AND ConnectionID = @i_connection_id
      INTO CORRESPONDING FIELDS OF @details.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->carrier_id    = i_carrier_id.
    me->connection_id = i_connection_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.


  METHOD get_output.

    DATA(departure) =
      airports[ AirportID = details-DepartureAirport ].

    DATA(destination) =
      airports[ AirportID = details-DestinationAirport ].

    APPEND |--------------------------------| TO r_output.
    APPEND |Carrier:     { carrier_id } { details-AirlineName }|
      TO r_output.
    APPEND |Connection:  { connection_id }|
      TO r_output.
    APPEND |Departure:   { details-DepartureAirport } { departure-Name }|
      TO r_output.
    APPEND |Destination: { details-DestinationAirport } { destination-Name }|
      TO r_output.

  ENDMETHOD.

ENDCLASS.
