
CLASS zocr_cl_db_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
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
    DATA:
      f_cut TYPE REF TO zocr_cl_db.  "class under test

    METHODS: db_write FOR TESTING.
    METHODS: get_instance FOR TESTING.
    METHODS: ztocr_db_write FOR TESTING.
ENDCLASS.       "zocr_Cl_Db_Test


CLASS zocr_cl_db_test IMPLEMENTATION.

  METHOD db_write.



  ENDMETHOD.


  METHOD get_instance.



  ENDMETHOD.


  METHOD ztocr_db_write.



  ENDMETHOD.




ENDCLASS.
