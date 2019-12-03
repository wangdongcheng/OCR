class ZCA_PERSISTENT_ZTOCR definition
  public
  inheriting from ZCB_PERSISTENT_ZTOCR
  final
  create private .

public section.

  class-data AGENT type ref to ZCA_PERSISTENT_ZTOCR read-only .

  class-methods CLASS_CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCA_PERSISTENT_ZTOCR IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
***BUILD 090501
************************************************************************
* Purpose        : Initialize the 'class'.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Singleton is created.
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-20   : (OS) Initial Version
* - 2000-03-06   : (BGR) 2.0 modified REGISTER_CLASS_AGENT
************************************************************************
* GENERATED: Do not modify
************************************************************************

  create object AGENT.

  call method AGENT->REGISTER_CLASS_AGENT
    exporting
      I_CLASS_NAME          = 'ZCL_PERSISTENT_ZTOCR'
      I_CLASS_AGENT_NAME    = 'ZCA_PERSISTENT_ZTOCR'
      I_CLASS_GUID          = '080027918A241EDA85B68A13082F5A88'
      I_CLASS_AGENT_GUID    = '080027918A241EDA85B68A2B4AF39A88'
      I_AGENT               = AGENT
      I_STORAGE_LOCATION    = 'ZTOCR'
      I_CLASS_AGENT_VERSION = '2.0'.

           "CLASS_CONSTRUCTOR
  endmethod.
ENDCLASS.
