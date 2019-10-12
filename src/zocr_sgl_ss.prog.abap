*&---------------------------------------------------------------------*
*& Include          ZOCR_SGL_SS
*&---------------------------------------------------------------------*

*-- buttons
SELECTION-SCREEN FUNCTION KEY 1. " Upload New Picture
SELECTION-SCREEN FUNCTION KEY 2. " Import Pic Folder
SELECTION-SCREEN FUNCTION KEY 3. " Import from SAP DMS
SELECTION-SCREEN FUNCTION KEY 4. " User Configuration

*-- pic selection
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-t01." Selection
SELECT-OPTIONS: s_picnm FOR gs_sel-picnm,
                s_temnl FOR gs_sel-temnl,
                s_uplip FOR gs_sel-uplip,
                s_crdat FOR gs_sel-crdat,
                s_crnam FOR gs_sel-crnam,
                s_chdat FOR gs_sel-chdat,
                s_chnam FOR gs_sel-chnam.
SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS: s_md5   FOR gs_sel-guid_md5.
SELECTION-SCREEN END OF BLOCK b01.

*-- layout
SELECTION-SCREEN BEGIN OF BLOCK layout WITH FRAME TITLE text-t02." Layout
PARAMETERS: p_dvari TYPE slis_vari.
SELECTION-SCREEN END OF BLOCK layout.

*-- note
SELECTION-SCREEN BEGIN OF BLOCK note WITH FRAME TITLE text-t03." Note
SELECTION-SCREEN COMMENT /1(79) text-n01.
SELECTION-SCREEN COMMENT /1(79) text-n02.
SELECTION-SCREEN COMMENT /1(79) text-n03.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN COMMENT /1(79) text-n04.
SELECTION-SCREEN END OF BLOCK note.
