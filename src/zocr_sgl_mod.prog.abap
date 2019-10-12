*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_MOD
*&---------------------------------------------------------------------*

DATA:
  lv_action TYPE c,
  lv_answer TYPE c..
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100' WITH gs_sgl_para-picnm.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA lv_readonly TYPE i.

  CASE sy-ucomm.
    WHEN 'UPL_SGL'.
      PERFORM upl_new_pic
                  USING
                     abap_false.

    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar       = 'Attention'(005)
          text_question  = TEXT-sav " Are you sure to save the pic to system?
          text_button_1  = TEXT-bty
          text_button_2  = TEXT-btn
        IMPORTING
          answer         = lv_answer
        EXCEPTIONS
          text_not_found = 1
          OTHERS         = 2.
      IF lv_answer EQ '1'.

        PERFORM save_pic_2_db
                    USING
                       gi_txt
                    CHANGING
                       gs_ztocr_db
                       gs_sgl_para
                       lv_action.

        IF lv_action EQ gc_action-ins.
* 008	The picture has been added to system
          MESSAGE s008.
        ELSEIF lv_action EQ gc_action-upd.
* 009	The existing picture has been updated
          MESSAGE s009.
        ELSEIF lv_answer EQ gc_action-del.
        ELSE.
* 010	No changes on pictures
          MESSAGE s010.
        ENDIF.
      ENDIF.
    WHEN 'OCR'.
      PERFORM read_ocr_text_rfc
                  USING
                     gs_sgl_para-pic_str
                  CHANGING
                     gs_sgl_para-rt_rfc_dest
                     gs_sgl_para-txt_tab.

      IF gs_sgl_para-txt_tab IS NOT INITIAL.
*-- display the ocr result text on text container
        CALL METHOD gi_txt->set_text_as_r3table
          EXPORTING
            table           = gs_sgl_para-txt_tab " Internal Table
          EXCEPTIONS
            error_dp        = 1
            error_dp_create = 2
            OTHERS          = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        EXPORT p1 = gs_sgl_para-txt_tab TO DATA BUFFER gs_sgl_para-txt_str.
      ENDIF.

    WHEN 'TOGGLE'.
*-- toggle display/change
      IF gv_0100_status EQ gc_status-display.
        gv_0100_status = gc_status-change.
      ELSE.
        gv_0100_status = gc_status-display.
      ENDIF.

*-- ReadOnly mode; eq 0: OFF ; ne 0: ON
      IF gi_txt->m_readonly_mode EQ cl_gui_textedit=>false.
        lv_readonly = cl_gui_textedit=>true.
      ELSE.
        lv_readonly = cl_gui_textedit=>false.
      ENDIF.

      CALL METHOD gi_txt->set_readonly_mode
        EXPORTING
          readonly_mode          = lv_readonly
        EXCEPTIONS
          error_cntl_call_method = 1
          invalid_parameter      = 2
          OTHERS                 = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    WHEN 'SETTING'.
      CALL SCREEN 0101 STARTING AT 3  3
                         ENDING AT 71 8.

    WHEN 'NML'. " display normal
      CALL METHOD gi_pic->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_normal.

    WHEN 'CEN'. " display center
      CALL METHOD gi_pic->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_fit_center.

    WHEN 'DISP_IE'. " display in IE

*-- display picture in IE for better review and check
      PERFORM disp_in_ie
                  USING
                     gs_sgl_para.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_MODULE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_module INPUT.

  PERFORM clear_all
              USING
                 'XXX##'
              CHANGING
                 gi_pic
                 gi_pic_cctrl
                 gi_txt
                 gi_txt_cctrl
                 gs_sgl_para.

  CASE sy-ucomm.
    WHEN '&F03'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN '&F15' OR '&F12'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_0100 OUTPUT.

  DATA:
        lv_subtype TYPE c LENGTH 1024.

*-- toggle display/change
  LOOP AT SCREEN.
    IF screen-name EQ 'GS_SGL_PARA-DESCR'.
      IF gv_0100_status EQ gc_status-display.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.
      MODIFY SCREEN..
    ENDIF.
  ENDLOOP.

*-- Display picture for preview
  IF gi_pic_cctrl IS INITIAL.
    CREATE OBJECT gi_pic_cctrl
      EXPORTING
*       parent                      =
        container_name              = 'GI_PIC_CCTRL'
*       style                       =
*       lifetime                    = lifetime_default
*       repid                       =
*       dynnr                       =
*       no_autodef_progid_dynnr     =
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      macro_msg.
      RETURN.
    ENDIF.
  ENDIF.

  IF gi_pic IS INITIAL.
    CREATE OBJECT gi_pic
      EXPORTING
