@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Value Help'
define view entity ZVH_SH_HMS_DEPT
  as select from zsh_hms_dept
{
      @ObjectModel.text.element: [ 'DepartmentName' ]
  key department_uuid as DepartmentUUID,

      department_id as DepartmentID,

      department_name as DepartmentName,

      floor_no as FloorNo,
      phone as Phone
}
