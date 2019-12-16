*----------------------------------------------------------------------*
***INCLUDE LZOCR_DBCLS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_unit_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_unit_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>zocr_Cl_Db_Test
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZOCR_CL_DB
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    METHODS:
      ut_001 FOR TESTING,
      ut_002 FOR TESTING,
      ut_003 FOR TESTING.
ENDCLASS.

CLASS lcl_unit_test IMPLEMENTATION.
  METHOD ut_001.
    cl_demo_output=>write( |UT 01| ).

  ENDMETHOD.

  METHOD ut_002.
    cl_demo_output=>write( |UT 02| ).
  ENDMETHOD.

  METHOD ut_003.
    cl_demo_output=>write( |UT 03| ).
    cl_demo_output=>display( ).
  ENDMETHOD.
ENDCLASS.
