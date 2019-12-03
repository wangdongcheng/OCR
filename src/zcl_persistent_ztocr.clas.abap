class ZCL_PERSISTENT_ZTOCR definition
  public
  final
  create protected

  global friends ZCB_PERSISTENT_ZTOCR .

public section.

  interfaces IF_OS_STATE .

  methods SET_UPLIP
    importing
      !I_UPLIP type ZOCR_UPLIP
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_TXT_STR
    importing
      !I_TXT_STR type BCS_CONTENTS_BIN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_TEMNL
    importing
      !I_TEMNL type XUTERMINAL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_PSIZE
    importing
      !I_PSIZE type ZOCR_PSIZE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_PIC_STR
    importing
      !I_PIC_STR type BCS_CONTENTS_BIN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_PICNM
    importing
      !I_PICNM type TEXT100
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_DESCR
    importing
      !I_DESCR type TEXT100
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CRTIM
    importing
      !I_CRTIM type UZEIT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CRNAM
    importing
      !I_CRNAM type ERNAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CRDAT
    importing
      !I_CRDAT type ERSDA
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CHTIM
    importing
      !I_CHTIM type UZEIT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CHNAM
    importing
      !I_CHNAM type AENAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CHDAT
    importing
      !I_CHDAT type LAEDA
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_UPLIP
    returning
      value(RESULT) type ZOCR_UPLIP
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_TXT_STR
    returning
      value(RESULT) type BCS_CONTENTS_BIN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_TEMNL
    returning
      value(RESULT) type XUTERMINAL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PSIZE
    returning
      value(RESULT) type ZOCR_PSIZE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PIC_STR
    returning
      value(RESULT) type BCS_CONTENTS_BIN
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_PICNM
    returning
      value(RESULT) type TEXT100
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_GUID_MD5
    returning
      value(RESULT) type HASH160
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_DESCR
    returning
      value(RESULT) type TEXT100
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CRTIM
    returning
      value(RESULT) type UZEIT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CRNAM
    returning
      value(RESULT) type ERNAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CRDAT
    returning
      value(RESULT) type ERSDA
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CHTIM
    returning
      value(RESULT) type UZEIT
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CHNAM
    returning
      value(RESULT) type AENAM
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CHDAT
    returning
      value(RESULT) type LAEDA
    raising
      CX_OS_OBJECT_NOT_FOUND .
protected section.

  data GUID_MD5 type HASH160 .
  data PICNM type TEXT100 .
  data DESCR type TEXT100 .
  data TEMNL type XUTERMINAL .
  data UPLIP type ZOCR_UPLIP .
  data CRDAT type ERSDA .
  data CRTIM type UZEIT .
  data CRNAM type ERNAM .
  data CHDAT type LAEDA .
  data CHTIM type UZEIT .
  data CHNAM type AENAM .
  data PSIZE type ZOCR_PSIZE .
  data PIC_STR type BCS_CONTENTS_BIN .
  data TXT_STR type BCS_CONTENTS_BIN .
private section.
ENDCLASS.



CLASS ZCL_PERSISTENT_ZTOCR IMPLEMENTATION.


  method GET_CHDAT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CHDAT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CHDAT.

           " GET_CHDAT
  endmethod.


  method GET_CHNAM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CHNAM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CHNAM.

           " GET_CHNAM
  endmethod.


  method GET_CHTIM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CHTIM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CHTIM.

           " GET_CHTIM
  endmethod.


  method GET_CRDAT.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CRDAT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CRDAT.

           " GET_CRDAT
  endmethod.


  method GET_CRNAM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CRNAM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CRNAM.

           " GET_CRNAM
  endmethod.


  method GET_CRTIM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CRTIM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CRTIM.

           " GET_CRTIM
  endmethod.


  method GET_DESCR.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute DESCR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = DESCR.

           " GET_DESCR
  endmethod.


  method GET_GUID_MD5.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute GUID_MD5
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = GUID_MD5.

           " GET_GUID_MD5
  endmethod.


  method GET_PICNM.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute PICNM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = PICNM.

           " GET_PICNM
  endmethod.


  method GET_PIC_STR.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute PIC_STR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = PIC_STR.

           " GET_PIC_STR
  endmethod.


  method GET_PSIZE.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute PSIZE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = PSIZE.

           " GET_PSIZE
  endmethod.


  method GET_TEMNL.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute TEMNL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = TEMNL.

           " GET_TEMNL
  endmethod.


  method GET_TXT_STR.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute TXT_STR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = TXT_STR.

           " GET_TXT_STR
  endmethod.


  method GET_UPLIP.
***BUILD 090501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute UPLIP
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = UPLIP.

           " GET_UPLIP
  endmethod.


  method IF_OS_STATE~GET.
***BUILD 090501
     " returning result type ref to object
************************************************************************
* Purpose        : Get state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  create object STATE_OBJECT.
  call method STATE_OBJECT->SET_STATE_FROM_OBJECT( ME ).
  result = STATE_OBJECT.

  endmethod.


  method IF_OS_STATE~HANDLE_EXCEPTION.
