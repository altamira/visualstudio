
--------------------------------------------------------------------------------
--pr_valida_exclusao_campo
--------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA                                     2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server  2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Validar Exclusao de Campo
--Data			: 12/03/2004
--                      : 09/08/2004 - Tirado da verificação a tabela Nota_Saida - Daniel C. Neto.
--                      : 03/09/2004 - Tirado da verificação a tabela Dipi_Destinatario - Daniel C. Neto.
--                      : 08/11/2004 - Tirado verificação da tabela Cliente_Historico _ daniel C. Neto.
--                      : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 09.10.2007 - Verificação da Procedure - Carlos Fernandes
----------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_valida_exclusao_campo

@campo              varchar(40),
@cd_valor           int,
@nm_tabela_exclusao varchar(60)

as

 declare @SQL       varchar(8000)
 declare @nm_tabela varchar(60)
 declare @cd_chave  int

select 
  identity(int, 1,1) as cd_chave,
  tab.ds_tabela as 'nm_tabela',
  ' Select top 1 ''x'' from ' + t.name as instrucao

--' x where ' + + 'x.' + c.name + ' = ' +
-- 'c.' + c.name  
into #TabelaRelacionada
from 
  sysobjects t inner join
  syscolumns c on t.id = c.id inner join
  EGISADMIN.dbo.Tabela tab on tab.nm_tabela = t.name
where c.name = @campo
and t.xtype = 'U' and t.name <> @nm_tabela_exclusao
and t.name <> 'Item_Projeto'      -- Colocado temporariamente por causa de problemas de Modelagem. Campo cd_produto é um char(15)
and t.name <> 'Consulta_Itens'    -- Colocado temporariamente por causa de problemas de Modelagem. Campo cd_produto é um varchar(
and t.name <> 'Nota_Saida'        -- Colocado temporariamente por causa de problemas de Modelagem. Campo cd_cliente deveria ter o nome de cd_destinatario.
and t.name <> 'Dipi_Destinatario' -- Colocado temporariamente por causa de problemas de Modelagem. Campo cd_cliente deveria ter o nome de cd_destinatario.
and t.name <> 'Cliente_Historico' -- Tirado a pedido do Elias em 08/11/2004
and t.name <> 'Produto_Custo'     -- Tirado a pedido do Márcio em 15/06/2005
and t.name <> 'Produto_Saldo'     -- Tirado a pedido do Márcio em 15/06/2005
and t.name <> 'Evolucao_Consumo'  -- Tirado Carlos - 31.03.2009

while exists ( select 'x' from #TabelaRelacionada)
begin
  select top 1 
    @SQL       = instrucao,
    @cd_chave  = cd_chave,
    @nm_tabela = nm_tabela
  from
    #TabelaRelacionada
  order by cd_chave


  set @SQL = 'if exists ( ' + @SQL + ' where ' + @campo + ' = ' + cast(@cd_valor as varchar(40)) +
             ' ) raiserror( ''Atenção, não foi possível excluir devido a existência deste registro em ' + 
             rtrim(ltrim(@nm_tabela)) +'''' + ',16,1)'

  
--  print(@SQL)

  exec(@SQL)

  if @@ERROR <> 0
    return  
             
  delete from #TabelaRelacionada where cd_chave = @cd_chave  
  
end

--select * from #TabelaRelacionada

