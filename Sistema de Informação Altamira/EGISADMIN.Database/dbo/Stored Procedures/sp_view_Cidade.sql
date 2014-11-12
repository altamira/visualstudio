
CREATE PROCEDURE [sp_view_Cidade]
@cd_pais int,
@cd_estado int
AS
  select cd_cidade, nm_cidade
  from cidade
  where cd_pais = @cd_pais
    and cd_estado = @cd_estado

