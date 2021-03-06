SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE sp_GroupDetail
	(
		@Action char(1),
		@OrgId int,
		@Id int,
		@vchDesc varchar(50)
	)
AS
	set nocount on
	
	if @Action = 'D'
	begin
		if not exists(select 'true' from [Groups] where [Id] = @Id and OrgId = @OrgId)
		begin
			return -1
		end
		else
		begin
			if exists(select 'true' from Logins_Groups where GroupId = @Id and OrgId = @OrgId)
			begin
				return 1
			end 
			else
			begin
				delete from Groups_Permissions
				where GroupId = @Id
				and OrgId = @OrgId
	
				delete from Groups
				where [Id] = @Id
				and OrgId = @OrgId
				
				return 0
			end
		end
	end
	if @Action = 'U'
	begin
		if @Id = 0
		begin -- insert
			insert into [Groups]([OrgId], [vchDesc], [CanDelete])
			values(@OrgId, @vchDesc, 1)

			return 0
		end
		else
		begin -- update
			if not exists(select 'true' from [Groups] where [Id] = @Id and OrgId = @OrgId)
			begin
				return -1
			end
			else
			begin
				update 	Groups
				set 	vchDesc = @vchDesc
				where 	[Id] = @Id
				and OrgId = @OrgId

				return 0
			end
		end
	end
	return 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

