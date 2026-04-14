CLASS lhc_Header_110 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header_110 RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Header_110 RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Header_110.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Header_110.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Header_110.

    METHODS read FOR READ
      IMPORTING keys FOR READ Header_110 RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Header_110.

    METHODS rba_Items_110 FOR READ
      IMPORTING keys_rba FOR READ Header_110\_Items_110 FULL result_requested RESULT result LINK association_links.

    METHODS cba_Items_110 FOR MODIFY
      IMPORTING entities_cba FOR CREATE Header_110\_Items_110.

ENDCLASS.

CLASS lhc_Header_110 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      " Mapping to Database Table ZTIME_HDR_110
      DATA(ls_header) = CORRESPONDING ztime_hdr_110( <entity> MAPPING FROM ENTITY ).

      " Administrative fields setup
      ls_header-local_created_by = sy-uname.
      GET TIME STAMP FIELD ls_header-local_created_at.
      ls_header-local_last_changed_by = sy-uname.
      ls_header-local_last_changed_at = ls_header-local_created_at.
      ls_header-last_changed_at = ls_header-local_created_at.

      " Buffer-la save pandrom
      lo_buffer->set_hdr_buffer( ls_header ).

      " Mapping back to RAP framework
      INSERT VALUE #( %cid      = <entity>-%cid
                      tsuuid    = <entity>-tsuuid ) INTO TABLE mapped-header_110.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      DATA(ls_header) = CORRESPONDING ztime_hdr_110( <entity> MAPPING FROM ENTITY ).

      " Update administrative fields
      ls_header-local_last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_header-local_last_changed_at.

      lo_buffer->set_hdr_buffer( ls_header ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      " Adding UUID to deletion queue in buffer
      lo_buffer->set_hdr_for_delete( VALUE #( ts_uuid = <key>-tsuuid ) ).
      lo_buffer->set_deletion_flag( abap_true ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      SELECT * FROM ztime_hdr_110
        FOR ALL ENTRIES IN @keys
        WHERE ts_uuid = @keys-tsuuid
        INTO TABLE @DATA(lt_headers).

      LOOP AT lt_headers INTO DATA(ls_header).
        INSERT CORRESPONDING #( ls_header MAPPING TO ENTITY ) INTO TABLE result.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD lock.
    " Locking logic for unmanaged scenario if needed
  ENDMETHOD.

  METHOD rba_Items_110.
    " Read By Association: If user navigates to items
  ENDMETHOD.

  METHOD cba_Items_110.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<entity_cba>).
      DATA(lv_parent_uuid) = <entity_cba>-tsuuid.

      LOOP AT <entity_cba>-%target ASSIGNING FIELD-SYMBOL(<item_entity>).
        DATA(ls_item) = CORRESPONDING ztime_itm_110( <item_entity> MAPPING FROM ENTITY ).

        " Parent link mapping
        ls_item-parent_uuid = lv_parent_uuid.

        " Set administrative fields for item
        ls_item-local_created_by = sy-uname.
        GET TIME STAMP FIELD ls_item-local_created_at.
        ls_item-local_last_changed_by = sy-uname.
        ls_item-local_last_changed_at = ls_item-local_created_at.
        ls_item-last_changed_at = ls_item-local_created_at.

        " Save item to buffer
        lo_buffer->set_itm_buffer( ls_item ).

        INSERT VALUE #( %cid      = <item_entity>-%cid
                        itemuuid  = ls_item-item_uuid
                        %is_draft = <item_entity>-%is_draft ) INTO TABLE mapped-item_110.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
