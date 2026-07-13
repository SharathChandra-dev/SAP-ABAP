@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Appointment Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SH_HMS_APPOINTMENT
  provider contract transactional_query
  as projection on ZI_SH_HMS_APPOINTMENT
{
  key AppointmentUUID,
      @Search.defaultSearchElement: true
      AppointmentID,
      PatientUUID,
      DoctorUUID,
      DepartmentUUID,
      AppointmentDate,
      AppointmentTime,
      @Search.defaultSearchElement: true
      Reason,
      Priority,
      Status,
      Notes,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Patient,
      _Doctor,
      _Department
}
