SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectWorkOrderListForDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectWorkOrderListForDate]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
CREATE  procedure sp_SelectWorkOrderListForDate਍ഀ
(਍ഀ
		@OrgId int,਍ഀ
		@dtMinDate datetime,਍ഀ
		@dtMaxDate datetime਍ഀ
)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
	਍ഀ
	select 	WO.[Id] as [Id],਍ഀ
		dateadd(d, datediff(d, '', WO.dtScheduled), '') as [Date],਍ഀ
		datepart(dw, WO.dtScheduled) as [WeekDay],਍ഀ
		isnull(E.vchEquipId, '') as vchEquipId,਍ഀ
		convert(varchar, year(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, month(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, day(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, WO.WorkOrderNumber) as vchWorkOrderNumber,਍ഀ
		case when isnull(LT.vchFirstName, '') = '' then '' else LT.vchLastName + ', ' + LT.vchFirstName end as TechName,਍ഀ
		case when isnull(LO.vchFirstName, '') = '' then '' else LO.vchLastName + ', ' + LO.vchFirstName end as OperatorName,਍ഀ
		case when isnull(LO.vchLastName, '') = '' then '' else LO.vchLastName end as OperatorLastName,਍ഀ
		isnull(WOS.vchStatus, 'Unknown') as StatusName,਍ഀ
		isnull(WOS.vchColor, '') as Color,਍ഀ
		isnull(WOOS.vchStatus, '') as OperatorStatusName,਍ഀ
		isnull(WOOS.vchColor, 'lightgrey') as OperatorColor਍ഀ
	from WorkOrders WO਍ഀ
	inner join WorkOrderStatus WOS਍ഀ
	on WO.StatusId <> 2 ਍ഀ
	and WO.StatusId = WOS.[Id]਍ഀ
	and WO.OrgId = @OrgId਍ഀ
	and WO.btIsActive = 1਍ഀ
	and datediff(minute, @dtMinDate, dateadd(d, 1, dateadd(d, datediff(d, '', WO.dtScheduled), ''))) > 0 ਍ഀ
	and datediff(minute, dateadd(d, datediff(d, '', WO.dtScheduled), ''), @dtMaxDate) > 0 ਍ഀ
	left outer join WorkOrderOperatorStatus WOOS਍ഀ
	on WO.OperatorStatusId = WOOS.[Id]਍ഀ
	left outer join Equipments E਍ഀ
	on E.[Id] = WO.EquipId਍ഀ
	and E.OrgId = Wo.OrgId਍ഀ
	left outer join Logins LT਍ഀ
	on WO.intTechid = LT.[Id]਍ഀ
	left outer join Logins LO਍ഀ
	on WO.intOperatorId = LO.[Id]਍ഀ
	union all਍ഀ
	select 	WO.[Id] as [Id],਍ഀ
		dateadd(d, datediff(d, '', WO.dtClosed), '') as [Date],਍ഀ
		datepart(dw, WO.dtClosed) as [WeekDay],਍ഀ
		isnull(E.vchEquipId, '') as vchEquipId,਍ഀ
		convert(varchar, year(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, month(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, day(WO.dtCreated)) + '-' + ਍ഀ
		convert(varchar, WO.WorkOrderNumber) as vchWorkOrderNumber,਍ഀ
		case when isnull(LT.vchFirstName, '') = '' then '' else LT.vchLastName + ', ' + LT.vchFirstName end as TechName,਍ഀ
		case when isnull(LO.vchFirstName, '') = '' then '' else LO.vchLastName + ', ' + LO.vchFirstName end as OperatorName,਍ഀ
		case when isnull(LO.vchLastName, '') = '' then '' else LO.vchLastName end as OperatorLastName,਍ഀ
		isnull(WOS.vchStatus, 'Unknown') as StatusName,਍ഀ
		isnull(WOS.vchColor, '') as Color,਍ഀ
		isnull(WOOS.vchStatus, '') as OperatorStatusName,਍ഀ
		isnull(WOOS.vchColor, 'lightgrey') as OperatorColor਍ഀ
	from WorkOrders WO਍ഀ
	inner join WorkOrderStatus WOS਍ഀ
	on WO.StatusId = 2 ਍ഀ
	and WO.StatusId = WOS.[Id]਍ഀ
	and WO.OrgId = @OrgId਍ഀ
	and WO.btIsActive = 1਍ഀ
	and datediff(minute, @dtMinDate, dateadd(d, 1, dateadd(d, datediff(d, '', WO.dtClosed), ''))) > 0 ਍ഀ
	and datediff(minute, dateadd(d, datediff(d, '', WO.dtClosed), ''), @dtMaxDate) > 0 ਍ഀ
	left outer join WorkOrderOperatorStatus WOOS਍ഀ
	on WO.OperatorStatusId = WOOS.[Id]਍ഀ
	left outer join Equipments E਍ഀ
	on E.[Id] = WO.EquipId਍ഀ
	and E.OrgId = Wo.OrgId਍ഀ
	left outer join Logins LT਍ഀ
	on WO.intTechid = LT.[Id]਍ഀ
	left outer join Logins LO਍ഀ
	on WO.intOperatorId = LO.[Id]਍ഀ
	order by vchWorkOrderNumber asc਍ഀ
਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
