class ZOCR_CL_PERSIST_DB_PIC definition
  public
  inheriting from ZOCR_CL_PERSIST_DB
  final
  create private .

public section.

  interfaces ZOCR_IF_PERSIST_FACTORY .

  aliases GET_INSTANTCE
    for ZOCR_IF_PERSIST_FACTORY~GET_INSTANTCE .

  data PIC_TABLE type ZOCR_IF_TOPS=>TT_ZTOCR_HT read-only .

  methods ZOCR_IF_PERSIST_DB~SELECT_BY_PK
    redefinition .
  methods ZOCR_IF_PERSIST_DB~SYNC_UPD
    redefinition .
  methods ZOCR_IF_PERSIST_DB~SET_TABLE_NAME
    redefinition .
protected section.
private section.

  class-data PIC_TABLE_OBJ type ref to ZOCR_CL_PERSIST_DB_PIC .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB_PIC IMPLEMENTATION.


  METHOD ZOCR_IF_PERSIST_DB~SELECT_BY_PK.
    CHECK is_primay_keys-ztocr_guid_md5 IS NOT INITIAL.

    SELECT
      *
      FROM ztocr
      WHERE guid_md5 EQ @is_primay_keys-ztocr_guid_md5
      INTO TABLE @pic_table.
    IF sy-subrc NE 0.
* 016	Can't find MD5 value in picture DB
      MESSAGE s016 INTO DATA(lv_dummy).

      zcx_ocr_exception=>raise_t100(
          iv_msgid = sy-msgid    " Message Class
          iv_msgno = sy-msgno    " Message Number
      ).
    ENDIF.

  ENDMETHOD.


  METHOD zocr_if_persist_db~set_table_name.
    me->table_name = zocr_if_tops=>cs_tab_name-pic.
  ENDMETHOD.


  METHOD ZOCR_IF_PERSIST_DB~SYNC_UPD.

    CHECK it_upd IS NOT INITIAL.
    DATA(lt_upd) = CONV ztocr_t( it_upd ).

    LOOP AT lt_upd ASSIGNING FIELD-SYMBOL(<ls_upd>).
      READ TABLE pic_table ASSIGNING FIELD-SYMBOL(<ls_pic_tab>)
        WITH TABLE KEY mandt    = sy-mandt
                       guid_md5 = <ls_upd>-guid_md5.
      IF sy-subrc EQ 0.
        <ls_pic_tab>-zsocr   = <ls_upd>-zsocr        .
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD zocr_if_persist_factory~get_instantce.
    IF pic_table_obj IS NOT BOUND.
      pic_table_obj = NEW zocr_cl_persist_db_pic( ).
    ENDIF.

    pic_table_obj->set_table_name( ).
    ro_table_obj = pic_table_obj.

  ENDMETHOD.
ENDCLASS.
