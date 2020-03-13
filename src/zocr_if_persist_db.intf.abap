interface ZOCR_IF_PERSIST_DB
  public .


  methods INSERT
    importing
      !IT_INS type TABLE .
  methods SELECT_BY_RANGES .
  methods SELECT_BY_PK
    importing
      !IS_PRIMAY_KEYS type ZOCR_IF_TOPS=>TS_PRIMARY_KEYS
    raising
      ZCX_OCR_EXCEPTION .
  methods UPDATE
    importing
      !IT_UPD type TABLE
      !IV_TABLE_NAME type TABNAME optional
    raising
      ZCX_OCR_EXCEPTION .
  methods SYNC_UPD
    importing
      !IT_UPD type TABLE .
  methods SET_TABLE_NAME .
endinterface.
