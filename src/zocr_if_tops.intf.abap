interface ZOCR_IF_TOPS
  public .


  types:
    BEGIN OF ts_primary_keys,
      ztocr_guid_md5 TYPE hash160,
      ztocr01_pk     TYPE zsocr01_pk,
    END OF ts_primary_keys .
  types:
    tt_ztocr_ht TYPE STANDARD TABLE OF ztocr
      WITH NON-UNIQUE KEY primary_key COMPONENTS mandt
                                                 guid_md5
      WITH UNIQUE HASHED KEY hk COMPONENTS mandt
                                           guid_md5 .

  constants:
    BEGIN OF cs_tab_name,
      pic      TYPE tabname VALUE 'ZTOCR',
      user     TYPE tabname VALUE 'ZTOCR01',
      worklist TYPE tabname VALUE 'ZSOCR_WKLST',
    END OF cs_tab_name .
  constants:
    BEGIN OF cs_tab_cls_name,
      pic  TYPE seoclsname VALUE 'ZOCR_CL_PERSIST_DB_PIC',
      user TYPE seoclsname VALUE 'ZOCR_CL_PERSIST_DB_USER',
    END OF cs_tab_cls_name .
  constants CV_WORKLIST_PFSTATUS_NAME type SLIS_FORMNAME value 'CALLBACK_SET_PF' ##NO_TEXT.
  constants CV_WORKLIST_UCOMM_SUBR_NAME type SLIS_FORMNAME value 'CALLBACK_USER_CMD' ##NO_TEXT.
  constants CV_MSG_CLAS type ARBGB value 'ZOCR' ##NO_TEXT.
endinterface.
