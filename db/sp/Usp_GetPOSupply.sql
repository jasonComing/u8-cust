USE [UFDATA_004_2015]
GO

/****** Object:  StoredProcedure [dbo].[Usp_GetPOSupply]    Script Date: 2015-10-04 20:37:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Usp_GetPOSupply](@dbts binary(8),  
 @iError INT OUTPUT  
 )  
AS  
 DECLARE @QuanDecimal AS TINYINT  
 DECLARE @SqlStr NVARCHAR(4000)  
   
-- SET @QuanDecimal=(SELECT ISNULL(cValue,cDefault) FROM AccInformation WHERE cName=N'iStrsQuanDecDgt')  
   
 INSERT INTO mps_refonlinedata(DocType,BillType,BillId,BillCode,InvCode,Free1,Free2,Free3,Free4,  
   Free5,Free6,Free7,Free8,Free9,Free10,DemBillQty,DemQty,DemDate,DemSourceDId,SoCode,SoSeq,Status,AuditDate,BillSeq,FRefCode,FRefType)  
  SELECT 3,  
 isnull(Po_Podetails.SoType,0),Po_Podetails.ID,Po_Pomain.cPoId,Po_Podetails.cInvCode,  
 Po_Podetails.cFree1,Po_Podetails.cFree2,Po_Podetails.cFree3,Po_Podetails.cFree4,Po_Podetails.cFree5,Po_Podetails.cFree6,Po_Podetails.cFree7,  
 Po_Podetails.cFree8,Po_Podetails.cFree9,Po_Podetails.cFree10,isnull(Po_Podetails.iQuantity,0),ISNULL(Po_Podetails.iQuantity,0)-ISNULL(iReceivedQty,0)-ISNULL(iArrQty,0) AS iYLQuantity,dArriveDate,ISNULL(Po_Podetails.sodid,'') AS sodid,
 --(case when Po_Podetails.sotype=1 then so_sodetails.csocode else(case when Po_Podetails.sotype=3 then v_expo.ccode when Po_Podetails.sotype=4 then AA_RequirementClass.cRClassCode when Po_Podetails.sotype=5 then Po_Podetails.sodid when Po_Podetails.sotype=6 then Po_Podetails.sodid end) end) AS SoCode,    
 --(case when Po_Podetails.sotype=1 then so_sodetails.irowno else (case when Po_Podetails.sotype=3 then v_expo.irowno else 0 end) end) as SoSeq,  
 Po_Podetails.csocode as SoCode,Po_Podetails.irowno as SoSeq,
 case when ISNULL(po_podetails.cbcloser,'')>'' or isnull(t.bPTMPS_MRP,1) = 0 then 4 when ((isnull(Po_Pomain.cVerifier,N'')<>N'' and isnull(Po_Pomain.cChanger,N'')=N'')or isnull(Po_Pomain.cChangVerifier,N'')<>N'' ) then 3 when ISNULL(Po_Pomain.cLocker,'')>'' then 2 else 1 end  ,
Po_Pomain.cAuditDate,Po_Podetails.ivouchrowno,isnull(po_pomain.cptcode,'') as cptcode,2
   FROM Po_Pomain INNER JOIN Po_Podetails ON Po_Pomain.POID=Po_Podetails.POID  
   left outer join PurchaseType t on t.cPTCode = Po_Pomain.cPTCode
   --LEFT outer JOIN So_Sodetails ON Po_Podetails.sodid=cast(So_Sodetails.isosid as nvarchar(60)) and Po_Podetails.sotype =1    
   --LEFT outer JOIN v_mps_forecast ON Po_Podetails.sodid=cast(v_mps_forecast.ForecastDId as nvarchar(60)) and Po_Podetails.sotype =2    
   --LEFT outer JOIN v_ex_order_forPUReport AS v_expo ON Po_Podetails.sodid=cast(v_expo.autoid as nvarchar(60)) and Po_Podetails.sotype =3    
   --LEFT outer join AA_RequirementClass on AA_RequirementClass.cRClassCode=Po_Podetails.sodid  and Po_Podetails.sotype =4  
   --LEFT outer join so_somain on so_somain.csocode=Po_Podetails.sodid and  Po_Podetails.sotype =5  
   --LEFT outer join ex_order on ex_order.ccode=Po_Podetails.sodid and  Po_Podetails.sotype =6  
  WHERE (Po_Podetails.dUfts > @Dbts or Po_Pomain.ufts > @Dbts) and isnull(Po_Pomain.cBusType,'')<>'直运采购' and isnull(Po_Pomain.cBusType,'')<>'固定资产'  
   /**不考虑为FALSE**/
    and isnull(Po_Podetails.cDefine30,'')<>'False'
   
 IF @@error<>0   
  SET @iError=@@error  
   

GO


