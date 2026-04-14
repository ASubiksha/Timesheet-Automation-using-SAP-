CLASS zcl_time_buffer_110 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE. " Singleton Pattern

  PUBLIC SECTION.
    " 1. Key Types for Deletion logic
    TYPES: BEGIN OF ty_ts_key,
             ts_uuid TYPE sysuuid_x16,
           END OF ty_ts_key,
           BEGIN OF ty_item_key,
             item_uuid TYPE sysuuid_x16,
           END OF ty_item_key.

    TYPES: tt_ts_keys   TYPE STANDARD TABLE OF ty_ts_key WITH DEFAULT KEY,
           tt_item_keys TYPE STANDARD TABLE OF ty_item_key WITH DEFAULT KEY.

    " 2. Singleton Instance Method
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_time_buffer_110.

    " 3. Buffer Methods
    METHODS:
      " Header Buffer
      set_hdr_buffer
        IMPORTING im_header  TYPE ztime_hdr_110,
      get_hdr_buffer
        EXPORTING ex_header  TYPE ztime_hdr_110,

      " Item Buffer
      set_itm_buffer
        IMPORTING im_item    TYPE ztime_itm_110,
      get_itm_buffer
        EXPORTING ex_item    TYPE ztime_itm_110,

      " Deletion Queues
      set_hdr_for_delete
        IMPORTING im_ts_key TYPE ty_ts_key,
      get_hdr_for_delete
        EXPORTING ex_ts_keys TYPE tt_ts_keys,

      set_itm_for_delete
        IMPORTING im_item_key  TYPE ty_item_key,
      get_itm_for_delete
        EXPORTING ex_item_keys TYPE tt_item_keys,

      " Flags and Cleanup
      set_deletion_flag
        IMPORTING im_delete_flag TYPE abap_boolean,
      get_deletion_flag
        EXPORTING ex_delete_flag TYPE abap_boolean,

      cleanup_buffer.

  PRIVATE SECTION.
    " Buffer Storage
    CLASS-DATA: gs_hdr_buff        TYPE ztime_hdr_110,
                gs_itm_buff        TYPE ztime_itm_110,
                gt_hdr_delete_buff TYPE tt_ts_keys,
                gt_itm_delete_buff TYPE tt_item_keys,
                gv_delete_flag     TYPE abap_boolean.

    " Singleton Instance
    CLASS-DATA mo_instance TYPE REF TO zcl_time_buffer_110.
ENDCLASS.

CLASS zcl_time_buffer_110 IMPLEMENTATION.

  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_buffer.
    gs_hdr_buff = im_header.
  ENDMETHOD.

  METHOD get_hdr_buffer.
    ex_header = gs_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_buffer.
    gs_itm_buff = im_item.
  ENDMETHOD.

  METHOD get_itm_buffer.
    ex_item = gs_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_for_delete.
    APPEND im_ts_key TO gt_hdr_delete_buff.
  ENDMETHOD.
METHOD get_hdr_for_delete.
    ex_ts_keys = gt_hdr_delete_buff.
  ENDMETHOD.

  METHOD set_itm_for_delete.
    APPEND im_item_key TO gt_itm_delete_buff.
  ENDMETHOD.

  METHOD get_itm_for_delete.
    ex_item_keys = gt_itm_delete_buff.
  ENDMETHOD.

  METHOD set_deletion_flag.
    gv_delete_flag = im_delete_flag.
  ENDMETHOD.

  METHOD get_deletion_flag.
    ex_delete_flag = gv_delete_flag.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr_buff, gs_itm_buff,
           gt_hdr_delete_buff, gt_itm_delete_buff,
           gv_delete_flag.
  ENDMETHOD.

ENDCLASS.
