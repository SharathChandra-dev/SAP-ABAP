@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@EndUserText.label: 'Patient Value Help'
define view entity ZVH_SH_HMS_PATIENT
  as select from zsh_hms_patient
{
      @ObjectModel.text.element: [ 'PatientName' ]
  key patient_uuid as PatientUUID,

      @Search.defaultSearchElement: true
      patient_id as PatientID,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      concat_with_space( first_name, last_name, 1 ) as PatientName,

      first_name as FirstName,
      last_name  as LastName,
      phone      as Phone,
      email      as Email
}
