create view v_CustMoRdRecords01
as
select m.Moid, r.AutoID,r.ID,r.cInvCode,r.iNum,r.iQuantity,r.iUnitCost,r.iPrice,r.iAPrice,r.iPUnitCost,r.iPPrice,r.cBatch,r.cVouchCode,r.cInVouchCode,r.cinvouchtype,r.iSOutQuantity,r.iSOutNum,r.cFree1,r.cFree2,r.iFlag,r.dSDate,r.iTax,r.iSQuantity,r.iSNum,r.iMoney,r.iFNum,r.iFQuantity,r.dVDate,r.cPosition,r.cDefine22,r.cDefine23,r.cDefine24,r.cDefine25,r.cDefine26,r.cDefine27,r.cItem_class,r.cItemCode,r.iPOsID,r.fACost,r.cName,r.cItemCName,r.cFree3,r.cFree4,r.cFree5,r.cFree6,r.cFree7,r.cFree8,r.cFree9,r.cFree10,r.cBarCode,r.iNQuantity,r.iNNum,r.cAssUnit,r.dMadeDate,r.iMassDate,r.cDefine28,r.cDefine29,r.cDefine30,r.cDefine31,r.cDefine32,r.cDefine33,r.cDefine34,r.cDefine35,r.cDefine36,r.cDefine37,r.iCheckIds,r.cBVencode,r.chVencode,r.bGsp,r.cGspState,r.iArrsId,r.cCheckCode,r.iCheckIdBaks,r.cRejectCode,r.iRejectIds,r.cCheckPersonCode,r.dCheckDate,r.iOriTaxCost,r.iOriCost,r.iOriMoney,r.iOriTaxPrice,r.ioriSum,r.iTaxRate,r.iTaxPrice,r.iSum,r.bTaxCost,r.cPOID,r.cMassUnit,r.iMaterialFee,r.iProcessCost,r.iProcessFee,r.dMSDate,r.iSMaterialFee,r.iSProcessFee,r.iOMoDID,r.strContractId,r.strCode,r.bChecked,r.bRelated,r.iOMoMID,r.iMatSettleState,r.iBillSettleCount,r.bLPUseFree,r.iOriTrackID,r.coritracktype,r.cbaccounter,r.dbKeepDate,r.bCosting,r.iSumBillQuantity,r.bVMIUsed,r.iVMISettleQuantity,r.iVMISettleNum,r.cvmivencode,r.iInvSNCount,r.cwhpersoncode,r.cwhpersonname,r.impcost,r.iIMOSID,r.iIMBSID,r.cbarvcode,r.dbarvdate,r.iinvexchrate,r.corufts,r.comcode,r.strContractGUID,r.iExpiratDateCalcu,r.cExpirationdate,r.dExpirationdate,r.cciqbookcode,r.iBondedSumQty,r.iordertype,r.iorderdid,r.iordercode,r.iorderseq,r.isodid,r.isotype,r.csocode,r.isoseq,r.cBatchProperty1,r.cBatchProperty2,r.cBatchProperty3,r.cBatchProperty4,r.cBatchProperty5,r.cBatchProperty6,r.cBatchProperty7,r.cBatchProperty8,r.cBatchProperty9,r.cBatchProperty10,r.cbMemo,r.iFaQty,r.isTax,r.irowno,r.strowguid,r.rowufts,r.ipreuseqty,r.ipreuseinum,r.iDebitIDs,r.OutCopiedQuantity,r.iOldPartId,r.fOldQuantity,r.cbsysbarcode,r.bmergecheck,r.iMergeCheckAutoId,r.bnoitemused,r.cReworkMOCode,r.iReworkMODetailsid,r.iProductType,r.cMainInvCode,r.iMainMoDetailsID,r.iShareMaterialFee,r.cplanlotcode,r.bgift,r.iposflag
from RdRecords01 r
join OM_MOMain m on m.cCode = r.cpoid
go
