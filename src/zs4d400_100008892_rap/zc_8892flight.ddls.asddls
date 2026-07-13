@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'Z8892FLIGHT'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_8892FLIGHT
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_8892FLIGHT
  association [1..1] to ZR_8892FLIGHT as _BaseEntity on $projection.CARRIERID = _BaseEntity.CARRIERID and $projection.CONNECTIONID = _BaseEntity.CONNECTIONID and $projection.FLIGHTDATE = _BaseEntity.FLIGHTDATE
{
  key CarrierID,
  key ConnectionID,
  key FlightDate,
  PlaneTypeID,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
