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
protected section.
private section.

  class-data USER_TABLE_OBJ type ref to ZOCR_CL_PERSIST_DB_USER .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB_USER IMPLEMENTATION.


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
