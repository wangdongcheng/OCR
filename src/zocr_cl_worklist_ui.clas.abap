class ZOCR_CL_WORKLIST_UI definition
  public
  final
  create public .

public section.

  class-methods DISPLAY_WORKLIST
    changing
      !CT_OUTTAB type TABLE
    raising
      ZCX_OCR_EXCEPTION .
  class-methods SET_WORKLIST_UCOMM
    importing
      !IV_UCOMM_SUBROUTINE_NAME type SLIS_FORMNAME .
  class-methods SET_WORKLIST_PF_STATUS
    importing
      !IV_PF_STATUS_NAME type SLIS_FORMNAME .
  class-methods SET_WORKLIST_MAIN_PROG
    importing
      !IV_MAIN_PROG_NAME type SYST_CPROG .
protected section.
private section.

  class-data WORKLIST_PF_STATUS_NAME type SLIS_FORMNAME .
  class-data WORKLIST_UCOM_SUBROUTINE_NAME type SLIS_FORMNAME .
  class-data WORKLIST_MAIN_PROG type SYST_CPROG .

  class-methods SET_FIELDCAT
    importing
      !IV_STRUCTURE_NAME type TABNAME
    returning
      value(RT_FIELDCAT) type LVC_T_FCAT .
  class-methods SET_LAYOUT
    returning
      value(RS_LAYOUT) type LVC_S_LAYO .
ENDCLASS.



CLASS ZOCR_CL_WORKLIST_UI IMPLEMENTATION.


  METHOD DISPLAY_WORKLIST.

*-- alv reuse fm
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
*       I_INTERFACE_CHECK        = ' '
        i_bypassing_buffer       = abap_true
*       I_BUFFER_ACTIVE          =
        i_callback_program       = worklist_main_prog
        i_callback_pf_status_set = worklist_pf_status_name
        i_callback_user_command  = worklist_ucom_subroutine_name
*       I_CALLBACK_TOP_OF_PAGE   = ' '
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME         =
*       I_BACKGROUND_ID          = ' '
*       I_GRID_TITLE             =
*       I_GRID_SETTINGS          =
        is_layout_lvc            = set_layout( )
        it_fieldcat_lvc          = set_fieldcat( zocr_if_tops=>cs_tab_name-worklist )
*       IT_EXCLUDING             =
*       IT_SPECIAL_GROUPS_LVC    =
*       IT_SORT_LVC              =
*       IT_FILTER_LVC            =
*       IT_HYPERLINK             =
*       IS_SEL_HIDE              =
*       I_DEFAULT                = 'X'
        i_save                   = 'A' " All
*       IS_VARIANT               =
*       IT_EVENTS                =
*       IT_EVENT_EXIT            =
*       IS_PRINT_LVC             =
*       IS_REPREP_ID_LVC         =
*       I_SCREEN_START_COLUMN    = 0
*       I_SCREEN_START_LINE      = 0
*       I_SCREEN_END_COLUMN      = 0
*       I_SCREEN_END_LINE        = 0
*       I_HTML_HEIGHT_TOP        =
*       I_HTML_HEIGHT_END        =
*       IT_ALV_GRAPHICS          =
*       IT_EXCEPT_QINFO_LVC      =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER  =
*       ES_EXIT_CAUSED_BY_USER   =
      TABLES
        t_outtab                 = ct_outtab
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
* 018	Failed to display data on worklist
      MESSAGE s018 INTO DATA(lv_dummy).
      zcx_ocr_exception=>raise_t100(
        iv_msgid = sy-msgid
        iv_msgno = sy-msgno ).
    ENDIF.

  ENDMETHOD.


  METHOD set_fieldcat.
    DATA:
       lt_fieldcat   TYPE lvc_t_fcat.
    FIELD-SYMBOLS:
       <ls_fieldcat> TYPE lvc_s_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = iv_structure_name
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      CLEAR rt_fieldcat.
    ENDIF.

    LOOP AT lt_fieldcat ASSIGNING <ls_fieldcat>.
      IF <ls_fieldcat>-fieldname EQ 'SEL'     OR
         <ls_fieldcat>-fieldname EQ 'PIC_STR' OR
         <ls_fieldcat>-fieldname EQ 'TXT_STR'.

        <ls_fieldcat>-tech = abap_true.
      ELSEIF
        <ls_fieldcat>-fieldname EQ 'GUID_MD5'.

        <ls_fieldcat>-no_out = abap_true.
      ELSEIF
        <ls_fieldcat>-fieldname EQ 'UPLIP'.

        <ls_fieldcat>-scrtext_l = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_s = 'Upload IP'.
      ELSEIF
        <ls_fieldcat>-fieldname EQ 'PSIZE'.

        <ls_fieldcat>-scrtext_l = 'Picture Size'.
        <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_s = 'Pic Size'.
      ELSEIF
        <ls_fieldcat>-fieldname EQ 'PICNM'.

        <ls_fieldcat>-scrtext_l = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_s = 'Pic Name'.
      ELSEIF
        <ls_fieldcat>-fieldname = 'DESCR'.
        <ls_fieldcat>-scrtext_l = <ls_fieldcat>-scrtext_m = 'Pic Description'.
        <ls_fieldcat>-scrtext_s = 'Pic Dscrp.'.
      ENDIF.
      <ls_fieldcat>-col_opt = abap_true.
    ENDLOOP.

    IF lt_fieldcat IS NOT INITIAL.
      rt_fieldcat = lt_fieldcat.
    ENDIF.
  ENDMETHOD.


  METHOD set_layout.
    rs_layout-stylefname = 'CELLSTYLE'.
    rs_layout-box_fname  = 'SEL'.
  ENDMETHOD.


  METHOD SET_WORKLIST_MAIN_PROG.
    CHECK iv_main_prog_name IS NOT INITIAL.
    worklist_main_prog = iv_main_prog_name.
  ENDMETHOD.


  METHOD set_worklist_pf_status.
    CHECK iv_pf_status_name IS NOT INITIAL.
    worklist_pf_status_name = iv_pf_status_name.
  ENDMETHOD.


  METHOD set_worklist_ucomm.
    CHECK iv_ucomm_subroutine_name IS NOT INITIAL.
    worklist_ucom_subroutine_name = iv_ucomm_subroutine_name.
  ENDMETHOD.
ENDCLASS.
