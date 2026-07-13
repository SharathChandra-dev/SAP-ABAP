@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Visit Interface'
@Metadata.allowExtensions: true
define view entity ZI_SH_HMS_VISIT
  as select from zsh_hms_visit
  association [1..1] to ZI_SH_HMS_APPOINTMENT as _Appointment
    on $projection.AppointmentUUID = _Appointment.AppointmentUUID
{
  key visit_uuid            as VisitUUID,
      appointment_uuid      as AppointmentUUID,
      check_in_at           as CheckInAt,
      consultation_start_at as ConsultationStartAt,
      consultation_end_at   as ConsultationEndAt,
      diagnosis             as Diagnosis,
      treatment_notes       as TreatmentNotes,
      follow_up_date        as FollowUpDate,
      status                as Status,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      _Appointment
}
