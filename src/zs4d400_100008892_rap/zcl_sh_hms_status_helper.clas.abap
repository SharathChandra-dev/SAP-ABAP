CLASS zcl_sh_hms_status_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS c_status_booked     TYPE zsh_hms_appt-status VALUE 'BK'.
    CONSTANTS c_status_confirmed  TYPE zsh_hms_appt-status VALUE 'CF'.
    CONSTANTS c_status_checked_in TYPE zsh_hms_appt-status VALUE 'CI'.
    CONSTANTS c_status_completed  TYPE zsh_hms_appt-status VALUE 'CO'.
    CONSTANTS c_status_cancelled  TYPE zsh_hms_appt-status VALUE 'CX'.

    CLASS-METHODS can_confirm
      IMPORTING status TYPE zsh_hms_appt-status
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS can_cancel
      IMPORTING status TYPE zsh_hms_appt-status
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS can_check_in
      IMPORTING status TYPE zsh_hms_appt-status
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS can_complete
      IMPORTING status TYPE zsh_hms_appt-status
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS zcl_sh_hms_status_helper IMPLEMENTATION.
  METHOD can_confirm.
    result = xsdbool( status = c_status_booked ).
  ENDMETHOD.

  METHOD can_cancel.
    result = xsdbool(
      status = c_status_booked OR
      status = c_status_confirmed ).
  ENDMETHOD.

  METHOD can_check_in.
    result = xsdbool( status = c_status_confirmed ).
  ENDMETHOD.

  METHOD can_complete.
    result = xsdbool( status = c_status_checked_in ).
  ENDMETHOD.
ENDCLASS.
