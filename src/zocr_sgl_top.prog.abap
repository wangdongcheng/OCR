*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_TOP
*&---------------------------------------------------------------------*


TYPES BEGIN OF gts_sgl_para.
INCLUDE TYPE ztocr           AS ztocr.
*INCLUDE STRUCTURE zsocr01_pk AS pk.
INCLUDE STRUCTURE zsocr01    AS 01.
TYPES:
  fullpath     TYPE string, " C:\Users\wangd\Desktop\7.png
  path         TYPE string, " C:\Users\wangd\Desktop\
*  fullname     TYPE string, " 7.png, replaced by ztocr-picnm
  filename     TYPE string, " 7
  suffix       TYPE string, " png
  rt_disp_mode TYPE i, " runtime display mode
  rt_rfc_dest  TYPE rfcdest,
  pic_tab      TYPE zsocr_pic_data_t, " Date type = RAW -> ABAP Type = X
  url          TYPE c LENGTH 256,
  txt_tab      TYPE soli_tab.
TYPES END OF gts_sgl_para.


TYPES:
  gtt_sgl_para TYPE STANDARD TABLE OF gts_sgl_para,

  BEGIN OF gts_crit,
    picnm    TYPE RANGE OF text100,
    temnl    TYPE RANGE OF xuterminal,
    uplip    TYPE RANGE OF ztocr-uplip,
    crdat    TYPE RANGE OF ersda,
    crnam    TYPE RANGE OF ernam,
    chdat    TYPE RANGE OF laeda,
    chnam    TYPE RANGE OF ernam,
    guid_md5 TYPE RANGE OF hash160,
  END OF gts_crit.


TABLES:
  sscrfields.


DATA:
  gs_variant     TYPE disvariant,
  gs_sel         TYPE gts_sgl_para,
  gs_sgl_para    TYPE gts_sgl_para,
  gt_sgl_para    TYPE gtt_sgl_para,
  gs_ztocr01     TYPE ztocr01, " user specific configuration
  gs_ztocr01_db  TYPE ztocr01, " user specific configuration in DB
  gs_ztocr       TYPE ztocr,
  gs_ztocr_db    TYPE ztocr,
  gs_crit        TYPE gts_crit,
  gt_zsocr_wklst TYPE zsocr_wklst_t.

*-- dynpro fields
DATA:
  gi_txt_cctrl   TYPE REF TO cl_gui_custom_container,
  gi_txt         TYPE REF TO cl_gui_textedit,
  gi_pic_cctrl   TYPE REF TO cl_gui_custom_container,
  gi_pic         TYPE REF TO cl_gui_picture,
  gv_0100_status TYPE c,
  gv_okcode      TYPE sy-ucomm.


CONSTANTS:
  BEGIN OF gc_status,
    display TYPE c VALUE 'V',
    change  TYPE c VALUE 'A',
  END OF gc_status,

  BEGIN OF gc_action,
    ins TYPE c VALUE 'I',
    upd TYPE c VALUE 'U',
    del TYPE c VALUE 'D',
  END OF gc_action,

  BEGIN OF gc_filter,
    all        TYPE text100 VALUE 'All_Pic_File_(*.jpg;*.jpeg;*.jpe;*.jfif;*.png;*.tif;*.tiff;*.bmp;*.dib)|',
    all_suffix TYPE text100 VALUE '*.jpg;*.jpeg;*.jpe;*.jfif;*.png;*.tif;*.tiff;*.bmp;*.dib|',
    jpg        TYPE text100 VALUE 'JPEG_(*.jpg;*.jpeg;*.jpe;*.jfif)|*.jpg;*.jpeg;*.jpe;*.jfif|',
    png        TYPE text100 VALUE 'PNG_(*.png)|*.png|',
    tif        TYPE text100 VALUE 'TIFF_(*.tif;*.tiff)|*.tif;*.tiff|',
    bmp        TYPE text100 VALUE 'BMP_(*.bmp;*.dib)|*.bmp;*.dib|',
  END OF gc_filter,

  gc_dot       TYPE c VALUE '.',
  gc_backslash TYPE c VALUE '\',
  gc_dash      TYPE c VALUE '-',
  gc_rfc_dest  TYPE rfcdest VALUE 'OCR'.


DEFINE macro_s_message.                                     "#EC NEEDED
*----  Meldung
  MESSAGE ID      syst-msgid
          TYPE    'S'
          NUMBER  syst-msgno
          WITH    syst-msgv1
                  syst-msgv2
                  syst-msgv3
                  syst-msgv4.
END-OF-DEFINITION.

DEFINE macro_msg.
  MESSAGE ID     sy-msgid
          TYPE   sy-msgty
          NUMBER sy-msgno
          WITH   sy-msgv1
                 sy-msgv2
                 sy-msgv3
                 sy-msgv4.
END-OF-DEFINITION.
