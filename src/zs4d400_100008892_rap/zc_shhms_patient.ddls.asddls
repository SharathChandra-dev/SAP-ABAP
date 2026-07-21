@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZSHHMS_PATIENT'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_SHHMS_PATIENT
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_SHHMS_PATIENT
  association [1..1] to ZR_SHHMS_PATIENT as _BaseEntity on $projection.PATIENTUUID = _BaseEntity.PATIENTUUID
{
  key PatientUUID,
  PatientID,
  FirstName,
  LastName,
  DateOfBirth,
  Gender,
  Phone,
  Email,
  Address,
  CriticalAllergy,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Lastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
