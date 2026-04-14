CLASS lhc_Item_110 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Item_110.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Item_110.

    METHODS read FOR READ
      IMPORTING keys FOR READ Item_110 RESULT result.

    METHODS rba_Header_110 FOR READ
      IMPORTING keys_rba FOR READ Item_110\_Header_110 FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Item_110 IMPLEMENTATION.

  METHOD update.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      " Mapping Entity to Database Table ZTIME_ITM_110
      DATA(ls_db_itm) = CORRESPONDING ztime_itm_110( <ls_entity> MAPPING FROM ENTITY ).

      " Update Administrative Fields for Item
      ls_db_itm-local_last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_db_itm-local_last_changed_at.

      " Buffer-la data-va update pandrom
      lo_buffer->set_itm_buffer( im_item = ls_db_itm ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_buffer) = zcl_time_buffer_110=>get_instance( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      " Item-ah deletion queue-la podurom
      lo_buffer->set_itm_for_delete( im_item_key = VALUE #( item_uuid = <ls_key>-ItemUuid ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      SELECT * FROM ztime_itm_110
        FOR ALL ENTRIES IN @keys
        WHERE item_uuid = @keys-ItemUuid
        INTO TABLE @DATA(lt_db_itm).

      LOOP AT lt_db_itm INTO DATA(ls_db_itm).
        INSERT CORRESPONDING #( ls_db_itm MAPPING TO ENTITY ) INTO TABLE result.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD rba_Header_110.
    " Read By Association logic: standard display-ku framework handles it
  ENDMETHOD.

ENDCLASS.
