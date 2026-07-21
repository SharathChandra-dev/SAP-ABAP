@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSHHMS_DOCTOR'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_SHHMS_DOCTOR
  as select from ZSH_HMS_DOCTOR
{
  key doctor_uuid as DoctorUUID,
  doctor_id as DoctorID,
  doctor_name as DoctorName,
  specialization as Specialization,
  department_uuid as DepartmentUUID,
  phone as Phone,
  email as Email,
  is_active as IsActive,
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
