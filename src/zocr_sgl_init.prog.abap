*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_INIT
*&---------------------------------------------------------------------*


INITIALIZATION.

*-- function keys
  PERFORM set_buttons_on_selscreen.

*-- owner
  s_crnam[] = VALUE #( ( sign   = 'I'
                         option = 'EQ'
                         low    = sy-uname ) ).

*-- alv layout
  PERFORM alv_variant_default_get
              USING
                 sy-repid
                 space
              CHANGING
                 p_dvari
                 gs_variant.

*-- get user config data from db
  PERFORM get_usr_config
              CHANGING
                 gs_ztocr01
                 gs_ztocr01_db.

*-- if first time
  IF gs_ztocr01_db IS INITIAL.
    CALL SCREEN 0102 STARTING AT 3  3
                       ENDING AT 77 12.
  ELSE.
    DATA(lv_uplip)   = gs_ztocr01-uplip.
    gs_ztocr01       = gs_ztocr01_db.
    gs_ztocr01-uplip = lv_uplip.
  ENDIF.

*-- sync user configuration to runtime
  IF gs_sgl_para-01 NE gs_ztocr01_db-01.
    MOVE-CORRESPONDING gs_ztocr01_db TO gs_sgl_para.
    gs_sgl_para-rt_disp_mode = gs_ztocr01_db-dispm.
    gs_sgl_para-rt_rfc_dest  = gs_ztocr01_db-rfcdest.
  ENDIF.
