declare @yuyan varchar(50)
declare @yuyan2 varchar(50)
set @yuyan='zh-cn'
set @yuyan2='ZH-TW'

--�ɹ����� ʿơ����
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9C}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9C}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--�ɹ����� ʿơ����
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9C}','btnImportPo','default', 'U8CustDef','88', 
	'88','save', '0', 'IEDIT','U8101VouchPlugin.POsImport',
	'�ɹ�ʿơ����',@yuyan,'','�ɹ�ʿơ����','',
	1,'�ɹ�ʿơ���ص�����','save','save'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9C}','btnImportPo','default', 'U8CustDef','88', 
	'88','save', '0', 'IEDIT','U8101VouchPlugin.POsImport',
	'�ɹ�ʿơ����',@yuyan2,'','�ɹ�ʿơ����','',
	1,'�ɹ�ʿơ���ص�����','save','save'

	

--���۶��� ʿơ
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9D}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9D}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--���۶��� ʿơ
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9D}','btnImportSo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImport',
	'ʿơ���۶�������',@yuyan,'','ʿơ���۶�������','',
	1,'ʿơ���۶�������','unverify','unverify'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9D}','btnImportSo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImport',
	'ʿơ���۶�������',@yuyan2,'','ʿơ���۶�������','',
	1,'ʿơ���۶�������','unverify','unverify'

--���۶���  ����˵������
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9E}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9E}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--���۶���  ����˵������
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9E}','btnImportSoMemo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportMemo',
	'���۶�������˵������',@yuyan,'','���۶�������˵������','',
	1,'���۶�������˵������','print','print'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9E}','btnImportSoMemo','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportMemo',
	'���۶�������˵������',@yuyan2,'','���۶�������˵������','',
	1,'���۶�������˵������','print','print'

--���۶�����ӡ�����PDF
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{64F5291F-2AED-4065-8EDB-500C278A4A9F}'
Delete  From  [AA_CustomerButton] where [cButtonID]  ='{65F5291F-2AED-4065-8EDB-500C278A4A9F}'
INSERT INTO [AA_CustomerButton]
(
	[cButtonID], [cButtonKey], [cButtonType], [cProjectNO], [cFormKey], 
	[cVoucherKey], [cKeyBefore], [iOrder], [cGroup], [cCustomerObjectName], 
	[cCaption], [cLocaleID], [cImage], [cToolTip], [cHotKey], 
	[bInneralCommand], [cVariant], [cVisibleAsKey], [cEnableAsKey]
)
--���۶�����ӡ�����PDF
Select

	'{64F5291F-2AED-4065-8EDB-500C278A4A9F}','btnImportSoPrintAndOut','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportPrintAndOut',
	'��ӡ�����',@yuyan,'','��ӡ�����','',
	1,'��ӡ�����','print','print'
union all
Select

	'{65F5291F-2AED-4065-8EDB-500C278A4A9F}','btnImportSoPrintAndOut','default', 'U8CustDef','17', 
	'17','save', '0', 'IEDIT','U8101VouchPlugin.SOsImportPrintAndOut',
	'��ӡ�����',@yuyan2,'','��ӡ�����','',
	1,'��ӡ�����','print','print'


--select * from AA_CustomerButton where cButtonKey like 'btnImport%' or cCaption like 'ʿơ����' or cCustomerObjectName like 'U8Test%'
--delete AA_CustomerButton where cButtonKey like 'btnImport%' or cCaption like 'ʿơ����' or cCustomerObjectName like 'U8Test%'