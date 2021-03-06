SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_TimeLogDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_TimeLogDetail]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
CREATE procedure dbo.sp_TimeLogDetail਍ഀ
	(਍ഀ
		@Action char(1),਍ഀ
		@OrgId int,਍ഀ
		@Id int output,਍ഀ
		@OrderId int=null output,਍ഀ
		@RepairId int=null output,਍ഀ
		@TechId int=null output,਍ഀ
		@dtStartTime datetime=null output,਍ഀ
		@dtStopTime datetime=null output,਍ഀ
		@dmHours decimal(19,8)=null output,਍ഀ
		@dmHourlyRate decimal(19,8)=null output,਍ഀ
		@vchNote varchar(6000)=null output,਍ഀ
		@dtCreatedDate datetime=null output਍ഀ
	)਍ഀ
as਍ഀ
	set nocount on਍ഀ
	਍ഀ
	if @Action = 'S'਍ഀ
	begin਍ഀ
		if not exists(select 'true' from TimeLog where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			select 	@OrderId = OrderId,਍ഀ
				@RepairId = RepairId,਍ഀ
				@TechId = TechId,਍ഀ
				@dtStartTime = dtStartTime,਍ഀ
				@dtStopTime = dtStopTime,਍ഀ
				@dmHours = dmHours,਍ഀ
				@dmHourlyRate = dmHourlyRate,਍ഀ
				@vchNote = vchNote,਍ഀ
				@dtCreatedDate = dtCreatedDate਍ഀ
			from TimeLog਍ഀ
			where [Id] = @Id਍ഀ
			and OrgId = @OrgId਍ഀ
		end਍ഀ
	end਍ഀ
	if @Action = 'U'਍ഀ
	begin਍ഀ
		if @Id = 0਍ഀ
		begin -- insert਍ഀ
			insert into [TimeLog](਍ഀ
				[OrgId], ਍ഀ
				[OrderId], ਍ഀ
				[RepairId],਍ഀ
				[TechId], ਍ഀ
				[dtStartTime], ਍ഀ
				[dtStopTime], ਍ഀ
				[dmHours], ਍ഀ
				[dmHourlyRate], ਍ഀ
				[vchNote],਍ഀ
				[dtCreatedDate]਍ഀ
				)਍ഀ
			values( @OrgId,਍ഀ
				@OrderId,਍ഀ
				@RepairId,਍ഀ
				@TechId,਍ഀ
				@dtStartTime,਍ഀ
				@dtStopTime,਍ഀ
				@dmHours,਍ഀ
				@dmHourlyRate,਍ഀ
				isnull(@vchNote, ''),਍ഀ
				isnull(@dtCreatedDate, getdate())਍ഀ
				)਍ഀ
਍ഀ
			select @Id = scope_identity()਍ഀ
			return 0਍ഀ
		end਍ഀ
		else਍ഀ
		begin -- update਍ഀ
			if not exists(select 'true' from TimeLog where [Id] = @Id and OrgId = @OrgId)਍ഀ
			begin਍ഀ
				return -1਍ഀ
			end਍ഀ
			else਍ഀ
			begin਍ഀ
				update 	[TimeLog]਍ഀ
				set 	[RepairId]=@RepairId,਍ഀ
					[TechId]=@TechId,਍ഀ
					[dtStartTime]=@dtStartTime,਍ഀ
					[dtStopTime]=@dtStopTime,਍ഀ
					[dmHours]=@dmHours,਍ഀ
					[dmHourlyRate]=@dmHourlyRate,਍ഀ
					[vchNote]=@vchNote,਍ഀ
					[dtCreatedDate] = @dtCreatedDate਍ഀ
				where 	[OrgId]=@OrgId਍ഀ
				and 	[Id]=@Id ਍ഀ
				return 0਍ഀ
			end਍ഀ
		end਍ഀ
	end਍ഀ
਍ഀ
	if @Action = 'D'਍ഀ
	begin -- delete਍ഀ
		if not exists(select 'true' from TimeLog where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			delete from [TimeLog]਍ഀ
			where [Id] = @Id ਍ഀ
			and OrgId = @OrgId਍ഀ
		end਍ഀ
	end਍ഀ
	return 0਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
