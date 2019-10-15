*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_FORM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  LOCAL_FILE_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILEL  text
*      <--P_GV_FULLNAME  text
*      <--P_GV_PATH  text
*      <--P_GV_FULLPATH  text
*----------------------------------------------------------------------*
FORM popup_file_browser
  CHANGING
        ev_fullpath  TYPE string.

  CLEAR: ev_fullpath.

  DATA:
    lv_window_title TYPE string,
    lv_filter       TYPE string.

  DATA:
    lt_filetable  TYPE filetable,
    lv_rc         TYPE i,
    lv_usr_action TYPE i.

  lv_window_title = 'Select picture'(001).

  lv_filter = gc_filter.
  CONDENSE lv_filter NO-GAPS.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = lv_window_title
      default_extension       = '*.*'
*     default_filename        =
      file_filter             = lv_filter
*     with_encoding           =
*     initial_directory       =
      multiselection          = abap_false
    CHANGING
      file_table              = lt_filetable
      rc                      = lv_rc
      user_action             = lv_usr_action
*     file_encoding           =
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    IF lv_usr_action EQ cl_gui_frontend_services=>action_ok.
      ev_fullpath = lt_filetable[ 1 ]-filename.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_IMAGE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILEL  text
*      <--P_GV_FULLNAME  text
*      <--P_GV_PATH  text
*      <--P_GV_FULLPATH  text
*----------------------------------------------------------------------*
FORM validate_image_file
  USING
        iv_fullpath TYPE string
  CHANGING
        ev_fullpath TYPE string
        ev_fullname TYPE char100
        ev_path     TYPE string
        ev_filename TYPE string
        ev_suffix   TYPE string.

  DATA: lv_result TYPE abap_bool.

  CLEAR: ev_fullpath,
         ev_fullname,
         ev_path,
         ev_filename,
         ev_suffix.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = iv_fullpath
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
    macro_s_message.
  ELSE.
    IF lv_result NE abap_true.
      MESSAGE e001 DISPLAY LIKE 'S'.
    ELSE.
      ev_fullpath = iv_fullpath.

      CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
        EXPORTING
          full_name     = iv_fullpath
        IMPORTING
          stripped_name = ev_fullname
          file_path     = ev_path
        EXCEPTIONS
          x_error       = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
        macro_s_message.
        RETURN.
      ELSE.
        SPLIT ev_fullname AT gc_dot
          INTO ev_filename
               ev_suffix.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM validate_usr_config
  USING
        is_ztocr01 TYPE ztocr01
  CHANGING
        eb_error   TYPE xfeld.

  DATA:
    lv_result TYPE abap_bool,
    lv_file   TYPE string.

  CLEAR eb_error.

*-- IE browser path
  lv_file = is_ztocr01-iepth.
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    IF lv_result NE abap_true.
      eb_error = abap_true.

* 013	IE Browser doesn't exist in given path, please check
      MESSAGE s013.
      RETURN.
    ENDIF.
  ENDIF.

*-- temp folder path
  lv_file = is_ztocr01-tmpph.
  CALL METHOD cl_gui_frontend_services=>directory_exist
    EXPORTING
      directory            = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    IF lv_result NE abap_true.
      eb_error = abap_true.

* 014	The given temporary folder doesn't exist, please check
      MESSAGE s014.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.


FORM upl_new_pic
  USING
        ib_first_time TYPE xfeld.

  DATA:
    lv_fullpath TYPE string. " e.g. C:\Users\wangd\Desktop\7.png

  PERFORM popup_file_browser
              CHANGING
                 lv_fullpath.

  CHECK lv_fullpath IS NOT INITIAL.

  IF ib_first_time NE abap_true.
    PERFORM clear_all
              USING
                 'XXX#X'
              CHANGING
                 gi_pic
                 gi_pic_cctrl
                 gi_txt
                 gi_txt_cctrl
                 gs_sgl_para.

*-- sync user configuration to runtime
    IF gs_sgl_para-01 NE gs_ztocr01_db-01.
      MOVE-CORRESPONDING gs_ztocr01_db TO gs_sgl_para.
      gs_sgl_para-rt_disp_mode = gs_ztocr01_db-dispm.
      gs_sgl_para-rt_rfc_dest  = gs_ztocr01_db-rfcdest.
    ENDIF.
  ENDIF.

*-- more validate conditions
  PERFORM validate_image_file
              USING
                 lv_fullpath
              CHANGING
                 gs_sgl_para-fullpath
                 gs_sgl_para-picnm
                 gs_sgl_para-path
                 gs_sgl_para-filename
                 gs_sgl_para-suffix.

*-- pic to rawstring, data table and get MD5 value
  PERFORM pic_2_rawstring
              USING
                 gs_sgl_para-fullpath
              CHANGING
                 gs_sgl_para-guid_md5
                 gs_sgl_para-pic_str
                 gs_sgl_para-pic_tab.

*-- pic size in kilobytes, data type RAW(abap type X) with length 1024 = 1 K
  gs_sgl_para-psize = lines( gs_sgl_para-pic_tab ).

*-- get pic from DB by primary key (unique MD5 value)
  PERFORM get_sgl_pic_db_by_pk
              USING
                 gs_sgl_para-guid_md5
              CHANGING
                 gs_ztocr_db.
  IF gs_ztocr_db IS NOT INITIAL.
