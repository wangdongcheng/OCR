INTERFACE zocr_if_tops
  PUBLIC .


  TYPES:
    BEGIN OF ts_primary_keys,
      ztocr_guid_md5 TYPE hash160,
      ztocr01_pk     TYPE zsocr01_pk,
    END OF ts_primary_keys .
  TYPES:
    tt_ztocr_ht TYPE STANDARD TABLE OF ztocr
      WITH NON-UNIQUE KEY primary_key COMPONENTS mandt
                                                 guid_md5
      WITH UNIQUE HASHED KEY hk COMPONENTS mandt
                                           guid_md5 .

  CONSTANTS:
    BEGIN OF cs_tab_name,
      pic      TYPE tabname VALUE 'ZTOCR',
      user     TYPE tabname VALUE 'ZTOCR01',
      worklist TYPE tabname VALUE 'ZSOCR_WKLST',
    END OF cs_tab_name .
  CONSTANTS:
    BEGIN OF cs_tab_cls_name,
      pic  TYPE seoclsname VALUE 'ZOCR_CL_PERSIST_DB_PIC',
      user TYPE seoclsname VALUE 'ZOCR_CL_PERSIST_DB_USER',
    END OF cs_tab_cls_name .
  CONSTANTS cv_worklist_pfstatus_name TYPE slis_formname VALUE 'CALLBACK_SET_PF' ##NO_TEXT.
  CONSTANTS cv_worklist_ucomm_subr_name TYPE slis_formname VALUE 'CALLBACK_USER_CMD' ##NO_TEXT.
ENDINTERFACE.
