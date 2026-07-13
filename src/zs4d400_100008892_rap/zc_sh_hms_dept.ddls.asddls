@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HMS Department Projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SH_HMS_DEPT
  provider contract transactional_query
  as projection on ZI_SH_HMS_DEPT
{
  key DepartmentUUID,
      @Search.defaultSearchElement: true
      DepartmentID,
      @Search.defaultSearchElement: true
      DepartmentName,
      FloorNo,
      Phone,
      IsActive,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