* 007	The uploaded pic already exists in DB, will display the DB pic instead
    MESSAGE i007.
    MOVE-CORRESPONDING gs_ztocr_db TO gs_sgl_para.

    PERFORM conv_xstr_2_data_tab
                USING
                   gs_sgl_para-pic_str
                   gs_sgl_para-txt_str
                CHANGING
                   gs_sgl_para-pic_tab
                   gs_sgl_para-txt_tab.

  ENDIF.

*-- display picture cockpit
  gv_0100_status = gc_status-display.
  IF ib_first_time EQ abap_true.
    CALL SCREEN 0100.
  ELSE.
    LEAVE TO SCREEN 0100.
  ENDIF.

ENDFORM.

FORM popup_directory_browser
  CHANGING
        ev_path     TYPE string
        et_pic_file TYPE rstt_t_files
        ev_count    TYPE i.

  DATA:
    lv_title    TYPE string,
    lt_pic_file TYPE rstt_t_files,
    lr_suffix   TYPE RANGE OF string.

  CLEAR: ev_path,
         et_pic_file,
         ev_count.

  lr_suffix = VALUE #( sign   = 'I'
                       option = 'EQ'
                        ( low = 'jpg'   )
                        ( low = 'jpeg'  )
                        ( low = 'jpe'   )
                        ( low = 'jfif'  )
                        ( low = 'png'   )
                        ( low = 'tif'   )
                        ( low = 'tiff'  )
                        ( low = 'bmp'   )
                        ( low = 'dib'   )
                        ( low = 'JPG'   )
                        ( low = 'JPEG'  )
                        ( low = 'JPE'   )
                        ( low = 'JFIF'  )
                        ( low = 'PNG'   )
                        ( low = 'TIF'   )
                        ( low = 'TIFF'  )
                        ( low = 'BMP'   )
                        ( low = 'DIB'   )
                     ).

  lv_title  = 'Select Picture Folder'(004).

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = lv_title
*     initial_folder       =
    CHANGING
      selected_folder      = ev_path
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    CALL METHOD cl_gui_frontend_services=>directory_list_files
      EXPORTING
        directory                   = ev_path
*       filter                      = '*.*'
        files_only                  = abap_true
*       directories_only            =
      CHANGING
        file_table                  = lt_pic_file
        count                       = ev_count
      EXCEPTIONS
        cntl_error                  = 1
        directory_list_files_failed = 2
        wrong_parameter             = 3
        error_no_gui                = 4
        not_supported_by_gui        = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      CLEAR ev_count.
      LOOP AT lt_pic_file ASSIGNING FIELD-SYMBOL(<ls_pic_file>).

        SPLIT <ls_pic_file>-filename AT gc_dot INTO TABLE DATA(lt_tab).

*-- filter the all files with picture suffix
        IF lt_tab[ lines( lt_tab ) ] IN lr_suffix.
          APPEND <ls_pic_file> TO et_pic_file.
          ev_count = ev_count + 1.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

FORM import_pic_folder.
  DATA:
    lv_path     TYPE string,
    lt_pic_file TYPE STANDARD TABLE OF file_info,
    lv_count    TYPE i.

  PERFORM popup_directory_browser
              CHANGING
                 lv_path
                 lt_pic_file
                 lv_count.

  MESSAGE 'not ready yet' TYPE 'I'.
ENDFORM.


FORM get_sgl_pic_db_by_pk
  USING
        iv_guid_md5 TYPE hash160
  CHANGING
        es_ztocr_db TYPE ztocr.

  CHECK iv_guid_md5 IS NOT INITIAL.

  CLEAR es_ztocr_db.

  SELECT SINGLE
    *
    FROM ztocr
    INTO es_ztocr_db
    WHERE guid_md5 EQ iv_guid_md5.

ENDFORM.

FORM conv_xstr_2_data_tab
  USING
        iv_pic_str TYPE xstring
        iv_txt_str TYPE xstring
  CHANGING
        et_pic_tab TYPE zsocr_pic_data_t
        et_txt_tab TYPE soli_tab.

  CLEAR: et_pic_tab,
         et_txt_tab.

  IF iv_pic_str IS NOT INITIAL.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = iv_pic_str
      TABLES
        binary_tab = et_pic_tab.
  ELSE.
    CLEAR et_pic_tab.
  ENDIF.

  IF iv_txt_str IS NOT INITIAL.
    IMPORT p1 = et_txt_tab FROM DATA BUFFER iv_txt_str.
  ELSE.
    CLEAR et_txt_tab.
  ENDIF.

ENDFORM.

FORM pic_2_rawstring
  USING
        iv_fullpath TYPE string
  CHANGING
        ev_guid_md5 TYPE hash160
        ev_pic_str  TYPE xstring
        ev_pic_data TYPE zsocr_pic_data_t.

  DATA:
    lv_pic_str  TYPE icmdata,
    lt_pic_data TYPE zsocr_pic_data_t,
    lv_len      TYPE i,
    lv_hash     TYPE hash160.

  CLEAR: ev_guid_md5,
         ev_pic_str,
         ev_pic_data.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = iv_fullpath
      filetype                = 'BIN'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
    IMPORTING
      filelength              = lv_len
*     HEADER                  =
    TABLES
      data_tab                = lt_pic_data
* CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_len
    IMPORTING
      buffer       = lv_pic_str
    TABLES
      binary_tab   = lt_pic_data
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

*-- 'save as' will change the MD5
*-- 'copy and rename' won't change the MD5
*-- so we can take MD5 hash value as the key to store image file in DB
  CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
    EXPORTING
      alg            = 'MD5'
      data           = lv_pic_str
*     LENGTH         = 0
    IMPORTING
      hash           = lv_hash
*     HASHLEN        =
*     HASHX          =
*     HASHXLEN       =
*     HASHSTRING     =
*     HASHXSTRING    =
*     HASHB64STRING  =
    EXCEPTIONS
      unknown_alg    = 1
      param_error    = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    ev_guid_md5 = lv_hash.
    ev_pic_str  = lv_pic_str.
    ev_pic_data = lt_pic_data.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_BUTTONS_ON_SELSCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_buttons_on_selscreen .
  DATA:
        ls_btn TYPE smp_dyntxt.

  ls_btn-text           = ''.
  ls_btn-icon_id        = icon_create_text.
  ls_btn-icon_text      = TEXT-upl.  " Upload New Picture
  ls_btn-quickinfo      = TEXT-up2.  " Upload New Picture from Local Folder
  sscrfields-functxt_01 = ls_btn.

  ls_btn-text           = ''.
  ls_btn-icon_id        = icon_open_folder.
  ls_btn-icon_text      = TEXT-fld.  " Import Pic Folder
  ls_btn-quickinfo      = TEXT-fll.  " Batch Import Local Picture Folder
  sscrfields-functxt_02 = ls_btn.

  ls_btn-text           = ''.
  ls_btn-icon_id        = icon_import.
  ls_btn-icon_text      = TEXT-dms.  " Import from SAP DMS
  ls_btn-quickinfo      = TEXT-dml.  " Import from SAP Document Management System
  sscrfields-functxt_03 = ls_btn.

  ls_btn-text           = ''.
  ls_btn-icon_id        = icon_configuration.
  ls_btn-icon_text      = TEXT-usr.  " User Configuration
  ls_btn-quickinfo      = TEXT-usl.  " Configuration for User Master
  sscrfields-functxt_04 = ls_btn.
ENDFORM.

FORM read_ocr_text_rfc
  USING
        iv_pic_str  TYPE xstring
  CHANGING
        cv_rfc_dest TYPE rfcdest
        et_ocr_txt  TYPE soli_tab.

  CLEAR et_ocr_txt.

  CHECK iv_pic_str IS NOT INITIAL.

  IF cv_rfc_dest IS INITIAL.
    cv_rfc_dest = gc_rfc_dest. " take default if empty
  ENDIF.

*-- RFC solution for now, transfer pic stream to remote OCR engine
*-- and then wait to get the text stream back
*-- [TODO] later consider the more efficient asynchronized way
  CALL FUNCTION 'ZOCR_RFC_ENGINE'
    DESTINATION cv_rfc_dest
    EXPORTING
      iv_pic_str            = iv_pic_str
*     IV_LANGUAGE           =
    IMPORTING
*     et_ocr_msg            =
      et_ocr_txt            = et_ocr_txt
*     ev_subrc              =
*      et_ret2    =.
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2.
  IF sy-subrc NE 0.
* /BCV/SIN  039 RFC connection problems with system &1
    MESSAGE e039(/bcv/sin) WITH gs_sgl_para-rt_rfc_dest DISPLAY LIKE 'S'.
  ENDIF.
ENDFORM.

FORM clear_all
  USING
        iv_clear_switch    TYPE char5  " 'X' means need to clear, '#' means dont need clear
  CHANGING
        ci_pic             TYPE REF TO cl_gui_picture
        ci_pic_cctrl       TYPE REF TO cl_gui_custom_container
        ci_txt             TYPE REF TO cl_gui_textedit
        ci_txt_cctrl       TYPE REF TO cl_gui_custom_container
        cs_sgl_para        TYPE gts_sgl_para
        .
*-- need to FREE the instance, or the pic might be NOT REFRESHED
  CHECK iv_clear_switch NE '#####'. " 5 * '#'

  IF iv_clear_switch+0(1) EQ abap_true.
    CALL METHOD ci_pic->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      CLEAR ci_pic.
    ENDIF.
  ENDIF.

  IF iv_clear_switch+1(1) EQ abap_true.
    CALL METHOD ci_pic_cctrl->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      CLEAR ci_pic_cctrl.
    ENDIF.
  ENDIF.

  IF iv_clear_switch+2(1) EQ abap_true.
    CALL METHOD ci_txt->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      CLEAR ci_txt.
    ENDIF.
  ENDIF.

  IF iv_clear_switch+3(1) EQ abap_true.
    CALL METHOD ci_txt_cctrl->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      CLEAR ci_txt_cctrl.
    ENDIF.
  ENDIF.

  IF iv_clear_switch+4(1) EQ abap_true.
    CLEAR cs_sgl_para.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BASIC_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_usr_config
  CHANGING
        es_ztocr01    TYPE ztocr01
        es_ztocr01_db TYPE ztocr01.

  DATA:
    lv_ip_terminal TYPE xuterminal,
    lv_answer      TYPE c,
    lt_ztocr01     TYPE ztocr01_t.

  CLEAR es_ztocr01.

  es_ztocr01-uname   = sy-uname.

