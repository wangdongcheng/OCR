class ZOCR_CL_PERSIST_DB_OPERATOR definition
  public
  final
  create public .

public section.

  class-methods GET_TABLE_OBJ
    importing
      !IV_TABLE_CLASS_NAME type SEOCLSNAME
    returning
      value(RI_TABLE_OBJ) type ref to ZOCR_CL_PERSIST_DB
    raising
      ZCX_OCR_EXCEPTION .
protected section.
private section.

  class-data TABLE_OBJ type ref to ZOCR_CL_PERSIST_DB .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB_OPERATOR IMPLEMENTATION.


  METHOD get_table_obj.
    CHECK iv_table_class_name IS NOT INITIAL.

    TRY .
        CALL METHOD (iv_table_class_name)=>zocr_if_persist_factory~get_instantce
          RECEIVING
            ri_table_obj = ri_table_obj.

      CATCH cx_sy_dyn_call_illegal_method
            cx_sy_dyn_call_illegal_class.

* 017	Failed to get instance of class &1
        MESSAGE s017 WITH iv_table_class_name INTO DATA(lv_dummy).

        zcx_ocr_exception=>raise_t100(
          iv_msgid = sy-msgid
          iv_msgno = sy-msgno ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
