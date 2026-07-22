CLASS zcl_100008892_select DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_100008892_select IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

* First connection
    TRY.
        connection = NEW #(
          i_carrier_id    = 'LH'
          i_connection_id = '0400'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Instance creation failed` ).
    ENDTRY.

* Second connection
    TRY.
        connection = NEW #(
          i_carrier_id    = 'AA'
          i_connection_id = '0017'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Instance creation failed` ).
    ENDTRY.

* Third connection
    TRY.
        connection = NEW #(
          i_carrier_id    = 'SQ'
          i_connection_id = '0001'
        ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Instance creation failed` ).
    ENDTRY.

* Display all connections
    LOOP AT connections INTO connection.
      out->write( connection->get_output( ) ).
    ENDLOOP.

    out->write(
      |Successfully created instances: { lcl_connection=>conn_counter }|
    ).

  ENDMETHOD.

ENDCLASS.
