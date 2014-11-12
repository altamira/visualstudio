
--------------------------------------------------------------------------------------------------
--sp_helptext fn_composicao_processo_padrao
--------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2007
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Carlos Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Retornar a composição do processo de padrão
--Data			: 19.12.2007
--Alteração		: 19.12.2007
--Desc. Alteração	: Ajustes - Carlos Fernandes
-- 21.12.2007           : Ordem/Complemento - Carlos Fernandes
-- 03.06.2008 - Ajuste do Novo flag do Processo Padrão para cálculo de custo - Carlos Fernandes
--------------------------------------------------------------------------------------------------

CREATE FUNCTION fn_composicao_processo_padrao
  (@cd_processo int)
RETURNS 
  @Composicao_Produto TABLE 
  (cd_processo           int, 
   cd_processo_padrao    int,
--   cd_ordem_composicao   int,
   cd_produto            int,
   qt_produto_composicao float,
   cd_fase_produto       int
   )

AS

BEGIN

  -- criar a tabela temporária na memória

  declare @tmpArvoreProdutoComposicao table 
  ( cd_processo           int,
    cd_processo_padrao    int,
--    cd_ordem_composicao   int,
    cd_produto            int,
    qt_produto_composicao float, 
    cd_fase_produto       int,   
    verificada            char(1) )

  -- declarar as variáveis

  declare @cd_processo_padrao  int
  declare @qt_processo         float
  declare @cd_produto          int
  declare @cd_fase_produto     int
  declare @lsair_loop          char(1)
  declare @ncd_processo        int
  declare @ncd_processo_padrao int
  declare @ncd_produto         int
  declare @cd_ordem_composicao int


  --fase do parâmetro

  select 
    @cd_fase_produto = isnull(cd_fase_produto,0)
  from
    parametro_comercial
  where
   cd_fase_produto = dbo.fn_empresa()


  --Processo Padrão Principal 

  --select * from processo_padrao

  select 
    top 1 
    @cd_processo_padrao = isnull(pp.cd_processo_padrao   ,0),
    @cd_ordem_composicao=1,
    @qt_processo        = isnull(pp.qt_processo_padrao   ,1),
    @cd_produto         = isnull(p.cd_produto            ,0),
    @cd_fase_produto    = case when isnull(p.cd_fase_produto_baixa,0)>0
                            then
                               isnull(p.cd_fase_produto_baixa,0)
                            else
                               @cd_fase_produto
                            end
                          
  from
    processo_padrao pp                    with (nolock) 
    left outer join produto_producao  pop with (nolock) on pop.cd_processo_padrao = pp.cd_processo_padrao
    left outer join produto p             with (nolock) on p.cd_produto           = pop.cd_produto
  where 
    pp.cd_processo_padrao = @cd_processo

--select * from produto_producao

  -- inserir o registro do produto principal

  insert into @tmpArvoreProdutoComposicao
  values ( @cd_processo, @cd_processo_padrao, @cd_produto, @qt_processo,@cd_fase_produto,'S' )

  -- carregar os filhos do produto pai-de-todos 
  -- select * from processo_padrao_produto

  insert into
     @tmpArvoreProdutoComposicao
  select
     @cd_processo,
     pp.cd_processo_padrao,
     ppc.cd_produto,
     ppc.qt_produto_processo,
     ppc.cd_fase_produto,
     'N'            as verificada
  from
    processo_padrao_produto ppc      with (nolock)
    inner join produto_producao  pop with (nolock) on pop.cd_produto         = ppc.cd_produto 
                                                    --and pop.cd_processo_padrao = ppc.cd_processo_padrao 
    inner join processo_padrao   pp  with (nolock) on pp.cd_processo_padrao  = pop.cd_processo_padrao

--select * from produto_producao

  where
    ppc.cd_processo_padrao = @cd_processo
    and isnull(pp.ic_custo_processo_padrao,'S')='S'
  order by
    1

  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado

  while ( @lsair_loop = 'N' ) begin

     declare crFilhos cursor for
        select cd_processo, 
               cd_processo_padrao,
               cd_produto
        from @tmpArvoreProdutoComposicao
        where verificada = 'N'

     open crFilhos

     FETCH NEXT FROM crFilhos
        INTO @ncd_processo, 
             @ncd_processo_padrao,
             @ncd_produto
 
     if @@FETCH_STATUS = 0 begin

        --select * from processo_padrao_produto

        -- inserir na tabela temporária os filhos do produto atual

        insert into
           @tmpArvoreProdutoComposicao
        select
           @cd_processo,
           pop.cd_processo_padrao,
           ppp.cd_produto,
           ppp.qt_produto_processo,
           ppp.cd_fase_produto,
           'N'    as verificada
        from
           processo_padrao_produto      ppp with (nolock)          
           inner join produto_producao  pop with (nolock) on pop.cd_produto             = ppp.cd_produto
                                                             and pop.cd_processo_padrao = ppp.cd_processo_padrao
        where
            ppp.cd_processo_padrao = @ncd_processo_padrao 


        -- setar o status deste registro como verificado

        update @tmpArvoreProdutoComposicao
        set verificada = 'S'
        where cd_processo        = @ncd_processo and
              cd_processo_padrao = @ncd_processo_padrao and
              cd_produto         = @ncd_produto

     end
     else begin
        set @lsair_loop = 'S'
     end

     close      crFilhos
     deallocate crFilhos

  end

  --Apresentação da Tabela Final

  insert into
    @Composicao_Produto    
  select
     tapc.cd_processo,
     tapc.cd_processo_padrao,
--     identity(int,1,1)        as cd_ordem_composicao,
     tapc.cd_produto,
     tapc.qt_produto_composicao,
     tapc.cd_fase_produto
  from
     @tmpArvoreProdutoComposicao tapc
  
  RETURN

END

--select * from produto

