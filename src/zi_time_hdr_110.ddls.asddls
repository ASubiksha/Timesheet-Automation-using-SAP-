@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Interface View (Root View)'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_TIME_HDR_110 
  as select from ztime_hdr_110
  /* Target data source: ZI_TIME_ITM_110 */
  composition [0..*] of ZI_TIME_ITM_110 as _Items_110 
{
    key ts_uuid               as TsUuid,
    employee_id               as EmployeeId,
    ts_month                  as TsMonth,
    ts_year                   as TsYear,
    status                    as Status,
    
    local_created_by          as LocalCreatedBy,
    local_created_at          as LocalCreatedAt,
    local_last_changed_by     as LocalLastChangedBy,
    local_last_changed_at     as LocalLastChangedAt,
    last_changed_at           as LastChangedAt,
    
    /* Association exposure */
    _Items_110 
}
