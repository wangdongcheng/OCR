class ZOCR_CL_PERSIST_DB_OPERATOR definition
  public
  final
  create public

  global friends ZOCR_CL_PERSIST_DB_PIC
                 ZOCR_CL_PERSIST_DB_USER .

public section.

  class-methods GET_TABLE_OBJ
    importing
      !IV_TABLE_CLASS_NAME type SEOCLSNAME
    returning
      value(RO_TABLE_OBJ) type ref to ZOCR_CL_PERSIST_DB
    raising
      ZCX_OCR_EXCEPTION .
  class-methods COMMIT_WORK .
  class-methods COMMIT_WORK_AND_WAIT
    raising
      ZCX_OCR_EXCEPTION .
protected section.
private section.

  class-data TABLE_OBJ type ref to ZOCR_CL_PERSIST_DB .
ENDCLASS.



CLASS ZOCR_CL_PERSIST_DB_OPERATOR IMPLEMENTATION.


  METHOD commit_work.


    COMMIT WORK.


  ENDMETHOD.


  METHOD commit_work_and_wait.
    DATA ls_ret TYPE bapiret2.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   = abap_true
      IMPORTING
        return = ls_ret.

    IF ls_ret IS NOT INITIAL.
      zcx_ocr_exception=>raise_t100(
        EXPORTING
          iv_msgid          = sy-msgid    " Message Class
          iv_msgno          = sy-msgno ). " Message Number
    ENDIF.

  ENDMETHOD.


  METHOD get_table_obj.
    CHECK iv_table_class_name IS NOT INITIAL.

    TRY .
        CALL METHOD (iv_table_class_name)=>get_instantce
          RECEIVING
            ro_table_obj = ro_table_obj.

      CATCH cx_sy_dyn_call_illegal_method
            cx_sy_dyn_call_illegal_class.

* 017	Failed to get instance of class &1
        MESSAGE s017 WITH iv_table_class_name INTO DATA(lv_dummy).

        zcx_ocr_exception=>raise_t100(
          iv_msgid = sy-msgid
          iv_msgno = sy-msgno
          iv_msgv1 = sy-msgv1 ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
