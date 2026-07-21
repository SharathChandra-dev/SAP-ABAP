@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSHHMS_APPT'
@EndUserText.label: 'HMS Appointment Root View'

define root view entity ZR_SHHMS_APPT
  as select from zsh_hms_appt as Appointment

  association [0..1] to ZVH_SH_HMS_PATIENT as _PatientVH
    on $projection.PatientUUID = _PatientVH.PatientUUID

  association [0..1] to ZVH_SH_HMS_DOCTOR as _DoctorVH
    on $projection.DoctorUUID = _DoctorVH.DoctorUUID

  association [0..1] to ZVH_SH_HMS_DEPT as _DepartmentVH
    on $projection.DepartmentUUID = _DepartmentVH.DepartmentUUID
{
  key appointment_uuid as AppointmentUUID,

  @EndUserText.label: 'Appointment ID'
  appointment_id as AppointmentID,

  @EndUserText.label: 'Patient'
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_PATIENT',
        element: 'PatientUUID'
      }
    }
  ]
  patient_uuid as PatientUUID,

  @EndUserText.label: 'Doctor'
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_DOCTOR',
        element: 'DoctorUUID'
      }
    }
  ]
  doctor_uuid as DoctorUUID,

  @EndUserText.label: 'Department'
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_DEPT',
        element: 'DepartmentUUID'
      }
    }
  ]
  department_uuid as DepartmentUUID,

  @EndUserText.label: 'Patient ID'
  patient_id as PatientID,

  @EndUserText.label: 'Doctor ID'
  doctor_id as DoctorID,

  @EndUserText.label: 'Department ID'
  department_id as DepartmentID,

  @EndUserText.label: 'Patient Name'
  patient_name as PatientName,

  @EndUserText.label: 'Doctor Name'
  doctor_name as DoctorName,

  @EndUserText.label: 'Department'
  department_name as DepartmentName,

  @EndUserText.label: 'Appointment Date'
  appointment_date as AppointmentDate,

  @EndUserText.label: 'Appointment Time'
  appointment_time as AppointmentTime,

  @EndUserText.label: 'Reason'
  reason as Reason,

  @EndUserText.label: 'Priority'
  priority as Priority,
  @EndUserText.label: 'Priority Criticality'
  priority_criticality as PriorityCriticality,

  @EndUserText.label: 'Status'
  status as Status,

  @EndUserText.label: 'Notes'
  notes as Notes,

  @Semantics.user.createdBy: true
  created_by as CreatedBy,

  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,

  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,

  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,

  _PatientVH,
  _DoctorVH,
  _DepartmentVH
}