*-- 'IP-Terminal Name'
  CALL FUNCTION 'TERMINAL_ID_GET'
* EXPORTING
*   USERNAME                   = SY-UNAME
    IMPORTING
      terminal             = lv_ip_terminal
    EXCEPTIONS
      multiple_terminal_id = 1
      no_terminal_found    = 2
      OTHERS               = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    SPLIT lv_ip_terminal
       AT gc_dash
     INTO es_ztocr01-uplip
          es_ztocr01-temnl.
  ENDIF.

  SELECT
    *
    FROM ztocr01
    INTO TABLE lt_ztocr01
    WHERE uname EQ sy-uname.

  IF sy-subrc NE 0.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar       = 'Attention'
        text_question  = TEXT-002 " This is your first time to use OMS, please save your configuration first
        text_button_1  = TEXT-bty
        text_button_2  = TEXT-btn
      IMPORTING
        answer         = lv_answer
      EXCEPTIONS
        text_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      IF lv_answer NE '1'.
        LEAVE PROGRAM.
      ENDIF.
    ENDIF.
  ELSE.
    READ TABLE lt_ztocr01 INTO es_ztocr01_db
      WITH KEY temnl = es_ztocr01-temnl.
    IF sy-subrc NE 0.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar       = 'Attention'
          text_question  = TEXT-003 " This is your terminal first time to use OMS, please save your configuration first
          text_button_1  = TEXT-bty
          text_button_2  = TEXT-btn
        IMPORTING
          answer         = lv_answer
        EXCEPTIONS
          text_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        IF lv_answer NE '1'.
          LEAVE PROGRAM.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_DISP_MODE_LISTBOX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_disp_mode_listbox
  USING
        iv_vrm_id TYPE vrm_id.

  DATA:
    lt_vrm_value TYPE vrm_values,
    ls_vrm_value TYPE vrm_value.

*-- init listbox for display mode
*-- 0:  DISPLAY_MODE_NORMAL
*-- 1:  DISPLAY_MODE_STRETCH
*-- 2:  DISPLAY_MODE_FIT
*-- 3:  DISPLAY_MODE_NORMAL_CENTER
*-- 4:  DISPLAY_MODE_FIT_CENTER
  lt_vrm_value = VALUE #(
                          ( key = '0' text = 'Normal'         )
                          ( key = '1' text = 'Stretch'        )
                          ( key = '2' text = 'Fit'            )
                          ( key = '3' text = 'Normal Center'  )
                          ( key = '4' text = 'Fit Center'     )
                        ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = iv_vrm_id
      values          = lt_vrm_value
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM save_usr_config_2_db
  CHANGING
        cs_ztocr01_db TYPE ztocr01
        cs_ztocr01    TYPE ztocr01
        ev_action     TYPE c. " i=insert, u=update, d=delete

  CLEAR ev_action.

  DATA(lt_ztocr01) = VALUE ztocr01_t( ( cs_ztocr01 ) ).

  IF cs_ztocr01_db IS INITIAL.
    CALL FUNCTION 'ZTOCR01_DB_WRITE'
      EXPORTING
        it_ins    = lt_ztocr01
*       IT_UPD    =
*       IT_DEL    =
        ib_commit = abap_true
        ib_wait   = abap_true.

    cs_ztocr01_db = cs_ztocr01.
    ev_action = gc_action-ins.

  ELSEIF cs_ztocr01 NE cs_ztocr01_db.
    CALL FUNCTION 'ZTOCR01_DB_WRITE'
      EXPORTING
*       it_ins    =
        it_upd    = lt_ztocr01
*       IT_DEL    =
        ib_commit = abap_true
        ib_wait   = abap_true.

    cs_ztocr01_db = cs_ztocr01.
    ev_action = gc_action-upd.

  ELSEIF cs_ztocr01 EQ cs_ztocr01_db.
    CLEAR ev_action.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SAVE_PIC_2_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_pic_2_db
  USING
        ii_txt      TYPE REF TO cl_gui_textedit
  CHANGING
        cs_ztocr_db TYPE ztocr
        cs_sgl_para TYPE gts_sgl_para
        ev_action   TYPE c.

  DATA:
    ls_ztocr    TYPE ztocr,
    lb_modified TYPE i. " CL_GUI_TEXTEDIT=>TRUE / FALSE

  CLEAR ev_action.
  CHECK cs_sgl_para IS NOT INITIAL.

  ls_ztocr       = cs_sgl_para-ztocr.
  ls_ztocr-mandt = sy-mandt.

  CALL METHOD ii_txt->get_text_as_r3table
    EXPORTING
      only_when_modified     = cl_gui_textedit=>false
    IMPORTING
      table                  = cs_sgl_para-txt_tab
      is_modified            = lb_modified
    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      error_dp_create        = 3
      potential_data_loss    = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF lb_modified = cl_gui_textedit=>true. " text changed
    EXPORT p1 = cs_sgl_para-txt_tab TO DATA BUFFER ls_ztocr-txt_str.
  ENDIF.

  DATA(lt_ztocr) = VALUE ztocr_t( ( ls_ztocr ) ).

