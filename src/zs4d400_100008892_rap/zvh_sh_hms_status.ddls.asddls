@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Status Value Help'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZVH_SH_HMS_STATUS
  as select from zsh_hms_status
{
  @ObjectModel.text.element: [ 'StatusText' ]
  key status       as Status,

  @Semantics.text: true
  status_text      as StatusText,

  criticality      as Criticality
}
