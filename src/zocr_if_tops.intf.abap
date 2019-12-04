INTERFACE zocr_if_tops
  PUBLIC .

  TYPES:
    BEGIN OF ts_primary_keys,
      ztocr_guid_md5 TYPE hash160,
      ztocr01_pk     TYPE zsocr01_pk,
    END OF ts_primary_keys,

    tt_ztocr_ht TYPE STANDARD TABLE OF ztocr
      WITH NON-UNIQUE KEY primary_key COMPONENTS mandt
                                                 guid_md5
      WITH UNIQUE HASHED KEY hk COMPONENTS mandt
                                           guid_md5.

  CONSTANTS:
    BEGIN OF cs_tab_name,
      pic TYPE tabname VALUE 'ZTOCR',
      usr TYPE tabname VALUE 'ZTOCR01',
    END OF cs_tab_name .
  CONSTANTS:
    BEGIN OF cs_tab_cls_name,
      pic TYPE seoclsname VALUE 'ZOCR_CL_PERSIST_PIC',
    END OF cs_tab_cls_name .
ENDINTERFACE.
