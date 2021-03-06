SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PMSchedDetailsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_PMSchedDetailsDetail]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
create procedure dbo.sp_PMSchedDetailsDetail਍ഀ
	(਍ഀ
		@Action char(1),਍ഀ
		@OrgId int,਍ഀ
		@Id int,਍ഀ
		@PMSchedId int=null output,਍ഀ
		@PMServiceId int=null output,਍ഀ
		@UnitMeasureId int=null output,਍ഀ
		@intDays int=null output,਍ഀ
		@dmUnits decimal(19, 8)=null output਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
਍ഀ
	if @Action = 'S'਍ഀ
	begin਍ഀ
		if not exists(select 'true' from PMSchedDetails where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			select 	@PMSchedId = PMSchedId,਍ഀ
				@PMServiceId = PMServiceId,਍ഀ
				@UnitMeasureId = UnitMeasureId,਍ഀ
				@intDays = intDays,਍ഀ
				@dmUnits = dmUnits਍ഀ
			from PMSchedDetails਍ഀ
			where [Id] = @Id਍ഀ
			and OrgId = @OrgId਍ഀ
਍ഀ
			return 0਍ഀ
		end਍ഀ
	end਍ഀ
	if @Action = 'D'਍ഀ
	begin਍ഀ
		if not exists(select 'true' from PMSchedDetails where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			if exists(select top 1 'true' ਍ഀ
				from WorkOrderPMItems਍ഀ
				where OrgId = @OrgId਍ഀ
				and PMSchedDetailId = @Id)਍ഀ
			begin਍ഀ
				return -2਍ഀ
			end਍ഀ
਍ഀ
			delete from PMSchedDetails਍ഀ
			where [Id] = @Id਍ഀ
			and OrgId = @OrgId਍ഀ
			਍ഀ
			return 0਍ഀ
		end਍ഀ
	end਍ഀ
	if @Action = 'U'਍ഀ
	begin਍ഀ
		if @Id = 0਍ഀ
		begin -- insert਍ഀ
਍ഀ
			insert into [PMSchedDetails]([OrgId], [PMSchedId], [PMServiceId], [UnitMeasureId], [intDays], [dmUnits])਍ഀ
			values(@OrgId, @PMSchedId, @PMServiceId, @UnitMeasureId, @intDays, @dmUnits)਍ഀ
਍ഀ
			return 0਍ഀ
		end਍ഀ
		else਍ഀ
		begin -- update਍ഀ
			if not exists(select 'true' from PMSchedDetails where [Id] = @Id and OrgId = @OrgId)਍ഀ
			begin਍ഀ
				return -1਍ഀ
			end਍ഀ
			else਍ഀ
			begin਍ഀ
				update 	PMSchedDetails਍ഀ
				set 	PMSchedId = @PMSchedId,਍ഀ
					PMServiceId = @PMServiceId,਍ഀ
					UnitMeasureId = @UnitMeasureId,਍ഀ
					intDays = @intDays,਍ഀ
					dmUnits = @dmUnits਍ഀ
				where 	[Id] = @Id਍ഀ
				and 	OrgId = @OrgId਍ഀ
਍ഀ
				return 0਍ഀ
			end਍ഀ
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
