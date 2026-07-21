@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSHHMS_PATIENT'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_SHHMS_PATIENT
  as select from ZSH_HMS_PATIENT
{
  key patient_uuid as PatientUUID,
  patient_id as PatientID,
  first_name as FirstName,
  last_name as LastName,
  date_of_birth as DateOfBirth,
  gender as Gender,
  phone as Phone,
  email as Email,
  address as Address,
  critical_allergy as CriticalAllergy,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