*-- insert new
  IF cs_ztocr_db IS INITIAL.

    lt_ztocr[ 1 ]-crdat = sy-datum.
    lt_ztocr[ 1 ]-crtim = sy-uzeit.
    lt_ztocr[ 1 ]-crnam = sy-uname.

*    CALL FUNCTION 'ZTOCR_DB_WRITE'
*      EXPORTING
*        it_ins    = lt_ztocr
**       IT_UPD    =
**       IT_DEL    =
*        ib_commit = abap_true
*        ib_wait   = abap_true.

    zocr_cl_db=>ztocr_db_write(
      EXPORTING
        it_ins    = lt_ztocr
*       it_upd    =
*       it_del    =
        ib_commit = abap_false
        ib_wait   = abap_false
        ).

    ev_action = gc_action-ins.

*-- update existing pic or ocr text to DB
  ELSEIF ls_ztocr NE cs_ztocr_db.

    lt_ztocr[ 1 ]-chdat = sy-datum.
    lt_ztocr[ 1 ]-chtim = sy-uzeit.
    lt_ztocr[ 1 ]-chnam = sy-uname.

    zocr_cl_db=>ztocr_db_write(
      EXPORTING
        it_upd    = lt_ztocr
        ib_commit = abap_true
        ib_wait   = abap_true
        ).

*    CALL FUNCTION 'ZTOCR_DB_WRITE'
*      EXPORTING
**       IT_INS    =
*        it_upd    = lt_ztocr
**       IT_DEL    =
*        ib_commit = abap_true
*        ib_wait   = abap_true.

    ev_action = gc_action-upd.

*-- no change
  ELSEIF ls_ztocr EQ cs_ztocr_db.
    CLEAR ev_action.
  ENDIF.

  cs_ztocr_db       = lt_ztocr[ 1 ]. " sync back
  cs_sgl_para-ztocr = lt_ztocr[ 1 ].
  cs_sgl_para-uplip = lt_ztocr[ 1 ]-uplip.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  alv_variant_default_get
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IV_REPID   text
*      -->IV_HANDLE  text
*      -->EV_DVARI   text
*      -->ES_VARIANT text
*----------------------------------------------------------------------*
FORM alv_variant_default_get
  USING
        iv_repid   TYPE sy-repid
        iv_handle  TYPE slis_handl
  CHANGING
        ev_dvari   TYPE slis_vari
        es_variant TYPE disvariant.

  CLEAR es_variant.
  CLEAR ev_dvari.

  es_variant-report   = iv_repid.
  es_variant-handle   = iv_handle.

  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = 'A'
    CHANGING
      cs_variant = es_variant
    EXCEPTIONS
      not_found  = 4.

*------ Fehlerverarbeitung
  IF ( sy-subrc = 0 ).
    ev_dvari = es_variant-variant.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TEST_AND_ASSIGN_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_DVARI  text
*      <--P_GS_VARIANT  text
*----------------------------------------------------------------------*
FORM test_and_assign_layout
  CHANGING
        ev_variant TYPE slis_vari
        cs_variant TYPE disvariant.


  DATA: ls_variant TYPE disvariant.

  ls_variant-report  = sy-repid.
  ls_variant-handle  = ''.
  ls_variant-variant = ev_variant.

  CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
    EXPORTING
      i_save        = 'A'
    CHANGING
      cs_variant    = ls_variant
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.
  IF sy-subrc = 0.
    cs_variant-variant = ev_variant.
    cs_variant-report  = sy-repid.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_DVARI  text
*      <--P_GS_VARIANT  text
*----------------------------------------------------------------------*
FORM alv_variant_f4
  CHANGING
        ev_variant TYPE slis_vari
        cs_variant TYPE disvariant.

  DATA: lv_exit TYPE c.
  CLEAR ev_variant.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = cs_variant
      i_save     = 'A'
    IMPORTING
      e_exit     = lv_exit
      es_variant = cs_variant
    EXCEPTIONS
      not_found  = 2.

  IF ( sy-subrc <> 2 AND lv_exit IS INITIAL ).
    ev_variant = cs_variant-variant.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_PICNM[]  text
*      -->P_S_TEMNL[]  text
*      -->P_S_LSTIP[]  text
*      -->P_S_CRDAT[]  text
*      -->P_S_CRNAM[]  text
*      -->P_S_CHDAT[]  text
*      -->P_S_CHNAM[]  text
*      -->P_S_MD5[]  text
*----------------------------------------------------------------------*
FORM main
  USING
        ir_picnm TYPE ANY TABLE
        ir_temnl TYPE ANY TABLE
        ir_uplip TYPE ANY TABLE
        ir_crdat TYPE ANY TABLE
        ir_crnam TYPE ANY TABLE
        ir_chdat TYPE ANY TABLE
        ir_chnam TYPE ANY TABLE
        ir_md5   TYPE ANY TABLE.


*-- prepare crit from selection screen input values
  PERFORM prep_crit
              USING
                 ir_picnm
                 ir_temnl
                 ir_uplip
                 ir_crdat
                 ir_crnam
                 ir_chdat
                 ir_chnam
                 ir_md5
              CHANGING
                 gs_crit.

*-- get picture tables from DB
  PERFORM get_pic_db_by_crit
              USING
                 gs_crit
              CHANGING
                 gt_zsocr_wklst.


*-- AlV worklist display and ALV user events
  PERFORM disp_pic_worklist
              USING
                 gt_zsocr_wklst.

