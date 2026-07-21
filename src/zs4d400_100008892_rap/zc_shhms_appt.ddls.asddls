@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'HMS Appointments'
@ObjectModel.sapObjectNodeType.name: 'ZSHHMS_APPT'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZC_SHHMS_APPT
  provider contract transactional_query
  as projection on ZR_SHHMS_APPT
{
  key AppointmentUUID,

  @EndUserText.label: 'Appointment ID'
  AppointmentID,

  @EndUserText.label: 'Patient ID'
  @ObjectModel.text.element: [ 'PatientID' ]
  @UI.textArrangement: #TEXT_ONLY
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_PATIENT',
        element: 'PatientUUID'
      }
    }
  ]
  PatientUUID,

  @EndUserText.label: 'Doctor ID'
  @ObjectModel.text.element: [ 'DoctorID' ]
  @UI.textArrangement: #TEXT_ONLY
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_DOCTOR',
        element: 'DoctorUUID'
      }
    }
  ]
  DoctorUUID,

  @EndUserText.label: 'Department ID'
  @ObjectModel.text.element: [ 'DepartmentID' ]
  @UI.textArrangement: #TEXT_ONLY
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_DEPT',
        element: 'DepartmentUUID'
      }
    }
  ]
  DepartmentUUID,

  @EndUserText.label: 'Patient ID'
  PatientID,

  @EndUserText.label: 'Doctor ID'
  DoctorID,

  @EndUserText.label: 'Department ID'
  DepartmentID,

  @EndUserText.label: 'Patient Name'
  PatientName,

  @EndUserText.label: 'Doctor Name'
  DoctorName,

  @EndUserText.label: 'Department Name'
  DepartmentName,

  @EndUserText.label: 'Appointment Date'
  AppointmentDate,

  @EndUserText.label: 'Appointment Time'
  AppointmentTime,

  @EndUserText.label: 'Reason'
  Reason,

  @EndUserText.label: 'Priority'
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_PRIORITY',
        element: 'Priority'
      },
      useForValidation: true
    }
  ]
  Priority,
  @EndUserText.label: 'Priority Criticality'
  PriorityCriticality,

  @EndUserText.label: 'Status'
  @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZVH_SH_HMS_STATUS',
        element: 'Status'
      },
      useForValidation: true
    }
  ]
  Status,

  @EndUserText.label: 'Notes'
  Notes,

  @Semantics.user.createdBy: true
  CreatedBy,

  @Semantics.systemDateTime.createdAt: true
  CreatedAt,

  @Semantics.user.lastChangedBy: true
  LastChangedBy,

  @Semantics.systemDateTime.lastChangedAt: true
  LastChangedAt,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LocalLastChangedAt,

  _PatientVH,
  _DoctorVH,
  _DepartmentVH
}
