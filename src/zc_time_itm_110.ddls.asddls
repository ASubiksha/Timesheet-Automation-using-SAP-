@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Consumption View 110'
@Metadata.allowExtensions: true

define view entity ZC_TIME_ITM_110
  as projection on ZI_TIME_ITM_110
{
    key ItemUuid,
    ParentUuid,
    WorkDate,
    UnitCode,
    TotalHours,
    Description,
    
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    /* Association redirect - Idhu romba mukkiyam */
    _Header_110 : redirected to parent ZC_TIME_HDR_110
}