***BUILD 090501
     " importing I_EXCEPTION type ref to IF_OS_EXCEPTION_INFO optional
     " importing I_EX_OS type ref to CX_OS_OBJECT_NOT_FOUND optional
************************************************************************
* Purpose        : Handles exceptions during attribute access.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : If an exception is raised during attribut access,
*                  this method is called and the exception is passed
*                  as a paramater. The default is to raise the exception
*                  again, so that the caller can handle the exception.
*                  But it is also possible to handle the exception
*                  here in the callee.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************
* Modify if you like
************************************************************************

  if i_ex_os is not initial.
    raise exception i_ex_os.
  endif.

  endmethod.


  method IF_OS_STATE~INIT.
***BUILD 090501
"#EC NEEDED
************************************************************************
* Purpose        : Initialisation of the transient state partition.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Transient state is initial.
*
* OO Exceptions  : -
*
* Implementation : Caution!: Avoid Throwing ACCESS Events.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

  endmethod.


  method IF_OS_STATE~INVALIDATE.
***BUILD 090501
"#EC NEEDED
************************************************************************
* Purpose        : Do something before all persistent attributes are
*                  cleared.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : Whatever you like to do.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

  endmethod.


  method IF_OS_STATE~SET.
***BUILD 090501
     " importing I_STATE type ref to object
************************************************************************
* Purpose        : Set state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  STATE_OBJECT ?= I_STATE.
  call method STATE_OBJECT->SET_OBJECT_FROM_STATE( ME ).

  endmethod.


  method SET_CHDAT.
***BUILD 090501
     " importing I_CHDAT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CHDAT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CHDAT <> CHDAT ).

    CHDAT = I_CHDAT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CHDAT <> CHDAT )

           " GET_CHDAT
  endmethod.


  method SET_CHNAM.
***BUILD 090501
     " importing I_CHNAM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CHNAM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CHNAM <> CHNAM ).

    CHNAM = I_CHNAM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CHNAM <> CHNAM )

           " GET_CHNAM
  endmethod.


  method SET_CHTIM.
***BUILD 090501
     " importing I_CHTIM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CHTIM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CHTIM <> CHTIM ).

    CHTIM = I_CHTIM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CHTIM <> CHTIM )

           " GET_CHTIM
  endmethod.


  method SET_CRDAT.
***BUILD 090501
     " importing I_CRDAT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CRDAT
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CRDAT <> CRDAT ).

    CRDAT = I_CRDAT.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CRDAT <> CRDAT )

           " GET_CRDAT
  endmethod.


  method SET_CRNAM.
***BUILD 090501
     " importing I_CRNAM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CRNAM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CRNAM <> CRNAM ).

    CRNAM = I_CRNAM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CRNAM <> CRNAM )

           " GET_CRNAM
  endmethod.


  method SET_CRTIM.
***BUILD 090501
     " importing I_CRTIM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CRTIM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CRTIM <> CRTIM ).

    CRTIM = I_CRTIM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CRTIM <> CRTIM )

           " GET_CRTIM
  endmethod.


  method SET_DESCR.
***BUILD 090501
     " importing I_DESCR
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute DESCR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_DESCR <> DESCR ).

    DESCR = I_DESCR.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_DESCR <> DESCR )

           " GET_DESCR
  endmethod.


  method SET_PICNM.
***BUILD 090501
     " importing I_PICNM
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute PICNM
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_PICNM <> PICNM ).

    PICNM = I_PICNM.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_PICNM <> PICNM )

           " GET_PICNM
  endmethod.


  method SET_PIC_STR.
***BUILD 090501
     " importing I_PIC_STR
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute PIC_STR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_PIC_STR <> PIC_STR ).

    PIC_STR = I_PIC_STR.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_PIC_STR <> PIC_STR )

           " GET_PIC_STR
  endmethod.


  method SET_PSIZE.
***BUILD 090501
     " importing I_PSIZE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute PSIZE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_PSIZE <> PSIZE ).

    PSIZE = I_PSIZE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_PSIZE <> PSIZE )

           " GET_PSIZE
  endmethod.


  method SET_TEMNL.
***BUILD 090501
     " importing I_TEMNL
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute TEMNL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_TEMNL <> TEMNL ).

    TEMNL = I_TEMNL.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_TEMNL <> TEMNL )

           " GET_TEMNL
  endmethod.


  method SET_TXT_STR.
***BUILD 090501
     " importing I_TXT_STR
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute TXT_STR
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_TXT_STR <> TXT_STR ).

    TXT_STR = I_TXT_STR.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_TXT_STR <> TXT_STR )

           " GET_TXT_STR
  endmethod.


  method SET_UPLIP.
***BUILD 090501
     " importing I_UPLIP
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute UPLIP
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_UPLIP <> UPLIP ).

    UPLIP = I_UPLIP.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_UPLIP <> UPLIP )

           " GET_UPLIP
  endmethod.
ENDCLASS.
