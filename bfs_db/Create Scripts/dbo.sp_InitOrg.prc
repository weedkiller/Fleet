SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS OFF ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_InitOrg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_InitOrg]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
CREATE   procedure dbo.sp_InitOrg਍ഀ
as਍ഀ
	set nocount on਍ഀ
਍ഀ
	declare @OrgId int਍ഀ
	declare @dtCreated datetime਍ഀ
	declare @RC int਍ഀ
	਍ഀ
	-- Step 1. Organization Information਍ഀ
	begin transaction਍ഀ
	਍ഀ
		select @OrgId = 0, @dtCreated = getdate()਍ഀ
		਍ഀ
		insert into [Orgs](਍ഀ
			[intBWAId], ਍ഀ
			[vchName], ਍ഀ
			[btActive], ਍ഀ
			[dtCreated], ਍ഀ
			[dtCurrentDate], ਍ഀ
			[vchLogo], ਍ഀ
			[btPrint], ਍ഀ
			[vchFullName], ਍ഀ
			[vchAddress1], ਍ഀ
			[vchAddress2], ਍ഀ
			[vchCity], ਍ഀ
			[vchProvince], ਍ഀ
			[vchPostalCode], ਍ഀ
			[vchPhone], ਍ഀ
			[vchPhone2], ਍ഀ
			[vchFax], ਍ഀ
			[vchAcctNumber], ਍ഀ
			[vchContactName], ਍ഀ
			[vchNotes], ਍ഀ
			[vchWeb], ਍ഀ
			[vchEmail],਍ഀ
			[bitTechCanViewHourlyRate]਍ഀ
			)਍ഀ
		values(	1,਍ഀ
			'Demo County', ਍ഀ
			1, ਍ഀ
			@dtCreated, ਍ഀ
			@dtCreated,਍ഀ
			'DemoInc_45px.gif', ਍ഀ
			1, ਍ഀ
			'Demo County Department Of Education', ਍ഀ
			'222 Street Ave', ਍ഀ
			'', ਍ഀ
			'Atlanta', ਍ഀ
			'GA', ਍ഀ
			'30303', ਍ഀ
			'555-555-1212', ਍ഀ
			'', ਍ഀ
			'', ਍ഀ
			'', ਍ഀ
			'Patrick Clements', ਍ഀ
			'', ਍ഀ
			'http://login.bigfleetsystem.com', ਍ഀ
			'',਍ഀ
			1਍ഀ
			)਍ഀ
		select @OrgId = scope_identity()਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 1. An error occurred loading the new organization'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 1. A new organization has been added to database'਍ഀ
	end਍ഀ
	਍ഀ
	-- Step 2. Equipment Types਍ഀ
	begin transaction਍ഀ
	਍ഀ
		insert into [EquipTypes]([OrgId], [vchName], [InspectId], [UnitMeasureId])਍ഀ
		select @OrgId, 'Bus', null, 1਍ഀ
		union all਍ഀ
		select @OrgId, 'Van', null, 3਍ഀ
		union all ਍ഀ
		select @OrgId, 'Truck', null, 2਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 2. An error occurred loading the new types of equipments'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 2. The new equipment types has been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 3. Equipment (Component) Makers Names being used in your company਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [EquipMakes]([OrgId], [vchMakeName])਍ഀ
		select @OrgId, 'All America'਍ഀ
		union all ਍ഀ
		select @OrgId, 'International'਍ഀ
		union all ਍ഀ
		select @OrgId, 'CAT'਍ഀ
		union all ਍ഀ
		select @OrgId, 'ALLISION'਍ഀ
		union all ਍ഀ
		select @OrgId, 'Ford'਍ഀ
		union all ਍ഀ
		select @OrgId, 'Chevrolet'਍ഀ
		union all ਍ഀ
		select @OrgId, 'CUM'਍ഀ
		union all ਍ഀ
		select @OrgId, 'DT'਍ഀ
		union all ਍ഀ
		select @OrgId, 'ALLAMER'਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 3. An error occurred loading the makers names'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 3. The new makers names has been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 4. Models Names for different Types and Makers of Equipments਍ഀ
	begin transaction਍ഀ
਍ഀ
		-- 1.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'All America'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'BUS')਍ഀ
	਍ഀ
		-- 2.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'International'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'BUS')਍ഀ
	਍ഀ
		-- 3.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Ranger')਍ഀ
	਍ഀ
		-- 4.਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Astro')਍ഀ
	਍ഀ
		-- 5.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Van')਍ഀ
	਍ഀ
		-- 6.਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'F350')਍ഀ
	਍ഀ
		-- 7.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Chevrolet'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Van')਍ഀ
	਍ഀ
		-- 8.਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Step Van')਍ഀ
	਍ഀ
		-- 9.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Truck'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Truck')਍ഀ
	਍ഀ
		-- 10.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 0, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Chevrolet'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Truck'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Astro')਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 4. An error occurred loading the Models names'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 4. The new Models names has been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 5. Equipment Departments, Locations, Disposal Methods਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [Departments]([OrgId], [vchName])਍ഀ
		values(@OrgId, 'Transportation')਍ഀ
਍ഀ
		insert into [Locations]([OrgId], [vchName])਍ഀ
		values(@OrgId, 'Default')਍ഀ
਍ഀ
		insert into [EquipDisposalMethods]([OrgId], [vchName], [btActive])਍ഀ
		select @OrgId, 'Sold', 1਍ഀ
		union all਍ഀ
		select @OrgId, 'Salvaged', 1਍ഀ
		union all਍ഀ
		select @OrgId, 'Auctioned', 1਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 5. An error occurred loading the Departments, Locations, Disposal Methods.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 5. New Departments (Locations, Disposal Methods) has been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 6. Additional Custom Fields of Equipments਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [CustFieldDef](਍ഀ
			[OrgId], ਍ഀ
			[DataTypeId], ਍ഀ
			[ComponentTypeId], ਍ഀ
			[NumberColumn], ਍ഀ
			[vchName], ਍ഀ
			[vchNameText], ਍ഀ
			[vchNameLookupTable], ਍ഀ
			[vchNameFieldLookup], ਍ഀ
			[btRequired], ਍ഀ
			[intFieldTypeId], ਍ഀ
			[vchDefault], ਍ഀ
			[vchHelp]਍ഀ
			)਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchCondition', ਍ഀ
			'Condition', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Bus Condition, e.g.: EXCELLENT, GOOD, FAIR, POOR.'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'dmCost', ਍ഀ
			'Cost', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			3, ਍ഀ
			'0.0', ਍ഀ
			'Bus Cost'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			2, ਍ഀ
			'vchColor', ਍ഀ
			'Color', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Bus Color'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'intPassengers', ਍ഀ
			'Passengers', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			2, ਍ഀ
			'0', ਍ഀ
			'Amount of passengers seats at the Bus'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchColor', ਍ഀ
			'Color', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Van Color'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			2, ਍ഀ
			'vchNote', ਍ഀ
			'Note', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchColor', ਍ഀ
			'Color', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Truck Color'਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Truck'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			2, ਍ഀ
			'vchNote', ਍ഀ
			'Note', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipTypes as ET਍ഀ
		where 	DT.vchName = 'Equipment'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Truck'਍ഀ
਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 6. An error occurred loading the Custom Fields for the Equipments.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 6. Custom Fields for the new equipment types have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 7. Equipment Components, Defaults਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [EquipComponentTypes]([OrgId], [vchName])਍ഀ
		select @OrgId, 'Engine'਍ഀ
		union all਍ഀ
		select @Orgid, 'Transmission'਍ഀ
		union all਍ഀ
		select @Orgid, 'Chassis'਍ഀ
