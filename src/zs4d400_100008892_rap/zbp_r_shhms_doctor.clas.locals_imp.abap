CLASS lhc_zr_shhms_doctor DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING
        REQUEST requested_authorizations FOR ZrShhmsDoctor
      RESULT result.

    METHODS formatDoctorName
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR ZrShhmsDoctor~formatDoctorName.

    METHODS validateDoctor
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR ZrShhmsDoctor~validateDoctor.

ENDCLASS.


CLASS lhc_zr_shhms_doctor IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD formatDoctorName.

    READ ENTITIES OF zr_shhms_doctor IN LOCAL MODE
      ENTITY ZrShhmsDoctor
      FIELDS ( DoctorName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(doctors).

    LOOP AT doctors INTO DATA(doctor).

      DATA words          TYPE STANDARD TABLE OF string WITH EMPTY KEY.
      DATA formatted_name TYPE string.

      SPLIT to_lower( val = doctor-DoctorName )
        AT space INTO TABLE words.

      LOOP AT words ASSIGNING FIELD-SYMBOL(<word>).

        IF <word> IS INITIAL.
          CONTINUE.
        ENDIF.

        IF strlen( <word> ) > 1.

          <word> =
            to_upper(
              val = substring(
                val = <word>
                off = 0
                len = 1
              )
            )
            &&
            substring(
              val = <word>
              off = 1
            ).

        ELSE.

          <word> = to_upper( val = <word> ).

        ENDIF.

      ENDLOOP.

      formatted_name = concat_lines_of(
        table = words
        sep   = ` `
      ).

      IF formatted_name <> doctor-DoctorName.

        MODIFY ENTITIES OF zr_shhms_doctor IN LOCAL MODE
          ENTITY ZrShhmsDoctor
          UPDATE FIELDS ( DoctorName )
          WITH VALUE #(
            (
              %tky       = doctor-%tky
              DoctorName = formatted_name
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validateDoctor.

    READ ENTITIES OF zr_shhms_doctor IN LOCAL MODE
      ENTITY ZrShhmsDoctor
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(doctors).

    LOOP AT doctors INTO DATA(doctor).

      DATA has_error     TYPE abap_bool.
      DATA existing_uuid TYPE zsh_hms_doctor-doctor_uuid.
      DATA phone_text    TYPE string.

      CLEAR:
        has_error,
        existing_uuid,
        phone_text.

      SELECT SINGLE
        FROM zsh_hms_doctor
        FIELDS doctor_uuid
        WHERE doctor_id = @doctor-DoctorID
          AND doctor_uuid <> @doctor-DoctorUUID
        INTO @existing_uuid.

      IF existing_uuid IS NOT INITIAL.

        has_error = abap_true.

        APPEND VALUE #(
          %tky = doctor-%tky
          %element-DoctorID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = |Doctor ID { doctor-DoctorID } already exists.|
          )
        ) TO reported-ZrShhmsDoctor.

      ELSE.

        phone_text = CONV string( doctor-Phone ).

        phone_text = replace(
          val  = phone_text
          sub  = ` `
          with = ``
          occ  = 0
        ).

        IF strlen( phone_text ) <> 10
           OR phone_text CN '0123456789'.

          has_error = abap_true.

          APPEND VALUE #(
            %tky = doctor-%tky
            %element-Phone = if_abap_behv=>mk-on
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text = 'Phone number must contain exactly 10 digits.'
            )
          ) TO reported-ZrShhmsDoctor.

        ELSEIF doctor-Email IS INITIAL
           OR doctor-Email NA '@'
           OR doctor-Email NA '.'.

          has_error = abap_true.

          APPEND VALUE #(
            %tky = doctor-%tky
            %element-Email = if_abap_behv=>mk-on
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text = 'Enter a valid email address.'
            )
          ) TO reported-ZrShhmsDoctor.

        ELSEIF doctor-IsActive <> abap_true
           AND doctor-IsActive <> abap_false.

          has_error = abap_true.

          APPEND VALUE #(
            %tky = doctor-%tky
            %element-IsActive = if_abap_behv=>mk-on
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text = 'Is Active must be X for active or blank for inactive.'
            )
          ) TO reported-ZrShhmsDoctor.

        ENDIF.

      ENDIF.

      IF has_error = abap_true.

        APPEND VALUE #(
          %tky = doctor-%tky
        ) TO failed-ZrShhmsDoctor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
