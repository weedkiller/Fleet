SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PMServiceDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_PMServiceDetail]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
CREATE  procedure dbo.sp_PMServiceDetail਍ഀ
	(਍ഀ
		@Action char(1),਍ഀ
		@OrgId int,਍ഀ
		@Id int,਍ഀ
		@RepairCatId int=null output,਍ഀ
		@vchDesc varchar(100)=null output਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
਍ഀ
	if @Action = 'S'਍ഀ
	begin਍ഀ
		if not exists(select 'true' from PMServices where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			select 	@RepairCatId = RepairCatId,਍ഀ
				@vchDesc = vchDesc਍ഀ
			from 	PMServices਍ഀ
			where 	[Id] = @Id਍ഀ
			and 	OrgId = @OrgId਍ഀ
		end਍ഀ
	end਍ഀ
	if @Action = 'D'਍ഀ
	begin਍ഀ
		if not exists(select 'true' from PMServices where [Id] = @Id and OrgId = @OrgId)਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
		else਍ഀ
		begin਍ഀ
			if exists(select 'true' ਍ഀ
				from PMSchedDetails਍ഀ
				where PMServiceId = @Id਍ഀ
				and OrgId = @OrgId਍ഀ
				)਍ഀ
			begin਍ഀ
				return -2਍ഀ
			end਍ഀ
਍ഀ
			delete from PMServices਍ഀ
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
			insert into PMServices([OrgId], [RepairCatId], [vchDesc], [btRequiresRepair])਍ഀ
			values(@OrgId, @RepairCatId, isnull(@vchDesc, ''), 0)਍ഀ
਍ഀ
			return 0਍ഀ
		end਍ഀ
		else਍ഀ
		begin -- update਍ഀ
			if not exists(select 'true' from PMServices where [Id] = @Id and OrgId = @OrgId)਍ഀ
			begin਍ഀ
				return -1਍ഀ
			end਍ഀ
			else਍ഀ
			begin਍ഀ
				update 	PMServices ਍ഀ
				set 	RepairCatId = @RepairCatId,਍ഀ
					vchDesc = isnull(@vchDesc, '')਍ഀ
				where 	[Id] = @Id਍ഀ
				and OrgId = @OrgId਍ഀ
਍ഀ
				return 0਍ഀ
			end਍ഀ
		end਍ഀ
	end਍ഀ
	return 0਍ഀ
਍ഀ
਍ഀ
਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
