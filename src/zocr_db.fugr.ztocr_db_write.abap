FUNCTION ztocr_db_write.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_INS) TYPE  ZTOCR_T OPTIONAL
*"     REFERENCE(IT_UPD) TYPE  ZTOCR_T OPTIONAL
*"     REFERENCE(IT_DEL) TYPE  ZTOCR_T OPTIONAL
*"     REFERENCE(IB_COMMIT) TYPE  XFELD DEFAULT ABAP_FALSE
*"     REFERENCE(IB_WAIT) TYPE  XFELD DEFAULT ABAP_FALSE
*"----------------------------------------------------------------------


*-- delete
  IF it_del IS SUPPLIED AND it_del IS NOT INITIAL.
    DELETE ztocr FROM TABLE it_del.
    IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
      MESSAGE a009(e1) WITH 'ZTOCR01' .                     "#EC NOTEXT
    ENDIF.
  ENDIF.

*-- insert
  IF it_ins IS SUPPLIED AND it_ins IS NOT INITIAL.
    INSERT ztocr FROM TABLE it_ins.
    IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
      MESSAGE a009(e1) WITH 'ZTOCR01' .                     "#EC NOTEXT
    ENDIF.
  ENDIF.

*-- update
  IF it_upd IS SUPPLIED AND it_upd IS NOT INITIAL.
    UPDATE ztocr FROM TABLE it_upd.
    IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
      MESSAGE a009(e1) WITH 'ZTOCR01' .                     "#EC NOTEXT
    ENDIF.
  ENDIF.


*-- commit work and wait
  IF ib_commit EQ abap_true.
    IF ib_wait EQ abap_true.
      COMMIT WORK AND WAIT.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDIF.


ENDFUNCTION.
