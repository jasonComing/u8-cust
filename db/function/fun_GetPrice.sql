Create   FUNCTION fun_GetPrice(@cInvCode varchar(30))
/*
功能：取料件最小单价
	（在历史PO单价中与最高进价控制两者之间选取）
*/
RETURNS float
AS
BEGIN
	DECLARE @mixPrice float		--最小單價
	DECLARE @PriceByPOdetails float
	DECLARE @PriceByInvCode float

	if not exists(select cInvCode from Inventory where cInvCode=@cInvCode )
		return 0

	select top 1 @PriceByInvCode=ISNULL(iInvMPCost,0)
	from  Inventory
	where cInvCode=@cInvCode

	if not exists(select  iUnitPrice
						from  PO_Podetails
						where cInvCode=@cInvCode 	and  iUnitPrice != 0
						)
			set @PriceByPOdetails =0
	else
		begin
				select top 1  @PriceByPOdetails=isnull(iUnitPrice,0)
				from  PO_Podetails
				where cInvCode=@cInvCode
				and  iUnitPrice != 0
				order by id desc
		end

	if @PriceByPOdetails >= @PriceByInvCode
		set @mixPrice=@PriceByInvCode
	else
		set @mixPrice=@PriceByPOdetails
	RETURN @mixPrice
END