*       lifetime =
*       shellstyle =
        parent = gi_pic_cctrl
*       name   =
      EXCEPTIONS
        error  = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
      macro_msg.
      RETURN.
    ENDIF.

    lv_subtype = gs_sgl_para-suffix. " jpg, bmp, tif, png...

    CLEAR gs_sgl_para-url.
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        type                 = 'IMAGE'
        subtype              = lv_subtype
*       SIZE                 =
*       DATE                 =
*       TIME                 =
*       DESCRIPTION          =
*       LIFETIME             =
*       CACHEABLE            =
*       SEND_DATA_AS_STRING  =
*       FIELDS_FROM_APP      =
      TABLES
        data                 = gs_sgl_para-pic_tab
*       FIELDS               =
*       PROPERTIES           =
*       COLUMNS_TO_STRETCH   =
      CHANGING
        url                  = gs_sgl_para-url
      EXCEPTIONS
        dp_invalid_parameter = 1
        dp_error_put_table   = 2
        dp_error_general     = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CALL METHOD gi_pic->load_picture_from_url
      EXPORTING
        url    = gs_sgl_para-url
*  IMPORTING
*       result =
      EXCEPTIONS
        error  = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL METHOD gi_pic->set_display_mode
      EXPORTING
        display_mode = gs_sgl_para-rt_disp_mode.
  ENDIF.

*-- Display OCR text
  IF gi_txt_cctrl IS INITIAL.
    CREATE OBJECT gi_txt_cctrl
      EXPORTING
        container_name              = 'GI_TXT_CCTRL'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      macro_msg.
      RETURN.
    ENDIF.
  ENDIF.

  IF gi_txt IS INITIAL.
    CREATE OBJECT gi_txt
      EXPORTING
        parent                 = gi_txt_cctrl
      EXCEPTIONS
        error_cntl_create      = 1
        error_cntl_init        = 2
        error_cntl_link        = 3
        error_dp_create        = 4
        gui_type_not_supported = 5
        OTHERS                 = 6.
    IF sy-subrc <> 0.
      macro_msg.
      RETURN.
    ENDIF.

    IF gs_sgl_para-txt_tab IS NOT INITIAL.
*-- display the ocr result text on text container
      CALL METHOD gi_txt->set_text_as_r3table
        EXPORTING
          table           = gs_sgl_para-txt_tab " Internal Table
        EXCEPTIONS
          error_dp        = 1
          error_dp_create = 2
          OTHERS          = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.

*--- read only
    CALL METHOD gi_txt->set_readonly_mode
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      macro_msg.
      RETURN.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS '0101'.
  SET TITLEBAR '0101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  IF gv_okcode EQ 'OK'.
    CALL METHOD gi_pic->set_display_mode
      EXPORTING
        display_mode = gs_sgl_para-rt_disp_mode.
  ENDIF.

  IF gv_okcode EQ 'OK' OR gv_okcode EQ 'CANC'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_0101 OUTPUT.

  PERFORM init_disp_mode_listbox
              USING
                 'GS_SGL_PARA-RT_DISP_MODE'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0102  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0102 OUTPUT.
  SET PF-STATUS '0102'.
  SET TITLEBAR '0102'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0102 INPUT.

  DATA lb_error TYPE xfeld.

*-- validate the IE browser path and temp folder path
  PERFORM validate_usr_config
              USING
                 gs_ztocr01
              CHANGING
                 lb_error.

  CHECK lb_error NE abap_true.

  IF gv_okcode EQ 'OK'.

    PERFORM save_usr_config_2_db
                CHANGING
                   gs_ztocr01_db
                   gs_ztocr01
                   lv_action.
    CASE lv_action.
      WHEN ''.
* 006	No configuration changed
        MESSAGE s006.
      WHEN gc_action-ins.
* 004 User configuration has been added
        MESSAGE s004.
      WHEN gc_action-upd.
* 005 User configuration has been changed
        MESSAGE s005.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

  IF gv_okcode EQ 'OK' OR gv_okcode EQ 'CANC'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_0102  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_0102 OUTPUT.

  IF gs_ztocr01_db-rfcdest IS INITIAL.
    gs_ztocr01-rfcdest = gc_rfc_dest.
  ENDIF.

  IF gs_ztocr01_db-tmpph IS INITIAL.
    gs_ztocr01-tmpph   = TEXT-tmp. " C:\Windows\Temp\
  ENDIF.

  IF gs_ztocr01_db-iepth IS INITIAL.
    gs_ztocr01-iepth   = TEXT-iep. " C:\Program Files\Internet Explorer\iexplore.exe
  ENDIF.

  PERFORM init_disp_mode_listbox
              USING
                 'GS_ZTOCR01-DISPM'.

ENDMODULE.