ENDFORM.

FORM prep_crit
  USING
        ir_picnm TYPE ANY TABLE
        ir_temnl TYPE ANY TABLE
        ir_uplip TYPE ANY TABLE
        ir_crdat TYPE ANY TABLE
        ir_crnam TYPE ANY TABLE
        ir_chdat TYPE ANY TABLE
        ir_chnam TYPE ANY TABLE
        ir_md5   TYPE ANY TABLE
  CHANGING
        es_crit  TYPE gts_crit.

  CLEAR es_crit.

  es_crit-picnm    =   ir_picnm.
  es_crit-temnl    =   ir_temnl.
  es_crit-uplip    =   ir_uplip.
  es_crit-crdat    =   ir_crdat.
  es_crit-crnam    =   ir_crnam.
  es_crit-chdat    =   ir_chdat.
  es_crit-chnam    =   ir_chnam.
  es_crit-guid_md5 =   ir_md5.

ENDFORM.

FORM get_pic_db_by_crit
  USING
        is_crit        TYPE gts_crit
  CHANGING
        et_zsocr_wklst TYPE zsocr_wklst_t.

  DATA:
        lt_ztocr TYPE ztocr_t.

  CLEAR et_zsocr_wklst.

  SELECT
    *
    FROM ztocr
    INTO TABLE lt_ztocr
    WHERE picnm    IN is_crit-picnm
      AND temnl    IN is_crit-temnl
      AND uplip    IN is_crit-uplip
      AND crdat    IN is_crit-crdat
      AND crnam    IN is_crit-crnam
      AND chdat    IN is_crit-chdat
      AND chnam    IN is_crit-chnam
      AND guid_md5 IN is_crit-guid_md5
    .
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING lt_ztocr TO et_zsocr_wklst.
  ENDIF.

ENDFORM.

FORM disp_pic_worklist
  USING
        it_zsocr_wklst TYPE zsocr_wklst_t.

  DATA:
    lt_fieldcat TYPE lvc_t_fcat,
    ls_layout   TYPE lvc_s_layo.

*-- ALV Fieldcategory
  PERFORM prep_fieldcat
              USING
                 'ZSOCR_WKLST'
              CHANGING
                 lt_fieldcat.

*-- ALV Layout
  PERFORM layout_prep
              CHANGING
                 ls_layout.

*-- ALV reuse FM
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
      i_bypassing_buffer       = abap_true
*     I_BUFFER_ACTIVE          =
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'CALLBACK_SET_PF'
      i_callback_user_command  = 'CALLBACK_USER_CMD'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout_lvc            = ls_layout
      it_fieldcat_lvc          = lt_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS_LVC    =
*     IT_SORT_LVC              =
*     IT_FILTER_LVC            =
*     IT_HYPERLINK             =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
      i_save                   = 'A' " All
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT_LVC             =
*     IS_REPREP_ID_LVC         =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        =
*     I_HTML_HEIGHT_END        =
*     IT_ALV_GRAPHICS          =
*     IT_EXCEPT_QINFO_LVC      =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = it_zsocr_wklst
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


FORM prep_fieldcat
  USING
        iv_struc_name TYPE tabname
  CHANGING
        et_fieldcat   TYPE lvc_t_fcat.

  DATA:
     lt_fieldcat   TYPE lvc_t_fcat.
  FIELD-SYMBOLS:
     <ls_fieldcat> TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = iv_struc_name
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    CLEAR et_fieldcat.
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
    ENDIF.
    <ls_fieldcat>-col_opt = abap_true.
  ENDLOOP.

  IF lt_fieldcat IS NOT INITIAL.
    et_fieldcat = lt_fieldcat.
  ENDIF.
ENDFORM.

FORM layout_prep
  CHANGING
        es_layout TYPE lvc_s_layo.

  CLEAR es_layout.
  es_layout-stylefname = 'CELLSTYLE'.
  es_layout-box_fname  = 'SEL'.

ENDFORM.

FORM callback_set_pf                    ##called
  USING
        it_excltab TYPE slis_t_extab.

  DATA:lt_excltab TYPE slis_t_extab.

  lt_excltab = it_excltab.

  PERFORM excltab_prep
    CHANGING
          lt_excltab.

*--- Copy Standard GUI Status STANDARD_FULLSCREEN From FG SLVC_FULLSCREEN
  SET PF-STATUS 'WKLST' EXCLUDING lt_excltab.
ENDFORM.

FORM excltab_prep
  CHANGING
        ct_excltab TYPE slis_t_extab.

  DATA lt_excltab TYPE slis_t_extab.

  lt_excltab = VALUE #( ( fcode = '&ETA'       ) "Details
                        ( fcode = '&EB9'       ) "Call Up Report...
                        ( fcode = '&ABC'       ) "ABC Analysis
                        ( fcode = '&GRAPH'     ) "Graphic
                        ( fcode = '&INFO'      ) "Information
                        ( fcode = '&DATA_SAVE' ) "Save
                        ).

  APPEND LINES OF lt_excltab TO ct_excltab.
ENDFORM.

