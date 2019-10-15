class ZOCR_CL_DB definition
  public
  create public .

public section.

  interfaces ZOCR_IF_DB .

  class-methods ZTOCR_DB_WRITE
    importing
      !IT_INS type ZTOCR_T optional
      !IT_UPD type ZTOCR_T optional
      !IT_DEL type ZTOCR_T optional
      !IB_COMMIT type ABAP_BOOL default ABAP_FALSE
      !IB_WAIT type ABAP_BOOL default ABAP_FALSE .
  class-methods GET_INSTANCE
    returning
      value(RI_ZOCR_DB) type ref to ZOCR_CL_DB .
protected section.
private section.
ENDCLASS.



CLASS ZOCR_CL_DB IMPLEMENTATION.


  METHOD get_instance.
    CREATE OBJECT ri_zocr_db.
  ENDMETHOD.


  METHOD zocr_if_db~db_write.

*-- delete
    IF it_del IS SUPPLIED AND it_del IS NOT INITIAL.
      DELETE (iv_db_name) FROM TABLE it_del.
      IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
        MESSAGE a009(e1) WITH iv_db_name.                   "#EC NOTEXT
      ENDIF.
    ENDIF.

*-- insert
    IF it_ins IS SUPPLIED AND it_ins IS NOT INITIAL.
      INSERT (iv_db_name) FROM TABLE it_ins.
      IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
        MESSAGE a009(e1) WITH iv_db_name .                  "#EC NOTEXT
      ENDIF.
    ENDIF.

*-- update
    IF it_upd IS SUPPLIED AND it_upd IS NOT INITIAL.
      UPDATE (iv_db_name) FROM TABLE it_upd.
      IF NOT syst-subrc IS INITIAL .
*--E1	009	Error updating table &
        MESSAGE a009(e1) WITH iv_db_name .                  "#EC NOTEXT
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

  ENDMETHOD.


  METHOD ZTOCR_DB_WRITE.

    CALL METHOD zocr_cl_db=>zocr_if_db~db_write
      EXPORTING
        iv_db_name = 'ZTOCR'
        it_ins     = it_ins
        it_upd     = it_upd
        it_del     = it_del
        ib_commit  = ib_commit
        ib_wait    = ib_wait.

  ENDMETHOD.
ENDCLASS.
