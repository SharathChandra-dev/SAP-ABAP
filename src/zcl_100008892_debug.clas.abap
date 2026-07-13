CLASS zcl_100008892_debug DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_100008892_DEBUG IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Declarations
**********************************************************************
    " Types
    TYPES t_amount     TYPE p LENGTH 8 DECIMALS 2.
    TYPES t_percentage TYPE p LENGTH 2 DECIMALS 1.

    " Input for the calculation
    CONSTANTS loan_total        TYPE t_amount     VALUE '50000.00'.
    CONSTANTS interest_rate     TYPE t_percentage VALUE '2.0'.
    CONSTANTS payment_month     TYPE t_amount     VALUE '1000.00'.
    CONSTANTS spec_repay_year   TYPE t_amount     VALUE '10000.00'.  " Extra payment per year
    CONSTANTS spec_repay_mode   TYPE c LENGTH 1   VALUE 'Q'.         "'A' Annual, 'H' every half year, 'Q' 'every Quarter

    " Output
    DATA repayment_plan TYPE TABLE OF string.

    " Helper Variables
    DATA loan_remaining         TYPE t_amount.
    DATA interest_month         TYPE t_amount.
    DATA repayment_month        TYPE t_amount.
    DATA interest_total         TYPE t_amount.
    DATA special_repayment      TYPE t_amount.

    DATA months_counter         TYPE i.
    DATA months_btw_spec_pay    TYPE i.


* Processing
**********************************************************************

    " Initializations
    loan_remaining = loan_total.

    CASE spec_repay_mode.
      WHEN 'A'.
        months_btw_spec_pay = 12.
        special_repayment   = spec_repay_year.
      WHEN 'H'.
        months_btw_spec_pay = 6.
        special_repayment   = spec_repay_year / 2.
      WHEN 'Q'.
        months_btw_spec_pay = 3.
        special_repayment   = spec_repay_year / 4.
      WHEN OTHERS.
        out->write( 'Invalid extra payment mode'  ).
        EXIT.
    ENDCASE.

    " Calculations
    DO.

      IF loan_remaining <= 0.
        EXIT.
      ENDIF.

      DO months_btw_spec_pay TIMES.

        months_counter = months_counter + 1.

        " calculate interest and back payment for current month
        interest_month    = loan_remaining *  ( interest_rate / 100 ) / 12 .
        repayment_month   = payment_month - interest_month.

        " add monthly interest to total interest
        interest_total = interest_total + interest_month.

        " deduct repayment
        loan_remaining = loan_remaining - repayment_month.

        " add payment to repayment plan
        APPEND |Month {  months_counter } - Interest: { interest_month } Remaining loan: { loan_remaining } |
            TO repayment_plan.

        IF loan_remaining < 0.
          EXIT.
        ENDIF.
      ENDDO.

      IF loan_remaining < 0.
        EXIT.
      ENDIF.

      " deduct the special repayment (n times a year, spec_repay_year over the year )
      loan_remaining = loan_remaining - special_repayment.

      "add special repayment to repayment plan
      APPEND |Special repayment of { special_repayment }! Remaining loan { loan_remaining } |
          TO repayment_plan.
    ENDDO.

* Output
**********************************************************************

    out->write( |Starting value of loan:   { loan_total        }| ).
    out->write( |Monthly payment:          { payment_month     }| ).
    out->write( |Special repayment         { special_repayment } every { months_btw_spec_pay } months. | ).

    out->write( |-----------------------Result-----------------------| ).
    out->write( |Total repayment after { months_counter DIV 12 } years and { months_counter MOD 12 } months. | ).
    out->write( |Total interest paid: { interest_total } | ).

    "Repayment Plan
    out->write(
                name = `Repayment Plan:`
                data = repayment_plan
              ).

  ENDMETHOD.
ENDCLASS.
