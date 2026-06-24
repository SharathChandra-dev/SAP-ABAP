CLASS zcl_100008892_iterate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS max_count TYPE i VALUE 20.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_100008892_iterate IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Internal table for Fibonacci numbers
    DATA numbers TYPE TABLE OF i.

    " Loop max_count times
    DO max_count TIMES.

      CASE sy-index.

        WHEN 1.
          APPEND 0 TO numbers.

        WHEN 2.
          APPEND 1 TO numbers.

        WHEN OTHERS.
          APPEND numbers[ sy-index - 2 ] + numbers[ sy-index - 1 ] TO numbers.

      ENDCASE.

    ENDDO.

    " Output result
    out->write( numbers ).

  ENDMETHOD.

ENDCLASS.
