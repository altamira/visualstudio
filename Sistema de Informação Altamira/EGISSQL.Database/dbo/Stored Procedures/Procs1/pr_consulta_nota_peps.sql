
CREATE PROCEDURE pr_consulta_nota_peps
@ic_parametro               int, 
@cd_movimento_estoque       int,
@dt_inicial                 datetime,
@dt_final                   datetime,
@nm_fantasia_produto        varchar (30)          
AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Movimentação do Estoque do Produto pela Nota PEPS
                        -- Todos
-------------------------------------------------------------------------------
  begin
    select 
      nep.*,
      isnull(nep.cd_documento_entrada_peps,0),
      p.nm_fantasia_produto, 
      p.nm_produto, 
      f.nm_fantasia_fornecedor
    from Nota_Entrada_PEPS nep
    left outer join produto p on p.cd_produto=nep.cd_produto
    left outer join fornecedor f on f.cd_fornecedor=nep.cd_fornecedor
    left outer join movimento_estoque me on me.cd_movimento_estoque=nep.cd_movimento_estoque
    where 
      ( (nep.cd_movimento_estoque = @cd_movimento_estoque ) or
      (nep.dt_documento_entrada_peps between @dt_inicial and
          @dt_final and @cd_movimento_estoque = 0) )
      and p.nm_fantasia_produto like @nm_fantasia_produto + '%'
    order by me.dt_movimento_estoque, 
             nep.cd_movimento_estoque, 
             nep.cd_documento_entrada_peps
end  

