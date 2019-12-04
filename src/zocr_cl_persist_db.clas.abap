class ZOCR_CL_PERSIST_DB definition
  public
  abstract
  create public .

public section.

  interfaces ZOCR_IF_PERSIST_DB .
protected section.
private section.

  aliases CURRENT_TABLE_OBJ
    for ZOCR_IF_PERSIST_DB~CURRENT_TABLE_OBJ .
  aliases TABLE_CLASS_NAME
    for ZOCR_IF_PERSIST_DB~TABLE_CLASS_NAME .
  aliases TABLE_NAME
    for ZOCR_IF_PERSIST_DB~TABLE_NAME .
  aliases INSERT
    for ZOCR_IF_PERSIST_DB~INSERT .
  aliases SELECT_BY_PK
    for ZOCR_IF_PERSIST_DB~SELECT_BY_PK .
  aliases SELECT_BY_RANGES
    for ZOCR_IF_PERSIST_DB~SELECT_BY_RANGES .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB IMPLEMENTATION.


  METHOD zocr_if_persist_db~commit_work.
    IF ib_wait EQ abap_true.
      COMMIT WORK AND WAIT.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~INSERT.
  endmethod.


  METHOD zocr_if_persist_db~select_by_pk.

  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~SELECT_BY_RANGES.
  endmethod.


  METHOD zocr_if_persist_db~update.
    CHECK it_upd IS NOT INITIAL AND
          iv_table_name IS NOT INITIAL.

    UPDATE (iv_table_name) FROM TABLE it_upd.

    IF NOT sy-subrc IS INITIAL .
*--E1	009	Error updating table &
      MESSAGE a009(e1) WITH iv_table_name INTO DATA(lv_dummy).
      zcx_ocr_exception=>raise_t100(
          iv_msgid = sy-msgid
          iv_msgno = sy-msgno ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
