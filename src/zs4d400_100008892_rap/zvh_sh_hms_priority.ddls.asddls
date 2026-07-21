@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Priority Value Help'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZVH_SH_HMS_PRIORITY
  as select from zsh_hms_priority
{
  @ObjectModel.text.element: [ 'PriorityText' ]
  key priority      as Priority,

  @Semantics.text: true
  priority_text     as PriorityText,

  criticality       as Criticality
}
