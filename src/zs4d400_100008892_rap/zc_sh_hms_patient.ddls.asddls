@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Patient Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SH_HMS_PATIENT
  provider contract transactional_query
  as projection on ZI_SH_HMS_PATIENT
{
  key PatientUUID,
      @Search.defaultSearchElement: true
      PatientID,
      @Search.defaultSearchElement: true
      FirstName,
      @Search.defaultSearchElement: true
      LastName,
      DateOfBirth,
      Gender,
      Phone,
      Email,
      Address,
      CriticalAllergy,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
