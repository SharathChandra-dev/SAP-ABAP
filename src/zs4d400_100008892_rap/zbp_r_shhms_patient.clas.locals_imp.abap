CLASS lhc_zr_shhms_patient DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING
        REQUEST requested_authorizations FOR ZrShhmsPatient
      RESULT result.

    METHODS formatPatientNames
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR ZrShhmsPatient~formatPatientNames.

    METHODS validatePatient
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR ZrShhmsPatient~validatePatient.

ENDCLASS.


CLASS lhc_zr_shhms_patient IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD formatPatientNames.

    READ ENTITIES OF zr_shhms_patient IN LOCAL MODE
      ENTITY ZrShhmsPatient
      FIELDS ( FirstName LastName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(patients).

    LOOP AT patients INTO DATA(patient).

      DATA first_name_words TYPE STANDARD TABLE OF string
                            WITH EMPTY KEY.
      DATA last_name_words  TYPE STANDARD TABLE OF string
                            WITH EMPTY KEY.

      DATA formatted_first_name TYPE zsh_hms_patient-first_name.
      DATA formatted_last_name  TYPE zsh_hms_patient-last_name.

      CLEAR:
        first_name_words,
        last_name_words,
        formatted_first_name,
        formatted_last_name.

      SPLIT to_lower( val = patient-FirstName )
        AT space INTO TABLE first_name_words.

      LOOP AT first_name_words ASSIGNING FIELD-SYMBOL(<first_word>).

        IF <first_word> IS INITIAL.
          CONTINUE.
        ENDIF.

        IF strlen( <first_word> ) > 1.

          <first_word> =
            to_upper(
              val = substring(
                val = <first_word>
                off = 0
                len = 1
              )
            )
            &&
            substring(
              val = <first_word>
              off = 1
            ).

        ELSE.

          <first_word> = to_upper( val = <first_word> ).

        ENDIF.

      ENDLOOP.

      formatted_first_name = concat_lines_of(
        table = first_name_words
        sep   = ` `
      ).

      SPLIT to_lower( val = patient-LastName )
        AT space INTO TABLE last_name_words.

      LOOP AT last_name_words ASSIGNING FIELD-SYMBOL(<last_word>).

        IF <last_word> IS INITIAL.
          CONTINUE.
        ENDIF.

        IF strlen( <last_word> ) > 1.

          <last_word> =
            to_upper(
              val = substring(
                val = <last_word>
                off = 0
                len = 1
              )
            )
            &&
            substring(
              val = <last_word>
              off = 1
            ).

        ELSE.

          <last_word> = to_upper( val = <last_word> ).

        ENDIF.

      ENDLOOP.

      formatted_last_name = concat_lines_of(
        table = last_name_words
        sep   = ` `
      ).

      IF formatted_first_name <> patient-FirstName
         OR formatted_last_name <> patient-LastName.

        MODIFY ENTITIES OF zr_shhms_patient IN LOCAL MODE
          ENTITY ZrShhmsPatient
          UPDATE FIELDS ( FirstName LastName )
          WITH VALUE #(
            (
              %tky      = patient-%tky
              FirstName = formatted_first_name
              LastName  = formatted_last_name
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validatePatient.

    READ ENTITIES OF zr_shhms_patient IN LOCAL MODE
      ENTITY ZrShhmsPatient
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(patients).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT patients INTO DATA(patient).

      DATA has_error     TYPE abap_bool.
      DATA existing_uuid TYPE zsh_hms_patient-patient_uuid.
      DATA phone_text    TYPE string.

      CLEAR:
        has_error,
        existing_uuid,
        phone_text.

      SELECT SINGLE
        FROM zsh_hms_patient
        FIELDS patient_uuid
        WHERE patient_id = @patient-PatientID
          AND patient_uuid <> @patient-PatientUUID
        INTO @existing_uuid.

      IF existing_uuid IS NOT INITIAL.

        has_error = abap_true.

        APPEND VALUE #(
          %tky = patient-%tky
          %element-PatientID = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = |Patient ID { patient-PatientID } already exists.|
          )
        ) TO reported-ZrShhmsPatient.

      ENDIF.

      phone_text = CONV string( patient-Phone ).

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
          %tky = patient-%tky
          %element-Phone = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Phone number must contain exactly 10 digits.'
          )
        ) TO reported-ZrShhmsPatient.

      ENDIF.

      IF patient-Email IS INITIAL
         OR patient-Email NA '@'
         OR patient-Email NA '.'.

        has_error = abap_true.

        APPEND VALUE #(
          %tky = patient-%tky
          %element-Email = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Enter a valid email address.'
          )
        ) TO reported-ZrShhmsPatient.

      ENDIF.

      IF patient-DateOfBirth IS INITIAL
         OR patient-DateOfBirth >= today.

        has_error = abap_true.

        APPEND VALUE #(
          %tky = patient-%tky
          %element-DateOfBirth = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Date of birth must be earlier than today.'
          )
        ) TO reported-ZrShhmsPatient.

      ENDIF.

      IF patient-Gender <> 'M'
         AND patient-Gender <> 'F'
         AND patient-Gender <> 'O'.

        has_error = abap_true.

        APPEND VALUE #(
          %tky = patient-%tky
          %element-Gender = if_abap_behv=>mk-on
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Gender must be M, F, or O.'
          )
        ) TO reported-ZrShhmsPatient.

      ENDIF.

      IF has_error = abap_true.

        APPEND VALUE #(
          %tky = patient-%tky
        ) TO failed-ZrShhmsPatient.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
