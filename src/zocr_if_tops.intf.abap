INTERFACE zocr_if_tops
  PUBLIC .


  TYPES:
    BEGIN OF ts_primary_keys,
      ztocr_guid_md5 TYPE hash160,
      ztocr01_pk     TYPE zsocr01_pk,
    END OF ts_primary_keys.
ENDINTERFACE.
