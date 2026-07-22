CLASS zcl_100008892_itab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_100008892_itab IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'LH'
          i_connection_id = '0400'
        ).
        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `LH 0400 was not found` ).
    ENDTRY.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'AA'
          i_connection_id = '0017'
        ).
        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `AA 0017 was not found` ).
    ENDTRY.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'SQ'
          i_connection_id = '0001'
        ).
        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `SQ 0001 was not found` ).
    ENDTRY.

    LOOP AT connections INTO connection.
      out->write( connection->get_output( ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
