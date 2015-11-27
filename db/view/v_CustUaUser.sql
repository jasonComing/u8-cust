create view v_CustUaUser
as
select cUser_Id, cUser_Name, cPassword, iAdmin, cDept, cBelongGrp, nState, cUserEmail, cUserHand, SaveMailCount, SaveSMSCount, localeid, iErrorCount, dPasswordDate, cSysUserName, cSysUserPassword, bLogined, authenMode, bRefuseModifyLoginDate, iUserType, bAutoCloseException, bDuaLoginException, dCrDate, bModifyPWFirstLogin, bAllinOneUser, bIMUser, bCCUser
from ufsystem..UA_User