CREATE proc CopyInvCode
@newInvCode varchar(50)=null,
@oldInvCode varchar(50)=null
/*
功能：将ICE产成品料号，以新客号复制一份
		写入存货档表
调用实例:exec CopyInvCode '000_tt','D_007226'
*/
as
begin
	declare @maxidNum int
	if (@newInvCode is null or @oldInvCode is null ) return

	set nocount on

	begin tran t1
	if not exists(select * from bas_part where InvCode =@newInvCode )
	 begin
		select @maxidNum=max(partId)+1 from bas_part
		insert into  bas_part(partId,InvCode,bVirtual ,SafeQty,MinQty,MulQty,FixQty,cBasEngineerFigNo,fBasMaxSupply,iSurenessType,iDateType,
									iDateSum,iDynamicSurenessType,iBestrowSum,iPercentumSum )
		select @maxidNum,@newInvCode,bVirtual ,SafeQty,MinQty,MulQty,FixQty,cBasEngineerFigNo,fBasMaxSupply,iSurenessType,iDateType,
									iDateSum,iDynamicSurenessType,iBestrowSum,iPercentumSum from  bas_part where InvCode =@oldInvCode
	 end

	 if not exists(select * from Inventory_sub where cInvSubCode =@newInvCode )
	 begin
		insert into  Inventory_sub(cInvSubCode,fBuyExcess,iSurenessType,iDateType,iDateSum,iDynamicSurenessType,iBestrowSum,iPercentumSum,
					bIsAttachFile,bInByProCheck,iRequireTrackStyle,iExpiratDateCalcu,iBOMExpandUnitType,bPurPriceFree1,
					bPurPriceFree2,bPurPriceFree3,bPurPriceFree4,bPurPriceFree5,bPurPriceFree6,bPurPriceFree7,bPurPriceFree8,
					bPurPriceFree9,bPurPriceFree10,bOMPriceFree1,bOMPriceFree2,bOMPriceFree3,bOMPriceFree4,bOMPriceFree5,bOMPriceFree6,
					bOMPriceFree7,bOMPriceFree8,bOMPriceFree9,bOMPriceFree10,bSalePriceFree1,bSalePriceFree2,bSalePriceFree3,bSalePriceFree4,
					bSalePriceFree5,bSalePriceFree6,bSalePriceFree7,bSalePriceFree8,bSalePriceFree9,bSalePriceFree10,fInvOutUpLimit,bBondedInv,
					bBatchCreate,bBatchProperty1,bBatchProperty2,bBatchProperty3,bBatchProperty4,bBatchProperty5,bBatchProperty6,bBatchProperty7,
					bBatchProperty8,bBatchProperty9,bBatchProperty10,bControlFreeRange1,bControlFreeRange2,bControlFreeRange3,bControlFreeRange4,
					bControlFreeRange5,bControlFreeRange6,bControlFreeRange7,bControlFreeRange8,bControlFreeRange9,bControlFreeRange10,fInvCIQExch,
					iWarrantyPeriod,iWarrantyUnit,bInvKeyPart,iAcceptEarlyDays,fCurLLaborCost,fCurLVarManuCost,fCurLFixManuCost,fCurLOMCost,fNextLLaborCost,
					fNextLVarManuCost,fNextLFixManuCost,fNextLOMCost,dInvCreateDatetime,bPUQuota,bInvROHS,bPrjMat,fPrjMatLimit,bInvAsset,bSrvProduct,
					iAcceptDelayDays,iPlanCheckDay,iMaterialsCycle,iDrawType,bSCkeyProjections,iSupplyPeriodType,iTimeBucketId,iAvailabilityDate,
					fMaterialCost,bImport,iNearRejectDays,bCheckSubitemCost,fRoundFactor,bConsiderFreeStock,bSuitRetail)
		select @newInvCode,fBuyExcess,iSurenessType,iDateType,iDateSum,iDynamicSurenessType,iBestrowSum,iPercentumSum,bIsAttachFile,
					bInByProCheck,iRequireTrackStyle,iExpiratDateCalcu,iBOMExpandUnitType,bPurPriceFree1,bPurPriceFree2,bPurPriceFree3,bPurPriceFree4,
					bPurPriceFree5,bPurPriceFree6,bPurPriceFree7,bPurPriceFree8,bPurPriceFree9,bPurPriceFree10,bOMPriceFree1,bOMPriceFree2,bOMPriceFree3,
					bOMPriceFree4,bOMPriceFree5,bOMPriceFree6,bOMPriceFree7,bOMPriceFree8,bOMPriceFree9,bOMPriceFree10,bSalePriceFree1,bSalePriceFree2,
					bSalePriceFree3,bSalePriceFree4,bSalePriceFree5,bSalePriceFree6,bSalePriceFree7,bSalePriceFree8,bSalePriceFree9,bSalePriceFree10,
					fInvOutUpLimit,bBondedInv,bBatchCreate,bBatchProperty1,bBatchProperty2,bBatchProperty3,bBatchProperty4,bBatchProperty5,bBatchProperty6,
					bBatchProperty7,bBatchProperty8,bBatchProperty9,bBatchProperty10,bControlFreeRange1,bControlFreeRange2,bControlFreeRange3,bControlFreeRange4,
					bControlFreeRange5,bControlFreeRange6,bControlFreeRange7,bControlFreeRange8,bControlFreeRange9,bControlFreeRange10,fInvCIQExch,iWarrantyPeriod,
					iWarrantyUnit,bInvKeyPart,iAcceptEarlyDays,fCurLLaborCost,fCurLVarManuCost,fCurLFixManuCost,fCurLOMCost,fNextLLaborCost,
					fNextLVarManuCost,fNextLFixManuCost,fNextLOMCost,dInvCreateDatetime,bPUQuota,bInvROHS,bPrjMat,fPrjMatLimit,bInvAsset,bSrvProduct,
					iAcceptDelayDays,iPlanCheckDay,iMaterialsCycle,iDrawType,bSCkeyProjections,iSupplyPeriodType,iTimeBucketId,iAvailabilityDate,fMaterialCost,
					bImport,iNearRejectDays,bCheckSubitemCost,fRoundFactor,bConsiderFreeStock,bSuitRetail
		 from  Inventory_sub where cInvSubCode =@oldInvCode

	 end

	 if not exists(select * from Inventory_extradefine where cInvCode =@newInvCode )
	 begin
		insert into  Inventory_extradefine(cInvCode,cidefine1,cidefine2,cidefine3,cidefine4,cidefine5,cidefine6,cidefine7,cidefine8,cidefine9,
					cidefine10,cidefine12,cidefine13,cidefine14,cidefine15,cidefine16)
		select @newInvCode,cidefine1,cidefine2,cidefine3,cidefine4,cidefine5,cidefine6,cidefine7,cidefine8,cidefine9,
					cidefine10,cidefine12,cidefine13,cidefine14,cidefine15,cidefine16 from  Inventory_extradefine where cInvCode =@oldInvCode

	 end

	 if not exists(select * from Inventory where cInvCode =@newInvCode )
	 begin
		insert into  Inventory(cInvCode,cInvAddCode,cInvName,cInvStd,cInvCCode,cVenCode,cReplaceItem,cPosition,bSale,bPurchase,bSelf,
				bComsume,bProducing,bService,bAccessary,iTaxRate,iInvWeight,iVolume,iInvRCost,iInvSPrice,iInvSCost,iInvLSCost,iInvNCost,
				iInvAdvance,iInvBatch,iSafeNum,iTopSum,iLowSum,iOverStock,cInvABC,bInvQuality,bInvBatch,bInvEntrust,bInvOverStock,dSDate,
				dEDate,bFree1,bFree2,cInvDefine1,cInvDefine2,cInvDefine3,bInvType,iInvMPCost,cQuality,bFree3,bFree4,bFree5,bFree6,bFree7,
				bFree8,bFree9,bFree10,cCreatePerson,cModifyPerson,dModifyDate,fSubscribePoint,fVagQuantity,cValueType,fOutExcess,fInExcess,
				iMassDate,iWarnDays,fExpensesExch,bTrack,bSerial,bBarCode,cBarCode,cInvDefine4,cInvDefine5,cInvDefine6,cInvDefine7,cInvDefine8,
				cInvDefine9,cInvDefine10,cInvDefine11,cInvDefine12,cInvDefine13,cInvDefine14,cInvDefine15,cInvDefine16,iGroupType,cGroupCode,
				cComUnitCode,cAssComUnitCode,cSAComUnitCode,cPUComUnitCode,cSTComUnitCode,cCAComUnitCode,cFrequency,iFrequency,iDays,dLastDate,
				iWastage,bSolitude,cEnterprise,cAddress,cFile,cLabel,cCheckOut,cLicence,bSpecialties,cDefWareHouse,iHighPrice,iExpSaleRate,
				cPriceGroup,cOfferGrade,iOfferRate,cCurrencyName,cProduceAddress,cProduceNation,cRegisterNo,cEnterNo,cPackingType,cEnglishName,
				bPropertyCheck,cPreparationType,cCommodity,iRecipeBatch,cNotPatentName,iROPMethod,iBatchRule,iAssureProvideDays,iTestStyle,
				iDTMethod,fDTRate,fDTNum,cDTUnit,iDTStyle,iQTMethod,bPlanInv,bProxyForeign,bATOModel,bCheckItem,bPTOModel,bEquipment,cProductUnit,
				fOrderUpLimit,cMassUnit,fRetailPrice,cInvDepCode,iAlterAdvance,fAlterBaseNum,cPlanMethod,bMPS,bROP,bRePlan,cSRPolicy,bBillUnite,
				iSupplyDay,fSupplyMulti,fMinSupply,bCutMantissa,cInvPersonCode,iInvTfId,cEngineerFigNo,bInTotalCost,iSupplyType,bConfigFree1,
				bConfigFree2,bConfigFree3,bConfigFree4,bConfigFree5,bConfigFree6,bConfigFree7,bConfigFree8,bConfigFree9,bConfigFree10,iDTLevel,
				cDTAQL,bPeriodDT,cDTPeriod,iBigMonth,iBigDay,iSmallMonth,iSmallDay,bOutInvDT,bBackInvDT,iEndDTStyle,bDTWarnInv,cCIQCode,cWGroupCode,
				cWUnit,fGrossW,cVGroupCode,cVUnit,fLength,fWidth,fHeight,cShopUnit,cPurPersonCode,bImportMedicine,bFirstBusiMedicine,bForeExpland,
				cInvPlanCode,fConvertRate,dReplaceDate,bInvModel,bKCCutMantissa,bReceiptByDT,iImpTaxRate,bExpSale,iDrawBatch,bCheckBSATP,cInvProjectCode,
				iTestRule,cRuleCode,bCheckFree1,bCheckFree2,bCheckFree3,bCheckFree4,bCheckFree5,bCheckFree6,bCheckFree7,bCheckFree8,bCheckFree9,
				bCheckFree10,bBomMain,bBomSub,bProductBill,iCheckATP,iInvATPId,iPlanTfDay,iOverlapDay,bPiece,bSrvItem,bSrvFittings,fMaxSupply,fMinSplit,
				bSpecialOrder,bTrackSaleBill,cInvMnemCode,iPlanDefault,iPFBatchQty,iAllocatePrintDgt,bCheckBatch,bMngOldpart,iOldpartMngRule)

		select @newInvCode,cInvAddCode,cInvName,cInvStd,cInvCCode,cVenCode,cReplaceItem,cPosition,bSale,bPurchase,bSelf,
				bComsume,bProducing,bService,bAccessary,iTaxRate,iInvWeight,iVolume,iInvRCost,iInvSPrice,iInvSCost,iInvLSCost,iInvNCost,
				iInvAdvance,iInvBatch,iSafeNum,iTopSum,iLowSum,iOverStock,cInvABC,bInvQuality,bInvBatch,bInvEntrust,bInvOverStock,dSDate,
				dEDate,bFree1,bFree2,cInvDefine1,cInvDefine2,cInvDefine3,bInvType,iInvMPCost,cQuality,bFree3,bFree4,bFree5,bFree6,bFree7,
				bFree8,bFree9,bFree10,cCreatePerson,cModifyPerson,dModifyDate,fSubscribePoint,fVagQuantity,cValueType,fOutExcess,fInExcess,
				iMassDate,iWarnDays,fExpensesExch,bTrack,bSerial,bBarCode,cBarCode,cInvDefine4,cInvDefine5,cInvDefine6,cInvDefine7,cInvDefine8,
				cInvDefine9,cInvDefine10,cInvDefine11,cInvDefine12,cInvDefine13,cInvDefine14,cInvDefine15,cInvDefine16,iGroupType,cGroupCode,
				cComUnitCode,cAssComUnitCode,cSAComUnitCode,cPUComUnitCode,cSTComUnitCode,cCAComUnitCode,cFrequency,iFrequency,iDays,dLastDate,
				iWastage,bSolitude,cEnterprise,cAddress,cFile,cLabel,cCheckOut,cLicence,bSpecialties,cDefWareHouse,iHighPrice,iExpSaleRate,
				cPriceGroup,cOfferGrade,iOfferRate,cCurrencyName,cProduceAddress,cProduceNation,cRegisterNo,cEnterNo,cPackingType,cEnglishName,
				bPropertyCheck,cPreparationType,cCommodity,iRecipeBatch,cNotPatentName,iROPMethod,iBatchRule,iAssureProvideDays,iTestStyle,
				iDTMethod,fDTRate,fDTNum,cDTUnit,iDTStyle,iQTMethod,bPlanInv,bProxyForeign,bATOModel,bCheckItem,bPTOModel,bEquipment,cProductUnit,
				fOrderUpLimit,cMassUnit,fRetailPrice,cInvDepCode,iAlterAdvance,fAlterBaseNum,cPlanMethod,bMPS,bROP,bRePlan,cSRPolicy,bBillUnite,
				iSupplyDay,fSupplyMulti,fMinSupply,bCutMantissa,cInvPersonCode,iInvTfId,cEngineerFigNo,bInTotalCost,iSupplyType,bConfigFree1,bConfigFree2,
				bConfigFree3,bConfigFree4,bConfigFree5,bConfigFree6,bConfigFree7,bConfigFree8,bConfigFree9,bConfigFree10,iDTLevel,cDTAQL,bPeriodDT,
				cDTPeriod,iBigMonth,iBigDay,iSmallMonth,iSmallDay,bOutInvDT,bBackInvDT,iEndDTStyle,bDTWarnInv,cCIQCode,cWGroupCode,cWUnit,fGrossW,
				cVGroupCode,cVUnit,fLength,fWidth,fHeight,cShopUnit,cPurPersonCode,bImportMedicine,bFirstBusiMedicine,bForeExpland,cInvPlanCode,
				fConvertRate,dReplaceDate,bInvModel,bKCCutMantissa,bReceiptByDT,iImpTaxRate,bExpSale,iDrawBatch,bCheckBSATP,cInvProjectCode,iTestRule,
				cRuleCode,bCheckFree1,bCheckFree2,bCheckFree3,bCheckFree4,bCheckFree5,bCheckFree6,bCheckFree7,bCheckFree8,bCheckFree9,bCheckFree10,
				bBomMain,bBomSub,bProductBill,iCheckATP,iInvATPId,iPlanTfDay,iOverlapDay,bPiece,bSrvItem,bSrvFittings,fMaxSupply,fMinSplit,bSpecialOrder,
				bTrackSaleBill,cInvMnemCode,iPlanDefault,iPFBatchQty,iAllocatePrintDgt,bCheckBatch,bMngOldpart,iOldpartMngRule 
		from  Inventory where cInvCode =@oldInvCode

	 end

	 if @@ERROR=0
			commit tran t1
	 else
			rollback tran t1

	set nocount off

end

