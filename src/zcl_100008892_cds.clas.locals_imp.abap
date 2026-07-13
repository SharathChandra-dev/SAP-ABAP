CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i READ-ONLY.

    METHODS constructor
      IMPORTING
        i_connection_id TYPE /dmo/connection_id
        i_carrier_id    TYPE /dmo/carrier_id
      RAISING
        cx_abap_invalid_value.

    METHODS get_output
      RETURNING
        VALUE(r_output) TYPE string_table.

  PRIVATE SECTION.

    DATA carrier_id      TYPE /dmo/carrier_id.
    DATA connection_id   TYPE /dmo/connection_id.
    DATA carrier_name    TYPE /dmo/carrier_name.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

ENDCLASS.



CLASS lcl_connection IMPLEMENTATION.

METHOD constructor.

  IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.

* SELECT SINGLE
*   FROM /dmo/connection
*   FIELDS airport_from_id, airport_to_id
*   WHERE carrier_id    = @i_carrier_id
*     AND connection_id = @i_connection_id
*   INTO ( @airport_from_id, @airport_to_id ).

  SELECT SINGLE
    FROM /DMO/I_Connection
    FIELDS DepartureAirport,
           DestinationAirport,
           \_Airline-Name
    WHERE AirlineID    = @i_carrier_id
      AND ConnectionID = @i_connection_id
    INTO ( @airport_from_id,
           @airport_to_id,
           @carrier_name ).

  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.

  me->carrier_id    = i_carrier_id.
  me->connection_id = i_connection_id.

  conn_counter = conn_counter + 1.

ENDMETHOD.


  METHOD get_output.



  APPEND |--------------------------------| TO r_output.
  APPEND |'``Carrier: ``'(004){  carrier_id } { carrier_name }| TO r_output.
  APPEND |'``Connection:``'(005){  connection_id }| TO r_output.
  APPEND |'``Departure:``'(006){  airport_from_id }| TO r_output.
  APPEND |'``Destination:``'(007){ airport_to_id }| TO r_output.

  ENDMETHOD.

ENDCLASS.
