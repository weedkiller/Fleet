SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectRepairCatsList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectRepairCatsList]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
create procedure sp_SelectRepairCatsList਍ഀ
	(਍ഀ
		@OrgId int਍ഀ
	)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
਍ഀ
	select 	[Id],਍ഀ
		vchName,਍ഀ
		isnull(vchDesc, '')਍ഀ
	from RepairCats਍ഀ
	where OrgId = @OrgId਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
