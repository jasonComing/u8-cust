[1mdiff --git a/db/sp/SP_AutoFillPodata.sql b/db/sp/SP_AutoFillPodata.sql[m
[1mnew file mode 100644[m
[1mindex 0000000..60538aa[m
[1m--- /dev/null[m
[1m+++ b/db/sp/SP_AutoFillPodata.sql[m
[36m@@ -0,0 +1,145 @@[m
[32m+[m[32malter proc SP_AutoFillPodata[m
[32m+[m[32m/*[m
[32m+[m[32m功能：采购员批理生单时，自动补上表头相关必填项，[m
[32m+[m		[32m（部门、业务员、付款条件、质量等级-A，建档作废标记－否）[m
[32m+[m		[32m表身补士啤行、赠品－否，不参加MRP运算[m
[32m+[m
[32m+[m[32m调用：在采购入单保存新增时，自动触发执行[m
[32m+[m		[32mexec SP_AutoFillPodata  1000021343[m
[32m+[m[32m作者：jams[m
[32m+[m[32m*/[m
[32m+[m[32m@poid bigint= 0 --採購單POID[m
[32m+[m[32mas[m
[32m+[m[32mbegin[m
[32m+[m	[32mset nocount on[m
[32m+[m
[32m+[m	[32mdeclare @PoNO  varchar(30)			--采购订单号[m
[32m+[m
[32m+[m	[32mdeclare @rowcount int				--表体需要加载士啤的行数[m
[32m+[m	[32mdeclare @MaxRowNum int				--表体最大行号[m
[32m+[m
[32m+[m	[32mif not exists(select * from PO_Pomain where POID =@poid )[m
[32m+[m		[32mreturn[m
[32m+[m
[32m+[m	[32m--取出cpoid[m
[32m+[m	[32mselect  top 1 @PoNO=cPOID  from  PO_Pomain  where POID =@poid[m
[32m+[m
[32m+[m	[32m--变更表头信息[m
[32m+[m	[32mupdate PO_POMain[m
[32m+[m	[32mset cPTCode = isnull(cPTCode, '01'),[m
[32m+[m		[32mcdefine1 = isnull(cdefine1, 'A'),[m
[32m+[m		[32mcPayCode = isnull(cPayCode, '01')[m
[32m+[m	[32mwhere POID =@poid[m
[32m+[m
[32m+[m	[32mupdate PO_PoMain[m
[32m+[m	[32mset cDepCode = isnull(PO_PoMain.cDepCode, Department.cDepCode),[m
[32m+[m		[32mcPersonCode = isnull(PO_PoMain.cPersonCode, Person.cPersonCode)[m
[32m+[m	[32mfrom PO_PoMain[m
[32m+[m	[32mjoin Person on Person.cPersonName = PO_PoMain.cMaker[m
[32m+[m	[32mleft join Department on Department.cDepCode = Person.cDepCode[m
[32m+[m	[32mwhere PO_PoMain.POID = @poid[m
[32m+[m
[32m+[m	[32m--表头扩展项[m
[32m+[m	[32mupdate PO_POMain_ExtraDefine[m
[32m+[m	[32mset chdefine19 = '否'[m
[32m+[m	[32mfrom PO_POMain_ExtraDefine[m
[32m+[m	[32mwhere chdefine19 is null[m
[32m+[m	[32mand POID=@poid[m
[32m+[m
[32m+[m
[32m+[m	[32m--====以下为表体更新　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝[m
[32m+[m	[32m--更新单价/金额[m
[32m+[m	[32mupdate pp[m
[32m+[m	[32mset iUnitPrice =vv.MinPrice,[m
[32m+[m		[32m iMoney= vv.MinPrice * pp.iQuantity[m
[32m+[m	[32mfrom  PO_Podetails  pp[m
[32m+[m	[32mjoin V_InvCodePriceList  vv on pp.cInvCode=vv.cInvCode[m
[32m+[m	[32mwhere poid=@poid[m
[32m+[m	[32m--and pp.iUnitPrice <>0[m
[32m+[m	[32mand bgift=0[m
[32m+[m
[32m+[m	[32m--取出表体需要加载士啤的行数[m
[32m+[m	[32mselect @rowcount =count(*) from PO_Podetails[m
[32m+[m	[32mwhere poid=@poid[m
[32m+[m	[32mand bgift=0[m
[32m+[m
[32m+[m	[32mselect @MaxRowNum =max(ivouchrowno) from PO_Podetails where poid=@poid[m
[32m+[m
[32m+[m	[32mif(@rowcount = 0 or @MaxRowNum =0)[m
[32m+[m		[32mreturn[m
[32m+[m
[32m+[m	[32m--取出等待要插入的表体ID号[m
[32m+[m	[32mdeclare @ifatherID int[m
[32m+[m	[32mdeclare @iChildID int[m
[32m+[m	[32mexec sp_getID N'00',N'001',N'Pomain',@rowcount,@ifatherID output,@iChildID output[m
[32m+[m
[32m+[m	[32mdeclare @bodyID bigint[m
[32m+[m	[32mdeclare @invCode varchar(30)[m
[32m+[m	[32mdeclare @iQuantity int[m
[32m+[m	[32mdeclare @iRate  float[m
[32m+[m	[32mdeclare @irowx int[m
[32m+[m
[32m+[m	[32mset @irowx=1[m
[32m+[m
[32m+[m	[32mdeclare my_cursor cursor for[m
[32m+[m			[32mselect PO_Podetails.ID,PO_Podetails.cInvCode,PO_Podetails.iQuantity,isnull(Inventory.cInvDefine13,0.0) as iRate from PO_Podetails[m
[32m+[m			[32mleft join Inventory  on PO_Podetails.cinvCode=Inventory.cinvCode[m
[32m+[m			[32mwhere poid=@poid[m
[32m+[m			[32mand bgift=0[m
[32m+[m			[32morder by PO_Podetails.ivouchrowno[m
[32m+[m
[32m+[m	[32mopen my_cursor[m
[32m+[m	[32mfetch next from my_cursor into @bodyID, @invCode,@iQuantity,@iRate[m
[32m+[m
[32m+[m	[32mwhile @@FETCH_STATUS = 0[m
[32m+[m	[32mbegin[m
[32m+[m			[32mInsert Into PO_PODetails(id,cpoid,cinvcode,iquantity,inum,iquotedprice,iunitprice,imoney,itax,isum,idiscount,inatunitprice,[m
[32m+[m				[32minatmoney,inattax,inatsum,inatdiscount,darrivedate,cfree1,cfree2,ipertaxrate,cdefine22,cdefine23,[m
[32m+[m				[32mcdefine24,cdefine25,cdefine26,cdefine27,iflag,citemcode,citem_class,ppcids,citemname,cfree3,cfree4,cfree5,[m
[32m+[m				[32mcfree6,cfree7,cfree8,cfree9,cfree10,bgsp,poid,cunitid,itaxprice,iappids,cdefine28,cdefine29,cdefine30,[m
[32m+[m				[32mcdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,isosid,btaxcost,csource,cbcloser,ippartid,[m
[32m+[m				[32mipquantity,iptoseq,sotype,sodid,contractrowguid,cupsocode,iinvmpcost,contractcode,contractrowno,fporefusequantity,[m
[32m+[m				[32mfporefusenum,iorderdid,iordertype,csoordercode,iorderseq,cbclosetime,cbclosedate,cbg_itemcode,cbg_itemname,[m
[32m+[m				[32mcbg_caliberkey1,cbg_caliberkeyname1,cbg_caliberkey2,cbg_caliberkeyname2,cbg_caliberkey3,cbg_caliberkeyname3,[m
[32m+[m				[32mcbg_calibercode1,cbg_calibername1,cbg_calibercode2,cbg_calibername2,cbg_calibercode3,cbg_calibername3,ibg_ctrl,[m
[32m+[m				[32mcbg_auditopinion,fexquantity,fexnum,ivouchrowno,cbg_caliberkey4,cbg_caliberkeyname4,cbg_caliberkey5,cbg_caliberkeyname5,[m
[32m+[m				[32mcbg_caliberkey6,cbg_caliberkeyname6,cbg_calibercode4,cbg_calibername4,cbg_calibercode5,cbg_calibername5,[m
[32m+[m				[32mcbg_calibercode6,cbg_calibername6,csocode,irowno,cxjspdids,cbmemo,planlotnumber,bgift,cbsysbarcode)[m
[32m+[m
[32m+[m			[32mselect @iChildID - @rowcount + @irowx,cpoid,cinvcode,@iQuantity * @iRate ,0,iquotedprice,0,0,itax,0,idiscount,0,[m
[32m+[m				[32m0,0,0,inatdiscount,darrivedate,cfree1,cfree2,ipertaxrate,cdefine22,cdefine23,[m
[32m+[m				[32mcdefine24,cdefine25,cdefine26,cdefine27,iflag,citemcode,citem_class,ppcids,citemname,cfree3,cfree4,cfree5,[m
[32m+[m				[32mcfree6,cfree7,cfree8,cfree9,cfree10,bgsp,poid,cunitid,0,iappids,cdefine28,cdefine29,'false',[m
[32m+[m				[32mcdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,isosid,btaxcost,csource,cbcloser,ippartid,[m
[32m+[m				[32mipquantity,iptoseq,sotype,sodid,contractrowguid,cupsocode,iinvmpcost,contractcode,contractrowno,fporefusequantity,[m
[32m+[m				[32mfporefusenum,iorderdid,iordertype,csoordercode,iorderseq,cbclosetime,cbclosedate,cbg_itemcode,cbg_itemname,[m
[32m+[m				[32mcbg_caliberkey1,cbg_caliberkeyname1,cbg_caliberkey2,cbg_caliberkeyname2,cbg_caliberkey3,cbg_caliberkeyname3,[m
[32m+[m				[32mcbg_calibercode1,cbg_calibername1,cbg_calibercode2,cbg_calibername2,cbg_calibercode3,cbg_calibername3,ibg_ctrl,[m
[32m+[m				[32mcbg_auditopinion,fexquantity,fexnum, @MaxRowNum+@irowx ,cbg_caliberkey4,cbg_caliberkeyname4,cbg_caliberkey5,cbg_caliberkeyname5,[m
[32m+[m				[32mcbg_caliberkey6,cbg_caliberkeyname6,cbg_calibercode4,cbg_calibername4,cbg_calibercode5,cbg_calibername5,[m
[32m+[m				[32mcbg_calibercode6,cbg_calibername6,csocode,irowno,cxjspdids,cbmemo,planlotnumber,1,'||pupo|'+@PoNO+'|'+ cast( @MaxRowNum+@irowx as varchar)[m
[32m+[m			[32mfrom 	PO_PODetails where id=@bodyID[m
[32m+[m
[32m+[m
[32m+[m		[32m-- 插入扩展表[m
[32m+[m		[32m Insert Into PO_PODetails_ExtraDefine(id,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,[m
[32m+[m			[32m  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,[m
[32m+[m			[32m  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39)[m
[32m+[m
[32m+[m	[32m　	 select @iChildID - @rowcount + @irowx ,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,[m
[32m+[m			[32m  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,[m
[32m+[m			[32m  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39[m
[32m+[m		[32m from PO_PODetails_ExtraDefine[m
[32m+[m		[32m where id=@bodyID[m
[32m+[m
[32m+[m		[32mset @irowx=@irowx+1[m
[32m+[m
[32m+[m		[32mfetch next from my_cursor into @bodyID, @invCode,@iQuantity,@iRate[m
[32m+[m
[32m+[m	[32mend[m
[32m+[m
[32m+[m	[32mclose my_cursor[m
[32m+[m	[32mdeallocate my_cursor[m
[32m+[m
[32m+[m	[32mset nocount off[m
[32m+[m[32mend[m
[1mdiff --git a/db/trigger/tri_AutoFillPodata.sql b/db/trigger/tri_AutoFillPodata.sql[m
[1mnew file mode 100644[m
[1mindex 0000000..2fdb724[m
[1m--- /dev/null[m
[1m+++ b/db/trigger/tri_AutoFillPodata.sql[m
[36m@@ -0,0 +1,38 @@[m
[32m+[m[32mcreate trigger tri_AutoFillPodata[m
[32m+[m[32m/*[m
[32m+[m[32m功能：采购员批理生单时，自动补上表头相关必填项，[m
[32m+[m		[32m（部门、业务员、付款条件、质量等级-A，建档作废标记－否）[m
[32m+[m		[32m表身补士啤行、赠品－否，不参加MRP运算[m
[32m+[m[32m作者：Jams[m
[32m+[m[32m*/[m
[32m+[m[32mon po_pomain[m
[32m+[m[32m   after update[m
[32m+[m[32mas[m
[32m+[m[32mbegin[m
[32m+[m	[32mset nocount on[m
[32m+[m
[32m+[m	[32mdeclare @poid bigint[m
[32m+[m
[32m+[m	[32mif UPDATE (csysbarcode)[m
[32m+[m[32m        and not exists (SELECT 1 from Deleted where csysbarcode is not null)[m
[32m+[m[32m        and not exists (select 1 from Inserted where cPTCode is not null)[m
[32m+[m	[32mbegin[m
[32m+[m
[32m+[m		[32mdeclare mycursor cursor for[m
[32m+[m			[32mselect POID from inserted[m
[32m+[m
[32m+[m		[32mopen mycursor[m
[32m+[m		[32mfetch next from mycursor into @poid[m
[32m+[m
[32m+[m		[32mwhile @@FETCH_STATUS = 0[m
[32m+[m		[32mbegin[m
[32m+[m			[32mexec SP_AutoFillPodata  @poid[m
[32m+[m			[32mfetch next from mycursor into @poid[m
[32m+[m		[32mend[m
[32m+[m
[32m+[m		[32mclose mycursor[m
[32m+[m		[32mdeallocate mycursor[m
[32m+[m	[32mend[m
[32m+[m
[32m+[m	[32mset nocount off[m
[32m+[m[32mend[m
\ No newline at end of file[m
[1mdiff --git a/db/view/V_InvCodePriceList.sql b/db/view/V_InvCodePriceList.sql[m
[1mnew file mode 100644[m
[1mindex 0000000..a8814a1[m
[1m--- /dev/null[m
[1m+++ b/db/view/V_InvCodePriceList.sql[m
[36m@@ -0,0 +1,18 @@[m
[32m+[m[32mcreate view  V_InvCodePriceList[m
[32m+[m[32m/*[m
[32m+[m[32m功能：取料件最小单价[m
[32m+[m	[32m（在历史PO单价中与最高进价控制两者之间选取）[m
[32m+[m[32m*/[m
[32m+[m[32mas[m
[32m+[m	[32m  select tbtemp.cInvCode,min(tbtemp.MinPrice) as 'MinPrice'[m
[32m+[m	[32m  from (select Inventory.cInvCode,isnull(Inventory.iInvMPCost,0) as 'MinPrice'  from Inventory[m
[32m+[m				[32munion[m
[32m+[m				[32mselect PO_Podetails.cInvCode, PO_Podetails.iUnitPrice as 'MinPrice' from PO_Podetails[m
[32m+[m				[32mwhere  PO_Podetails.ID in ([m
[32m+[m								[32mselect MAX(po.id)[m
[32m+[m								[32mfrom PO_Podetails as po[m
[32m+[m								[32mwhere po.iUnitPrice != 0[m
[32m+[m								[32mgroup by po.cInvCode[m
[32m+[m								[32m)[m
[32m+[m			[32m  ) as tbtemp[m
[32m+[m	[32m  group by tbtemp.cInvCode[m
