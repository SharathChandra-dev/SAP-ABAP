@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Flight Service Projection'
@ObjectModel.sapObjectNodeType.name: 'Z8892FLIGHT'
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_8892FLIGHT
  provider contract transactional_query
  as projection on ZR_8892FLIGHT

  association [1..1] to ZR_8892FLIGHT as _BaseEntity
    on  $projection.CarrierID    = _BaseEntity.CarrierID
    and $projection.ConnectionID = _BaseEntity.ConnectionID
    and $projection.FlightDate   = _BaseEntity.FlightDate
{
  key CarrierID,
  key ConnectionID,
  key FlightDate,

      PlaneTypeID,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,

      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'I_CurrencyStdVH',
            element: 'Currency'
          }
        }
      ]
      CurrencyCode,

      @Semantics.user.createdBy: true
      LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      _BaseEntity
}
