@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Appointment Interface'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'AppointmentID' ]
define root view entity ZI_SH_HMS_APPOINTMENT
  as select from zsh_hms_appt
  association [0..1] to ZI_SH_HMS_PATIENT as _Patient
    on $projection.PatientUUID = _Patient.PatientUUID
  association [0..1] to ZI_SH_HMS_DOCTOR as _Doctor
    on $projection.DoctorUUID = _Doctor.DoctorUUID
  association [0..1] to ZI_SH_HMS_DEPT as _Department
    on $projection.DepartmentUUID = _Department.DepartmentUUID
{
  key appointment_uuid      as AppointmentUUID,
      appointment_id        as AppointmentID,
      patient_uuid          as PatientUUID,
      doctor_uuid           as DoctorUUID,
      department_uuid       as DepartmentUUID,
      appointment_date      as AppointmentDate,
      appointment_time      as AppointmentTime,
      reason                as Reason,
      priority              as Priority,
      status                as Status,
      notes                 as Notes,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      _Patient,
      _Doctor,
      _Department
}
