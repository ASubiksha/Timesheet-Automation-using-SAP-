@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Consumption View 110'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_TIME_HDR_110
  as projection on ZI_TIME_HDR_110
{
    key TsUuid,
    
    @Search.defaultSearchElement: true
    EmployeeId,
    
    TsMonth,
    TsYear,
    Status,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    /* Child view-ku redirect pandrom */
    _Items_110 : redirected to composition child ZC_TIME_ITM_110
}
