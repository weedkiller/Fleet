SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SetAssociationsRepair]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SetAssociationsRepair]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
----------------------------------------------------------------------------਍ഀ
-- Author: Alexey Gavrilov਍ഀ
-- Date: 9/2/2004 ਍ഀ
-- Description: The procedure set the association between serviced repair and ਍ഀ
-- issue (reported Issue, PM Item, Inspection Item)਍ഀ
---------------------------------------------------------------------------਍ഀ
CREATE   procedure sp_SetAssociationsRepair਍ഀ
(਍ഀ
	@btChecked bit,਍ഀ
	@OrgId int,਍ഀ
	@OrderId int,਍ഀ
	@vchType varchar(25),਍ഀ
	@ItemId int,਍ഀ
	@RepairId int,਍ഀ
	@ServiceResultId int਍ഀ
)਍ഀ
as਍ഀ
	set nocount on਍ഀ
	declare @btAssociation bit਍ഀ
	declare @countLinks int਍ഀ
	declare @RepairItemId int਍ഀ
	declare @i int਍ഀ
	declare @N int਍ഀ
	declare @PMSchedDetailId int਍ഀ
਍ഀ
	declare @tmp_pm table(਍ഀ
		[Id] int identity(1, 1),਍ഀ
		PMSchedDetailId int਍ഀ
		)਍ഀ
	਍ഀ
	-- to define, is there association? and also RepairItemId਍ഀ
	select 	@btAssociation  = (case when count(RM.[Id]) = 0 then 0 else 1 end),਍ഀ
		@RepairItemId = isnull(S.ItemId, 0)਍ഀ
	from RepairMult RM਍ഀ
	inner join (਍ഀ
		select 	'RI' as Type,਍ഀ
			RI.[Id] as [Id],਍ഀ
			RI.RepairItemId as ItemId਍ഀ
		from WorkOrderReportedIssues RI਍ഀ
		where RI.[Id] = @ItemId਍ഀ
		and RI.WorkOrderId = @OrderId਍ഀ
		and RI.OrgId = @OrgId਍ഀ
		union all਍ഀ
		select 	'PMI' as Type,਍ഀ
			PMI.[Id] as [Id],਍ഀ
			PMI.RepairItemId as ItemId਍ഀ
		from WorkOrderPMItems PMI਍ഀ
		where PMI.[Id] = @ItemId਍ഀ
		and PMI.WorkOrderId = @OrderId਍ഀ
		and PMI.OrgId = @OrgId਍ഀ
		union all਍ഀ
		select 	'II' as Type,਍ഀ
			II.[Id] as [Id],਍ഀ
			II.RepairItemId as ItemId਍ഀ
		from WorkOrderInspectItems II਍ഀ
		where II.[Id] = @ItemId਍ഀ
		and II.WorkOrderId = @OrderId਍ഀ
		and II.OrgId = @OrgId	਍ഀ
		) S਍ഀ
	on RM.RepairId = @RepairId਍ഀ
	and S.ItemId = RM.ItemId਍ഀ
	and S.Type = @vchType	਍ഀ
	group by S.ItemId਍ഀ
਍ഀ
	if isnull(@btChecked, 0) = 0਍ഀ
	begin -- unchecked or nothing਍ഀ
		if isnull(@btAssociation, 0) = 1 -- if the accosiation was then delete it਍ഀ
		begin -- unchecked [delete association]਍ഀ
			-- So when we is removing association between a source and repair ਍ഀ
			-- we must know how many repaires has source. (See in RepairMult table)਍ഀ
			-- if the repair is alone then this link will be deleted (a row in RepairMult) ਍ഀ
			-- and also we set null in ServiceResultId, ServiceCheckId and RepairItemId ਍ഀ
			-- fields in source table਍ഀ
			-- if the repaires are many then we delete only link (the RepairMult row)਍ഀ
			-- for curent repair਍ഀ
			select @countLinks = count([Id])਍ഀ
			from RepairMult ਍ഀ
			where ItemId = isnull(@RepairItemId, 0)਍ഀ
			and OrgId = @OrgId਍ഀ
਍ഀ
			if @countLinks < 1਍ഀ
			begin਍ഀ
				return 0਍ഀ
			end ਍ഀ
			else਍ഀ
			begin਍ഀ
				delete ਍ഀ
				from RepairMult਍ഀ
				where RepairId = @RepairId਍ഀ
				and OrgId = @OrgId਍ഀ
				and ItemId = isnull(@RepairItemId, 0)਍ഀ
			end਍ഀ