FORM callback_user_cmd                 ##called
  USING
        iv_ucomm    TYPE sy-ucomm
        is_selfield TYPE slis_selfield.

  DATA:
        lv_sel_count TYPE i.

  CASE iv_ucomm.
    WHEN 'DISP_SGL'.
      LOOP AT gt_zsocr_wklst ASSIGNING FIELD-SYMBOL(<ls_wklst>)
        WHERE sel EQ abap_true.
        lv_sel_count = lv_sel_count + 1.
      ENDLOOP.

      IF lv_sel_count EQ 0.
* 011	Please select at least one line to display the picture
        MESSAGE e011 DISPLAY LIKE 'S'.
      ELSEIF lv_sel_count GT 1.
* 012	Please only select one line to display the picture
        MESSAGE e012 DISPLAY LIKE 'S'.
      ELSE.
        gs_sgl_para-ztocr = gs_ztocr = gs_ztocr_db = <ls_wklst>-ztocr.
        SPLIT gs_sgl_para-picnm AT gc_dot
         INTO gs_sgl_para-filename
              gs_sgl_para-suffix.
      ENDIF.

      PERFORM conv_xstr_2_data_tab
                  USING
                     gs_sgl_para-pic_str
                     gs_sgl_para-txt_str
                  CHANGING
                     gs_sgl_para-pic_tab
                     gs_sgl_para-txt_tab.

      gv_0100_status = gc_status-display. " display
      CALL SCREEN 0100.

    WHEN 'REFRESH'.
      PERFORM get_pic_db_by_crit
                  USING
                     gs_crit
                  CHANGING
                     gt_zsocr_wklst.

      is_selfield-refresh = abap_true.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.

FORM disp_in_ie
  USING
        is_sgl_para TYPE gts_sgl_para.

