CLASS zcl_100008892_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.



CLASS zcl_100008892_cds IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA connection TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'LH'
          i_connection_id = '0400'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( 'First method call failed'(003) ).
    ENDTRY.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'AA'
          i_connection_id = '0017'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( 'Second method call failed'(002) ).
    ENDTRY.

    TRY.
        connection = NEW #(
          i_carrier_id    = 'SQ'
          i_connection_id = '0001'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( 'Third method call failed'(001) ).
    ENDTRY.

    LOOP AT connections INTO connection.
      out->write( connection->get_output( ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
