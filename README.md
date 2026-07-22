# SAP-ABAP

# Hospital Appointment RAP - Knowledge Transfer

## Knowledge Transfer Record

- **Title:** Hospital Appointment and Patient Visit Management System - Technical Handover
- **Application area:** SAP ABAP Cloud, RAP, CDS, OData V4, SAP Fiori Elements
- **Package:** `ZS4D400_100008892_RAP`
- **University:** SRH University Munich
- **Program:** Applied Computer Science
- **Module:** SAP ABAP
- **Project team:** Sharath Chandra Chandrashekhar and Piyush Prabhakar
- **Primary audience:** Instructor, project reviewer, and the next ABAP developer

## Purpose

This project provides draft-enabled maintenance for hospital appointments, patients, and doctors. It uses the ABAP RESTful Application Programming Model to expose metadata-driven SAP Fiori Elements applications through OData V4 UI services.

The core appointment workflow allows a coordinator to select a patient, doctor, and department; enter the required date, time, reason, priority, and status; validate the booking; and activate the draft. The solution prevents historical appointments and overlapping bookings for the same doctor, date, and time.

## Main Repository Objects

### Appointment

- Active table: `ZSH_HMS_APPT`
- Draft table: `ZSHHMS_APPT_D`
- Root CDS entity: `ZR_SHHMS_APPT`
- Projection CDS entity: `ZC_SHHMS_APPT`
- Root behavior definition: `ZR_SHHMS_APPT`
- Projection behavior definition: `ZC_SHHMS_APPT`
- Behavior pool: `ZBP_R_SHHMS_APPT`
- Service definition: `ZUI_SHHMS_APPT_O4`
- OData V4 UI service binding: the published appointment binding associated with `ZUI_SHHMS_APPT_O4`

### Patient

- Active table: `ZSH_HMS_PATIENT`
- Draft table: `ZSHHMS_PATIENT_D`
- Root CDS entity: `ZR_SHHMS_PATIENT`
- Projection CDS entity: `ZC_SHHMS_PATIENT`
- Behavior pool: `ZBP_R_SHHMS_PATIENT`
- Published OData V4 UI service and binding generated for patient maintenance

### Doctor

- Active table: `ZSH_HMS_DOCTOR`
- Draft table: `ZSHHMS_DOCTOR_D`
- Root CDS entity: `ZR_SHHMS_DOCTOR`
- Projection CDS entity: `ZC_SHHMS_DOCTOR`
- Behavior pool: `ZBP_R_SHHMS_DOCTOR`
- Published OData V4 UI service and binding generated for doctor maintenance

### Supporting Data and Value Helps

- Department data: `ZSH_HMS_DEPT`
- Visit data: `ZSH_HMS_VISIT`
- Patient value help: `ZVH_SH_HMS_PATIENT`
- Doctor value help: `ZVH_SH_HMS_DOCTOR`
- Department value help: `ZVH_SH_HMS_DEPT`
- Priority value help: `ZVH_SH_HMS_PRIORITY`
- Status value help: `ZVH_SH_HMS_STATUS`

## Activation Order

1. Activate active and draft database tables.
2. Activate value-help and root CDS entities.
3. Activate root behavior definitions and behavior pools.
4. Activate projection CDS entities and projection behavior definitions.
5. Activate metadata extensions.
6. Activate service definitions.
7. Activate, publish, and verify the OData V4 UI service bindings.

## Demonstration Runbook

1. Open the appointment OData V4 UI service binding.
2. Confirm that the binding is active and the local service endpoint is published.
3. Select the appointment entity set and choose Preview.
4. Click Go to load appointments.
5. Choose Create to open a draft.
6. Use Patient, Doctor, and Department value help instead of typing UUID values.
7. Enter Appointment ID, a future date and time, reason, priority, and status.
8. Demonstrate a past-date validation error.
9. Demonstrate a doctor schedule-conflict validation error.
10. Correct the data and activate the draft.
11. Open the patient and doctor previews to demonstrate draft master-data maintenance and duplicate-ID validation.

## Implemented Rules

- Appointment date and time must not be in the past.
- A doctor cannot have two appointments at the same date and time.
- A conflict message identifies the patient already booked in the time slot.
- Appointment references and key business fields are mandatory.
- Patient ID and Doctor ID must be unique.
- Patient and doctor names are normalized to title case.
- Phone numbers must contain exactly ten digits.
- Email addresses receive a basic format check.
- Patient date of birth cannot be in the future.
- Priority and Status are selectable value-help fields.

## Troubleshooting

- If a preview reports no authorization for a service group, open the correct service binding, confirm that it is published, and verify the user has start authorization for that binding.
- If Fiori metadata appears unchanged, reactivate the CDS, behavior, metadata extension, service definition, and service binding, then open a new preview session.
- If activation reports an unsuitable draft persistency, compare every root CDS element with the draft table field name and type.
- If the behavior pool is reported as missing, generate or open the behavior implementation class and activate the global class and local handler types.
- If stale errors remain in Eclipse after successful activation, refresh the package and Problems view or restart Eclipse.

## Known Limitations and Next Steps

- Department maintenance is not included as a completed draft application.
- A unified SAP Fiori launchpad shell with navigation to all domains remains future work.
- Visit processing can be extended into a complete draft business object.
- Current authorization methods are demonstration-oriented and require production role design.
- Automated ABAP Unit and integration tests should be added before production use.
- Health-data privacy, audit retention, monitoring, and transport governance require formal implementation.

## Handover Attachments

- `Hospital_Appointment_RAP_Technical_Report.docx`
- `Hospital_Appointment_RAP_Presentation.pptx`
- This knowledge-transfer record

## Ownership Confirmation

The project team confirms that the final solution, documentation, and presentation are understood by both team members. Either team member should be able to activate the application, open the service binding, demonstrate draft creation and validation, explain the RAP layers, and identify the known limitations.
