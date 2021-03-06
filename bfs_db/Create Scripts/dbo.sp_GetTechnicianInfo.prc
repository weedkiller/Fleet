SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_GetTechnicianInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_GetTechnicianInfo]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
CREATE   procedure dbo.sp_GetTechnicianInfo਍ഀ
(਍ഀ
	@OrgId int,਍ഀ
	@OrderId int,਍ഀ
	@TechId int=null output,਍ഀ
	@dmHourlyRate decimal(18, 9)=null output,਍ഀ
	@bitTechCanViewHourlyRate bit=null output਍ഀ
)਍ഀ
as਍ഀ
	set nocount on਍ഀ
਍ഀ
	select @bitTechCanViewHourlyRate = isnull(bitTechCanViewHourlyRate, 0)਍ഀ
	from Orgs਍ഀ
	where [Id] = @OrgId਍ഀ
਍ഀ
	if isnull(@TechId, 0) = 0਍ഀ
	begin਍ഀ
		if exists(select 'true' from WorkOrders where [Id] = @OrderId and OrgId = @OrgId and isnull(intTechId, 0) <> 0)਍ഀ
		begin਍ഀ
			select 	@TechId = L.[Id],਍ഀ
				@dmHourlyRate = isnull(L.dmHourlyRate, 0.0)਍ഀ
			from Logins L਍ഀ
			inner join WorkOrders WO਍ഀ
			on WO.[Id] = @OrderId਍ഀ
			and WO.OrgId = @OrgId਍ഀ
			and WO.intTechId = L.[Id]਍ഀ
	਍ഀ
			return 1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		if exists(select 'true' from Logins where [Id] = @TechId)਍ഀ
		begin਍ഀ
			select @dmHourlyRate = dmHourlyRate਍ഀ
			from Logins਍ഀ
			where [Id] = @TechId਍ഀ
਍ഀ
			return 1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
	end਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
