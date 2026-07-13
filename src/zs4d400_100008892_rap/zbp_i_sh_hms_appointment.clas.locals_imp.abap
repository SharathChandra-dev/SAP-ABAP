CLASS lhc_Appointment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Appointment RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Appointment RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION Appointment~cancel RESULT result.

    METHODS checkIn FOR MODIFY
      IMPORTING keys FOR ACTION Appointment~checkIn RESULT result.

    METHODS complete FOR MODIFY
      IMPORTING keys FOR ACTION Appointment~complete RESULT result.

    METHODS confirm FOR MODIFY
      IMPORTING keys FOR ACTION Appointment~confirm RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Appointment~setInitialStatus.

    METHODS validateAppointment FOR VALIDATE ON SAVE
      IMPORTING keys FOR Appointment~validateAppointment.

ENDCLASS.

CLASS lhc_Appointment IMPLEMENTATION.

  METHOD get_instance_authorizations.
    result = VALUE #(
      FOR key IN keys
      ( %tky = key-%tky
        %update = if_abap_behv=>auth-allowed
        %delete = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD cancel.
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments ASSIGNING FIELD-SYMBOL(<appointment>).
      IF zcl_sh_hms_status_helper=>can_cancel( <appointment>-Status ) = abap_false.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-Status = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only booked or confirmed appointments can be cancelled.' ) ) TO reported-appointment.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR appointment IN appointments
          WHERE ( Status = zcl_sh_hms_status_helper=>c_status_booked OR
                  Status = zcl_sh_hms_status_helper=>c_status_confirmed )
          ( %tky = appointment-%tky
            Status = zcl_sh_hms_status_helper=>c_status_cancelled ) ).

    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_appointments).

    result = VALUE #( FOR appointment IN updated_appointments
      ( %tky = appointment-%tky
        %param = appointment ) ).
  ENDMETHOD.

  METHOD checkIn.
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments ASSIGNING FIELD-SYMBOL(<appointment>).
      IF zcl_sh_hms_status_helper=>can_check_in( <appointment>-Status ) = abap_false.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-Status = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only confirmed appointments can be checked in.' ) ) TO reported-appointment.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR appointment IN appointments
          WHERE ( Status = zcl_sh_hms_status_helper=>c_status_confirmed )
          ( %tky = appointment-%tky
            Status = zcl_sh_hms_status_helper=>c_status_checked_in ) ).

    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_appointments).

    result = VALUE #( FOR appointment IN updated_appointments
      ( %tky = appointment-%tky
        %param = appointment ) ).
  ENDMETHOD.

  METHOD complete.
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments ASSIGNING FIELD-SYMBOL(<appointment>).
      IF zcl_sh_hms_status_helper=>can_complete( <appointment>-Status ) = abap_false.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-Status = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only checked-in appointments can be completed.' ) ) TO reported-appointment.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR appointment IN appointments
          WHERE ( Status = zcl_sh_hms_status_helper=>c_status_checked_in )
          ( %tky = appointment-%tky
            Status = zcl_sh_hms_status_helper=>c_status_completed ) ).

    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_appointments).

    result = VALUE #( FOR appointment IN updated_appointments
      ( %tky = appointment-%tky
        %param = appointment ) ).
  ENDMETHOD.

  METHOD confirm.
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments ASSIGNING FIELD-SYMBOL(<appointment>).
      IF zcl_sh_hms_status_helper=>can_confirm( <appointment>-Status ) = abap_false.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-Status = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only booked appointments can be confirmed.' ) ) TO reported-appointment.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR appointment IN appointments
          WHERE ( Status = zcl_sh_hms_status_helper=>c_status_booked )
          ( %tky = appointment-%tky
            Status = zcl_sh_hms_status_helper=>c_status_confirmed ) ).

    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_appointments).

    result = VALUE #( FOR appointment IN updated_appointments
      ( %tky = appointment-%tky
        %param = appointment ) ).
  ENDMETHOD.

  METHOD setInitialStatus.
    DATA(current_date) = cl_abap_context_info=>get_system_date( ).
    DATA(current_time) = cl_abap_context_info=>get_system_time( ).
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( AppointmentID Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    MODIFY ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        UPDATE FIELDS ( AppointmentID Status )
        WITH VALUE #(
          FOR appointment IN appointments
          WHERE ( Status IS INITIAL )
          ( %tky = appointment-%tky
            AppointmentID = |APT-{ current_date }-{ current_time }|
            Status = zcl_sh_hms_status_helper=>c_status_booked ) ).
  ENDMETHOD.

  METHOD validateAppointment.
    DATA(current_date) = cl_abap_context_info=>get_system_date( ).
    READ ENTITIES OF zi_sh_hms_appointment IN LOCAL MODE
      ENTITY Appointment
        FIELDS ( PatientUUID DoctorUUID DepartmentUUID AppointmentDate AppointmentTime Reason )
        WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments ASSIGNING FIELD-SYMBOL(<appointment>).
      IF <appointment>-PatientUUID IS INITIAL.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-PatientUUID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Patient is required.' ) ) TO reported-appointment.
      ENDIF.

      IF <appointment>-DoctorUUID IS INITIAL.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-DoctorUUID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Doctor is required.' ) ) TO reported-appointment.
      ENDIF.

      IF <appointment>-DepartmentUUID IS INITIAL.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-DepartmentUUID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Department is required.' ) ) TO reported-appointment.
      ENDIF.

      IF <appointment>-AppointmentDate IS INITIAL OR
        <appointment>-AppointmentDate < current_date.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-AppointmentDate = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Appointment date must be today or a future date.' ) ) TO reported-appointment.
      ENDIF.

      IF <appointment>-AppointmentTime IS INITIAL.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-AppointmentTime = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Appointment time is required.' ) ) TO reported-appointment.
      ENDIF.

      IF <appointment>-Reason IS INITIAL.
        APPEND VALUE #( %tky = <appointment>-%tky ) TO failed-appointment.
        APPEND VALUE #(
          %tky = <appointment>-%tky
          %element-Reason = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Reason is required.' ) ) TO reported-appointment.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
