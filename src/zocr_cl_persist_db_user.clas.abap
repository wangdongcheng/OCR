class ZOCR_CL_PERSIST_DB_USER definition
  public
  inheriting from ZOCR_CL_PERSIST_DB
  final
  create private .

public section.

  interfaces ZOCR_IF_PERSIST_FACTORY .

  aliases GET_INSTANTCE
    for ZOCR_IF_PERSIST_FACTORY~GET_INSTANTCE .

  data USER_TABLE type ZTOCR01_T read-only .

  methods ZOCR_IF_PERSIST_DB~SELECT_BY_PK
    redefinition .
  methods ZOCR_IF_PERSIST_DB~GET_TABLE_NAME
    redefinition .
protected section.
private section.

  class-data USER_TABLE_OBJ type ref to ZOCR_CL_PERSIST_DB_USER .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB_USER IMPLEMENTATION.


  METHOD zocr_if_persist_db~get_table_name.
    rv_table_name = zocr_if_tops=>cs_tab_name-user.
  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~SELECT_BY_PK.
**TRY.
*CALL METHOD SUPER->ZOCR_IF_PERSIST_DB~SELECT_BY_PK
*  EXPORTING
*    IS_PRIMAY_KEYS =
*    .
** CATCH zcx_ocr_exception .
**ENDTRY.
  endmethod.


  method ZOCR_IF_PERSIST_FACTORY~GET_INSTANTCE.
  endmethod.
ENDCLASS.
