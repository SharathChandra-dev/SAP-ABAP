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

  " Fibonacci numbers (already created in Task 1)
  DATA numbers TYPE TABLE OF i.

  CONSTANTS max_count TYPE i VALUE 20.

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

  " Output table (string rows)
  DATA output TYPE TABLE OF string.

  " Counter for numbering
  DATA(counter) = 0.

  " Loop over Fibonacci numbers
  LOOP AT numbers INTO DATA(number).

    counter = counter + 1.

    APPEND |{ counter WIDTH = 4 ALIGN = LEFT }: { number WIDTH = 10 ALIGN = RIGHT }|
      TO output.

  ENDLOOP.

out->write(
data = output
name = |The first { max_count } Fibonacci Numbers|
) .
  " Write to console
  out->write( output ).

ENDMETHOD.

ENDCLASS.
