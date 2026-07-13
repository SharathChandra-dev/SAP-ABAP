@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Visit Projection'
@Metadata.allowExtensions: true
define view entity ZC_SH_HMS_VISIT
  as select from ZI_SH_HMS_VISIT
{
  key VisitUUID,
      AppointmentUUID,
      CheckInAt,
      ConsultationStartAt,
      ConsultationEndAt,
      Diagnosis,
      TreatmentNotes,
      FollowUpDate,
      Status,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Appointment
}