਍ഀ
			if @countLinks = 1਍ഀ
			begin਍ഀ
				if @vchType = 'RI'਍ഀ
				begin਍ഀ
					update 	WorkOrderReportedIssues਍ഀ
					set 	ServiceResultId = null,਍ഀ
						ServiceCheckId = null,਍ഀ
						RepairItemId = null਍ഀ
					where 	[Id] = @ItemId਍ഀ
					and 	WorkOrderId = @OrderId਍ഀ
					and 	OrgId = @OrgId਍ഀ
				end਍ഀ
				if @vchType = 'PMI'਍ഀ
				begin਍ഀ
					update 	WorkOrderPMItems਍ഀ
					set 	ServiceResultId = null,਍ഀ
						ServiceCheckId = null,਍ഀ
						RepairItemId = null਍ഀ
					where 	[Id] = @ItemId਍ഀ
					and 	WorkOrderId = @OrderId਍ഀ
					and 	OrgId = @OrgId਍ഀ
				end਍ഀ
				if @vchType = 'II'਍ഀ
				begin਍ഀ
					update 	WorkOrderInspectItems਍ഀ
					set 	ServiceResultId = null,਍ഀ
						ServiceCheckId = null,਍ഀ
						RepairItemId = null਍ഀ
					where 	[Id] = @ItemId਍ഀ
					and 	WorkOrderId = @OrderId਍ഀ
					and 	OrgId = @OrgId਍ഀ
				end਍ഀ
			end਍ഀ
			return 0਍ഀ
		end਍ഀ
		else -- nothing਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
	end਍ഀ
	else਍ഀ
	begin -- checked or nothing਍ഀ
		if isnull(@btAssociation, 0) = 0 -- if the association wasn't then insert it਍ഀ
		begin -- checked [insert association]਍ഀ
			-- Well, first we set ServiceResultId to source's table, ਍ഀ
			-- second, we define has the current source another repaires. ਍ഀ
			-- if yes then we define the RepairItemId from source and create row in ਍ഀ
			-- RepairMult table with defined ItemId. ਍ഀ
			-- if not, we generate a new ItemId and also create a new row for RepairMult.਍ഀ
			-- if the source is PM item then we keep the history for his.਍ഀ
			select @RepairItemId = S.ItemId਍ഀ
			from (	select 	'RI' as Type,਍ഀ
					RI.[Id] as [Id],਍ഀ
					RI.RepairItemId as ItemId਍ഀ
				from WorkOrderReportedIssues RI਍ഀ
				where RI.[Id] = @ItemId਍ഀ
				and RI.WorkOrderId = @OrderId਍ഀ
				and RI.OrgId = @OrgId਍ഀ
				union all਍ഀ
				select 	'PMI' as Type,਍ഀ
					PMI.[Id] as [Id],਍ഀ
					PMI.RepairItemId as ItemId਍ഀ
				from WorkOrderPMItems PMI਍ഀ
				where PMI.[Id] = @ItemId਍ഀ
				and PMI.WorkOrderId = @OrderId਍ഀ
				and PMI.OrgId = @OrgId਍ഀ
				union all਍ഀ
				select 	'II' as Type,਍ഀ
					II.[Id] as [Id],਍ഀ
					II.RepairItemId as ItemId਍ഀ
				from WorkOrderInspectItems II਍ഀ
				where II.[Id] = @ItemId਍ഀ
				and II.WorkOrderId = @OrderId਍ഀ
				and II.OrgId = @OrgId਍ഀ
				) S਍ഀ
			where S.Type = @vchType਍ഀ
			and S.[Id] = @ItemId਍ഀ
਍ഀ
			if isnull(@RepairItemId, 0) = 0਍ഀ
			begin ਍ഀ
				select @RepairItemId = isnull(max(ItemId), 0) + 1਍ഀ
				from RepairMult਍ഀ
				where OrgId = @OrgId਍ഀ
			end਍ഀ
਍ഀ
			insert into [RepairMult](਍ഀ
				[OrgId], ਍ഀ
				[ItemId], ਍ഀ
				[RepairId]਍ഀ
				)਍ഀ
			values(਍ഀ
				@OrgId,਍ഀ
				@RepairItemId,਍ഀ
				@RepairId਍ഀ
				)਍ഀ
			if @vchType = 'RI'਍ഀ
			begin਍ഀ
				update 	WorkOrderReportedIssues਍ഀ
				set 	ServiceResultId = @ServiceResultId,਍ഀ
					RepairItemId = @RepairItemId਍ഀ
				where 	[Id] = @ItemId਍ഀ
				and 	WorkOrderId = @OrderId਍ഀ
				and 	OrgId = @OrgId਍ഀ
			end਍ഀ
			if @vchType = 'PMI'਍ഀ
			begin਍ഀ
				update 	WorkOrderPMItems਍ഀ
				set 	ServiceResultId = @ServiceResultId,਍ഀ
					RepairItemId = @RepairItemId਍ഀ
				where 	[Id] = @ItemId਍ഀ
				and 	WorkOrderId = @OrderId਍ഀ
				and 	OrgId = @OrgId਍ഀ
