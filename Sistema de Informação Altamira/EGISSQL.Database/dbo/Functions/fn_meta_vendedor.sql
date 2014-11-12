
Create FUNCTION fn_meta_vendedor 
 (@cd_vendedor          int, 
  @dt_inicial           datetime,
  @dt_final             datetime,
  @cd_categoria_produto int,
  @cd_ano               int = 0)
-----------------------------------------------------------------------------------------
--fn_meta_vendedor
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2006
-----------------------------------------------------------------------------------------
--Stored Procedure         : Microsoft SQL Server 2000
--Banco de Dados           : EgisSql ou EgisAdmin
--Autor                    : Carlos Cardoso Fernandes
--Data                     : 13.03.2006
--Objetivo                 : Busca o Valor da Meta para o Vendedor conforme parâmetros
--Atualização              : 
------------------------------------------------------------------------------------------
RETURNS Float
AS
BEGIN

  --select * from meta_vendedor

  declare @vl_meta_vendedor float

  set @vl_meta_vendedor = 0

  if @cd_ano>0 
  begin

    select
      @vl_meta_vendedor = sum ( isnull(vl_meta_categoria,0) )
    from
      Meta_Vendedor
    where
      cd_vendedor              = @cd_vendedor and
      cd_categoria_produto     = case when @cd_categoria_produto = 0 then cd_categoria_produto else @cd_categoria_produto end and
      year(dt_inicial_validade_meta) =@cd_ano and
      year(dt_final_validade_meta)   =@cd_ano      
  end
  else
    begin
      select
        @vl_meta_vendedor = sum ( isnull(vl_meta_categoria,0) )
      from
        Meta_Vendedor
      where
        cd_vendedor              = @cd_vendedor and
        cd_categoria_produto     = case when @cd_categoria_produto = 0 then cd_categoria_produto else @cd_categoria_produto end and
        dt_inicial_validade_meta >=@dt_inicial and
       dt_final_validade_meta   <=@dt_final      
     end

  if @vl_meta_vendedor is null
     set @vl_meta_vendedor = 0

  RETURN(@vl_meta_vendedor)

END

