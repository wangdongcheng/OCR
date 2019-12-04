class ZCX_OCR_EXCEPTION definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  data SUBRC type SYST_SUBRC read-only .
  data MT_CALLSTACK type SYMSGV read-only .
  data MSGV1 type SYMSGV .
  data MSGV2 type SYMSGV .
  data MSGV3 type SYMSGV .
  data MSGV4 type SYMSGV .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SUBRC type SYST_SUBRC optional
      !MT_CALLSTACK type SYMSGV optional
      !MSGV1 type SYMSGV optional
      !MSGV2 type SYMSGV optional
      !MSGV3 type SYMSGV optional
      !MSGV4 type SYMSGV optional .
  class-methods RAISE
    importing
      !IV_SUBRC type SYST_SUBRC optional
      !IV_TEXT type CLIKE
      !IX_PREVIOUS type ref to CX_ROOT optional
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods RAISE_T100
    importing
      !IV_MSGID type SYMSGID default SY-MSGID
      !IV_MSGNO type SYMSGNO default SY-MSGNO
      !IV_MSGV1 type SYMSGV default SY-MSGV1
      !IV_MSGV2 type SYMSGV default SY-MSGV2
      !IV_MSGV3 type SYMSGV default SY-MSGV3
      !IV_MSGV4 type SYMSGV default SY-MSGV4
    raising
      ZCX_OCR_EXCEPTION .
protected section.
private section.

  constants GC_GENERIC_ERROR_MSG type STRING value `An error occured (ZCX_OCR_EXCEPTION)` ##NO_TEXT.
ENDCLASS.



CLASS ZCX_OCR_EXCEPTION IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->SUBRC = SUBRC .
me->MT_CALLSTACK = MT_CALLSTACK .
me->MSGV1 = MSGV1 .
me->MSGV2 = MSGV2 .
me->MSGV3 = MSGV3 .
me->MSGV4 = MSGV4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  METHOD raise.
    DATA:
      lv_msgv1    TYPE symsgv,
      lv_msgv2    TYPE symsgv,
      lv_msgv3    TYPE symsgv,
      lv_msgv4    TYPE symsgv,
      ls_t100_key TYPE scx_t100key,
      lv_text     TYPE string.

    IF iv_text IS INITIAL.
      lv_text = gc_generic_error_msg.
    ELSE.
      lv_text = iv_text.
    ENDIF.

    CL_MESSAGE_HELPER=>set_msg_vars_for_clike( lv_text ).

    ls_t100_key-msgid = sy-msgid.
    ls_t100_key-msgno = sy-msgno.
    ls_t100_key-attr1 = 'MSGV1'.
    ls_t100_key-attr2 = 'MSGV2'.
    ls_t100_key-attr3 = 'MSGV3'.
    ls_t100_key-attr4 = 'MSGV4'.
    lv_msgv1 = sy-msgv1.
    lv_msgv2 = sy-msgv2.
    lv_msgv3 = sy-msgv3.
    lv_msgv4 = sy-msgv4.

    RAISE EXCEPTION TYPE zcx_ocr_exception
      EXPORTING
        textid   = ls_t100_key
        subrc    = iv_subrc
        msgv1    = lv_msgv1
        msgv2    = lv_msgv2
        msgv3    = lv_msgv3
        msgv4    = lv_msgv4
        previous = ix_previous.
  ENDMETHOD.


  METHOD raise_t100.
    DATA: ls_t100_key TYPE scx_t100key.

    ls_t100_key-msgid = iv_msgid.
    ls_t100_key-msgno = iv_msgno.
    ls_t100_key-attr1 = 'MSGV1'.
    ls_t100_key-attr2 = 'MSGV2'.
    ls_t100_key-attr3 = 'MSGV3'.
    ls_t100_key-attr4 = 'MSGV4'.

    IF iv_msgid IS INITIAL.
      CLEAR ls_t100_key.
    ENDIF.

    RAISE EXCEPTION TYPE zcx_ocr_exception
      EXPORTING
        textid = ls_t100_key
        msgv1  = iv_msgv1
        msgv2  = iv_msgv2
        msgv3  = iv_msgv3
        msgv4  = iv_msgv4.
  ENDMETHOD.
ENDCLASS.
