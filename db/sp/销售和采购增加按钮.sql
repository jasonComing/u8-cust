declare @yuyan varchar(50)
declare @yuyan2 varchar(50)
set @yuyan='zh-cn'
set @yuyan2='ZH-TW'

--采购订单 士啤加载
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9C}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9C}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--采购订单 士啤加载
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9C}','btnImportPo','default', 'U8CustDef','88', 
	'88','save', '0', 'IEDIT','U8101VouchPlugin.POsImport',
	'采购士啤加载',@yuyan,'','采购士啤加载','',
	1,'采购士啤加载到表体','save','save'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9C}','btnImportPo','default', 'U8CustDef','88', 
	'88','save', '0', 'IEDIT','U8101VouchPlugin.POsImport',
	'采购士啤加载',@yuyan2,'','采购士啤加载','',
	1,'采购士啤加载到表体','save','save'

	

--销售订单 士啤
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9D}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9D}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--销售订单 士啤
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9D}','btnImportSo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImport',
	'士啤销售订单生成',@yuyan,'','士啤销售订单生成','',
	1,'士啤销售订单生成','unverify','unverify'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9D}','btnImportSo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImport',
	'士啤销售订单生成',@yuyan2,'','士啤销售订单生成','',
	1,'士啤销售订单生成','unverify','unverify'

--销售订单  文字说明内容
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9E}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9E}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--销售订单  文字说明内容
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9E}','btnImportSoMemo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportMemo',
	'销售订单文字说明内容',@yuyan,'','销售订单文字说明内容','',
	1,'销售订单文字说明内容','print','print'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9E}','btnImportSoMemo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportMemo',
	'销售订单文字说明内容',@yuyan2,'','销售订单文字说明内容','',
	1,'销售订单文字说明内容','print','print'

--销售订单打印与输出PDF
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9F}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9F}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--销售订单打印与输出PDF
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9F}','btnImportSoPrintAndOut','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportPrintAndOut',
	'打印与输出',@yuyan,'','打印与输出','',
	1,'打印与输出','print','print'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9F}','btnImportSoPrintAndOut','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportPrintAndOut',
	'打印与输出',@yuyan2,'','打印与输出','',
	1,'打印与输出','print','print'


--select * from AA_CustomerButton where cButtonKey like 'btnImport%' or cCaption like '士啤处理' or cCustomerObjectName like 'U8Test%'
--delete AA_CustomerButton where cButtonKey like 'btnImport%' or cCaption like '士啤处理' or cCustomerObjectName like 'U8Test%'