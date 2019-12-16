*&---------------------------------------------------------------------*
*& Report ZOCR_TEST_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zocr_test_demo.

DATA li_pic TYPE REF TO zocr_cl_persist_db_pic.

TRY.

    DATA(ls_pks) = VALUE zocr_if_tops=>ts_primary_keys(
      ztocr_guid_md5 = '4759840A1C9AC8AC555E8C01A4F9F740' ).

    li_pic ?= zocr_cl_persist_db_operator=>get_table_obj(
      zocr_if_tops=>cs_tab_cls_name-pic ).   " Object Type Name

    li_pic->select_by_pk( ls_pks ).
  CATCH zcx_ocr_exception INTO DATA(lx_ocr).
    cl_demo_output=>display( lx_ocr->get_text( ) ).
    RETURN.
ENDTRY.

DATA(lt_upd) = li_pic->pic_table.
lt_upd[ 1 ]-descr = to_lower( |OO Update Test sync at { sy-uzeit }| ).

TRY .
    li_pic->update( lt_upd ).
  CATCH zcx_ocr_exception.

ENDTRY.
zocr_cl_persist_db_operator=>commit_work_and_wait( ).
li_pic->sync_upd( lt_upd ).
cl_demo_output=>display( li_pic->pic_table ).
