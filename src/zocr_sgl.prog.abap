*&---------------------------------------------------------------------*
*& Report ZOCR_SGL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOCR_SGL MESSAGE-ID zocr.

* Types, Global Variables and Constants
INCLUDE zocr_sgl_top.

* Subroutines
INCLUDE zocr_sgl_form.

* Selection Screen Elements
INCLUDE zocr_sgl_ss.

* Screen Flow Logic
INCLUDE zocr_sgl_mod.

* Initialization
INCLUDE zocr_sgl_init.

* Events At Selection Screen
INCLUDE zocr_sgl_at_ss.

* Main Program Logic
INCLUDE zocr_sgl_prog.
