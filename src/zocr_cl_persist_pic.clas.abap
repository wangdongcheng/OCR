class ZOCR_CL_PERSIST_PIC definition
  public
  inheriting from ZOCR_CL_PERSIST_DB
  final
  create private .

public section.

  interfaces ZOCR_IF_PERSIST_FACTORY .

  data PIC_TABLE type ZTOCR_T read-only .

  methods ZOCR_IF_PERSIST_DB~SELECT_BY_PK
    redefinition .
protected section.
private section.

  class-data PIC_TABLE_OBJ type ref to ZOCR_CL_PERSIST_PIC .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_PIC IMPLEMENTATION.


  METHOD zocr_if_persist_db~select_by_pk.
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


  METHOD zocr_if_persist_factory~get_instantce.
    IF pic_table_obj IS NOT BOUND.
      CREATE OBJECT pic_table_obj.
    ENDIF.

    ri_table_obj = pic_table_obj.
  ENDMETHOD.
ENDCLASS.
