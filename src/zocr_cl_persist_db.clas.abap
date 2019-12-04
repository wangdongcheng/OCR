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


  method ZOCR_IF_PERSIST_DB~INSERT.
  endmethod.


  METHOD zocr_if_persist_db~select_by_pk.

  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~SELECT_BY_RANGES.
  endmethod.
ENDCLASS.