਍ഀ
		insert into [EquipComponentDefault](਍ഀ
			[OrgId], ਍ഀ
			[ComponentTypeId], ਍ഀ
			[EquipmentTypeId]਍ഀ
			)਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Transmission'਍ഀ
		union all਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Bus'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Chassis'਍ഀ
		union all਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Van'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Transmission'਍ഀ
		union all਍ഀ
		select 	@OrgId,਍ഀ
			ECT.[Id],਍ഀ
			ET.[Id]਍ഀ
		from EquipTypes as ET, EquipComponentTypes as ECT਍ഀ
		where ET.OrgId = @OrgId and ET.vchName = 'Truck'਍ഀ
		and ECT.OrgId = @OrgId and ECT.vchName = 'Transmission'਍ഀ
਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 7. An error occurred loading the Equipment Components.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 7. Equipment Components have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 8. Components Fields਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [CustFieldDef](਍ഀ
			[OrgId], ਍ഀ
			[DataTypeId], ਍ഀ
			[ComponentTypeId], ਍ഀ
			[NumberColumn], ਍ഀ
			[vchName], ਍ഀ
			[vchNameText], ਍ഀ
			[vchNameLookupTable], ਍ഀ
			[vchNameFieldLookup], ਍ഀ
			[btRequired], ਍ഀ
			[intFieldTypeId], ਍ഀ
			[vchDefault], ਍ഀ
			[vchHelp]਍ഀ
			)਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'EngineModelId', ਍ഀ
			'Model', ਍ഀ
			'EquipModels', ਍ഀ
			'vchModelName', ਍ഀ
			0, ਍ഀ
			8, ਍ഀ
			'0', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchPart', ਍ഀ
			'Part #', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			2, ਍ഀ
			'vchSerial', ਍ഀ
			'Serial #', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Serial number'਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'TransModelId', ਍ഀ
			'Model', ਍ഀ
			'EquipModels', ਍ഀ
			'vchModelName', ਍ഀ
			0, ਍ഀ
			8, ਍ഀ
			'0', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchPart', ਍ഀ
			'Part #', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			2, ਍ഀ
			'vchSerial', ਍ഀ
			'Serial #', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			'Serial number'਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'ChasisModelId', ਍ഀ
			'Model', ਍ഀ
			'EquipModels', ਍ഀ
			'vchModelName', ਍ഀ
			0, ਍ഀ
			8, ਍ഀ
			'0', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Chassis'਍ഀ
		union all਍ഀ
		select	@OrgId,਍ഀ
			DT.[Id], ਍ഀ
			ET.[Id], ਍ഀ
			1, ਍ഀ
			'vchChassis', ਍ഀ
			'Chassis #', ਍ഀ
			null, ਍ഀ
			null, ਍ഀ
			0, ਍ഀ
			1, ਍ഀ
			'N''''', ਍ഀ
			''਍ഀ
		from 	DataTypes as DT, EquipComponentTypes as ET਍ഀ
		where 	DT.vchName = 'Component'਍ഀ
		and	ET.OrgId = @OrgId and ET.vchName = 'Chassis'਍ഀ
਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 8. An error occurred loading the Equipment Components Fields.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 8. Equipment Components Fields have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 9. Models Names for different Types and Makers of Components਍ഀ
	begin transaction਍ഀ
਍ഀ
		-- 1.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'All America'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Engine')਍ഀ
਍ഀ
		-- 2.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'International'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Engine')਍ഀ
਍ഀ
		-- 3.਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '360')਍ഀ
਍ഀ
		-- 4.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'CAT'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '3208')਍ഀ
਍ഀ
		-- 5.਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'C.7')਍ഀ
਍ഀ
		-- 6.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Engine')਍ഀ
਍ഀ
		-- 7.਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Motor')਍ഀ
਍ഀ
		-- 8.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'CUM'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '8.3')਍ഀ
਍ഀ
		-- 9.਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '5.9')਍ഀ
਍ഀ
		-- 10.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'DT'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Engine'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '466')਍ഀ
਍ഀ
		-- 11.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'All America'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Transmission')਍ഀ
਍ഀ
		-- 12.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'International'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Transmission')਍ഀ
਍ഀ
		-- 13.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'ALLISION'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '643')਍ഀ
਍ഀ
		-- 14.਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '545')਍ഀ
਍ഀ
		-- 15.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Transmission')਍ഀ
਍ഀ
		-- 16.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'ALLAMER'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Transmission'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, '545COM')਍ഀ
਍ഀ
		-- 17.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'All America'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Chassis'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Chassis')਍ഀ
਍ഀ
		-- 18.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'International'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Chassis'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Chassis')਍ഀ
਍ഀ
		-- 18.਍ഀ
		insert into [EquipModelType]([OrgId], [MakeId], [btIsComponent], [intTypeId])਍ഀ
		select @OrgId, EM.[Id], 1, ET.[Id]਍ഀ
		from EquipMakes as EM, EquipComponentTypes as ET਍ഀ
		where EM.OrgId = @OrgId and vchMakeName = 'Ford'਍ഀ
		and ET.OrgId = @OrgId and ET.vchName = 'Chassis'਍ഀ
	਍ഀ
		select @RC = scope_identity()਍ഀ
	਍ഀ
		insert into [EquipModels]([OrgId], [TypeId], [vchModelName])਍ഀ
		values(@OrgId, @RC, 'Chassis')਍ഀ
਍ഀ
਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 9. An error occurred loading the Models Names for Components.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 9.  Models Names for Components have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- Step 10. Repair Categories/Items਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [RepairCats]([OrgId], [vchName], [vchDesc])਍ഀ
		select @OrgId, 'Brakes', ''਍ഀ
		union all਍ഀ
		select @OrgId, 'Steering', ''਍ഀ
		union all਍ഀ
		select @OrgId, 'Engine', 'Engine,Battery,Radiator,Belts,Heater,Exhaust'਍ഀ
		union all਍ഀ
		select @OrgId, 'Lights/Instruments/Elec', 'Lights,Fuses,Bulbs,Horn,Alternator'਍ഀ
		union all਍ഀ
		select @OrgId, 'Transmisson', ''਍ഀ
		union all਍ഀ
		select @OrgId, 'Tires', ''਍ഀ
		union all਍ഀ
		select @OrgId, 'Body', 'Wipers,Doors,Glass,Seats,Stop Arms,Mirrors'਍ഀ
		union all ਍ഀ
		select @OrgId, 'Other', 'Bus Supplies'਍ഀ
	਍ഀ
		insert into [RepairItems]([OrgId], [CatId], [vchDesc])਍ഀ
		select @OrgId, RC.[Id], 'Drums'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Valves'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Brake Fluid'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Power Steering'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Steering'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Coolant Filter'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Starter'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Radiator'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Thermostat'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Heater'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Anti-Freeze'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Battery Cable'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Air Filter'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Alternator'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Fuel Filter'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Water Pump'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Fan Belts'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Oil'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Oil Filter'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Switches'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Lights/Instruments/Elec'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Lights'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Lights/Instruments/Elec'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Horn'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Lights/Instruments/Elec'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Transmisson'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Transmisson'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Tran Fluid'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Transmisson'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Tires'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Tires'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Body'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Body'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Other'਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Other'਍ഀ
਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 10. An error occurred loading the Repair Categories/Items.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 10. Repair Categories/Items have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- 11. Schedules of Preventive Maintenances਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [PMSchedules]([OrgId], [vchName])਍ഀ
		select @OrgId, 'Bus Normal PM List'਍ഀ
		union all਍ഀ
		select @OrgId, 'Bus Extended PM List'਍ഀ
		union all਍ഀ
		select @OrgId, 'Truck Normal PM List'਍ഀ
		union all਍ഀ
		select @OrgId, 'Fork Lift Normal PM List'਍ഀ
	਍ഀ
	if @@Error <> 0਍ഀ
	begin਍ഀ
		rollback transaction਍ഀ
		print 'Step 11. An error occurred loading the PM Schedules.'਍ഀ
		return (99)਍ഀ
	end਍ഀ
	else਍ഀ
	begin਍ഀ
		commit transaction਍ഀ
		print 'Step 11.  PM Schedules have been added to database'਍ഀ
	end਍ഀ
਍ഀ
	-- 12. PM Items਍ഀ
	begin transaction਍ഀ
਍ഀ
		insert into [PMServices]([OrgId], [RepairCatId], [vchDesc], [btRequiresRepair])਍ഀ
		select @OrgId, RC.[Id], 'Adjust Valve Clearance', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Air Conditioner Compressor', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Air Filter', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Alignment', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Alternator', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Lights/Instruments/Elec'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Brake Drum Shoe', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Transmission Service', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Transmisson'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Oil/Filter Service', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Engine'਍ഀ
		union all਍ഀ
		select @OrgId, RC.[Id], 'Brake Fluid', 0਍ഀ
		from RepairCats RC਍ഀ
		where RC.OrgId = @OrgId and RC.vchName = 'Brakes'਍ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䈀爀愀欀攀 匀栀漀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀愀瀀Ⰰ 刀漀琀漀爀Ⰰ ☀ 圀椀爀攀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀愀琀愀氀礀琀椀挀 䌀漀渀瘀攀爀琀攀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀栀愀渀最攀 圀椀渀搀猀栀椀攀氀搀 圀椀瀀攀爀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀氀攀愀渀 䘀甀攀氀 䤀渀樀攀挀琀漀爀猀⼀䌀愀爀戀甀爀攀琀漀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀氀甀琀挀栀 䌀礀氀椀渀搀攀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀漀渀琀爀漀氀 䄀爀洀 䰀漀眀攀爀 䈀愀氀氀 䨀漀椀渀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䌀漀漀氀椀渀最 匀礀猀琀攀洀 䘀氀甀猀栀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䐀椀猀挀 䈀爀愀欀攀 䌀愀氀椀瀀攀爀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䐀爀甀洀 䈀爀愀欀攀 䌀礀氀椀渀搀攀爀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䐀爀甀洀 䈀爀愀欀攀 匀栀漀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䔀渀最椀渀攀 䈀攀氀琀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䔀渀最椀渀攀 吀甀渀攀 唀瀀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䔀砀栀愀甀猀琀 倀椀瀀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䘀甀攀氀 䘀椀氀琀攀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䘀甀攀氀 䤀渀樀攀挀琀漀爀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䘀甀攀氀 倀甀洀瀀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀䠀攀愀琀攀爀 䌀漀爀攀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀倀䌀嘀 嘀愀氀瘀攀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀倀漀眀攀爀 匀琀攀攀爀椀渀最 倀甀洀瀀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀匀琀攀攀爀椀渀最✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀愀搀椀愀琀漀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀愀搀椀愀琀漀爀 䠀漀猀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䔀渀最椀渀攀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀挀栀愀爀最攀 䄀⼀䌀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀瀀氀愀挀攀 䈀爀愀欀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀瀀氀愀挀攀 倀愀爀欀椀渀最 䰀椀最栀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀刀漀琀愀琀攀 吀椀爀攀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀椀爀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀匀栀漀挀欀 䄀戀猀漀爀戀攀爀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀匀瀀愀爀欀 倀氀甀最猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀匀瀀爀椀渀最猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀匀琀愀爀琀攀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀匀琀爀甀琀琀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀栀攀爀洀漀猀琀愀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀攀 刀漀搀猀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀匀琀攀攀爀椀渀最✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀洀椀渀最 䈀攀氀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀洀椀渀最 䌀栀愀椀渀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䰀椀最栀琀猀⼀䤀渀猀琀爀甀洀攀渀琀猀⼀䔀氀攀挀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀爀攀猀 愀渀搀 䈀愀氀愀渀挀攀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀椀爀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀吀爀愀渀猀洀椀猀猀椀漀渀 䘀椀氀琀攀爀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀唀渀椀瘀攀爀猀愀氀 䌀嘀 䨀漀椀渀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀圀愀琀攀爀 倀甀洀瀀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 刀䌀⸀嬀䤀搀崀Ⰰ ✀圀栀攀攀氀 䄀氀椀最渀洀攀渀琀✀Ⰰ 　ഀ
਍ऀऀ昀爀漀洀 刀攀瀀愀椀爀䌀愀琀猀 刀䌀ഀ
਍ऀऀ眀栀攀爀攀 刀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 刀䌀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀愀渀猀洀椀猀猀漀渀✀ഀ
਍ഀ
਍ऀऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀倀䴀匀挀栀攀搀䐀攀琀愀椀氀猀崀⠀ഀ
਍ऀऀऀ嬀伀爀最䤀搀崀Ⰰ ഀ
਍ऀऀऀ嬀倀䴀匀挀栀攀搀䤀搀崀Ⰰ ഀ
਍ऀऀऀ嬀倀䴀匀攀爀瘀椀挀攀䤀搀崀Ⰰ ഀ
਍ऀऀऀ嬀唀渀椀琀䴀攀愀猀甀爀攀䤀搀崀Ⰰ ഀ
਍ऀऀऀ嬀椀渀琀䐀愀礀猀崀Ⰰ ഀ
਍ऀऀऀ嬀搀洀唀渀椀琀猀崀ഀ
਍ऀऀऀ⤀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ 㔀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀搀樀甀猀琀 嘀愀氀瘀攀 䌀氀攀愀爀愀渀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㤀　Ⰰ 㠀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀伀椀氀⼀䘀椀氀琀攀爀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㌀　Ⰰ ㈀㔀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ 㔀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀搀樀甀猀琀 嘀愀氀瘀攀 䌀氀攀愀爀愀渀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㐀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䈀爀愀欀攀 䐀爀甀洀 匀栀漀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㌀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䈀爀愀欀攀 䘀氀甀椀搀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㌀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䈀爀愀欀攀 匀栀漀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䐀椀猀挀 䈀爀愀欀攀 䌀愀氀椀瀀攀爀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䐀爀甀洀 䈀爀愀欀攀 䌀礀氀椀渀搀攀爀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㐀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䐀爀甀洀 䈀爀愀欀攀 匀栀漀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㠀　Ⰰ 㜀㔀　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀攀瀀氀愀挀攀 䈀爀愀欀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀倀漀眀攀爀 匀琀攀攀爀椀渀最 倀甀洀瀀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀椀攀 刀漀搀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀椀爀 䌀漀渀搀椀琀椀漀渀攀爀 䌀漀洀瀀爀攀猀猀漀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㌀㘀㔀Ⰰ ㄀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀椀爀 䘀椀氀琀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㈀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀氀椀最渀洀攀渀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀愀瀀Ⰰ 刀漀琀漀爀Ⰰ ☀ 圀椀爀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀愀琀愀氀礀琀椀挀 䌀漀渀瘀攀爀琀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㤀　Ⰰ ㌀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀氀攀愀渀 䘀甀攀氀 䤀渀樀攀挀琀漀爀猀⼀䌀愀爀戀甀爀攀琀漀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀氀甀琀挀栀 䌀礀氀椀渀搀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀　㤀㔀Ⰰ 㐀㔀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀漀漀氀椀渀最 匀礀猀琀攀洀 䘀氀甀猀栀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䔀渀最椀渀攀 䈀攀氀琀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䔀渀最椀渀攀 吀甀渀攀 唀瀀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㠀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䔀砀栀愀甀猀琀 倀椀瀀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀　㤀㔀Ⰰ 㐀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䘀甀攀氀 䘀椀氀琀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䘀甀攀氀 䤀渀樀攀挀琀漀爀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䘀甀攀氀 倀甀洀瀀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䠀攀愀琀攀爀 䌀漀爀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㐀㘀　Ⰰ 㐀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀倀䌀嘀 嘀愀氀瘀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀愀搀椀愀琀漀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀愀搀椀愀琀漀爀 䠀漀猀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀氀琀攀爀渀愀琀漀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀漀渀琀爀漀氀 䄀爀洀 䰀漀眀攀爀 䈀愀氀氀 䨀漀椀渀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀攀挀栀愀爀最攀 䄀⼀䌀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㌀㔀㘀Ⰰ 㠀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀攀瀀氀愀挀攀 倀愀爀欀椀渀最 䰀椀最栀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㌀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀匀瀀愀爀欀 倀氀甀最猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀匀琀愀爀琀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀栀攀爀洀漀猀琀愀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㈀㄀㤀　Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀椀洀椀渀最 䈀攀氀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㈀㄀㤀　Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀椀洀椀渀最 䌀栀愀椀渀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀匀栀漀挀欀 䄀戀猀漀爀戀攀爀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ ㄀　　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀匀瀀爀椀渀最猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㘀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀匀琀爀甀琀琀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㌀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 䘀椀氀琀攀爀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀唀渀椀瘀攀爀猀愀氀 䌀嘀 䨀漀椀渀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㔀㐀　Ⰰ ㈀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀圀栀攀攀氀 䄀氀椀最渀洀攀渀琀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀㠀　Ⰰ 㜀㔀　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀刀漀琀愀琀攀 吀椀爀攀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㄀　㤀㔀Ⰰ 㐀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀椀爀攀猀 愀渀搀 䈀愀氀愀渀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ ㌀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䌀栀愀渀最攀 圀椀渀搀猀栀椀攀氀搀 圀椀瀀攀爀猀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 一唀䰀䰀Ⰰ 㤀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 䔀砀琀攀渀搀攀搀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀圀愀琀攀爀 倀甀洀瀀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ 㔀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀甀挀欀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀搀樀甀猀琀 嘀愀氀瘀攀 䌀氀攀愀爀愀渀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㤀　Ⰰ 㠀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀甀挀欀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀伀椀氀⼀䘀椀氀琀攀爀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㌀　Ⰰ ㈀㔀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀吀爀甀挀欀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㜀㌀　Ⰰ 㔀　　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䘀漀爀欀 䰀椀昀琀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀䄀搀樀甀猀琀 嘀愀氀瘀攀 䌀氀攀愀爀愀渀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ 㤀　Ⰰ 㠀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䘀漀爀欀 䰀椀昀琀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀伀椀氀⼀䘀椀氀琀攀爀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 ऀ䀀伀爀最䤀搀Ⰰ 倀䴀匀⸀嬀䤀搀崀Ⰰ 匀⸀嬀䤀搀崀Ⰰ 唀䴀⸀嬀䤀搀崀Ⰰ ㌀　Ⰰ ㈀㔀　　　⸀　　　　　　　　ഀ
਍ऀऀ昀爀漀洀 ऀ倀䴀匀挀栀攀搀甀氀攀猀 愀猀 倀䴀匀Ⰰ ഀ
਍ऀऀऀ倀䴀匀攀爀瘀椀挀攀猀 愀猀 匀Ⰰ ഀ
਍ऀऀऀ唀渀椀琀䴀攀愀猀甀爀攀猀 愀猀 唀䴀ഀ
਍ऀऀ眀栀攀爀攀 ऀ倀䴀匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀匀⸀瘀挀栀一愀洀攀 㴀 ✀䘀漀爀欀 䰀椀昀琀 一漀爀洀愀氀 倀䴀 䰀椀猀琀✀ഀ
਍ऀऀ愀渀搀ऀ匀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 匀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀ愀渀搀ऀ唀䴀⸀瘀挀栀一愀洀攀 㴀 ✀洀椀氀攀猀✀ഀ
਍ऀऀഀ
਍ഀ
਍ऀ椀昀 䀀䀀䔀爀爀漀爀 㰀㸀 　ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ爀漀氀氀戀愀挀欀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㈀⸀ 䄀渀 攀爀爀漀爀 漀挀挀甀爀爀攀搀 氀漀愀搀椀渀最 琀栀攀 倀䴀 䤀琀攀洀猀⸀✀ഀ
਍ऀऀ爀攀琀甀爀渀 ⠀㤀㤀⤀ഀ
਍ऀ攀渀搀ഀ
਍ऀ攀氀猀攀ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ挀漀洀洀椀琀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㈀⸀  倀䴀 䤀琀攀洀猀 栀愀瘀攀 戀攀攀渀 愀搀搀攀搀 琀漀 搀愀琀愀戀愀猀攀✀ഀ
਍ऀ攀渀搀ഀ
਍ഀ
਍ഀ
਍ऀⴀⴀ ㄀㐀⸀ 䤀渀猀瀀攀挀琀椀漀渀猀Ⰰ 䤀渀猀瀀攀挀琀椀漀渀 䤀琀攀洀猀ഀ
਍ऀ戀攀最椀渀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀椀漀渀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀瘀挀栀一愀洀攀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀䈀甀猀 ⴀ 䴀漀渀琀栀氀礀 匀攀爀瘀椀挀攀 䤀渀猀瀀攀挀琀椀漀渀✀ഀ
਍ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀䌀愀琀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀䤀搀崀Ⰰ 嬀瘀挀栀一愀洀攀崀Ⰰ 嬀琀椀渀琀伀爀搀攀爀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀Ⰰ ㄀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀䈀爀愀欀攀猀✀Ⰰ ㈀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀吀椀爀攀猀✀Ⰰ ㌀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀䘀爀漀渀琀 䔀渀搀✀Ⰰ 㐀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀䐀爀椀瘀攀 吀爀愀椀渀✀Ⰰ 㔀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ ✀䈀漀搀礀✀Ⰰ 㘀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀椀漀渀䤀琀攀洀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀䌀愀琀䤀搀崀Ⰰ 嬀瘀挀栀䐀攀猀挀崀Ⰰ 嬀琀椀渀琀伀爀搀攀爀崀Ⰰ 嬀戀琀䔀渀愀戀氀攀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀琀漀瀀 䄀爀洀 愀渀搀 䌀爀漀猀猀椀渀最 䜀愀琀攀✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀氀愀猀栀攀爀 䰀椀最栀琀猀 愀渀搀 匀琀爀漀戀攀 䰀椀最栀琀猀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀椀爀猀琀 䄀椀搀 䬀椀琀 愀渀搀 䘀椀爀攀 䔀砀琀椀渀最甀椀猀栀攀爀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䈀漀搀礀 䘀氀甀椀搀 䌀氀攀愀渀ⴀ甀瀀 䬀椀琀✀Ⰰ 㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䐀椀猀愀戀氀攀搀 嘀攀栀椀挀氀攀 圀愀爀渀椀渀最 䐀攀瘀椀挀攀猀✀Ⰰ 㔀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀吀甀爀渀 匀椀最渀愀氀猀Ⰰ䰀椀最栀琀猀 愀渀搀 䠀漀爀渀✀Ⰰ 㘀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䐀愀猀栀 䤀渀猀琀爀甀洀攀渀琀猀Ⰰ 䜀愀甀最攀猀 ☀ 匀瀀攀攀搀漀洀攀琀攀爀✀Ⰰ 㜀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀匀愀昀攀琀礀 䐀攀瘀椀挀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀攀爀瘀椀挀攀 䈀爀愀欀攀猀 ⴀ 倀爀椀洀愀爀礀✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀攀爀瘀椀挀攀 䈀爀愀欀攀猀 ⴀ 䈀愀挀欀甀瀀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀倀愀爀欀椀渀最 䈀爀愀欀攀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀倀攀搀愀氀 倀爀攀猀猀甀爀攀 愀渀搀 䌀氀攀愀爀愀渀挀攀✀Ⰰ 㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䄀椀爀 漀爀 䠀礀搀爀愀甀氀椀挀 䠀漀猀攀猀✀Ⰰ 㔀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䄀椀爀 倀爀攀猀猀甀爀攀 漀爀 䠀礀搀爀愀甀氀椀挀 䘀氀甀椀搀✀Ⰰ 㘀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀爀愀欀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀爀漀渀琀 吀椀爀攀猀㨀 吀爀攀愀搀 ⴀⴀ 䌀甀琀猀⼀䌀爀愀挀欀猀✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀吀椀爀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀愀搀 吀椀爀攀猀㨀 吀爀攀愀搀 ⴀⴀ 䌀甀琀猀⼀䌀爀愀挀欀猀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀吀椀爀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀爀攀猀 倀爀漀瀀攀爀氀礀 䤀渀昀氀愀琀攀搀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀吀椀爀攀猀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀瀀椀渀搀氀攀猀 愀渀搀 圀栀攀攀氀 䄀氀椀最渀洀攀渀琀✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䘀爀漀渀琀 䔀渀搀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀吀椀攀 刀漀搀猀 愀渀搀 䐀爀愀最 䰀椀渀欀猀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䘀爀漀渀琀 䔀渀搀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀爀漀渀琀 匀瀀爀椀渀最猀Ⰰ 䌀氀愀洀瀀猀 愀渀搀 匀栀愀挀欀氀攀猀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䘀爀漀渀琀 䔀渀搀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀倀漀眀攀爀 匀琀攀攀爀椀渀最 吀椀最栀琀 愀渀搀 䘀氀甀椀搀 䰀攀瘀攀氀✀Ⰰ 㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䘀爀漀渀琀 䔀渀搀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䜀漀瘀攀爀渀漀爀 倀爀漀瀀攀爀氀礀 匀攀琀 愀渀搀 圀漀爀欀椀渀最✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀甀攀氀 䰀椀渀攀 愀渀搀 吀愀渀欀⠀猀⤀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀甀攀氀 愀渀搀 圀愀琀攀爀 倀甀洀瀀猀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀伀椀氀 愀渀搀 䄀椀爀 䘀椀氀琀攀爀猀✀Ⰰ 㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䴀漀琀漀爀 匀甀瀀瀀漀爀琀猀㨀 䘀爀漀渀琀 愀渀搀 刀攀愀爀✀Ⰰ 㔀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䔀砀栀愀甀猀琀 匀礀猀琀攀洀✀Ⰰ 㘀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀愀渀 䈀攀氀琀⠀猀⤀✀Ⰰ 㜀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䄀氀琀攀爀渀愀琀漀爀 愀渀搀 䈀愀琀琀攀爀礀⠀椀攀猀⤀✀Ⰰ 㠀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀琀愀爀琀攀爀✀Ⰰ 㤀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䔀渀最椀渀攀 伀椀氀 䰀攀瘀攀氀✀Ⰰ ㄀　Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀吀爀愀渀猀洀椀猀猀椀漀渀 䘀氀甀椀搀 䰀攀瘀攀氀✀Ⰰ ㄀㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䌀漀漀氀愀渀琀 䰀攀瘀攀氀 愀渀搀 䠀漀猀攀猀✀Ⰰ ㄀㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀唀渀椀瘀⸀ 䨀漀椀渀琀猀 愀渀搀 䐀⸀ 匀⸀ 䈀攀愀爀椀渀最猀✀Ⰰ ㄀㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀愀爀 匀瀀爀椀渀最猀Ⰰ 䌀氀愀洀瀀猀 愀渀搀 匀栀愀挀欀氀攀猀✀Ⰰ ㄀㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀圀栀攀攀氀㨀 䰀甀最 䈀漀氀琀猀 吀椀最栀琀✀Ⰰ ㄀㔀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䈀甀猀 倀爀漀瀀攀爀氀礀 䰀甀戀爀椀挀愀琀攀搀✀Ⰰ ㄀㘀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䐀爀椀瘀攀 吀爀愀椀渀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀刀攀愀爀 嘀椀攀眀 愀渀搀 䌀爀漀猀猀ⴀ漀瘀攀爀 䴀椀爀爀漀爀猀✀Ⰰ ㄀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䘀攀渀搀攀爀猀Ⰰ 䌀漀眀氀 愀渀搀 䈀甀洀瀀攀爀猀✀Ⰰ ㈀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䐀爀椀瘀攀爀✀✀猀 匀攀愀琀 愀渀搀 匀攀愀琀 䈀攀氀琀✀Ⰰ ㌀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䔀渀琀爀愀渀挀攀 䐀漀漀爀Ⰰ 匀琀攀瀀猀 愀渀搀 匀琀攀瀀眀攀氀氀 䰀椀最栀琀✀Ⰰ 㐀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䔀洀攀爀最攀渀挀礀 䐀漀漀爀⠀猀⤀ 愀渀搀 䈀甀稀稀攀爀⠀猀⤀✀Ⰰ 㔀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䜀氀愀猀猀㨀 䐀漀漀爀猀Ⰰ 圀椀渀搀漀眀猀 愀渀搀 圀椀渀搀猀栀椀攀氀搀✀Ⰰ 㘀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀匀攀愀琀猀㨀 䄀渀挀栀漀爀Ⰰ 唀瀀栀漀氀猀琀攀爀礀 愀渀搀 䌀甀猀栀椀漀渀 䄀琀琀愀挀栀攀搀✀Ⰰ 㜀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀圀椀渀搀猀栀椀攀氀搀 圀椀瀀攀爀 愀渀搀 圀愀猀栀攀爀✀Ⰰ 㠀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀䌀⸀嬀䤀搀崀Ⰰ ✀䌀氀攀愀渀氀椀渀攀猀猀⼀ 䤀渀琀攀爀椀漀爀 漀昀 䈀漀搀礀✀Ⰰ 㤀Ⰰ ㄀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀䌀愀琀猀 䤀䌀ഀ
਍ऀऀ眀栀攀爀攀 䤀䌀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 瘀挀栀一愀洀攀 㴀 ✀䈀漀搀礀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀椀漀渀䤀琀攀洀猀开倀䴀匀挀栀攀搀䐀攀琀愀椀氀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀䤀琀攀洀䤀搀崀Ⰰ 嬀倀䴀匀挀栀攀搀䐀攀琀愀椀氀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䤀䤀⸀嬀䤀搀崀Ⰰ 倀䴀䐀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀椀漀渀䤀琀攀洀猀 䤀䤀Ⰰ 倀䴀匀挀栀攀搀䐀攀琀愀椀氀猀 倀䴀䐀ഀ
਍ऀऀ眀栀攀爀攀 䤀䤀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀䤀⸀䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 䤀䤀⸀瘀挀栀䐀攀猀挀 㴀 ✀䔀渀最椀渀攀 伀椀氀 䰀攀瘀攀氀✀ഀ
਍ऀऀ愀渀搀 倀䴀䐀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀䐀⸀倀䴀匀攀爀瘀椀挀攀䤀搀 椀渀 ⠀ഀ
਍ऀऀऀ猀攀氀攀挀琀 嬀䤀搀崀ഀ
਍ऀऀऀ昀爀漀洀 倀䴀匀攀爀瘀椀挀攀猀ഀ
਍ऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀伀椀氀⼀䘀椀氀琀攀爀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀऀ⤀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䤀䤀⸀嬀䤀搀崀Ⰰ 倀䴀䐀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀椀漀渀䤀琀攀洀猀 䤀䤀Ⰰ 倀䴀匀挀栀攀搀䐀攀琀愀椀氀猀 倀䴀䐀ഀ
਍ऀऀ眀栀攀爀攀 䤀䤀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀䤀⸀䤀渀猀瀀攀挀琀䤀搀 㴀 䀀刀䌀 愀渀搀 䤀䤀⸀瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 䘀氀甀椀搀 䰀攀瘀攀氀✀ഀ
਍ऀऀ愀渀搀 倀䴀䐀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 倀䴀䐀⸀倀䴀匀攀爀瘀椀挀攀䤀搀 椀渀 ⠀ഀ
਍ऀऀऀ猀攀氀攀挀琀 嬀䤀搀崀ഀ
਍ऀऀऀ昀爀漀洀 倀䴀匀攀爀瘀椀挀攀猀ഀ
਍ऀऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀吀爀愀渀猀洀椀猀猀椀漀渀 匀攀爀瘀椀挀攀✀ഀ
਍ऀऀऀ⤀ഀ
਍ഀ
਍ऀ椀昀 䀀䀀䔀爀爀漀爀 㰀㸀 　ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ爀漀氀氀戀愀挀欀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㐀⸀ 䄀渀 攀爀爀漀爀 漀挀挀甀爀爀攀搀 氀漀愀搀椀渀最 琀栀攀 䤀渀猀瀀攀挀琀椀漀渀 䤀琀攀洀猀⸀✀ഀ
਍ऀऀ爀攀琀甀爀渀 ⠀㤀㤀⤀ഀ
਍ऀ攀渀搀ഀ
਍ऀ攀氀猀攀ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ挀漀洀洀椀琀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㐀⸀ 䤀渀猀瀀攀挀琀椀漀渀 愀渀搀 栀椀猀 椀琀攀洀猀 栀愀瘀攀 戀攀攀渀 愀搀搀攀搀 琀漀 搀愀琀愀戀愀猀攀✀ഀ
਍ऀ攀渀搀ഀ
਍ഀ
਍ऀⴀⴀ ㄀㔀⸀ 䤀渀猀瀀攀挀琀椀漀渀 匀挀栀攀搀甀氀攀猀 愀渀搀 栀椀猀 搀攀琀愀椀氀猀ഀ
਍ऀ戀攀最椀渀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀匀挀栀攀搀甀氀攀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀瘀挀栀一愀洀攀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀匀挀栀攀搀甀氀攀 昀漀爀 䴀漀渀琀栀氀礀 䤀渀猀瀀攀挀琀椀漀渀 漀昀 䈀甀猀攀猀✀ഀ
਍ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䤀渀猀瀀攀挀琀匀挀栀攀搀䐀攀琀愀椀氀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀匀挀栀攀搀䤀搀崀Ⰰ 嬀䤀渀猀瀀攀挀琀椀漀渀䤀搀崀Ⰰ 嬀吀愀爀最攀琀䐀愀礀猀伀甀琀崀Ⰰ 嬀䴀椀渀椀洀甀洀䐀愀礀猀伀甀琀崀Ⰰ 嬀䴀愀砀椀洀甀洀䐀愀礀猀伀甀琀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䤀⸀嬀䤀搀崀Ⰰ ㌀　Ⰰ ㈀㐀Ⰰ ㌀㘀ഀ
਍ऀऀ昀爀漀洀 䤀渀猀瀀攀挀琀椀漀渀猀 愀猀 䤀ഀ
਍ऀऀ眀栀攀爀攀 䤀⸀伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 䤀⸀瘀挀栀一愀洀攀 㴀 ✀䈀甀猀 ⴀ 䴀漀渀琀栀氀礀 匀攀爀瘀椀挀攀 䤀渀猀瀀攀挀琀椀漀渀✀ഀ
਍ഀ
਍ऀ椀昀 䀀䀀䔀爀爀漀爀 㰀㸀 　ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ爀漀氀氀戀愀挀欀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㔀⸀ 䄀渀 攀爀爀漀爀 漀挀挀甀爀爀攀搀 氀漀愀搀椀渀最 琀栀攀 䤀渀猀瀀攀挀琀椀漀渀 匀挀栀攀搀甀氀攀猀⸀✀ഀ
਍ऀऀ爀攀琀甀爀渀 ⠀㤀㤀⤀ഀ
਍ऀ攀渀搀ഀ
਍ऀ攀氀猀攀ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ挀漀洀洀椀琀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㔀⸀ 䤀渀猀瀀攀挀琀椀漀渀 匀挀栀攀搀甀氀攀猀 栀愀瘀攀 戀攀攀渀 愀搀搀攀搀 琀漀 搀愀琀愀戀愀猀攀✀ഀ
਍ऀ攀渀搀ഀ
਍ഀ
਍ऀⴀⴀ ㄀㘀⸀ 唀猀攀爀猀 䤀渀昀漀爀洀愀琀椀漀渀 ഀ
਍ऀ戀攀最椀渀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀瘀挀栀䐀攀猀挀崀Ⰰ 嬀䌀愀渀䐀攀氀攀琀攀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀Ⰰ 　ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀䴀愀渀愀最攀爀猀✀Ⰰ ㄀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀唀猀攀爀猀✀Ⰰ ㄀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀䔀瘀攀爀礀漀渀攀✀Ⰰ 　ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ✀匀甀瀀攀爀 䄀搀洀椀渀✀Ⰰ ㄀ഀ
਍ഀ
਍ऀऀⴀⴀ ㄀⸀ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀崀⠀嬀瘀挀栀䘀椀爀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䰀愀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䔀洀愀椀氀崀Ⰰ 嬀瘀挀栀倀愀猀猀崀Ⰰ 嬀戀琀䄀挀琀椀瘀攀崀Ⰰ 嬀䤀渀椀琀椀愀氀猀崀Ⰰ 嬀倀䤀一崀Ⰰ 嬀搀琀䌀爀攀愀琀攀搀崀Ⰰ 嬀䌀爀攀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀搀琀唀瀀搀愀琀攀搀崀Ⰰ 嬀唀瀀搀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀猀愀氀琀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 ✀䄀搀洀椀渀✀Ⰰ ✀䐀攀洀漀䄀搀洀椀渀✀Ⰰ ✀搀攀洀漀愀搀洀椀渀䀀戀椀最昀氀攀攀琀猀礀猀琀攀洀⸀挀漀洀✀Ⰰ ✀㈀㤀㐀䐀㐀㄀㌀䐀㈀㜀㤀　䄀㠀㔀㄀㄀㠀䘀㐀䐀䌀㈀䐀䐀㜀䘀㔀䌀㄀㜀㠀㠀䈀㄀䘀㐀䐀㤀㈀✀Ⰰ ㄀Ⰰ ✀䄀䐀✀Ⰰ ✀㄀㈀㌀㐀㔀✀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ ✀堀娀㌀欀吀䴀䄀㴀✀ഀ
਍ऀഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开唀猀攀爀吀礀瀀攀猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀唀猀攀爀吀礀瀀攀䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ ㄀⤀ ⴀⴀ 愀搀搀 琀攀挀栀渀椀挀椀愀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀ഀ
਍ഀ
਍ऀऀⴀⴀ ㈀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀吀漀洀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀倀爀礀漀爀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀ഀ
਍ऀऀഀ
਍ऀऀⴀⴀ ㌀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀倀愀琀爀椀挀欀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀䌀氀攀洀攀渀琀猀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀ഀ
਍ऀऀഀ
਍ऀऀⴀⴀ 㐀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀䨀漀渀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀嘀椀挀欀攀爀猀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀ഀ
਍ऀऀഀ
਍ऀऀⴀⴀ 㔀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀䄀氀攀砀攀礀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀䜀愀瘀爀椀氀漀瘀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䄀搀洀椀渀椀猀琀爀愀琀漀爀猀✀ഀ
਍ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀匀甀瀀攀爀 䄀搀洀椀渀✀ഀ
਍ഀ
਍ऀऀⴀⴀ 㘀⸀ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀崀⠀嬀瘀挀栀䘀椀爀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䰀愀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䔀洀愀椀氀崀Ⰰ 嬀瘀挀栀倀愀猀猀崀Ⰰ 嬀戀琀䄀挀琀椀瘀攀崀Ⰰ 嬀䤀渀椀琀椀愀氀猀崀Ⰰ 嬀倀䤀一崀Ⰰ 嬀搀琀䌀爀攀愀琀攀搀崀Ⰰ 嬀䌀爀攀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀搀琀唀瀀搀愀琀攀搀崀Ⰰ 嬀唀瀀搀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀猀愀氀琀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 ✀䴀愀渀愀最攀爀✀Ⰰ ✀䐀攀洀漀䴀愀渀愀最攀爀✀Ⰰ ✀搀攀洀漀洀愀渀愀最攀爀䀀戀椀最昀氀攀攀琀猀礀猀琀攀洀⸀挀漀洀✀Ⰰ ✀㈀㤀㐀䐀㐀㄀㌀䐀㈀㜀㤀　䄀㠀㔀㄀㄀㠀䘀㐀䐀䌀㈀䐀䐀㜀䘀㔀䌀㄀㜀㠀㠀䈀㄀䘀㐀䐀㤀㈀✀Ⰰ ㄀Ⰰ ✀䴀䐀✀Ⰰ ✀㄀㈀㌀㐀㔀✀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ ✀堀娀㌀欀吀䴀䄀㴀✀ഀ
਍ऀഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开唀猀攀爀吀礀瀀攀猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀唀猀攀爀吀礀瀀攀䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ ㄀⤀ ⴀⴀ 愀搀搀 琀攀挀栀渀椀挀椀愀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䴀愀渀愀最攀爀猀✀ഀ
਍ഀ
਍ऀऀⴀⴀ 㜀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀䴀椀欀攀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀刀愀洀攀礀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䴀愀渀愀最攀爀猀✀ഀ
਍ഀ
਍ऀऀⴀⴀ 㠀⸀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 䰀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䰀漀最椀渀猀 䰀 ഀ
਍ऀऀ眀栀攀爀攀 瘀挀栀䘀椀爀猀琀一愀洀攀 㴀 ✀圀椀氀氀椀愀洀✀ 愀渀搀 瘀挀栀䰀愀猀琀一愀洀攀 㴀 ✀䴀甀爀瀀栀礀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀䴀愀渀愀最攀爀猀✀ഀ
਍ഀ
਍ऀऀⴀⴀ 㤀⸀ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀崀⠀嬀瘀挀栀䘀椀爀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䰀愀猀琀一愀洀攀崀Ⰰ 嬀瘀挀栀䔀洀愀椀氀崀Ⰰ 嬀瘀挀栀倀愀猀猀崀Ⰰ 嬀戀琀䄀挀琀椀瘀攀崀Ⰰ 嬀䤀渀椀琀椀愀氀猀崀Ⰰ 嬀倀䤀一崀Ⰰ 嬀搀琀䌀爀攀愀琀攀搀崀Ⰰ 嬀䌀爀攀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀搀琀唀瀀搀愀琀攀搀崀Ⰰ 嬀唀瀀搀愀琀攀搀䰀漀最椀渀䤀搀崀Ⰰ 嬀猀愀氀琀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 ✀伀瀀攀爀愀琀漀爀✀Ⰰ ✀䐀攀洀漀伀瀀攀爀愀琀漀爀✀Ⰰ ✀搀攀洀漀漀瀀攀爀愀琀漀爀䀀戀椀最昀氀攀攀琀猀礀猀琀攀洀⸀挀漀洀✀Ⰰ ✀㈀㤀㐀䐀㐀㄀㌀䐀㈀㜀㤀　䄀㠀㔀㄀㄀㠀䘀㐀䐀䌀㈀䐀䐀㜀䘀㔀䌀㄀㜀㠀㠀䈀㄀䘀㐀䐀㤀㈀✀Ⰰ ㄀Ⰰ ✀伀䐀✀Ⰰ ✀㄀㈀㌀㐀㔀✀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ 䀀搀琀䌀爀攀愀琀攀搀Ⰰ ㌀Ⰰ ✀堀娀㌀欀吀䴀䄀㴀✀ഀ
਍ऀഀ
਍ऀऀ猀攀氀攀挀琀 䀀刀䌀 㴀 猀挀漀瀀攀开椀搀攀渀琀椀琀礀⠀⤀ഀ
਍ऀഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开伀爀最猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀伀爀最䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ 䀀伀爀最䤀搀⤀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开唀猀攀爀吀礀瀀攀猀崀⠀嬀唀猀攀爀䤀搀崀Ⰰ 嬀唀猀攀爀吀礀瀀攀䤀搀崀⤀ഀ
਍ऀऀ瘀愀氀甀攀猀⠀䀀刀䌀Ⰰ ㈀⤀ ⴀⴀ 愀搀搀 琀攀挀栀渀椀挀椀愀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀䰀漀最椀渀猀开䜀爀漀甀瀀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀唀猀攀爀䤀搀崀Ⰰ 嬀䜀爀漀甀瀀䤀搀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 䀀刀䌀Ⰰ 䜀⸀嬀䤀搀崀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 ✀唀猀攀爀猀✀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 䜀爀漀甀瀀猀开倀攀爀洀椀猀猀椀漀渀猀⠀伀爀最䤀搀Ⰰ 䜀爀漀甀瀀䤀搀Ⰰ 倀攀爀洀椀猀猀椀漀渀䤀搀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀 愀猀 伀爀最䤀搀Ⰰ ⠀猀攀氀攀挀琀 嬀䤀搀崀 昀爀漀洀 䜀爀漀甀瀀猀 眀栀攀爀攀 伀爀最䤀搀 㴀 䀀伀爀最䤀搀 愀渀搀 瘀挀栀䐀攀猀挀 㴀 䜀⸀瘀挀栀䐀攀猀挀⤀ 愀猀 䜀爀漀甀瀀䤀搀Ⰰ 䜀倀⸀倀攀爀洀椀猀猀椀漀渀䤀搀ഀ
਍ऀऀ昀爀漀洀 䜀爀漀甀瀀猀 䜀ഀ
਍ऀऀ椀渀渀攀爀 樀漀椀渀 䜀爀漀甀瀀猀开倀攀爀洀椀猀猀椀漀渀猀 䜀倀ഀ
਍ऀऀ漀渀 䜀⸀嬀䤀搀崀 㴀 䜀倀⸀䜀爀漀甀瀀䤀搀ഀ
਍ऀऀഀ
਍ऀ椀昀 䀀䀀䔀爀爀漀爀 㰀㸀 　ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ爀漀氀氀戀愀挀欀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㘀⸀ 䄀渀 攀爀爀漀爀 漀挀挀甀爀爀攀搀 氀漀愀搀椀渀最 琀栀攀 唀猀攀爀猀⸀✀ഀ
਍ऀऀ爀攀琀甀爀渀 ⠀㤀㤀⤀ഀ
਍ऀ攀渀搀ഀ
਍ऀ攀氀猀攀ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ挀漀洀洀椀琀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㘀⸀ 唀猀攀爀猀 栀愀瘀攀 戀攀攀渀 愀搀搀攀搀 琀漀 搀愀琀愀戀愀猀攀✀ഀ
਍ऀ攀渀搀ഀ
਍ഀ
਍ऀⴀⴀ ㄀㜀⸀ 伀瀀攀爀愀琀漀爀ᤀ猠 䤀渀猀琀爀甀挀琀椀漀渀猀ഀ
਍ऀ戀攀最椀渀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ഀ
਍ऀऀ椀渀猀攀爀琀 椀渀琀漀 嬀伀瀀攀爀愀琀漀爀䤀渀猀琀爀甀挀琀椀漀渀猀崀⠀嬀伀爀最䤀搀崀Ⰰ 嬀吀礀瀀攀䤀搀崀Ⰰ 嬀瘀挀栀一漀琀攀崀⤀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ㌀Ⰰ ✀吀栀愀渀欀 礀漀甀 昀漀爀 甀猀椀渀最 䐀攀洀漀 䌀漀甀渀琀礀✀✀猀 渀攀眀 眀漀爀欀 漀爀搀攀爀 猀礀猀琀攀洀⸀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ㌀Ⰰ ✀倀氀攀愀猀攀 爀攀洀攀洀戀攀爀 琀漀 最漀 琀栀爀漀甀最栀 琀栀攀 䐀攀瀀愀爀琀甀爀攀 䌀栀攀挀欀ⴀ伀甀琀 瀀爀漀挀攀猀猀 眀栀攀渀 礀漀甀爀 戀甀猀 栀愀猀 戀攀攀渀 猀攀爀瘀椀挀攀搀⸀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 㐀Ⰰ ✀圀栀椀氀攀 琀攀挀栀渀椀挀椀愀渀猀 猀攀爀瘀攀 礀漀甀爀 攀焀甀椀瀀洀攀渀琀 愀琀 礀漀甀爀 搀椀猀瀀漀猀愀氀 愀 猀瀀攀挀椀愀氀 爀漀漀洀 眀栀攀爀攀 礀漀甀 挀愀渀 栀愀瘀攀 愀 爀攀猀琀Ⰰ 眀愀琀挀栀 吀嘀⼀䐀嘀䐀 攀琀挀⸀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 㔀Ⰰ ✀夀漀甀 栀愀瘀攀 爀攀焀甀攀猀琀攀搀 愀 猀瀀愀爀攀 攀焀甀椀瀀洀攀渀琀⸀ 倀氀攀愀猀攀 爀攀愀搀 琀栀攀 昀漀氀氀漀眀椀渀最 椀渀猀琀爀甀挀琀椀漀渀猀 愀戀漀甀琀 猀瀀愀爀攀 攀焀甀椀瀀洀攀渀琀㨀㰀甀氀 琀礀瀀攀㴀∀挀椀爀挀氀攀∀㸀㰀氀椀㸀夀漀甀 眀椀氀氀 渀攀攀搀 琀漀 最漀 琀漀 琀栀攀 昀爀漀渀琀 搀攀猀欀 琀漀 最攀琀 琀栀攀 欀攀礀猀㰀⼀氀椀㸀㰀氀椀㸀䄀氀氀 猀瀀愀爀攀 攀焀甀椀瀀洀攀渀琀 眀椀氀氀 渀攀攀搀 琀漀 戀攀 爀攀琀甀爀渀攀搀 甀瀀漀渀 挀栀攀挀欀ⴀ漀甀琀㰀⼀氀椀㸀㰀氀椀㸀刀攀昀甀攀氀 愀渀搀 琀漀瀀ⴀ漀昀昀 琀栀攀 攀焀甀椀瀀洀攀渀琀 戀攀昀漀爀攀 爀攀琀甀爀渀椀渀最㰀⼀氀椀㸀㰀氀椀㸀匀眀攀攀瀀 椀渀琀攀爀椀漀爀㰀⼀氀椀㸀㰀氀椀㸀倀愀爀欀 椀琀 挀氀漀猀攀 琀漀 眀栀攀爀攀 礀漀甀 昀漀甀渀搀 椀琀 漀渀 琀栀攀 氀漀琀㰀⼀氀椀㸀㰀⼀甀氀㸀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ ㄀Ⰰ ✀吀栀愀渀欀 礀漀甀 昀漀爀 甀猀椀渀最 䐀攀洀漀 䌀漀甀渀琀礀✀✀猀 渀攀眀 眀漀爀欀 漀爀搀攀爀 猀礀猀琀攀洀⸀✀ഀ
਍ऀऀ甀渀椀漀渀 愀氀氀ഀ
਍ऀऀ猀攀氀攀挀琀 䀀伀爀最䤀搀Ⰰ 㠀Ⰰ ✀倀氀攀愀猀攀 爀攀琀甀爀渀 琀栀攀 猀瀀愀爀攀 攀焀甀椀瀀洀攀渀琀猀 欀攀礀猀 琀漀 琀栀攀 昀爀漀渀琀 搀攀猀欀 挀氀攀爀欀⸀✀ഀ
਍ऀऀഀ
਍ऀ椀昀 䀀䀀䔀爀爀漀爀 㰀㸀 　ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ爀漀氀氀戀愀挀欀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㜀⸀ 䄀渀 攀爀爀漀爀 漀挀挀甀爀爀攀搀 氀漀愀搀椀渀最 琀栀攀 伀瀀攀爀愀琀漀爀ᤀ猠 䤀渀猀琀爀甀挀琀椀漀渀猀⸀✀ഀ
਍ऀऀ爀攀琀甀爀渀 ⠀㤀㤀⤀ഀ
਍ऀ攀渀搀ഀ
਍ऀ攀氀猀攀ഀ
਍ऀ戀攀最椀渀ഀ
਍ऀऀ挀漀洀洀椀琀 琀爀愀渀猀愀挀琀椀漀渀ഀ
਍ऀऀ瀀爀椀渀琀 ✀匀琀攀瀀 ㄀㜀⸀ 伀瀀攀爀愀琀漀爀ᤀ猠 䤀渀猀琀爀甀挀琀椀漀渀猀 栀愀瘀攀 戀攀攀渀 愀搀搀攀搀 琀漀 搀愀琀愀戀愀猀攀✀ഀ
਍ऀ攀渀搀ഀ
਍ऀഀ
਍ഀ
਍ⴀⴀ爀漀氀氀戀愀挀欀ഀ
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