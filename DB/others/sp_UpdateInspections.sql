SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

alter procedure sp_UpdateInspections
	(
		@btChecked bit,
		@OrgId int,
		@OrderId int,
		@ItemId int=null,
		@InspectId int
	)
AS
	set nocount on

	declare @tbl table ([Id] int identity(1,1), RepairItemId int)
	declare @tbl2 table (RepairId int)
	declare @IsDelete bit
	declare @i int, @N int

	if isnull(@btChecked, 0) = 0
	begin -- unchecked or nothing
		if exists(select 'true' from WorkOrderInspections where [Id] = isnull(@ItemId, 0) and OrgId = @OrgId)
		begin -- unchecked [delete item and his sub-items]

			-- define all RepairItemIds related to the Inspection
			insert into @tbl(RepairItemId)
			select RepairItemId
			from WorkOrderInspectItems
			where WorkOrderInspectId = isnull(@ItemId, 0)
			and OrgId = @OrgId
			and isnull(RepairItemId, 0) <> 0
			
			-- processing all repairs, if repair has the other sources 
			-- as PM items or Issues then we don't delete this repair
			-- or else we delete records of RepairMult, PartsUsed and
			-- Repairs tables
			select @i = 1, @N = scope_identity()
			while @i <= @N
			begin
				select @IsDelete = 1

				if exists(select 'true' 
					from WorkOrderPMItems PMI
					inner join @tbl tmp
					on PMI.OrgId = @OrgId
					and PMI.WorkOrderId = @OrderId
					and PMI.RepairItemId = tmp.RepairItemId
					and tmp.[Id] = @i
					)
				begin
					select @IsDelete = 0
				end

				if exists(select 'true' 
					from WorkOrderReportedIssues RI
					inner join @tbl tmp 
					on RI.OrgId = @OrgId
					and RI.WorkOrderId = @OrderId
					and RI.RepairItemId = tmp.RepairItemId
					and tmp.[Id] = @i
					)
				begin
					select @IsDelete = 0
				end

				if @IsDelete = 1
				begin -- deleting the relate records
					insert into @tbl2(RepairId)
					select RepairId
					from RepairMult
					where OrgId = @OrgId
					and ItemId in (
						select RepairItemId
						from @tbl
						where [Id] = @i
						)

					delete from RepairMult
					where OrgId = @OrgId
					and ItemId in (
						select RepairItemId
						from @tbl
						where [Id] = @i
						)

					delete from PartsUsed
					where OrgId = @OrgId
					and RepairId in (
						select RepairId
						from @tbl2
						)

					delete from Repairs
					where OrgId = @OrgId
					and [Id] in (
						select RepairId
						from @tbl2
						)

					delete from @tbl
				end
				
				select @i = @i + 1
			end

			-- delete inspection items
			delete from WorkOrderInspectItems
			where [WorkOrderInspectId] = @ItemId
			and WorkOrderId = @OrderId
			and OrgId = @OrgId

			-- delete inspection
			delete from WorkOrderInspections
			where [Id] = @ItemId
			and WorkOrderId = @OrderId
			and OrgId = @OrgId

			return 0
		end
		else -- nothing
		begin
			return -1
		end
	end
	else
	begin -- checked or nothing
		if not exists(select 'true' from WorkOrderInspections where [Id] = isnull(@ItemId, 0) and OrgId = @OrgId)
		begin -- checked [insert item and his sub-items]

			insert into WorkOrderInspections(
				[OrgId], 
				[WorkOrderId], 
				[InspectId],
				[TechId],
				[dtReport],
				[btIsProcessed]
				)
			select	@OrgId,
				@OrderId,
				@InspectId,
				WO.intTechId,
				getdate(),
				0
			from WorkOrders WO
			where [Id] = @OrderId
			and OrgId = @OrgId

			select @ItemId = scope_identity()

			insert into [WorkOrderInspectItems](
				[OrgId], 
				[WorkOrderId], 
				[WorkOrderInspectId], 
				[ItemId], 
				[ServiceResultId], 
				[ServiceCheckId], 
				[RepairItemId])
			select 	@OrgId,
				@OrderId,
				@ItemId,
				II.[Id],
				null,
				null,
				null
			from InspectionItems II
			where II.InspectId = @InspectId
			and II.OrgId = @OrgId
			and II.btEnabled = 1
			order by II.InspectCatId, II.tintOrder asc

			return @ItemId
		end
		else -- nothing
		begin
			return -1
		end
	end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

