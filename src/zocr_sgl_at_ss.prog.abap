*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_AT_SS
*&---------------------------------------------------------------------*


*-- AT SS
AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
*-- Upload New Picture
    WHEN 'FC01'.
      PERFORM upl_new_pic
                  USING
                     abap_true.
*-- Import Pic Folder
    WHEN 'FC02'.
      PERFORM import_pic_folder.

*-- Import from SAP DMS
    WHEN 'FC03'.
      MESSAGE 'Not ready yet' TYPE 'I'.

*-- User Configuration
    WHEN 'FC04'.
      CALL SCREEN 0102 STARTING AT 3   3
                         ENDING AT 77  12.
    WHEN OTHERS.
  ENDCASE.

*-- AT SS OUTPUT
AT SELECTION-SCREEN OUTPUT.
*-- for temporarily user management, user can only see the pics which created by themselves
*-- later will define different user groups, superusers see all pics
  LOOP AT SCREEN.
    IF screen-name EQ 'S_CRNAM-LOW' OR
       screen-name EQ 'S_CRNAM-HIGH'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*-- AT SS ON field
AT SELECTION-SCREEN ON p_dvari.
  IF p_dvari IS NOT INITIAL.
    PERFORM test_and_assign_layout
                CHANGING
                   p_dvari
                   gs_variant.
  ENDIF.

*-- AT SS value request
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dvari.
* -- F4 help for display variant
  PERFORM alv_variant_f4
              CHANGING
                 p_dvari
                 gs_variant.
