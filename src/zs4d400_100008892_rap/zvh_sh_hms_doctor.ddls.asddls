@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Doctor Value Help'
define view entity ZVH_SH_HMS_DOCTOR
  as select from zsh_hms_doctor
{
      @ObjectModel.text.element: [ 'DoctorName' ]
  key doctor_uuid as DoctorUUID,

      doctor_id as DoctorID,

      doctor_name as DoctorName,

      specialization as Specialization,
      department_uuid as DepartmentUUID,
      phone as Phone,
      email as Email
}
