@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Doctor Interface'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'DoctorID' ]
define root view entity ZI_SH_HMS_DOCTOR
  as select from zsh_hms_doctor
  association [0..1] to ZI_SH_HMS_DEPT as _Department
    on $projection.DepartmentUUID = _Department.DepartmentUUID
{
  key doctor_uuid           as DoctorUUID,
      doctor_id             as DoctorID,
      doctor_name           as DoctorName,
      specialization        as Specialization,
      department_uuid       as DepartmentUUID,
      phone                 as Phone,
      email                 as Email,
      is_active             as IsActive,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      _Department
}
