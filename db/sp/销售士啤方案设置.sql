
DELETE FROM [UFSystem].[dbo].UA_Menu WHERE  cMenu_Id=N'SOSP' 
INSERT INTO [UFSystem].[dbo].[UA_Menu]([cMenu_Id], [cMenu_Name], [cMenu_Eng], [cSub_Id], [IGrade], [cSupMenu_Id], [bEndGrade], [cAuth_Id], [iOrder], [iImgIndex], [Paramters], [Depends], [Flag])
VALUES('SOSP','销售士啤方案设置',null,'SA',1,'SAM0302',1,NULL,0,0,NULL,NULL,NULL)

select * from UFMenu_Business_Lang where MenuId='SAM0302'

DELETE FROM [UFSystem].[dbo].UFMenu_Business_Lang WHERE  MenuId=N'SOSP' 
insert into [UFSystem].[dbo].UFMenu_Business_Lang(MenuId,Caption,LocaleId)
select 'SOSP','销售士啤方案设置','zh-CN' union all
select 'SOSP','銷售士啤方案設置','zh-TW'



DELETE FROM UFSystem..UA_Idt WHERE  id=N'SOSP' 
INSERT INTO [UFSystem].[dbo].[ua_idt]([id], [assembly], [catalogtype], [type], [class], [entrypoint],[parameter],[reserved])
VALUES('SOSP','.\UAP\Runtime\UFIDA.U8.Portal.NetProductSample.dll',0,2,'UFIDA.U8.Portal.NetProductSample.MyLoginable',null,null,null)