*  CONSTANTS:
*    lc_pic_mark TYPE c LENGTH 10 VALUE '%PIC_PATH%'.
*
*  DATA:
*    lv_tmpph          TYPE text255,
*    lv_tmp_pic_nm     TYPE string, " nm = name
*    lv_tmp_html_fp    TYPE string, " fp = fullpath
*    lv_tmp_pic_fp     TYPE string,
*    lt_tline          TYPE tline_tab,
*    lt_html           TYPE dms_tab_tdline,
*    lv_html           TYPE tdline,
*    lv_result         TYPE abap_bool,
*    lv_long_html_line TYPE string.
*
*  IF is_sgl_para-guid_md5 IS INITIAL.
** 015  Please check the MD5 value of this picture
*    MESSAGE s015.
*    RETURN.
*  ENDIF.
*
*  IF substring( val = is_sgl_para-tmpph
*                off = strlen( is_sgl_para-tmpph ) - 1
*                len = 1 ) NE gc_backslash.  " check if temp folder path end with the path separator "\"
*
*    lv_tmpph = |{ is_sgl_para-tmpph }{ gc_backslash }|.
*  ELSE.
*    lv_tmpph = is_sgl_para-tmpph.
*  ENDIF.
*
*  lv_tmp_html_fp = |{ lv_tmpph }pic.html |.
*
**-- " if the pic just uploaded, don't need to copy to tmp path, just use the upload path
*  IF is_sgl_para-fullpath IS INITIAL.
*    lv_tmp_pic_nm  = |{ is_sgl_para-guid_md5 }{ gc_dot }{ is_sgl_para-suffix }|.
*    lv_tmp_pic_fp  = |{ lv_tmpph }{ lv_tmp_pic_nm }|.
*  ELSE.
*    lv_tmp_pic_fp = is_sgl_para-fullpath.
*  ENDIF.
*
**-- check if the pic already in tmp path
*  CALL METHOD cl_gui_frontend_services=>file_exist
*    EXPORTING
*      file                 = lv_tmp_pic_fp
*    RECEIVING
*      result               = lv_result
*    EXCEPTIONS
*      cntl_error           = 1
*      error_no_gui         = 2
*      wrong_parameter      = 3
*      not_supported_by_gui = 4
*      OTHERS               = 5.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ELSE.
*    IF lv_result NE abap_true.
*      CALL FUNCTION 'GUI_DOWNLOAD'
*        EXPORTING
**         BIN_FILESIZE            =
*          filename                = lv_tmp_pic_fp
*          filetype                = 'BIN'
**         APPEND                  = ' '
**         WRITE_FIELD_SEPARATOR   = ' '
**         HEADER                  = '00'
**         TRUNC_TRAILING_BLANKS   = ' '
**         WRITE_LF                = 'X'
**         COL_SELECT              = ' '
**         COL_SELECT_MASK         = ' '
**         DAT_MODE                = ' '
**         CONFIRM_OVERWRITE       = ' '
**         NO_AUTH_CHECK           = ' '
**         CODEPAGE                = ' '
**         IGNORE_CERR             = ABAP_TRUE
**         REPLACEMENT             = '#'
**         WRITE_BOM               = ' '
**         TRUNC_TRAILING_BLANKS_EOL       = 'X'
**         WK1_N_FORMAT            = ' '
**         WK1_N_SIZE              = ' '
**         WK1_T_FORMAT            = ' '
**         WK1_T_SIZE              = ' '
**         WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
**         SHOW_TRANSFER_STATUS    = ABAP_TRUE
**         VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
**   IMPORTING
**         FILELENGTH              =
*        TABLES
*          data_tab                = is_sgl_para-pic_tab
**         FIELDNAMES              =
*        EXCEPTIONS
*          file_write_error        = 1
*          no_batch                = 2
*          gui_refuse_filetransfer = 3
*          invalid_type            = 4
*          no_authority            = 5
*          unknown_error           = 6
*          header_not_allowed      = 7
*          separator_not_allowed   = 8
*          filesize_not_allowed    = 9
*          header_too_long         = 10
*          dp_error_create         = 11
*          dp_error_send           = 12
*          dp_error_write          = 13
*          unknown_dp_error        = 14
*          access_denied           = 15
*          dp_out_of_memory        = 16
*          disk_full               = 17
*          dp_timeout              = 18
*          file_not_found          = 19
*          dataprovider_exception  = 20
*          control_flush_error     = 21
*          OTHERS                  = 22.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*    ENDIF.
*  ENDIF.
*
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
**     CLIENT                  = SY-MANDT
*      id                      = 'ST'
*      language                = 'E'
*      name                    = 'ZOCR_PIC_HTML'
*      object                  = 'TEXT'
**     ARCHIVE_HANDLE          = 0
**     LOCAL_CAT               = ' '
** IMPORTING
**     HEADER                  =
**     OLD_LINE_COUNTER        =
*    TABLES
*      lines                   = lt_tline
*    EXCEPTIONS
*      id                      = 1
*      language                = 2
*      name                    = 3
*      not_found               = 4
*      object                  = 5
*      reference_check         = 6
*      wrong_access_to_archive = 7
*      OTHERS                  = 8.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ELSE.
*    LOOP AT lt_tline ASSIGNING FIELD-SYMBOL(<ls_tline>).
** %PIC_PATH%
*      FIND FIRST OCCURRENCE OF lc_pic_mark IN <ls_tline>-tdline.
*
*      IF sy-subrc EQ 0. " found mark to replace
*        IF strlen( <ls_tline>-tdline ) + strlen( lv_tmp_pic_fp ) - strlen( lc_pic_mark ) GT 132. " TDLINE CHAR  132, too long after replacement
*          lv_long_html_line = <ls_tline>-tdline.
*          REPLACE ALL OCCURRENCES OF lc_pic_mark IN lv_long_html_line WITH lv_tmp_pic_fp.
*          DO.
*            IF strlen( lv_long_html_line ) GE 132.
*              APPEND substring( val = lv_long_html_line
*                                off = 0
*                                len = 132 ) TO lt_html.
*              lv_long_html_line = substring( val = lv_long_html_line
*                                             off = 132 ).
*            ELSE.
*              APPEND substring( val = lv_long_html_line
*                                off = 0 ) TO lt_html.
*              EXIT.
*            ENDIF.
*          ENDDO.
*        ELSE.
*          REPLACE ALL OCCURRENCES OF lc_pic_mark IN <ls_tline>-tdline WITH lv_tmp_pic_fp.
*          APPEND <ls_tline>-tdline TO lt_html. " simply append
*        ENDIF.
*      ELSE.
*        APPEND <ls_tline>-tdline TO lt_html. " simply append
*      ENDIF.
*    ENDLOOP.
*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
**       BIN_FILESIZE            =
*        filename                = lv_tmp_html_fp
*        filetype                = 'ASC'
**       APPEND                  = ' '
**       WRITE_FIELD_SEPARATOR   = ' '
**       HEADER                  = '00'
**       TRUNC_TRAILING_BLANKS   = ' '
**       WRITE_LF                = 'X'
**       COL_SELECT              = ' '
**       COL_SELECT_MASK         = ' '
**       DAT_MODE                = ' '
**       CONFIRM_OVERWRITE       = ' '
**       NO_AUTH_CHECK           = ' '
*        codepage                = '4110' " utf-8, use FM SCP_CODEPAGE_BY_EXTERNAL_NAME to get the codepage number
**       IGNORE_CERR             = ABAP_TRUE
**       REPLACEMENT             = '#'
**       WRITE_BOM               = ' '
**       TRUNC_TRAILING_BLANKS_EOL       = 'X'
**       WK1_N_FORMAT            = ' '
**       WK1_N_SIZE              = ' '
**       WK1_T_FORMAT            = ' '
**       WK1_T_SIZE              = ' '
**       WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
**       SHOW_TRANSFER_STATUS    = ABAP_TRUE
**       VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
** IMPORTING
**       FILELENGTH              =
*      TABLES
*        data_tab                = lt_html
**       FIELDNAMES              =
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ELSE.
*
**-- display picture by IE
*      CALL METHOD cl_gui_frontend_services=>execute
*        EXPORTING
**         document               =
*          application            = |{ is_sgl_para-iepth }|  " convert TEXT255 to string
*          parameter              = lv_tmp_html_fp
**         default_directory      =
**         maximized              =
**         minimized              =
**         synchronous            =
**         operation              = 'OPEN'
*        EXCEPTIONS
*          cntl_error             = 1
*          error_no_gui           = 2
*          bad_parameter          = 3
*          file_not_found         = 4
*          path_not_found         = 5
*          file_extension_unknown = 6
*          error_execute_failed   = 7
*          synchronous_failed     = 8
*          not_supported_by_gui   = 9
*          OTHERS                 = 10.
*      IF sy-subrc <> 0.
**       Implement suitable error handling here
*      ENDIF.
*
*    ENDIF.
*
*  ENDIF.


ENDFORM.
