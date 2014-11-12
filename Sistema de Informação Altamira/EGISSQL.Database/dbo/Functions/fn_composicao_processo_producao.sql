
--------------------------------------------------------------------------------------------------
--sp_helptext fn_composicao_processo_producao
--------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2007
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Carlos Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Retornar a composição do processo de produção 
--Data			: 01.06.2007
--Alteração		: 01.06.2007
--Desc. Alteração	: Ajustes - Carlos Fernandes
-- 09.09.2010 - Flag para trazer o processo com o flag de custo - Carlos Fernandes
--------------------------------------------------------------------------------------------------

CREATE FUNCTION fn_composicao_processo_producao
  (@cd_processo int)
RETURNS 
  @Composicao_Produto TABLE 
  (cd_processo           int, 
   cd_processo_padrao    int,
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

  --fase do parâmetro

  select 
    @cd_fase_produto = isnull(cd_fase_produto,0)
  from
    parametro_comercial with (nolock)
  where
   cd_fase_produto = dbo.fn_empresa()


  --Processo Principal

  select 
    top 1 
    @cd_processo_padrao = isnull(pp.cd_processo_padrao   ,0),
    @qt_processo        = isnull(pp.qt_planejada_processo,0),
    @cd_produto         = isnull(pp.cd_produto           ,0),
    @cd_fase_produto    = case when isnull(pp.cd_fase_produto,0)>0 
                          then                   
                            isnull(pp.cd_fase_produto,0)
                          else
                            case when isnull(p.cd_fase_produto_baixa,0)>0
                            then
                               isnull(p.cd_fase_produto_baixa,0)
                            else
                               @cd_fase_produto
                            end
                          end
  from
    processo_producao pp      with (nolock) 
    left outer join produto p with (nolock) on p.cd_produto = pp.cd_produto
  where 
    cd_processo = @cd_processo

  -- inserir o registro do produto principal

  insert into @tmpArvoreProdutoComposicao
  values ( @cd_processo, @cd_processo_padrao, @cd_produto, @qt_processo, @cd_fase_produto,'S' )

  -- carregar os filhos do produto pai-de-todos 

  insert into
     @tmpArvoreProdutoComposicao
  select
     ppc.cd_processo,
     pp.cd_processo_padrao,
     ppc.cd_produto,
     ppc.qt_comp_processo,
     ppc.cd_fase_produto,
     'N'                  as verificada
  from
    processo_producao_componente ppc with (nolock)
    inner join produto_producao  pop with (nolock) on pop.cd_produto        = ppc.cd_produto
    inner join processo_padrao   pp  with (nolock) on pp.cd_processo_padrao = pop.cd_processo_padrao
  where
    ppc.cd_processo = @cd_processo 
    --verificar este flag para outros cliente ( talvez criar um parametro )
    --08.09.2010
    and isnull(pp.ic_custo_processo_padrao,'N') = 'S'

--

--select * from parametro_manufatura

  --Verificar se Existe Sub-Itens com Processo Padrão


  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado

  while ( @lsair_loop = 'N' ) begin

     declare crFilhos cursor for
        select cd_processo, cd_processo_padrao,cd_produto
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
           ppp.qt_produto_processo * @qt_processo,
           ppp.cd_fase_produto,
           'N'    as verificada
        from
           processo_padrao_produto      ppp with (nolock)          
           inner join produto_producao  pop with (nolock) on pop.cd_produto        = ppp.cd_produto
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
     tapc.cd_produto,
     tapc.qt_produto_composicao,
     tapc.cd_fase_produto
  from
     @tmpArvoreProdutoComposicao tapc

  RETURN

END

