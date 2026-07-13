@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Doctor Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SH_HMS_DOCTOR
  provider contract transactional_query
  as projection on ZI_SH_HMS_DOCTOR
{
  key DoctorUUID,
      @Search.defaultSearchElement: true
      DoctorID,
      @Search.defaultSearchElement: true
      DoctorName,
      Specialization,
      DepartmentUUID,
      Phone,
      Email,
      IsActive,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Department
}
