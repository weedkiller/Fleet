SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectInstructionTypes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectInstructionTypes]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
create procedure sp_SelectInstructionTypes਍ഀ
as਍ഀ
	set nocount on਍ഀ
਍ഀ
	select 	[Id],਍ഀ
		vchName਍ഀ
	from OperatorInstructionTypes਍ഀ
	order by vchName asc਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
