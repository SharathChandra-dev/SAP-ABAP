CLASS lhc_zr_shhms_appt DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorps
      FOR GLOBAL AUTHORIZATION
      IMPORTING
        REQUEST requested_authorizations
          FOR HospitalAppoinment
      RESULT result.

    METHODS setDisplayNames
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR HospitalAppoinment~setDisplayNames.

    METHODS validateAppointment
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR HospitalAppoinment~validateAppointment.

ENDCLASS.


CLASS lhc_zr_shhms_appt IMPLEMENTATION.

  METHOD get_global_authorps.
  ENDMETHOD.


  METHOD setDisplayNames.

    READ ENTITIES OF zr_shhms_appt IN LOCAL MODE
      ENTITY HospitalAppoinment
      FIELDS (
        PatientUUID
        DoctorUUID
        DepartmentUUID
        Priority
      )
      WITH CORRESPONDING #( keys )
      RESULT DATA(appointments).

    LOOP AT appointments INTO DATA(appointment).

      DATA patient_id          TYPE zsh_hms_appt-patient_id.
      DATA doctor_id           TYPE zsh_hms_appt-doctor_id.
      DATA department_id       TYPE zsh_hms_appt-department_id.
      DATA patient_first_name  TYPE zsh_hms_patient-first_name.
      DATA patient_last_name   TYPE zsh_hms_patient-last_name.
      DATA patient_name        TYPE zsh_hms_appt-patient_name.
      DATA doctor_name         TYPE zsh_hms_appt-doctor_name.
      DATA department_name     TYPE zsh_hms_appt-department_name.
      DATA priority_criticality
        TYPE zsh_hms_appt-priority_criticality.

      CLEAR:
        patient_id,
        doctor_id,
        department_id,
        patient_first_name,
        patient_last_name,
        patient_name,
        doctor_name,
        department_name,
        priority_criticality.

      IF appointment-PatientUUID IS NOT INITIAL.

        SELECT SINGLE
          FROM zsh_hms_patient
          FIELDS patient_id, first_name, last_name
          WHERE patient_uuid = @appointment-PatientUUID
          INTO (
            @patient_id,
            @patient_first_name,
            @patient_last_name
          ).

        CONCATENATE patient_first_name patient_last_name
          INTO patient_name
          SEPARATED BY space.

      ENDIF.

      IF appointment-DoctorUUID IS NOT INITIAL.

        SELECT SINGLE
          FROM zsh_hms_doctor
          FIELDS doctor_id, doctor_name
          WHERE doctor_uuid = @appointment-DoctorUUID
          INTO (
            @doctor_id,
            @doctor_name
          ).

      ENDIF.

      IF appointment-DepartmentUUID IS NOT INITIAL.

        SELECT SINGLE
          FROM zsh_hms_dept
          FIELDS department_id, department_name
          WHERE department_uuid = @appointment-DepartmentUUID
          INTO (
            @department_id,
            @department_name
          ).

      ENDIF.

      CASE appointment-Priority.
        WHEN 'U'.
          priority_criticality = 1.
        WHEN 'H'.
          priority_criticality = 2.
        WHEN 'N'.
          priority_criticality = 3.
        WHEN OTHERS.
          priority_criticality = 0.
      ENDCASE.

      MODIFY ENTITIES OF zr_shhms_appt IN LOCAL MODE
        ENTITY HospitalAppoinment
        UPDATE FIELDS (
          PatientID
          DoctorID
          DepartmentID
          PatientName
          DoctorName
          DepartmentName
          PriorityCriticality
        )
        WITH VALUE #(
          (
            %tky                = appointment-%tky
            PatientID           = patient_id
            DoctorID            = doctor_id
            DepartmentID        = department_id
            PatientName         = patient_name
            DoctorName          = doctor_name
            DepartmentName      = department_name
            PriorityCriticality = priority_criticality
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD validateAppointment.

    READ ENTITIES OF zr_shhms_appt IN LOCAL MODE
      ENTITY HospitalAppoinment
      FIELDS (
        AppointmentUUID
        AppointmentID
        DoctorUUID
        AppointmentDate
        AppointmentTime
      )
      WITH CORRESPONDING #( keys )
      RESULT DATA(appointments_to_validate).

    DATA current_date TYPE d.
    DATA current_time TYPE t.

    current_date =
      cl_abap_context_info=>get_system_date( ).

    current_time =
      cl_abap_context_info=>get_system_time( ).

    LOOP AT appointments_to_validate
      INTO DATA(appointment_to_validate).

      APPEND VALUE #(
        %tky        = appointment_to_validate-%tky
        %state_area = 'VALIDATE_DATE_TIME'
      ) TO reported-HospitalAppoinment.

      APPEND VALUE #(
        %tky        = appointment_to_validate-%tky
        %state_area = 'VALIDATE_DOCTOR_SLOT'
      ) TO reported-HospitalAppoinment.

      IF appointment_to_validate-AppointmentDate < current_date
         OR (
           appointment_to_validate-AppointmentDate = current_date
           AND
           appointment_to_validate-AppointmentTime <= current_time
         ).

        APPEND VALUE #(
          %tky = appointment_to_validate-%tky
        ) TO failed-HospitalAppoinment.

        APPEND VALUE #(
          %tky        = appointment_to_validate-%tky
          %state_area = 'VALIDATE_DATE_TIME'

          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Choose a future appointment date and time.'
          )

          %element-AppointmentDate =
            if_abap_behv=>mk-on

          %element-AppointmentTime =
            if_abap_behv=>mk-on
        ) TO reported-HospitalAppoinment.

        CONTINUE.

      ENDIF.

      IF appointment_to_validate-DoctorUUID IS NOT INITIAL
         AND
         appointment_to_validate-AppointmentDate IS NOT INITIAL
         AND
         appointment_to_validate-AppointmentTime IS NOT INITIAL.

        DATA conflicting_uuid TYPE zsh_hms_appt-appointment_uuid.
        DATA conflicting_id   TYPE zsh_hms_appt-appointment_id.
        DATA patient_id       TYPE zsh_hms_patient-patient_id.
        DATA first_name       TYPE zsh_hms_patient-first_name.
        DATA last_name        TYPE zsh_hms_patient-last_name.
        DATA patient_name     TYPE zsh_hms_appt-patient_name.

        CLEAR:
          conflicting_uuid,
          conflicting_id,
          patient_id,
          first_name,
          last_name,
          patient_name.

        SELECT SINGLE
          FROM zsh_hms_appt AS existing_appointment
          LEFT OUTER JOIN zsh_hms_patient AS existing_patient
            ON existing_patient~patient_uuid =
               existing_appointment~patient_uuid
          FIELDS
            existing_appointment~appointment_uuid,
            existing_appointment~appointment_id,
            existing_patient~patient_id,
            existing_patient~first_name,
            existing_patient~last_name
          WHERE existing_appointment~doctor_uuid =
                  @appointment_to_validate-DoctorUUID
            AND existing_appointment~appointment_date =
                  @appointment_to_validate-AppointmentDate
            AND existing_appointment~appointment_time =
                  @appointment_to_validate-AppointmentTime
            AND existing_appointment~appointment_uuid <>
                  @appointment_to_validate-AppointmentUUID
            AND existing_appointment~status <> 'CX'
          INTO (
            @conflicting_uuid,
            @conflicting_id,
            @patient_id,
            @first_name,
            @last_name
          ).

        IF conflicting_uuid IS NOT INITIAL.

          CONCATENATE first_name last_name
            INTO patient_name
            SEPARATED BY space.

          DATA conflict_message TYPE string.

          conflict_message =
            |Doctor already has appointment { conflicting_id } |
            && |with patient { patient_id } - { patient_name } |
            && |at this date and time.|.

          APPEND VALUE #(
            %tky = appointment_to_validate-%tky
          ) TO failed-HospitalAppoinment.

          APPEND VALUE #(
            %tky        = appointment_to_validate-%tky
            %state_area = 'VALIDATE_DOCTOR_SLOT'

            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = conflict_message
            )

            %element-DoctorUUID =
              if_abap_behv=>mk-on

            %element-AppointmentDate =
              if_abap_behv=>mk-on

            %element-AppointmentTime =
              if_abap_behv=>mk-on
          ) TO reported-HospitalAppoinment.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
