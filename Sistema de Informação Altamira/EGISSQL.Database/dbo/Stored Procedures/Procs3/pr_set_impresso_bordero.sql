
CREATE PROCEDURE pr_set_impresso_bordero

@cd_bordero int,
@ic_impresso char(1)

AS

  update
    Bordero
  set
    ic_impresso = @ic_impresso
  where
    cd_bordero = @cd_bordero
  
