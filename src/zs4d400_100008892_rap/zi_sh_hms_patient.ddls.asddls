@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Patient Interface'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'PatientID' ]
define root view entity ZI_SH_HMS_PATIENT
  as select from zsh_hms_patient
{
  key patient_uuid          as PatientUUID,
      patient_id            as PatientID,
      first_name            as FirstName,
      last_name             as LastName,
      date_of_birth         as DateOfBirth,
      gender                as Gender,
      phone                 as Phone,
      email                 as Email,
      address               as Address,
      critical_allergy      as CriticalAllergy,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
