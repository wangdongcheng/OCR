FUNCTION zocr_rfc_engine.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_PIC_STR) TYPE  ICMDATA
*"     VALUE(IV_LANGUAGE) TYPE  FPM_T_SPRAS OPTIONAL
*"  EXPORTING
*"     VALUE(ET_OCR_MSG) TYPE  DBA_EXEC_PROTOCOL
*"     VALUE(ET_OCR_TXT) TYPE  SOLI_TAB
*"     VALUE(EV_SUBRC) TYPE  SYST_SUBRC
*"     VALUE(ET_RET2) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  TYPES:
    BEGIN OF lts_pic_data,
      pic_data TYPE x LENGTH 1024,
    END OF lts_pic_data.

  CONSTANTS:
    lc_srv_path TYPE string VALUE '/home/tonywang/Pictures/ocr_tmp',
    lc_cmd      TYPE sxpglogcmd VALUE 'ZTESSERACT'.

  DATA:
    lt_pic_tab   TYPE STANDARD TABLE OF lts_pic_data,
    ls_ocr_txt   TYPE soli,
    ls_ret2      TYPE bapiret2,
    lv_srv_pic   TYPE fileextern,
    lv_srv_txt   TYPE fileextern,
    lv_para      TYPE btcxpgpar,
    lv_chk_space TYPE so_text255.

  CLEAR: et_ocr_msg,
         et_ocr_txt,
         ev_subrc,
         et_ret2.

  CHECK iv_pic_str IS NOT INITIAL.

  lv_srv_pic = |{ lc_srv_path }.jpg|.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = iv_pic_str
    TABLES
      binary_tab = lt_pic_tab.

  CALL FUNCTION 'AUTHORITY_CHECK_DATASET'
    EXPORTING
*     PROGRAM          =
      activity         = 'WRITE'
      filename         = lv_srv_pic
    EXCEPTIONS
      no_authority     = 1
      activity_unknown = 2
      OTHERS           = 3.
  IF sy-subrc <> 0.
    ls_ret2-message = 'No Authorization for Dataset'(001).
    APPEND ls_ret2 TO et_ret2.
    RETURN.
  ELSE.
    OPEN DATASET lv_srv_pic FOR OUTPUT IN BINARY MODE MESSAGE ls_ret2-message.
    IF sy-subrc NE 0.
      ev_subrc = sy-subrc.
      APPEND ls_ret2 TO et_ret2.
      RETURN.
    ENDIF.
    LOOP AT lt_pic_tab ASSIGNING FIELD-SYMBOL(<ls_pic_tab>).
      TRANSFER <ls_pic_tab>-pic_data TO lv_srv_pic.
    ENDLOOP.
    CLOSE DATASET lv_srv_pic.
  ENDIF.

  lv_para    = |{ lv_srv_pic } { lc_srv_path }|.
  lv_srv_txt = |{ lc_srv_path }.txt|.

  CALL FUNCTION 'SXPG_CALL_SYSTEM'
    EXPORTING
      commandname                = lc_cmd
      additional_parameters      = lv_para "/tmp/dev/7.png /tmp/dev/out
*     TRACE                      =
* IMPORTING
*     STATUS                     =
*     EXITCODE                   =
    TABLES
      exec_protocol              = et_ocr_msg
    EXCEPTIONS
      no_permission              = 1
      command_not_found          = 2
      parameters_too_long        = 3
      security_risk              = 4
      wrong_check_call_interface = 5
      program_start_error        = 6
      program_termination_error  = 7
      x_error                    = 8
      parameter_expected         = 9
      too_many_parameters        = 10
      illegal_command            = 11
      OTHERS                     = 12.
  IF sy-subrc <> 0.
    ev_subrc = sy-subrc.
    ls_ret2-message = 'Call external command failure'(002).
    APPEND ls_ret2 TO et_ret2.
    RETURN.
  ELSE.
    OPEN DATASET lv_srv_txt FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    DO.
      READ DATASET lv_srv_txt INTO ls_ocr_txt-line.
      IF sy-subrc EQ 0.
        lv_chk_space = ls_ocr_txt-line.
        CONDENSE lv_chk_space NO-GAPS.
        CHECK lv_chk_space IS NOT INITIAL. " ignore space lines

        APPEND ls_ocr_txt TO et_ocr_txt.
      ELSE.
        CLOSE DATASET lv_srv_txt.
        EXIT.
      ENDIF.
    ENDDO.
    CLOSE DATASET lv_srv_txt.
  ENDIF.

ENDFUNCTION.
