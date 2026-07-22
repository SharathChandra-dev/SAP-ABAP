CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i READ-ONLY.

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

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    DATA details       TYPE st_details.

ENDCLASS.


CLASS lcl_connection IMPLEMENTATION.

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

    APPEND |--------------------------------| TO r_output.
    APPEND |Carrier:     { carrier_id } { details-AirlineName }|
      TO r_output.
    APPEND |Connection:  { connection_id }|
      TO r_output.
    APPEND |Departure:   { details-DepartureAirport }|
      TO r_output.
    APPEND |Destination: { details-DestinationAirport }|
      TO r_output.

  ENDMETHOD.

ENDCLASS.
