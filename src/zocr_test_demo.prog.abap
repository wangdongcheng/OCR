*&---------------------------------------------------------------------*
*& Report ZOCR_TEST_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zocr_test_demo.

DATA li_pic TYPE REF TO zocr_cl_persist_pic.

TRY.

    DATA(ls_pks) = VALUE zocr_if_tops=>ts_primary_keys( ztocr_guid_md5 = '4759840A1C9AC8AC555E8C01A4F9F740-' ).

    li_pic ?= zocr_cl_persist_db_operator=>get_table_obj(
      iv_table_class_name = 'ZOCR_CL_PERSIST_PIC' ).   " Object Type Name

    li_pic->zocr_if_persist_db~select_by_pk( is_primay_keys = ls_pks ).
  CATCH zcx_ocr_exception INTO DATA(lx_ocr).
    cl_demo_output=>display( lx_ocr->get_text( ) ).
    RETURN.
ENDTRY.

cl_demo_output=>display( li_pic->pic_table ).
