@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZSHHMS_DOCTOR'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_SHHMS_DOCTOR
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_SHHMS_DOCTOR
  association [1..1] to ZR_SHHMS_DOCTOR as _BaseEntity on $projection.DOCTORUUID = _BaseEntity.DOCTORUUID
{
  key DoctorUUID,
  DoctorID,
  DoctorName,
  Specialization,
  DepartmentUUID,
  Phone,
  Email,
  IsActive,
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
