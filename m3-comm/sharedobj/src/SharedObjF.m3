(*                            -*- Mode: Modula-3 -*- 
 * 
 * For information about this program, contact Blair MacIntyre            
 * (bm@cs.columbia.edu) or Steven Feiner (feiner@cs.columbia.edu)         
 * at the Computer Science Dept., Columbia University,                    
 * 1214 Amsterdam Ave. Mailstop 0401, New York, NY, 10027.                
 *                                                                        
 * Copyright (C) 1995, 1996 by The Trustees of Columbia University in the 
 * City of New York.  Blair MacIntyre, Computer Science Department.       
 * See file COPYRIGHT-COLUMBIA for details.
 * 
 * Author          : Blair MacIntyre
 * Created On      : Mon Apr  6 15:29:08 1998
 * Last Modified By: Blair MacIntyre
 * Last Modified On: Mon Apr  6 15:32:02 1998
 * Update Count    : 3
 * 
 * $Source: /opt/cvs/cm3/m3-comm/sharedobj/src/SharedObjF.m3,v $
 * $Date: 2001-12-02 13:41:17 $
 * $Author: wagner $
 * $Revision: 1.2 $
 * 
 * $Log: not supported by cvs2svn $
 * Revision 1.1.1.1  2001/12/02 13:14:14  wagner
 * Blair MacIntyre's sharedobj package
 *
 * Revision 1.1  1998/05/13 17:25:19  bm
 * new files
 *
 * 
 * HISTORY
 *)

MODULE SharedObjF;

IMPORT SharedObjRep, SharedObj, SharedObjRTF, ObjectInfo;

PROCEDURE GetObjWireRep(obj: SharedObj.T; VAR wrep: WireRep) =
  BEGIN
    wrep := obj.wrep;
  END GetObjWireRep;

PROCEDURE GetObjRef(wrep: WireRep): SharedObj.T =
  VAR objInfo: ObjectInfo.T;
  BEGIN
    IF SharedObjRTF.GetObjInfo(wrep, objInfo) THEN
      RETURN SharedObjRTF.GetObjRef(objInfo);
    ELSE
      RETURN NIL;
    END;
  END GetObjRef;

BEGIN
END SharedObjF.
