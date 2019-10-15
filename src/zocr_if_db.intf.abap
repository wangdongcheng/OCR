interface ZOCR_IF_DB
  public .


  class-methods DB_WRITE
    importing
      !IV_DB_NAME type TABNAME
      !IT_INS type TABLE optional
      !IT_UPD type TABLE optional
      !IT_DEL type TABLE optional
      !IB_COMMIT type ABAP_BOOL optional
      !IB_WAIT type ABAP_BOOL optional .
endinterface.
