
-------------------------------------------------------------------------------
--pr_processo_alteracao_nome_fantasia_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Alteração do Nome Fantasia do Produto
--Data             : 22.08.2006
--Alteração        : 25/08/06 - Otimização de código, incluído tabelas 
--                   Ordem_montagem_item e Consulta_itens
--Alteração        : 05/02/07 - Alterando somente o produto selecionado e não 
--                   todos que tenham a mesma fantasia - Anderson
------------------------------------------------------------------------------
create procedure pr_processo_alteracao_nome_fantasia_produto
@ic_parametro             int         = 0,
@cd_produto               int         = 0,
@nm_fantasia_produto      varchar(30) = '',
@nm_novo_fantasia_produto varchar(30) = '',
@cd_usuario               int         = 0,
@cd_produto_alteracao     int         = 0


as


--Verifica se foi passado o código do produto
if @cd_produto>0 and @nm_fantasia_produto=''
begin
  select @nm_fantasia_produto = isnull(nm_fantasia_produto,'')
  from
   Produto
  where
    cd_produto = @cd_produto
end

--Gera a Inclusão do Registro na Tabela : Produto_Alteracao_Fantasia

if @ic_parametro=1
begin
  declare @Tabela		     varchar(50)  

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Produto_Alteracao_Fantasia' as varchar(50))

  -- campo chave utilizando a tabela de códigos
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_produto_alteracao', @codigo = @cd_produto_alteracao output
	
  while exists(Select top 1 'x' from produto_alteracao_fantasia where cd_produto_alteracao = @cd_produto_alteracao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_produto_alteracao', @codigo = @cd_produto_alteracao output	     
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_produto_alteracao, 'D'
  end
	
  --Insert na Tabela Produto Alteração

  insert into Produto_Alteracao_Fantasia
    (
    cd_produto_alteracao,
    cd_produto,
    nm_fantasia_produto,
    nm_novo_fantasia_produto,
    nm_obs_produto_alteracao,
    cd_usuario,
    dt_usuario,
    dt_alteracao_produto )

  select
    @cd_produto_alteracao,
    @cd_produto,
    @nm_fantasia_produto,
    @nm_novo_fantasia_produto,
    'Alteração Manual pelo Usuário',
    @cd_usuario,
    getdate(),
    getdate()


  --Liberação do Código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_produto_alteracao, 'D'
 
end

--Verifica se foi passado o nome fantasia do produto

if @nm_novo_fantasia_produto<>'' and @nm_fantasia_produto<>''
begin

  declare @SQL varchar(500)
  declare @Tabela_Alt varchar(50)
  declare @cd_chave int
  declare @filtro varchar(5000)
   
  if @cd_produto > 0
  begin
    set @filtro = ' where nm_fantasia_produto = ' + Quotename(@nm_fantasia_produto,'''') + ' and cd_produto = ' + cast(@cd_Produto as varchar)
  end
  else
  begin
    set @filtro = ' where nm_fantasia_produto = ' + Quotename(@nm_fantasia_produto,'''')
  end

  select 
    identity(int, 1,1) as chave, 
    'update ' + t.name + ' set nm_fantasia_produto = ' + Quotename(@nm_novo_fantasia_produto,'''') + 
    @filtro as comando,
    t.name as tabela
  into #TabelaModificada
  from 
    sysobjects t left outer join
    syscolumns c on t.id = c.id

  where
   t.xtype = 'U' and c.name = 'nm_fantasia_produto' and
   -- Coloque as tabelas a serem alteradas aqui!
   t.name in ('Produto','consulta_item_composicao','Pedido_Venda_Item','pedido_venda_composicao', 'Contrato_Fornecimento_Item',
              'Nota_Saida_Item','Pedido_Compra_Item','Pedido_Importacao_Item','Nota_Saida_Entrada_Item','Ordem_Montagem_Item','Consulta_Itens')


  while exists ( select top 1 'x' from #TabelaModificada )
  begin
    select top 1 
      @cd_chave = chave,
      @SQL = comando,
      @Tabela_Alt = tabela
    from #TabelaModificada

    --print(@SQL)

    exec(@SQL)

    print('Modificado ' + @Tabela_Alt)

    delete from #TabelaModificada where chave = @cd_chave

  end    

  if @cd_produto_alteracao <> 0 
    update Produto_Alteracao_Fantasia
    set dt_alteracao_produto = GetDate()
    where cd_produto_alteracao = @cd_produto_alteracao

end



