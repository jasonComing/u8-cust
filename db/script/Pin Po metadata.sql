update CustInvClassMetaData
set ShowInPo = 0, LastModified = getdate()
where cInvCCode = 603
and PropertyId in (66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 119, 120, 121, 122, 131, 141, 142, 143)