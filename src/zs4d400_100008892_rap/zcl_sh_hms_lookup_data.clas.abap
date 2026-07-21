CLASS zcl_sh_hms_lookup_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_sh_hms_lookup_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA priorities TYPE STANDARD TABLE OF zsh_hms_priority
      WITH EMPTY KEY.

    DATA statuses TYPE STANDARD TABLE OF zsh_hms_status
      WITH EMPTY KEY.

    priorities = VALUE #(
      (
        priority      = 'U'
        priority_text = 'Urgent'
        criticality   = 1
      )
      (
        priority      = 'H'
        priority_text = 'High'
        criticality   = 2
      )
      (
        priority      = 'N'
        priority_text = 'Normal'
        criticality   = 3
      )
      (
        priority      = 'L'
        priority_text = 'Low'
        criticality   = 0
      )
    ).

    statuses = VALUE #(
      (
        status      = 'BK'
        status_text = 'Booked'
        criticality = 0
      )
      (
        status      = 'CF'
        status_text = 'Confirmed'
        criticality = 3
      )
      (
        status      = 'CI'
        status_text = 'Checked In'
        criticality = 2
      )
      (
        status      = 'CU'
        status_text = 'Completed'
        criticality = 3
      )
      (
        status      = 'CX'
        status_text = 'Cancelled'
        criticality = 1
      )
    ).

    MODIFY zsh_hms_priority FROM TABLE @priorities.
    MODIFY zsh_hms_status FROM TABLE @statuses.

    out->write(
      'Priority and status lookup values created successfully.'
    ).

  ENDMETHOD.

ENDCLASS.
