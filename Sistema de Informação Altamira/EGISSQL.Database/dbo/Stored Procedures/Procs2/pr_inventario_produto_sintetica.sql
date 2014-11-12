
---------------------------------------------------
CREATE PROCEDURE  pr_inventario_produto_sintetica
---------------------------------------------------
--GBS - Global Business Solution	             2005
---------------------------------------------------

--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Inventário por Produto Simplificada
--Data             : 29.12.2005
--Atualizado       : 
---------------------------------------------------------------------------------
@cd_grupo_produto     int = 0,
@cd_produto           int = 0, 
@cd_fase_produto      int = 0,
@cd_status_produto    int = 1
AS

--Verifica a Fase do Produto e faz a busca da Fase do Parâmetro_Comercial

if @cd_fase_produto = 0 
begin
  select @cd_fase_produto = isnull(cd_fase_produto,0)
  from
    Parametro_Comercial
  where
    cd_empresa = dbo.fn_empresa()
end


  select   
    gp.nm_grupo_produto                         as 'Grupo',
    p.cd_produto,
    dbo.fn_mascara_produto(p.cd_produto) 	    	as 'Codigo',
    p.nm_fantasia_produto                       as 'Fantasia',
    p.nm_produto                                as 'Descricao',
    f.nm_fase_produto                           as 'Fase',
    um.sg_unidade_medida                        as 'Unidade',
    dbo.fn_getlocalizacao_produto(p.cd_produto) as 'Endereco',
    isnull(ps.qt_saldo_atual_produto,0)         as 'Saldo',
    '     '                                     as 'Contagem',
    isnull(pc.vl_custo_produto,0)               as 'Custo'
  from 
    Produto p
    left outer join Produto_saldo  ps on ps.cd_produto       = p.cd_produto and
                                         ps.cd_fase_produto  = @cd_fase_produto 
    left outer join Unidade_medida um on um.cd_unidade_medida=p.cd_unidade_medida
    left outer join Grupo_Produto  gp on gp.cd_grupo_produto =p.cd_grupo_produto
    left outer join Fase_produto   f  on f.cd_fase_produto   =ps.cd_fase_produto
    left outer join Produto_Custo pc  on pc.cd_produto        =p.cd_produto
  where 
    p.cd_grupo_produto = case when @cd_grupo_produto  = 0 then p.cd_grupo_produto  else @cd_grupo_produto  end and
    p.cd_produto       = case when @cd_produto        = 0 then p.cd_produto        else @cd_produto        end and
    p.cd_status_produto= case when @cd_status_produto = 0 then p.cd_status_produto else @cd_status_produto end 
  order by 
    gp.nm_grupo_produto, 
    --p.cd_mascara_produto,
    p.nm_produto

