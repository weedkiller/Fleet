SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SetInspectItemChecks]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SetInspectItemChecks]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
਍ഀ
----------------------------------------------------------------------------਍ഀ
-- Author: Alexey Gavrilov਍ഀ
-- Date: 9/2/2004 ਍ഀ
-- Description: The procedure set te check status to inspection items ਍ഀ
-- in work order and PM items associated with instection items਍ഀ
---------------------------------------------------------------------------਍ഀ
CREATE    procedure sp_SetInspectItemChecks਍ഀ
	(਍ഀ
		@OrgId int,਍ഀ
		@OrderId int,਍ഀ
		@ItemId int,਍ഀ
		@ServiceCheckId int=null,਍ഀ
		@ServiceResultId int=null, -- old result status਍ഀ
		@dtCurrentDate datetime਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
	declare @IsDelete bit਍ഀ
	declare @RepairItemId int਍ഀ
	declare @i int਍ഀ
	declare @N int਍ഀ
	declare @PMSchedDetailId int਍ഀ
	਍ഀ
	declare @tmp table(਍ഀ
		[Id] int identity(1, 1), ਍ഀ
		RepairId int਍ഀ
		)਍ഀ
	declare @tmp_pm table(਍ഀ
		[Id] int identity(1, 1),਍ഀ
		PMSchedDetailId int਍ഀ
		)਍ഀ
਍ഀ
	if not exists(select 'true' from WorkOrderInspectItems where [Id] = @ItemId and OrgId = @OrgId and WorkOrderId = @OrderId)਍ഀ
	begin਍ഀ
		return -1਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		-- select the link to serviced repairs if they is there਍ഀ
		select 	@RepairItemId = isnull(RepairItemId, 0)਍ഀ
		from 	WorkOrderInspectItems਍ഀ
		where 	[Id] = @ItemId ਍ഀ
		and 	OrgId = @OrgId਍ഀ
		and 	WorkOrderId = @OrderId਍ഀ
਍ഀ
		-- set a new check status for the Inspection item਍ഀ
		update 	WorkOrderInspectItems਍ഀ
		set 	ServiceCheckId = @ServiceCheckId,਍ഀ
			ServiceResultId = null,਍ഀ
			RepairItemId = null਍ഀ
		where 	[Id] = @ItemId਍ഀ
		and 	OrgId = @OrgId਍ഀ
		and 	WorkOrderId = @OrderId਍ഀ
਍ഀ
		-- updating the PM Items that was associated with an Inspection items਍ഀ
		-- The association store in a InspectionItems_PMSchedDetails਍ഀ
਍ഀ
		if isnull(@ServiceCheckId, 0) = 1 or isnull(@ServiceCheckId, 0) = 2਍ഀ
		begin਍ഀ
			-- update PM Items according to InspectionItems_PMSchedDetails਍ഀ
			if exists(select 'true' ਍ഀ
				from InspectionItems_PMSchedDetails I_P਍ഀ
				inner join WorkOrderInspectItems II਍ഀ
				on 	II.[Id] = @ItemId਍ഀ
				and  	II.WorkOrderId = @OrderId਍ഀ
				and 	II.OrgId = @OrgId਍ഀ
				and  	I_P.InspectItemId = II.ItemId਍ഀ
				and 	I_P.OrgId = II.OrgId਍ഀ
				)਍ഀ
			begin਍ഀ
				update 	WorkOrderPMItems ਍ഀ
				set 	ServiceCheckId = @ServiceCheckId,਍ഀ
					ServiceResultId = null,਍ഀ
					RepairItemId = null਍ഀ
				where 	WorkOrderId = @OrderId਍ഀ
				and 	OrgId = @OrgId਍ഀ
				and 	PMSchedDetailId in (਍ഀ
					select 	I_P.PMSchedDetailId਍ഀ
					from 	InspectionItems_PMSchedDetails I_P਍ഀ
					inner join WorkOrderInspectItems II਍ഀ
					on 	II.[Id] = @ItemId਍ഀ
					and  	II.WorkOrderId = @OrderId਍ഀ
					and 	II.OrgId = @OrgId਍ഀ
					and  	I_P.InspectItemId = II.ItemId਍ഀ
					and 	I_P.OrgId = II.OrgId਍ഀ
					)਍ഀ
		਍ഀ
				-- in any case we must to update of PM history ਍ഀ
				-- that this pm items was serviced਍ഀ
	਍ഀ
				-- select all associated PM Items ਍ഀ
				insert into @tmp_pm(PMSchedDetailId)਍ഀ
				select 	PMSD.[Id]਍ഀ
				from 	WorkOrders WO਍ഀ
				inner join Equipments E ਍ഀ
				on 	WO.[Id] = @OrderId਍ഀ
				and 	WO.OrgId = @OrgId਍ഀ
				and 	WO.EquipId = E.[Id]਍ഀ
				and 	WO.ORgId = E.OrgId਍ഀ
				inner join PMSchedDetails PMSD਍ഀ
				on 	PMSD.PMSchedId = E.PMScheduleId਍ഀ
				and 	PMSD.OrgId = E.OrgId਍ഀ
				inner join InspectionItems_PMSchedDetails IP਍ഀ
				on 	IP.PMSchedDetailId = PMSD.[Id]਍ഀ
				and 	IP.OrgId = PMSD.OrgId਍ഀ
				inner join WorkOrderInspectItems II਍ഀ
				on 	II.[Id] = @ItemId਍ഀ
				and 	II.WorkOrderId = WO.[Id]਍ഀ
				and 	IP.InspectItemId = II.ItemId਍ഀ
				and 	IP.OrgId = II.OrgId਍ഀ
		਍ഀ
				select @i = 1, @N = scope_identity()਍ഀ
		਍ഀ
				while @i <= @N਍ഀ
				begin਍ഀ
					select @PMSchedDetailId  = PMSchedDetailId ਍ഀ
					from @tmp_pm਍ഀ
					where [Id] = @i਍ഀ
	਍ഀ
					-- in history table is keeping the last check of detail਍ഀ
					-- if the record already there then editing else adding਍ഀ
					if not exists(select 'true' ਍ഀ
						from EquipPMHistory EH ਍ഀ
						inner join WorkOrders WO਍ഀ
						on 	WO.[Id] = @OrderId਍ഀ
						and 	WO.OrgId = @OrgId਍ഀ
						and 	EH.WorkOrderid = WO.[Id]਍ഀ
						and 	EH.EquipId = WO.EquipId਍ഀ
						and 	EH.OrgId = WO.OrgId਍ഀ
						and 	EH.PMSchedDetailId = @PMSchedDetailId਍ഀ
						)਍ഀ
					begin -- insert history਍ഀ
						insert into EquipPMHistory (਍ഀ
							OrgId, ਍ഀ
							EquipId,਍ഀ
							dtDate,਍ഀ
							PMSchedDetailId,਍ഀ
							dmUnits,਍ഀ
							WorkOrderId਍ഀ
							)਍ഀ
						select 	@OrgId,਍ഀ
							WO.EquipId,਍ഀ
							@dtCurrentDate,਍ഀ
							@PMSchedDetailId,਍ഀ
							WO.dmMileage,਍ഀ
							@OrderId਍ഀ
						from 	WorkOrders WO਍ഀ
						where  	WO.[Id] = @OrderId਍ऀഀ
਍ऀऀऀऀऀऀ愀渀搀 ऀ圀伀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀ攀渀搀ഀ
਍ऀऀऀऀऀ攀氀猀攀ഀ
਍ऀऀऀऀऀ戀攀最椀渀 ⴀⴀ 甀瀀搀愀琀攀 栀椀猀琀漀爀礀ഀ
਍ऀऀऀऀऀऀ甀瀀搀愀琀攀 ऀ䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀ഀ
਍ऀऀऀऀऀऀ猀攀琀 ऀ搀琀䐀愀琀攀 㴀 䀀搀琀䌀甀爀爀攀渀琀䐀愀琀攀Ⰰഀ
਍ऀऀऀऀऀऀऀ搀洀唀渀椀琀猀 㴀 圀伀⸀搀洀䴀椀氀攀愀最攀ഀ
਍ऀऀऀऀऀऀ昀爀漀洀 ऀ圀漀爀欀伀爀搀攀爀猀 圀伀ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀ऀ圀伀⸀嬀䤀搀崀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 ऀ圀伀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀ऀ䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀⸀䔀焀甀椀瀀䤀搀 㴀 圀伀⸀䔀焀甀椀瀀椀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀ऀ䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀⸀伀爀最䤀搀 㴀 圀伀⸀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀ऀ䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀⸀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀 㴀 䀀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 ऀ䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀⸀圀漀爀欀伀爀搀攀爀䤀搀 㴀 圀伀⸀嬀䤀搀崀ഀ
਍ऀऀऀऀऀ攀渀搀ഀ
਍ऀഀ
਍ऀऀऀऀऀ猀攀氀攀挀琀 䀀椀 㴀 䀀椀 ⬀ ㄀ഀ
਍ऀऀऀऀ攀渀搀ഀ
਍ऀऀऀ攀渀搀ഀ
਍ऀऀ攀渀搀ഀ
਍ഀ
਍ऀऀ椀昀 椀猀渀甀氀氀⠀䀀匀攀爀瘀椀挀攀刀攀猀甀氀琀䤀搀Ⰰ 　⤀ 㸀 　 ഀ
਍ऀऀ戀攀最椀渀ഀ
਍ऀऀऀⴀⴀ 椀昀 琀栀攀 搀攀氀攀琀椀渀最 爀攀瀀愀椀爀 栀愀猀 爀攀氀愀琀攀 琀漀 愀渀 漀琀栀攀爀 倀䴀 椀琀攀洀猀Ⰰ 䤀猀猀甀攀猀Ⰰ 愀渀搀 䤀渀猀瀀攀挀琀椀漀渀 䤀琀攀洀猀 ഀ
਍ऀऀऀⴀⴀ 琀栀攀渀 搀漀渀✀琀 搀攀氀攀琀攀 爀攀瀀愀椀爀 愀渀搀 漀渀氀礀 甀瀀搀愀琀攀 琀栀椀猀 䤀渀猀瀀攀挀琀椀漀渀 䤀琀攀洀猀ഀ
਍ऀऀऀ猀攀氀攀挀琀 䀀䤀猀䐀攀氀攀琀攀 㴀 ㄀ഀ
਍ऀऀऀ椀昀 攀砀椀猀琀猀⠀猀攀氀攀挀琀 ✀琀爀甀攀✀ ഀ
਍ऀऀऀऀ昀爀漀洀 圀漀爀欀伀爀搀攀爀倀䴀䤀琀攀洀猀ഀ
਍ऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀ愀渀搀 圀漀爀欀伀爀搀攀爀䤀搀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀琀攀洀䤀搀 㴀 䀀刀攀瀀愀椀爀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ⤀ഀ
਍ऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀ猀攀氀攀挀琀 䀀䤀猀䐀攀氀攀琀攀 㴀 　ഀ
਍ऀऀऀ攀渀搀ഀ
਍ऀऀऀ椀昀 攀砀椀猀琀猀⠀猀攀氀攀挀琀 ✀琀爀甀攀✀ ഀ
਍ऀऀऀऀ昀爀漀洀 圀漀爀欀伀爀搀攀爀刀攀瀀漀爀琀攀搀䤀猀猀甀攀猀ഀ
਍ऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀ愀渀搀 圀漀爀欀伀爀搀攀爀䤀搀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀琀攀洀䤀搀 㴀 䀀刀攀瀀愀椀爀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ⤀ഀ
਍ऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀ猀攀氀攀挀琀 䀀䤀猀䐀攀氀攀琀攀 㴀 　ഀ
਍ऀऀऀ攀渀搀ഀ
਍ഀ
਍ऀऀऀ椀昀 攀砀椀猀琀猀⠀猀攀氀攀挀琀 ✀琀爀甀攀✀ ഀ
਍ऀऀऀऀ昀爀漀洀 圀漀爀欀伀爀搀攀爀䤀渀猀瀀攀挀琀䤀琀攀洀猀ഀ
਍ऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀ愀渀搀 圀漀爀欀伀爀搀攀爀䤀搀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀琀攀洀䤀搀 㴀 䀀刀攀瀀愀椀爀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 嬀䤀搀崀 㰀㸀 䀀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ⤀ഀ
਍ऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀ猀攀氀攀挀琀 䀀䤀猀䐀攀氀攀琀攀 㴀 　ഀ
਍ऀऀऀ攀渀搀ഀ
਍ഀ
਍ऀऀऀ椀昀 䀀䤀猀䐀攀氀攀琀攀 㴀 ㄀ഀ
਍ऀऀऀ戀攀最椀渀 ⴀⴀ 瀀爀漀挀攀猀猀椀渀最 愀氀氀 爀攀瀀愀椀爀猀 昀漀爀 搀攀氀攀琀攀ഀ
਍ऀऀऀऀ椀渀猀攀爀琀 椀渀琀漀 䀀琀洀瀀⠀刀攀瀀愀椀爀䤀搀⤀ഀ
਍ऀऀऀऀ猀攀氀攀挀琀 刀攀瀀愀椀爀䤀搀ഀ
਍ऀऀऀऀ昀爀漀洀 刀攀瀀愀椀爀䴀甀氀琀ഀ
਍ऀऀऀऀ眀栀攀爀攀 䤀琀攀洀䤀搀 㴀 䀀刀攀瀀愀椀爀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ഀ
਍ऀऀऀऀ猀攀氀攀挀琀 䀀椀 㴀 ㄀Ⰰ 䀀一 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ഀ
਍ऀऀऀऀ搀攀氀攀琀攀 昀爀漀洀 刀攀瀀愀椀爀䴀甀氀琀ഀ
਍ऀऀऀऀ眀栀攀爀攀 䤀琀攀洀䤀搀 㴀 䀀刀攀瀀愀椀爀䤀琀攀洀䤀搀ഀ
਍ऀऀऀऀ愀渀搀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀഀ
਍ऀऀऀऀⴀⴀ 搀攀氀攀琀椀渀最 愀氀氀 爀攀瀀愀椀爀猀Ⰰ 椀昀 爀攀瀀愀椀爀 栀愀猀 漀琀栀攀爀 椀猀猀甀攀猀 ⠀漀爀 漀琀栀攀爀 椀琀攀洀⤀ ഀ
਍ऀऀऀऀⴀⴀ 琀栀攀渀 搀漀渀✀琀 搀攀氀攀琀攀 椀琀ഀ
਍ऀऀऀऀ眀栀椀氀攀 䀀椀 㰀㴀 䀀一ഀ
਍ऀऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀऀ椀昀 渀漀琀 攀砀椀猀琀猀⠀猀攀氀攀挀琀 ✀琀爀甀攀✀ ഀ
਍ऀऀऀऀऀऀ昀爀漀洀 刀攀瀀愀椀爀䴀甀氀琀 ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 ഀ
਍ऀऀऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀搀 椀渀 ⠀ഀ
਍ऀऀऀऀऀऀऀ猀攀氀攀挀琀 刀攀瀀愀椀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 䀀琀洀瀀ഀ
਍ऀऀऀऀऀऀऀ眀栀攀爀攀 嬀䤀搀崀 㴀 䀀椀ഀ
਍ऀऀऀऀऀऀऀ⤀ഀ
਍ऀऀऀऀऀऀ⤀ഀ
਍ऀऀऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀऀऀ搀攀氀攀琀攀 昀爀漀洀 倀愀爀琀猀唀猀攀搀ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀搀 椀渀 ⠀ഀ
਍ऀऀऀऀऀऀऀ猀攀氀攀挀琀 刀攀瀀愀椀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 䀀琀洀瀀ഀ
਍ऀऀऀऀऀऀऀ眀栀攀爀攀 嬀䤀搀崀 㴀 䀀椀ഀ
਍ऀऀऀऀऀऀऀ⤀ഀ
਍ഀ
਍ऀऀऀऀऀऀ搀攀氀攀琀攀 昀爀漀洀 吀椀洀攀䰀漀最 ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 伀爀搀攀爀䤀搀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 刀攀瀀愀椀爀䤀搀 椀渀 ⠀ഀ
਍ऀऀऀऀऀऀऀ猀攀氀攀挀琀 刀攀瀀愀椀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 ⌀琀洀瀀ഀ
਍ऀऀऀऀऀऀऀ眀栀攀爀攀 嬀䤀搀崀 㴀 䀀椀ഀ
਍ऀऀऀऀऀऀऀ⤀ഀ
਍ऀऀഀ
਍ऀऀऀऀऀऀ搀攀氀攀琀攀 昀爀漀洀 刀攀瀀愀椀爀猀ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀ愀渀搀 嬀䤀搀崀 椀渀 ⠀ഀ
਍ऀऀऀऀऀऀऀ猀攀氀攀挀琀 刀攀瀀愀椀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 䀀琀洀瀀ഀ
਍ऀऀऀऀऀऀऀ眀栀攀爀攀 嬀䤀搀崀 㴀 䀀椀ഀ
਍ऀऀऀऀऀऀऀ⤀ഀ
਍ऀऀऀऀऀ攀渀搀ഀ
਍ऀऀऀऀऀ猀攀氀攀挀琀 䀀椀 㴀 䀀椀 ⬀ ㄀ഀ
਍ऀऀऀऀ攀渀搀ഀ
਍ऀऀऀ攀渀搀ഀ
਍ऀऀ攀渀搀ഀ
਍ഀ
਍ऀऀ爀攀琀甀爀渀 　ഀ
਍ऀ攀渀搀ഀ
਍ഀ
਍ഀ
਍ഀ
਍ഀ
਍ഀ
਍䜀伀ഀ
਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀 ഀ
਍䜀伀ഀ
਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一 ഀ
਍䜀伀ഀ
਍ഀ
਍