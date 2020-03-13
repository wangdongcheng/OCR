class ZOCR_CL_PERSIST_DB definition
  public
  abstract
  create public .

public section.

  interfaces ZOCR_IF_PERSIST_DB .

  aliases INSERT
    for ZOCR_IF_PERSIST_DB~INSERT .
  aliases SELECT_BY_PK
    for ZOCR_IF_PERSIST_DB~SELECT_BY_PK .
  aliases SELECT_BY_RANGES
    for ZOCR_IF_PERSIST_DB~SELECT_BY_RANGES .
  aliases SET_TABLE_NAME
    for ZOCR_IF_PERSIST_DB~SET_TABLE_NAME .
  aliases SYNC_UPD
    for ZOCR_IF_PERSIST_DB~SYNC_UPD .
  aliases UPDATE
    for ZOCR_IF_PERSIST_DB~UPDATE .

  methods CONSTRUCTOR .
protected section.

  data TABLE_NAME type TABNAME .
private section.
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB IMPLEMENTATION.


  METHOD constructor.

*-- The use of dynamic_cast implicitly violate the <Open-Closed-Principal>

*    DATA(lv_class_name) = cl_abap_classdescr=>describe_by_object_ref( me )->absolute_name.
*
*    IF lv_class_name IS NOT INITIAL.
*      REPLACE FIRST OCCURRENCE OF '\CLASS=' IN lv_class_name WITH ''.
*    ENDIF.
*
*    me->table_name = SWITCH tabname( lv_class_name
*                                     WHEN zocr_if_tops=>cs_tab_cls_name-pic
*                                       THEN zocr_if_tops=>cs_tab_name-pic
*                                     WHEN zocr_if_tops=>cs_tab_cls_name-user
*                                       THEN zocr_if_tops=>cs_tab_name-user
*                                     " WHEN ...
*                                     "   THEN ...
*                                     ELSE || ).

  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~INSERT.
  endmethod.


  METHOD zocr_if_persist_db~select_by_pk.

  ENDMETHOD.


  method ZOCR_IF_PERSIST_DB~SELECT_BY_RANGES.
  endmethod.


  method ZOCR_IF_PERSIST_DB~SET_TABLE_NAME.
  endmethod.


  METHOD zocr_if_persist_db~update.

    IF it_upd IS INITIAL.
* 019	Importing table is empty
      MESSAGE e019 INTO DATA(lv_dummy).
      zcx_ocr_exception=>raise_t100(
        EXPORTING
          iv_msgid          = sy-msgid    " Message Class
          iv_msgno          = sy-msgno    " Message Number
          ).
    ENDIF.

    IF me->table_name IS INITIAL.
* 020	Please set table name in class by SE24
      MESSAGE e020 INTO lv_dummy.
      zcx_ocr_exception=>raise_t100(
        EXPORTING
          iv_msgid          = sy-msgid    " Message Class
          iv_msgno          = sy-msgno    " Message Number
          ).
    ENDIF.

    UPDATE (me->table_name) FROM TABLE it_upd.

    IF NOT sy-subrc IS INITIAL .
*--E1	009	Error updating table &
      MESSAGE a009(e1) WITH iv_table_name INTO lv_dummy.
      zcx_ocr_exception=>raise_t100(
          iv_msgid = sy-msgid
          iv_msgno = sy-msgno
          iv_msgv1 = sy-msgv1 ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
