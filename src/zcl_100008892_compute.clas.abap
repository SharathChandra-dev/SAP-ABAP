CLASS zcl_100008892_compute DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_100008892_compute IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA number1 TYPE i.
    DATA number2 TYPE i.
    DATA result  TYPE p LENGTH 8 DECIMALS 2.
    DATA op      TYPE c LENGTH 1.
    DATA output  TYPE string.

    number1 = 123.
    number2 = 0.
    op = '/'.

    CASE op.
      WHEN '+'.
        result = number1 + number2.

      WHEN '-'.
        result = number1 - number2.

      WHEN '*'.
        result = number1 * number2.

      WHEN '/'.
        TRY.
            result = number1 / number2.
          CATCH cx_sy_zerodivide.
            output = |Division by zero is not defined|.
        ENDTRY.

      WHEN OTHERS.
        output = |'{ op }' is not a valid operator!|.
    ENDCASE.

    IF output IS INITIAL.
      output = |{ number1 } { op } { number2 } = { result }|.
    ENDIF.

    out->write( output ).

  ENDMETHOD.

ENDCLASS.
