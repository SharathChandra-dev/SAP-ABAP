CLASS zcl_sh_hms_seed_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CLASS-METHODS add_department
      IMPORTING department_id   TYPE zsh_hms_dept-department_id
                department_name TYPE zsh_hms_dept-department_name
                floor_no        TYPE zsh_hms_dept-floor_no
                phone           TYPE zsh_hms_dept-phone
                created_by      TYPE zsh_hms_dept-created_by
                changed_at      TYPE timestampl
      RETURNING VALUE(uuid)     TYPE sysuuid_x16
      RAISING   cx_uuid_error.

    CLASS-METHODS add_doctor
      IMPORTING doctor_id       TYPE zsh_hms_doctor-doctor_id
                doctor_name     TYPE zsh_hms_doctor-doctor_name
                specialization  TYPE zsh_hms_doctor-specialization
                department_uuid TYPE zsh_hms_doctor-department_uuid
                phone           TYPE zsh_hms_doctor-phone
                email           TYPE zsh_hms_doctor-email
                created_by      TYPE zsh_hms_doctor-created_by
                changed_at      TYPE timestampl
      RETURNING VALUE(uuid)     TYPE sysuuid_x16
      RAISING   cx_uuid_error.

    CLASS-METHODS add_patient
      IMPORTING patient_id       TYPE zsh_hms_patient-patient_id
                first_name       TYPE zsh_hms_patient-first_name
                last_name        TYPE zsh_hms_patient-last_name
                date_of_birth    TYPE zsh_hms_patient-date_of_birth
                gender           TYPE zsh_hms_patient-gender
                phone            TYPE zsh_hms_patient-phone
                email            TYPE zsh_hms_patient-email
                address          TYPE zsh_hms_patient-address
                critical_allergy TYPE zsh_hms_patient-critical_allergy
                created_by       TYPE zsh_hms_patient-created_by
                changed_at       TYPE timestampl
      RETURNING VALUE(uuid)      TYPE sysuuid_x16
      RAISING   cx_uuid_error.

    CLASS-METHODS add_appointment
      IMPORTING appointment_id   TYPE zsh_hms_appt-appointment_id
                patient_uuid     TYPE zsh_hms_appt-patient_uuid
                doctor_uuid      TYPE zsh_hms_appt-doctor_uuid
                department_uuid  TYPE zsh_hms_appt-department_uuid
                appointment_date TYPE zsh_hms_appt-appointment_date
                appointment_time TYPE zsh_hms_appt-appointment_time
                reason           TYPE zsh_hms_appt-reason
                priority         TYPE zsh_hms_appt-priority
                status           TYPE zsh_hms_appt-status
                notes            TYPE zsh_hms_appt-notes
                created_by       TYPE zsh_hms_appt-created_by
                changed_at       TYPE timestampl
      RAISING   cx_uuid_error.
ENDCLASS.