਍ഀ
				if not exists(select 'true' ਍ഀ
					from EquipPMHistory EH ਍ഀ
					inner join WorkOrderPMItems PMI ਍ഀ
					on 	PMI.[Id] = @ItemId ਍ഀ
					and 	PMI.OrgId = @OrgId਍ഀ
					and 	PMI.WorkOrderId = @OrderId਍ഀ
					and 	EH.WorkOrderid = PMI.WorkOrderId਍ഀ
					and 	EH.OrgId = PMI.OrgId਍ഀ
					and 	EH.PMSchedDetailId = PMI.PMSchedDetailId਍ഀ
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
						getdate(),਍ഀ
						PMI.PMSchedDetailId,਍ഀ
						WO.dmMileage,਍ഀ
						@OrderId਍ഀ
					from 	WorkOrders WO਍ഀ
					inner join WorkOrderPMItems PMI਍ഀ
					on 	WO.[Id] = @OrderId਍ഀ
					and 	WO.OrgId = @OrgId਍ഀ
					and 	PMI.WorkOrderId = WO.[Id]਍ഀ
					and  	PMI.OrgId = WO.OrgId਍ഀ
					and 	PMI.[Id] = @ItemId਍ഀ
				end਍ഀ
				else਍ഀ
				begin -- update history਍ഀ
					update 	EquipPMHistory਍ഀ
					set 	dtDate = getdate(),਍ഀ
						dmUnits = WO.dmMileage਍ഀ
					from 	WorkOrders WO਍ഀ
					inner join WorkOrderPMItems PMI਍ഀ
					on 	WO.[Id] = @OrderId਍ഀ
					and 	WO.OrgId = @OrgId਍ഀ
					and 	PMI.WorkOrderId = WO.[Id]਍ഀ
					and  	PMI.OrgId = WO.OrgId਍ഀ
					and 	PMI.[Id] = @ItemId਍ഀ
					where 	EquipPMHistory.EquipId = WO.Equipid਍ഀ
					and	EquipPMHistory.OrgId = WO.OrgId਍ഀ
					and	EquipPMHistory.PMSchedDetailId = PMI.PMSchedDetailId਍ഀ
					and 	EquipPMHistory.WorkOrderId = PMI.WorkOrderId਍ഀ
				end਍ഀ
			end਍ഀ
			if @vchType = 'II'਍ഀ
			begin਍ഀ
				update 	WorkOrderInspectItems਍ഀ
				set 	ServiceResultId = @ServiceResultId,਍ഀ
					RepairItemId = @RepairItemId਍ഀ
				where 	[Id] = @ItemId਍ഀ
				and 	WorkOrderId = @OrderId਍ഀ
				and 	OrgId = @OrgId਍ഀ
਍ഀ
				-- updated the PM items that associated with current Inspection Item ਍ഀ
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
					set 	ServiceCheckId = 3,਍ഀ
						ServiceResultId = @ServiceResultId,਍ഀ
						RepairItemId = @RepairItemId਍ഀ
					where 	WorkOrderId = @OrderId਍ഀ
					and 	OrgId = @OrgId਍ഀ
					and 	isnull(RepairItemId, 0) = 0਍ഀ
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
					select @i = 1, @N = scope_identity()਍ऀഀ
਍ऀऀऀऀऀⴀⴀ 甀瀀搀愀琀攀 琀栀攀 倀䴀 䠀椀猀琀漀爀礀ഀ
਍ऀऀऀऀऀ眀栀椀氀攀 䀀椀 㰀㴀 䀀一ഀ
਍ऀऀऀऀऀ戀攀最椀渀ഀ
਍ऀऀऀऀऀऀ猀攀氀攀挀琀 䀀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀 㴀 倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀ഀ
਍ऀऀऀऀऀऀ昀爀漀洀 䀀琀洀瀀开瀀洀ഀ
਍ऀऀऀऀऀऀ眀栀攀爀攀 嬀䤀搀崀 㴀 䀀椀ഀ
਍ऀऀഀ
਍ऀऀऀऀऀऀⴀⴀ 椀渀 栀椀猀琀漀爀礀 琀愀戀氀攀 椀猀 欀攀攀瀀椀渀最 琀栀攀 氀愀猀琀 挀栀攀挀欀 漀昀 搀攀琀愀椀氀ഀ
਍ऀऀऀऀऀऀⴀⴀ 椀昀 琀栀攀 爀攀挀漀爀搀 愀氀爀攀愀搀礀 琀栀攀爀攀 琀栀攀渀 攀搀椀琀椀渀最 攀氀猀攀 愀搀搀椀渀最ഀ
਍ऀऀऀऀऀऀ椀昀 渀漀琀 攀砀椀猀琀猀⠀猀攀氀攀挀琀 ✀琀爀甀攀✀ ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀 䔀䠀 ഀ
਍ऀऀऀऀऀऀऀ椀渀渀攀爀 樀漀椀渀 圀漀爀欀伀爀搀攀爀猀 圀伀ഀ
਍ऀऀऀऀऀऀऀ漀渀 ऀ圀伀⸀嬀䤀搀崀 㴀 䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ愀渀搀 ऀ圀伀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀऀ愀渀搀 ऀ䔀䠀⸀圀漀爀欀伀爀搀攀爀椀搀 㴀 圀伀⸀嬀䤀搀崀ഀ
਍ऀऀऀऀऀऀऀ愀渀搀 ऀ䔀䠀⸀䔀焀甀椀瀀䤀搀 㴀 圀伀⸀䔀焀甀椀瀀䤀搀ഀ
਍ऀऀऀऀऀऀऀ愀渀搀 ऀ䔀䠀⸀伀爀最䤀搀 㴀 圀伀⸀伀爀最䤀搀ഀ
਍ऀऀऀऀऀऀऀ愀渀搀 ऀ䔀䠀⸀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀 㴀 䀀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀ഀ
਍ऀऀऀऀऀऀऀ⤀ഀ
਍ऀऀऀऀऀऀ戀攀最椀渀 ⴀⴀ 椀渀猀攀爀琀 栀椀猀琀漀爀礀ഀ
਍ऀऀऀऀऀऀऀ椀渀猀攀爀琀 椀渀琀漀 䔀焀甀椀瀀倀䴀䠀椀猀琀漀爀礀 ⠀ഀ
਍ऀऀऀऀऀऀऀऀ伀爀最䤀搀Ⰰ ഀ
਍ऀऀऀऀऀऀऀऀ䔀焀甀椀瀀䤀搀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ搀琀䐀愀琀攀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ搀洀唀渀椀琀猀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ圀漀爀欀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀऀ⤀ഀ
਍ऀऀऀऀऀऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ圀伀⸀䔀焀甀椀瀀䤀搀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ最攀琀搀愀琀攀⠀⤀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ䀀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ圀伀⸀搀洀䴀椀氀攀愀最攀Ⰰഀ
਍ऀऀऀऀऀऀऀऀ䀀伀爀搀攀爀䤀搀ഀ
਍ऀऀऀऀऀऀऀ昀爀漀洀 ऀ圀漀爀欀伀爀搀攀爀猀 圀伀ഀ
਍ऀऀऀऀऀऀऀ眀栀攀爀攀  ऀ圀伀⸀嬀䤀搀崀 㴀 䀀伀爀搀攀爀䤀搀ഀ
							and 	WO.OrgId = @OrgId਍ഀ
						end਍ഀ
						else਍ഀ
						begin -- update history਍ഀ
							update 	EquipPMHistory਍ഀ
							set 	dtDate = getdate(),਍ഀ
								dmUnits = WO.dmMileage਍ഀ
							from 	WorkOrders WO਍ഀ
							where	WO.[Id] = @OrderId਍ഀ
							and 	WO.OrgId = @OrgId਍ഀ
							and	EquipPMHistory.EquipId = WO.Equipid਍ഀ
							and	EquipPMHistory.OrgId = WO.OrgId਍ഀ
							and	EquipPMHistory.PMSchedDetailId = @PMSchedDetailId਍ഀ
							and 	EquipPMHistory.WorkOrderId = WO.[Id]਍ഀ
						end਍ഀ
		਍ഀ
						select @i = @i + 1਍ഀ
					end਍ഀ
				end਍ഀ
			end਍ഀ
			return 0਍ഀ
		end਍ഀ
		else -- nothing਍ഀ
		begin਍ഀ
			return -1਍ഀ
		end਍ഀ
	end	਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
