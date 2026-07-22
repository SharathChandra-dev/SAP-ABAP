CLASS LHC_ZR_8892FLIGHT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Zr8892flight
        RESULT result,
      validatePrice FOR VALIDATE ON SAVE
            IMPORTING keys FOR Zr8892flight~validatePrice.
ENDCLASS.

CLASS LHC_ZR_8892FLIGHT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD validatePrice.

  DATA failed_record
    LIKE LINE OF failed-Zr8892flight.

  DATA reported_record
    LIKE LINE OF reported-Zr8892flight.

  READ ENTITIES OF ZR_8892FLIGHT IN LOCAL MODE
    ENTITY Zr8892flight
      FIELDS ( Price )
      WITH CORRESPONDING #( keys )
      RESULT DATA(flights).

  LOOP AT flights INTO DATA(flight).

    IF flight-Price <= 0.

      failed_record-%tky = flight-%tky.
      APPEND failed_record
        TO failed-Zr8892flight.

      reported_record-%tky = flight-%tky.
      reported_record-%element-Price =
        if_abap_behv=>mk-on.

      reported_record-%msg = new_message(
        id       = '/LRN/S4D400'
        number   = '101'
        severity = ms-error
      ).

      APPEND reported_record
        TO reported-Zr8892flight.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
