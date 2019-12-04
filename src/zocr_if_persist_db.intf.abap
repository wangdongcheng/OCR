interface ZOCR_IF_PERSIST_DB
  public .


  class-data TABLE_NAME type TABNAME read-only .
  class-data TABLE_CLASS_NAME type SEOCLSNAME read-only .
  class-data CURRENT_TABLE_OBJ type ref to ZOCR_IF_PERSIST_DB read-only .

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
  methods COMMIT_WORK
    importing
      !IB_WAIT type ABAP_BOOL default ABAP_TRUE .
  methods SYNC_UPD
    importing
      !IT_UPD type TABLE .
endinterface.
