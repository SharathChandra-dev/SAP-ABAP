CLASS lhc_zr_shhms_doctor DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING
        REQUEST requested_authorizations FOR ZrShhmsDoctor
      RESULT result.

    METHODS normalizeDoctor
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR ZrShhmsDoctor~normalizeDoctor.

    METHODS validateDoctor
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR ZrShhmsDoctor~validateDoctor.

ENDCLASS.


CLASS lhc_zr_shhms_doctor IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD normalizeDoctor.

    READ ENTITIES OF zr_shhms_doctor IN LOCAL MODE
      ENTITY ZrShhmsDoctor
      FIELDS ( DoctorID DoctorName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(doctors).

    LOOP AT doctors INTO DATA(doctor).

      DATA words TYPE STANDARD TABLE OF string WITH EMPTY KEY.
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

      formatted_name =
        concat_lines_of(
          table = words
          sep   = ` `
        ).

      MODIFY ENTITIES OF zr_shhms_doctor IN LOCAL MODE
        ENTITY ZrShhmsDoctor
        UPDATE FIELDS ( DoctorID DoctorName )
        WITH VALUE #(
          (
            %tky       = doctor-%tky
            DoctorID   = to_upper( val = doctor-DoctorID )
            DoctorName = formatted_name
          )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD validateDoctor.

    READ ENTITIES OF zr_shhms_doctor IN LOCAL MODE
      ENTITY ZrShhmsDoctor
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(doctors).

    LOOP AT doctors INTO DATA(doctor).

      DATA existing_uuid TYPE zsh_hms_doctor-doctor_uuid.
      CLEAR existing_uuid.

      SELECT SINGLE
        FROM zsh_hms_doctor
        FIELDS doctor_uuid
        WHERE doctor_id = @doctor-DoctorID
          AND doctor_uuid <> @doctor-DoctorUUID
        INTO @existing_uuid.

      IF existing_uuid IS NOT INITIAL.

        APPEND VALUE #(
          %tky = doctor-%tky
        ) TO failed-ZrShhmsDoctor.

        APPEND VALUE #(
          %tky = doctor-%tky
          %element-DoctorID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = |Doctor ID { doctor-DoctorID } already exists.|
          )
        ) TO reported-ZrShhmsDoctor.

      ENDIF.

      DATA(phone_text) = CONV string( doctor-Phone ).

      phone_text = replace(
        val  = phone_text
        sub  = ` `
        with = ``
        occ  = 0
      ).

      IF strlen( phone_text ) <> 10
         OR phone_text CN '0123456789'.

        APPEND VALUE #(
          %tky = doctor-%tky
        ) TO failed-ZrShhmsDoctor.

        APPEND VALUE #(
          %tky = doctor-%tky
          %element-Phone = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Phone number must contain exactly 10 digits.'
          )
        ) TO reported-ZrShhmsDoctor.

      ENDIF.

      IF doctor-Email NA '@'
         OR doctor-Email NA '.'.

        APPEND VALUE #(
          %tky = doctor-%tky
        ) TO failed-ZrShhmsDoctor.

        APPEND VALUE #(
          %tky = doctor-%tky
          %element-Email = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Enter a valid email address.'
          )
        ) TO reported-ZrShhmsDoctor.

      ENDIF.

      IF doctor-IsActive <> abap_true
         AND doctor-IsActive <> abap_false.

        APPEND VALUE #(
          %tky = doctor-%tky
        ) TO failed-ZrShhmsDoctor.

        APPEND VALUE #(
          %tky = doctor-%tky
          %element-IsActive = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Is Active must be selected as active or inactive.'
          )
        ) TO reported-ZrShhmsDoctor.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
