@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Interface View'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_TIME_ITM_110 
  as select from ztime_itm_110
  /* Parent link - Header view kooda link pandrom */
  association to parent ZI_TIME_HDR_110 as _Header_110 on $projection.ParentUuid = _Header_110.TsUuid
{
    key item_uuid             as ItemUuid,
    parent_uuid               as ParentUuid,
    work_date                 as WorkDate,
    unit_code                 as UnitCode,
    total_hours               as TotalHours,
    description               as Description,
    
    local_created_by          as LocalCreatedBy,
    local_created_at          as LocalCreatedAt,
    local_last_changed_by     as LocalLastChangedBy,
    local_last_changed_at     as LocalLastChangedAt,
    last_changed_at           as LastChangedAt,
    
    /* Make association public */
    _Header_110 
}
