SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectPMServicesList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectPMServicesList]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
CREATE  procedure sp_SelectPMServicesList਍ഀ
	(਍ഀ
		@OrgId int਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
਍ഀ
	select 	PM.[Id], ਍ഀ
		PM.RepairCatId, ਍ഀ
		RC.vchName as CatName, ਍ഀ
		PM.vchDesc as ServiceName਍ഀ
	from PMServices PM਍ഀ
	inner join RepairCats RC਍ഀ
	on PM.OrgId = @OrgId਍ഀ
	and PM.RepairCatId = RC.[Id]਍ഀ
	and PM.OrgId = RC.OrgId਍ഀ
	order by RC.[Id] asc, PM.vchDesc asc਍ഀ
਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
