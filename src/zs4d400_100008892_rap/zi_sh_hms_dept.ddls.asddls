@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Department Interface'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'DepartmentID' ]
define root view entity ZI_SH_HMS_DEPT
  as select from zsh_hms_dept
{
  key department_uuid        as DepartmentUUID,
      department_id          as DepartmentID,
      department_name        as DepartmentName,
      floor_no               as FloorNo,
      phone                  as Phone,
      is_active              as IsActive,
      created_by             as CreatedBy,
      created_at             as CreatedAt,
      last_changed_by        as LastChangedBy,
      last_changed_at        as LastChangedAt,
      local_last_changed_at  as LocalLastChangedAt
}
