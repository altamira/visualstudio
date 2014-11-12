




--pr_Consulta_Produto
-------------------------------------------------------------------------------------------
-- GBS 
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta dos Produtos
-- Data             : 13.03.2002
-- Atualizado       : 10.05.2002
-- @nm_produto      : Descrição de Produtos
-- Mudado: - Trazer Sigla da Unidade_Medida
-- Daniel C. Neto - 24/07/2002
------------------------------------------------------------------------------------------

CREATE      PROCEDURE [dbo].[pr_Consulta_produto]
@ic_parametro int,
@nm_Produto varchar (40),
@cd_produto integer,
@cd_fase int

AS
if @ic_parametro = 1
begin
    if @cd_produto = 0 
    begin
        select
          p.cd_produto,
          p.cd_mascara_produto,
          p.nm_produto,
          p.nm_fantasia_produto,
          p.nm_marca_produto,
          p.qt_espessura_produto,
          p.qt_largura_produto,
          p.qt_peso_liquido,
          p.qt_peso_bruto,
          p.qt_comprimento_produto,
          p.cd_status_produto,
          s.nm_status_produto, ic_kogo_produto,
          p.cd_grupo_produto,
          g.nm_grupo_produto,
          p.cd_unidade_medida,
          u.nm_unidade_medida,
          u.sg_unidade_medida 
        from produto p
        left outer join status_produto s
        on p.cd_status_produto = s.cd_status_produto
        left outer join unidade_medida u
        on p.cd_unidade_medida = u.cd_unidade_medida
        left outer join grupo_produto g
        on p.cd_grupo_produto = g.cd_grupo_produto
          where  (p.nm_fantasia_produto like @nm_produto + '%') or
                 (@nm_produto = '') 
        order by    
          p.nm_fantasia_produto
    end
    if @cd_produto <> 0 
    begin
        select
          p.cd_produto,
          p.cd_mascara_produto,
          p.nm_produto,
          p.nm_fantasia_produto,
          p.nm_marca_produto,
          p.qt_espessura_produto,
          p.qt_largura_produto,
          p.qt_peso_liquido,
          p.qt_peso_bruto,
          p.qt_comprimento_produto,
          p.cd_status_produto,
          s.nm_status_produto, ic_kogo_produto,
          p.cd_grupo_produto,
          g.nm_grupo_produto,
          p.cd_unidade_medida,
          u.nm_unidade_medida,
          u.sg_unidade_medida 
        from produto p
        left outer join status_produto s
        on p.cd_status_produto = s.cd_status_produto
        left outer join unidade_medida u
        on p.cd_unidade_medida = u.cd_unidade_medida
        left outer join grupo_produto g
        on p.cd_grupo_produto = g.cd_grupo_produto
          where  (p.cd_produto = @cd_produto )
        order by    
          p.nm_fantasia_produto
    end
end
if @ic_parametro = 2
begin
    if @cd_produto = 0
    begin
        select
          p.cd_produto,
          p.cd_mascara_produto,
          p.nm_produto,
          p.nm_fantasia_produto,
          p.nm_marca_produto,
          p.qt_espessura_produto,
          p.qt_largura_produto,
          p.qt_peso_liquido,
          p.qt_peso_bruto,
          p.qt_comprimento_produto,
          sd.qt_saldo_reserva_produto,sd.qt_saldo_atual_produto,
          f.cd_fase_produto, f.nm_fase_produto,
          p.cd_status_produto,
          s.nm_status_produto, ic_kogo_produto,
          p.cd_grupo_produto,
          g.nm_grupo_produto,
          p.cd_unidade_medida,
          u.nm_unidade_medida,
          u.sg_unidade_medida 
        from
          produto p
        left outer join status_produto s
        on p.cd_status_produto = s.cd_status_produto
        left outer join unidade_medida u
        on p.cd_unidade_medida = u.cd_unidade_medida
        left outer join grupo_produto g
        on p.cd_grupo_produto = g.cd_grupo_produto
        left outer join produto_saldo sd
        on p.cd_produto = sd.cd_produto
        left outer join fase_produto f
        on sd.cd_fase_produto = f.cd_fase_produto
          where (p.nm_fantasia_produto like @nm_produto + '%') or
                (@nm_produto = '')
        order by
          p.nm_fantasia_produto
    end
    if @cd_produto <> 0
    begin
        select
          p.cd_produto,
          p.cd_mascara_produto,
          p.nm_produto,
          p.nm_fantasia_produto,
          p.nm_marca_produto,
          p.qt_espessura_produto,
          p.qt_largura_produto,
          p.qt_peso_liquido,
          p.qt_peso_bruto,
          p.qt_comprimento_produto,
          sd.qt_saldo_reserva_produto,
          sd.qt_saldo_atual_produto,
          f.cd_fase_produto, f.nm_fase_produto,
          p.cd_status_produto,
          s.nm_status_produto, ic_kogo_produto,
          p.cd_grupo_produto,
          g.nm_grupo_produto,
          p.cd_unidade_medida,
          u.nm_unidade_medida,
          u.sg_unidade_medida 
        from
          produto p
        left outer join status_produto s
        on p.cd_status_produto = s.cd_status_produto
        left outer join unidade_medida u
        on p.cd_unidade_medida = u.cd_unidade_medida
        left outer join grupo_produto g
        on p.cd_grupo_produto = g.cd_grupo_produto
        left outer join produto_saldo sd
        on p.cd_produto = sd.cd_produto

        left outer join fase_produto f
        on sd.cd_fase_produto = f.cd_fase_produto
          where (p.cd_produto = @cd_produto )
        order by
          p.nm_fantasia_produto
    end
end






