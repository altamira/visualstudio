

CREATE FUNCTION fn_composicao_produto_quantidade_pai
  (@cd_produto int)
RETURNS @Composicao_Produto TABLE 
	(cd_produto_pai int, 
	 cd_produto int,
   qt_produto_composicao float,
   cd_fase_produto int,
   nm_fantasia_produto varchar(30),
   qt_produto_pai float)
AS
BEGIN

  -- criar a tabela temporária na memória
  declare @tmpArvoreProdutoComposicao table 
  ( cd_produto_pai int,
    cd_produto int,
    qt_produto_composicao int,    
    cd_fase_produto int,
    verificada char(1),
    qt_produto_pai int )          -- Paulo

  -- declarar as variáveis
  declare @lsair_loop char(1)
  declare @cd_versao_produto int
  declare @ncd_produto_pai int
  declare @ncd_produto int
  declare @qt_produto_pai int -- Paulo

  select 
    @cd_versao_produto = cd_versao_produto 
  from 
    produto 
  where 
    cd_produto = @cd_produto

  -- inserir o registro do produto principal
  insert into @tmpArvoreProdutoComposicao
  values ( @cd_produto, 0, @cd_produto, 0, 'S', 1 )   -- Paulo
--  values ( @cd_produto, 0, @cd_produto, 0, 'S' )   

  -- carregar os filhos do produto pai-de-todos 
  insert into
     @tmpArvoreProdutoComposicao
  select
     cd_produto_pai,
     cd_produto,
     qt_produto_composicao,
     cd_fase_produto,
     'N' as verificada,
     1 as qt_produto_pai
  from
     produto_composicao
  where
     cd_produto_pai = @cd_produto and
     cd_versao_produto_comp = @cd_versao_produto

--  select * from @tmparvoreprodutocomposicao   -- Paulo

  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado
  while ( @lsair_loop = 'N' ) begin

     declare crFilhos cursor for
        select cd_produto_pai, cd_produto, qt_produto_composicao
        from @tmpArvoreProdutoComposicao
        where verificada = 'N'

     open crFilhos

     FETCH NEXT FROM crFilhos
        INTO @ncd_produto_pai,
             @ncd_produto,
             @qt_produto_pai

     select 
       @cd_versao_produto = cd_versao_produto 
     from 
       produto 
     where 
       cd_produto = @ncd_produto_pai

     if @@FETCH_STATUS = 0 begin

        -- inserir na tabela temporária os filhos do produto atual
        insert into
           @tmpArvoreProdutoComposicao
        select
           cd_produto_pai,
           cd_produto,
           qt_produto_composicao,
           cd_fase_produto,
           'N' as verificada,
           @qt_produto_pai
        from
           produto_composicao
        where
           cd_produto_pai = @ncd_produto and
           cd_versao_produto_comp = @cd_versao_produto

        -- setar o status deste registro como verificado
        update @tmpArvoreProdutoComposicao
        set verificada = 'S'
        where cd_produto_pai = @ncd_produto_pai and
              cd_produto = @ncd_produto

     end
     else begin
        set @lsair_loop = 'S'
     end

     close crFilhos
     deallocate crFilhos

  end

  insert into
    @Composicao_Produto    
  select
     tapc.cd_produto_pai,
     tapc.cd_produto,
     tapc.qt_produto_composicao,
     tapc.cd_fase_produto,
     p.nm_fantasia_produto,
     tapc.qt_produto_pai
  from
     @tmpArvoreProdutoComposicao tapc,
     produto p     
  where
    ( p.cd_produto = tapc.cd_produto )

  RETURN
END

