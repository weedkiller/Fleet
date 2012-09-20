SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_UpdateActiveWorkOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_UpdateActiveWorkOrder]਍ഀ
GO਍ഀ
਍ഀ
create procedure sp_UpdateActiveWorkOrder਍ഀ
	(਍ഀ
		@OrgId int,਍ഀ
		@OrderId int਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
	਍ഀ
	if not exists(select 'true' from WorkOrders where [Id] = @OrderId and OrgId = @OrgId)਍ഀ
	begin਍ഀ
		return -1਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		update WorkOrders਍ഀ
		set btIsActive = 1਍ഀ
		where [Id] = @OrderId਍ഀ
		and OrgId = @OrgId਍ഀ
		return 0਍ഀ
	end਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
