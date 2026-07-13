@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'Z8892FLIGHT'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_8892FLIGHT
  as select from Z8892FLIGHT
{
  key carrier_id as CarrierID,
  key connection_id as ConnectionID,
  key flight_date as FlightDate,
  plane_type_id as PlaneTypeID,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