CLASS zcl_sh_hms_seed_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA now TYPE timestampl.
    DATA current_date TYPE zsh_hms_appt-appointment_date.
    DATA appt_date_1 TYPE zsh_hms_appt-appointment_date.
    DATA appt_date_2 TYPE zsh_hms_appt-appointment_date.
    DATA appt_date_3 TYPE zsh_hms_appt-appointment_date.
    DATA appt_date_4 TYPE zsh_hms_appt-appointment_date.
    DATA current_user TYPE zsh_hms_dept-created_by.

    DATA dept_cardio TYPE sysuuid_x16.
    DATA dept_neuro  TYPE sysuuid_x16.
    DATA dept_ortho  TYPE sysuuid_x16.
    DATA dept_peds   TYPE sysuuid_x16.

    DATA doctor_meera TYPE sysuuid_x16.
    DATA doctor_arjun TYPE sysuuid_x16.
    DATA doctor_kavya TYPE sysuuid_x16.
    DATA doctor_rohan TYPE sysuuid_x16.
    DATA doctor_sneha TYPE sysuuid_x16.

    DATA patient_ananya TYPE sysuuid_x16.
    DATA patient_rahul  TYPE sysuuid_x16.
    DATA patient_neha   TYPE sysuuid_x16.
    DATA patient_vikram TYPE sysuuid_x16.
    DATA patient_sana   TYPE sysuuid_x16.
    DATA patient_amit   TYPE sysuuid_x16.

    current_date = cl_abap_context_info=>get_system_date( ).
    appt_date_1 = current_date + 1.
    appt_date_2 = current_date + 2.
    appt_date_3 = current_date + 3.
    appt_date_4 = current_date + 4.
    current_user = cl_abap_context_info=>get_user_technical_name( ).
    GET TIME STAMP FIELD now.

    DELETE FROM zsh_hms_appt
      WHERE appointment_id = 'APT-DEMO-001'
         OR appointment_id = 'APT-DEMO-002'
         OR appointment_id = 'APT-DEMO-003'
         OR appointment_id = 'APT-DEMO-004'
         OR appointment_id = 'APT-DEMO-005'
         OR appointment_id = 'APT-DEMO-006'.

    DELETE FROM zsh_hms_doctor
      WHERE doctor_id = 'DR001'
         OR doctor_id = 'DR002'
         OR doctor_id = 'DR003'
         OR doctor_id = 'DR004'
         OR doctor_id = 'DR005'.

    DELETE FROM zsh_hms_patient
      WHERE patient_id = 'P001'
         OR patient_id = 'P002'
         OR patient_id = 'P003'
         OR patient_id = 'P004'
         OR patient_id = 'P005'
         OR patient_id = 'P006'.

    DELETE FROM zsh_hms_dept
      WHERE department_id = 'D001'
         OR department_id = 'D002'
         OR department_id = 'D003'
         OR department_id = 'D004'.

    TRY.
        dept_cardio = add_department(
          department_id   = 'D001'
          department_name = 'Cardiology'
          floor_no        = '3'
          phone           = '555-3100'
          created_by      = current_user
          changed_at      = now ).

        dept_neuro = add_department(
          department_id   = 'D002'
          department_name = 'Neurology'
          floor_no        = '4'
          phone           = '555-4100'
          created_by      = current_user
          changed_at      = now ).

        dept_ortho = add_department(
          department_id   = 'D003'
          department_name = 'Orthopedics'
          floor_no        = '2'
          phone           = '555-2100'
          created_by      = current_user
          changed_at      = now ).

        dept_peds = add_department(
          department_id   = 'D004'
          department_name = 'Pediatrics'
          floor_no        = '1'
          phone           = '555-1100'
          created_by      = current_user
          changed_at      = now ).

        doctor_meera = add_doctor(
          doctor_id       = 'DR001'
          doctor_name     = 'Dr. Meera Shah'
          specialization  = 'Cardiologist'
          department_uuid = dept_cardio
          phone           = '555-3111'
          email           = 'meera.shah@example.com'
          created_by      = current_user
          changed_at      = now ).

        doctor_arjun = add_doctor(
          doctor_id       = 'DR002'
          doctor_name     = 'Dr. Arjun Rao'
          specialization  = 'Neurologist'
          department_uuid = dept_neuro
          phone           = '555-4111'
          email           = 'arjun.rao@example.com'
          created_by      = current_user
          changed_at      = now ).

        doctor_kavya = add_doctor(
          doctor_id       = 'DR003'
          doctor_name     = 'Dr. Kavya Nair'
          specialization  = 'Orthopedic Surgeon'
          department_uuid = dept_ortho
          phone           = '555-2111'
          email           = 'kavya.nair@example.com'
          created_by      = current_user
          changed_at      = now ).

        doctor_rohan = add_doctor(
          doctor_id       = 'DR004'
          doctor_name     = 'Dr. Rohan Mehta'
          specialization  = 'Pediatrician'
          department_uuid = dept_peds
          phone           = '555-1111'
          email           = 'rohan.mehta@example.com'
          created_by      = current_user
          changed_at      = now ).

        doctor_sneha = add_doctor(
          doctor_id       = 'DR005'
          doctor_name     = 'Dr. Sneha Kulkarni'
          specialization  = 'General Physician'
          department_uuid = dept_cardio
          phone           = '555-3122'
          email           = 'sneha.kulkarni@example.com'
          created_by      = current_user
          changed_at      = now ).

        patient_ananya = add_patient(
          patient_id       = 'P001'
          first_name       = 'Ananya'
          last_name        = 'Iyer'
          date_of_birth    = '19980514'
          gender           = 'F'
          phone            = '555-2001'
          email            = 'ananya.iyer@example.com'
          address          = '12 Lake View Road'
          critical_allergy = 'Penicillin'
          created_by       = current_user
          changed_at       = now ).

        patient_rahul = add_patient(
          patient_id       = 'P002'
          first_name       = 'Rahul'
          last_name        = 'Verma'
          date_of_birth    = '19891203'
          gender           = 'M'
          phone            = '555-2002'
          email            = 'rahul.verma@example.com'
          address          = '44 Market Street'
          critical_allergy = 'None'
          created_by       = current_user
          changed_at       = now ).

        patient_neha = add_patient(
          patient_id       = 'P003'
          first_name       = 'Neha'
          last_name        = 'Kapoor'
          date_of_birth    = '19920322'
          gender           = 'F'
          phone            = '555-2003'
          email            = 'neha.kapoor@example.com'
          address          = '8 Garden Avenue'
          critical_allergy = 'Sulfa drugs'
          created_by       = current_user
          changed_at       = now ).

        patient_vikram = add_patient(
          patient_id       = 'P004'
          first_name       = 'Vikram'
          last_name        = 'Singh'
          date_of_birth    = '19771109'
          gender           = 'M'
          phone            = '555-2004'
          email            = 'vikram.singh@example.com'
          address          = '27 River Road'
          critical_allergy = 'Latex'
          created_by       = current_user
          changed_at       = now ).

        patient_sana = add_patient(
          patient_id       = 'P005'
          first_name       = 'Sana'
          last_name        = 'Khan'
          date_of_birth    = '20010418'
          gender           = 'F'
          phone            = '555-2005'
          email            = 'sana.khan@example.com'
          address          = '19 Hill Street'
          critical_allergy = 'Peanuts'
          created_by       = current_user
          changed_at       = now ).

        patient_amit = add_patient(
          patient_id       = 'P006'
          first_name       = 'Amit'
          last_name        = 'Patel'
          date_of_birth    = '19840630'
          gender           = 'M'
          phone            = '555-2006'
          email            = 'amit.patel@example.com'
          address          = '65 Palm Layout'
          critical_allergy = 'None'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-001'
          patient_uuid     = patient_ananya
          doctor_uuid      = doctor_meera
          department_uuid  = dept_cardio
          appointment_date = appt_date_1
          appointment_time = '100000'
          reason           = 'Chest pain consultation'
          priority         = 'U'
          status           = zcl_sh_hms_status_helper=>c_status_booked
          notes            = 'Demo appointment created from seed data class.'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-002'
          patient_uuid     = patient_rahul
          doctor_uuid      = doctor_arjun
          department_uuid  = dept_neuro
          appointment_date = appt_date_2
          appointment_time = '113000'
          reason           = 'Migraine follow-up'
          priority         = 'N'
          status           = zcl_sh_hms_status_helper=>c_status_confirmed
          notes            = 'Follow-up consultation after previous medication.'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-003'
          patient_uuid     = patient_neha
          doctor_uuid      = doctor_kavya
          department_uuid  = dept_ortho
          appointment_date = appt_date_1
          appointment_time = '143000'
          reason           = 'Knee pain review'
          priority         = 'N'
          status           = zcl_sh_hms_status_helper=>c_status_booked
          notes            = 'Patient reports knee pain while walking.'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-004'
          patient_uuid     = patient_vikram
          doctor_uuid      = doctor_sneha
          department_uuid  = dept_cardio
          appointment_date = current_date
          appointment_time = '090000'
          reason           = 'Routine diabetes check'
          priority         = 'N'
          status           = zcl_sh_hms_status_helper=>c_status_checked_in
          notes            = 'Patient already checked in for routine visit.'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-005'
          patient_uuid     = patient_sana
          doctor_uuid      = doctor_rohan
          department_uuid  = dept_peds
          appointment_date = appt_date_3
          appointment_time = '153000'
          reason           = 'Fever and cough'
          priority         = 'U'
          status           = zcl_sh_hms_status_helper=>c_status_confirmed
          notes            = 'Confirmed pediatric appointment.'
          created_by       = current_user
          changed_at       = now ).

        add_appointment(
          appointment_id   = 'APT-DEMO-006'
          patient_uuid     = patient_amit
          doctor_uuid      = doctor_meera
          department_uuid  = dept_cardio
          appointment_date = appt_date_4
          appointment_time = '160000'
          reason           = 'Blood pressure consultation'
          priority         = 'N'
          status           = zcl_sh_hms_status_helper=>c_status_cancelled
          notes            = 'Cancelled by patient request.'
          created_by       = current_user
          changed_at       = now ).

      CATCH cx_uuid_error INTO DATA(uuid_error).
        out->write( uuid_error->get_text( ) ).
        RETURN.
    ENDTRY.

    COMMIT WORK.

    out->write( 'Multiple seed data records created successfully.' ).
    out->write( 'Refresh the Fiori preview and click Go.' ).
  ENDMETHOD.

  METHOD add_department.
    DATA dept TYPE zsh_hms_dept.

    uuid = cl_system_uuid=>create_uuid_x16_static( ).
    dept-department_uuid = uuid.
    dept-department_id = department_id.
    dept-department_name = department_name.
    dept-floor_no = floor_no.
    dept-phone = phone.
    dept-is_active = abap_true.
    dept-created_by = created_by.
    dept-created_at = changed_at.
    dept-last_changed_by = created_by.
    dept-last_changed_at = changed_at.
    dept-local_last_changed_at = changed_at.

    INSERT zsh_hms_dept FROM @dept.
  ENDMETHOD.

  METHOD add_doctor.
    DATA doctor TYPE zsh_hms_doctor.

    uuid = cl_system_uuid=>create_uuid_x16_static( ).
    doctor-doctor_uuid = uuid.
    doctor-doctor_id = doctor_id.
    doctor-doctor_name = doctor_name.
    doctor-specialization = specialization.
    doctor-department_uuid = department_uuid.
    doctor-phone = phone.
    doctor-email = email.
    doctor-is_active = abap_true.
    doctor-created_by = created_by.
    doctor-created_at = changed_at.
    doctor-last_changed_by = created_by.
    doctor-last_changed_at = changed_at.
    doctor-local_last_changed_at = changed_at.

    INSERT zsh_hms_doctor FROM @doctor.
  ENDMETHOD.

  METHOD add_patient.
    DATA patient TYPE zsh_hms_patient.

    uuid = cl_system_uuid=>create_uuid_x16_static( ).
    patient-patient_uuid = uuid.
    patient-patient_id = patient_id.
    patient-first_name = first_name.
    patient-last_name = last_name.
    patient-date_of_birth = date_of_birth.
    patient-gender = gender.
    patient-phone = phone.
    patient-email = email.
    patient-address = address.
    patient-critical_allergy = critical_allergy.
    patient-created_by = created_by.
    patient-created_at = changed_at.
    patient-last_changed_by = created_by.
    patient-last_changed_at = changed_at.
    patient-local_last_changed_at = changed_at.

    INSERT zsh_hms_patient FROM @patient.
  ENDMETHOD.

  METHOD add_appointment.
    DATA appt TYPE zsh_hms_appt.

    appt-appointment_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    appt-appointment_id = appointment_id.
    appt-patient_uuid = patient_uuid.
    appt-doctor_uuid = doctor_uuid.
    appt-department_uuid = department_uuid.
    appt-appointment_date = appointment_date.
    appt-appointment_time = appointment_time.
    appt-reason = reason.
    appt-priority = priority.
    appt-status = status.
    appt-notes = notes.
    appt-created_by = created_by.
    appt-created_at = changed_at.
    appt-last_changed_by = created_by.
    appt-last_changed_at = changed_at.
    appt-local_last_changed_at = changed_at.

    INSERT zsh_hms_appt FROM @appt.
  ENDMETHOD.
ENDCLASS.
