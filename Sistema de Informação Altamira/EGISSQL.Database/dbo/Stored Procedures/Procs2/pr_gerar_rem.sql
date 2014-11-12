
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Elias P. Silva
--Banco de Dados : EGISSQL
--Objetivo       : Gravar em Nota_Entrada_Registro e Nota_Entrada_Item_Registro o conteúdo da 
--                 Nota de Entrada
--Data           : 24/10/2002
--Atualizado     : 05/11/2002 - ELIAS
--
--            06/11/2002 - ELIAS
--            26/09/2003 - Incluido novos campos - ELIAS
--            30/09/2003 - Acrescido campo cd_mascara_classificacao - ELIAS
--            06/10/2003 - Acertos Gerais - ELIAS
--            17/10/2003 - Acrescentado Obs da Parametro_Tributacao_Entrada
--            29/10/2003 - Acrescentado o IPI ao Valor Contábil - ELIAS
--            03/11/2003 - Retirado a divisão deregistro por classificação fiscal - ELIAS
--                         Colocado rotina para arredondamento dos valores Contabil, ICMS e IPI - ELIAS 
--            04/11/2003 - Acerto na Exclusão, excluindo pela chave da tabela Nota_Entrada e não mais o REM - ELIAS
--            05/11/2003 - Acerto no Cálculo da Observação do IPI e utilização da aliq. IPI calculada
--                         quando na falta deste no item da NF - ELIAS
--            26/11/2003 - Acerto no Incremento do código sequencial - ELIAS
--                       - Acerto no Filtro dos Itens para montagem do Fiscal, Não ter livro de CFOP
--                         que está como "Destaca no livro" = NÃO e também de Prestação de Servico - ELIAS
--            27/11/2003 - Implementação de Rotina de Arredondamento para diferencas de no máximo 2 centavos - ELIAS
--            28/11/2003 - Não processar caso tenha manutenção pelo FISCAL - ELIAS
--            05/12/2003 - Gravação do REM na Nota_Entrada - ELIAS
--                         Retirada do cd_rem do where da deleção quanto código 1 - ELIAS
--            12/01/2004 - Incluído rotina para cálculo do IPI na BC do ICMS - ELIAS 
-- 	      09/02/2004 - Alterado o campo de quebra que era @pc_icms_item e deve ser o campo @pc_icms - ELIAS
--            19/02/2004 - Retirado Filtro de Destinação de Produto que havia no momento do cálculo do ICMS, que não
--                         calculava quando a destinação era diferente de 2 - ELIAS
--            16/06/2004 - Acerto no Cálculo de Outras, Isentas e Obs. - ELIAS
--            29/06/2004 - Acerto no Cálculo do IPI que estava fazendo somente para Destinações diferente de 2 - ELIAS
--            28/07/2004 - Feito acerto do cálculo de Obs do IPI quando ele não é retido, mas mesmo assim é destacado - ELIAS
--            18/02/2005 - Acerto na Geração de Livro que a partir de 2005 engloba também as NFs de Prestação de Serviço. - ELIAS
--            29/03/2005 - Acerto no Cálculo de Outras e Obs de ICMS quando Tributação contém apenas essas Colunas, não estava
--                         incorporando o Valor do IPI. - ELIAS
--                         Corrigido carregamento da variável cd_produto_item que não estava ocorrendo e causando falha na
--                         pesquisa de alíquota - ELIAS
--            24/05/2005 - Acerto no Cálculo de Outras e Isentas de ICMS e IPI após Arredondamento - ELIAS
--            05/09/2005 - Correção no Cálculo de Despesas p/ Dedução da BAse do ICMS para Geração do Livro - Carlos Fernandes           
--                       - Parametro_Tributacao_Entrada = ic_despesa_frete_icms
--            23/09/2005 - Ajuste nas rotinas de Arredondamento que estavam causando divergências na tributação 52 - ELIAS
--            20/12/2005 - Acerto para não gerar Livro de Séries D1, D2 e D3, conforme configurado na Série_Nota_Fiscal - ELIAS
--            26/07/2006 - Ajuste na Geração do Número REM quando a NFE é criada a partir da NFS - ELIAS
--            05/10/2006 - Ajuste para Gerar os Valores corretos quando a entrada via NFS for parcial - ELIAS
--                         Ajuste para não gerar vários registros indevidamente quando entrada de NFE de Importação - ELIAS
--            28.10.2007 - Redução da Base de Cálculo - Carlos Fernandes
-- 02.02.2008 - Verificar a Geração do Livro - Carlos Fernandes.
-- 09.12.2009 - Ajuste de Geração das Notas  - Carlos Fernandes
-- 10.12.2009 - Montagem de Uma tabela temporária caso já tenha manutenção fiscal - Carlos Fernandes
-- 16.11.2010 - Ajustes - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------------------

create procedure pr_gerar_rem
@ic_parametro         int     = 0,
@cd_nota_entrada      int     = 0,
@cd_fornecedor        int     = 0,
@cd_serie_nota_fiscal int     = 0,
@cd_operacao_fiscal   int     = 0,
@cd_usuario           int     = 0,
@ic_manutencao_aux    char(1) = 'N'

as

  SET NOCOUNT ON

  -- REM

  declare @cd_rem 		int
  declare @cd_novo_rem 		int
  declare @ic_novo_rem 		char(1)

  -- SEQUENCIAL
  declare @cd_sequencial	int

  -- Tributação
  declare @cd_tributacao 	int
  declare @cd_tributacao_item 	int

  declare @Tabela		varchar(50)

  -- Composição da Tributação
  declare @cd_composicao_tributacao int
  declare @cd_evento_tributacao     int
  declare @ic_evento_tributacao     char(1)

  -- Redução da Base de ICMS e do IPI
  declare @pc_red_bc_ipi                 decimal(25,2)
  declare @pc_red_bc_icms                decimal(25,2)

  -- Item
  declare @cd_item_nota_entrada          int
  declare @cd_classificacao_fiscal       int
  declare @cd_mascara_classificacao      char(10)
  declare @cd_produto_item 	         int
  declare @cd_operacao_item 	         int
  declare @vl_produto_item               decimal(25,2)
  declare @pc_icms_item                  decimal(25,2)
  declare @pc_ipi_item	      	         decimal(25,2)
  declare @pc_icms_red_nota_entrada_item decimal(25,2)
  declare @vl_soma_icms_item             decimal(25,2)

  declare @pc_icms_anterior              decimal(25,2)
  declare @pc_icms_red_nota_entrada      decimal(25,2)
  declare @cd_mascara_anterior           char(10)
  declare @cd_item_anterior              int

  -- ELIAS 05/11/2003
  declare @pc_icms_calc         decimal(25,2)
  declare @pc_ipi_calc          decimal(25,2)
  declare @cd_destinacao_produto int

  -- ELIAS 06/11/2003
  declare @cd_nota_saida        int

  -- Valores do Livro (Cálculo)

  declare @vl_contabil		decimal(25,2)
  declare @vl_bc_icms		decimal(25,2)
  declare @vl_bc_icms_item      decimal(25,2)
  declare @pc_icms		decimal(25,2)
  declare @pc_icms_retorno      decimal(25,2)
  declare @vl_icms		decimal(25,2)
  declare @vl_isento_icms	decimal(25,2)
  declare @vl_outras_icms	decimal(25,2)
  declare @vl_obs_icms		decimal(25,2)
  declare @vl_bc_ipi		decimal(25,2)
  declare @vl_bc_ipi_item       decimal(25,2)
  declare @pc_ipi		decimal(25,2)
  declare @vl_ipi		decimal(25,2)
  declare @vl_ipi_destacado     decimal(25,2)
  declare @vl_ipi_item          decimal(25,2)
  declare @vl_isento_ipi	decimal(25,2)
  declare @vl_outras_ipi	decimal(25,2)
  declare @vl_obs_ipi		decimal(25,2)
  declare @vl_despac            decimal(25,2)

  declare @cd_sit_tributaria   	char(3)
  declare @cd_tributacao_new  	int

  -- Chave dos novos registros do Livro
  declare @cd_item_rem          int

  -- Controle de IPI na BC do ICMS - ELIAS 12/01/2004

  declare @ic_ipi_bc_icms        char(1)
  declare @ic_despesa_frete_icms char(1)
  declare @vl_ipi_bc_icms        decimal(25,2)

  -- Controle de Cálculo do Valor de Outras com o
  -- Valor Contábil - ELIAS 29/03/2005

  declare @ic_icms_outras       char(1)
  declare @ic_manutencao        char(1)
  
  set @cd_novo_rem       = 0
  set @ic_novo_rem       = 'S'
  set @cd_item_rem       = 1
  set @vl_contabil       = 0
  set @vl_bc_icms        = 0
  set @vl_bc_icms_item   = 0
  set @pc_icms	         = 0
  set @vl_icms	         = 0
  set @vl_isento_icms    = 0
  set @vl_outras_icms    = 0
  set @vl_obs_icms       = 0
  set @vl_bc_ipi         = 0
  set @vl_bc_ipi_item    = 0
  set @vl_ipi	         = 0
  set @vl_ipi_item       = 0   -- ELIAS 05/11/2003
  set @vl_ipi_destacado  = 0 
  set @vl_isento_ipi     = 0
  set @vl_outras_ipi     = 0
  set @vl_obs_ipi        = 0
  set @ic_icms_outras    = 'N'
  set @vl_despac         = 0
  set @ic_ipi_bc_icms    = 'N'
  set @ic_manutencao_aux = 'N'

--select cd_destinacao_produto,* from nota_entrada

-------------------------------------------------------------------------------
if @ic_parametro = 1     -- Carrega as informações da nota nas tabelas do REM
-------------------------------------------------------------------------------
begin

  --print 1
   
  if exists(select 'x' cd_rem 
            from Nota_Entrada_Registro with (nolock) 
            where cd_fornecedor    = @cd_fornecedor and
              cd_nota_entrada      = @cd_nota_entrada and
              cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
              cd_operacao_fiscal   = @cd_operacao_fiscal)
  begin

    -- Guarda o número do REM e SEQUENCIAL existente

    select 
      @cd_rem        = cd_rem,
      @cd_sequencial = cd_sequencial
    from Nota_Entrada_Registro with (nolock) 
    where 
      cd_fornecedor        = @cd_fornecedor and
      cd_nota_entrada      = @cd_nota_entrada and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_operacao_fiscal   = @cd_operacao_fiscal  

    -- Apaga os REMs existentes

    delete from Nota_Entrada_Registro
    where (cd_fornecedor   = @cd_fornecedor and
      cd_nota_entrada      = @cd_nota_entrada and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_operacao_fiscal   = @cd_operacao_fiscal) 


    --Montagem de uma tabela auxiliar com os dados das notas da Manutenção Fiscal

    select
      *
    into
      #AuxItemRegistro
    from
      Nota_Entrada_Item_registro with (nolock) 
    where (cd_fornecedor   = @cd_fornecedor        and
      cd_nota_entrada      = @cd_nota_entrada      and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_operacao_fiscal   = @cd_operacao_fiscal   and
      isnull(ic_manutencao_fiscal,'N') = 'S' ) 

    if @ic_manutencao_aux = 'S' 
    begin
       set @ic_manutencao = 'S'
    end

    delete from Nota_Entrada_Item_Registro
    where (cd_fornecedor   = @cd_fornecedor and
      cd_nota_entrada      = @cd_nota_entrada and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_operacao_fiscal   = @cd_operacao_fiscal) 

    -- indica que o rem foi reutilizado e não atualiza o parametro_empresa
    set @ic_novo_rem = 'N' 

  end
  else
  begin

    -- Encontra novo REM    

    -- Carrega da tabela de Parâmetro
    select @cd_novo_rem = isnull(cd_rem_empresa,1)
    from EGISADMIN.dbo.Parametro_Empresa with (nolock) 
    where cd_empresa = dbo.fn_empresa()

    -- Verifica o último REM Gerado
    select @cd_rem = (isnull(max(cd_rem),1)+1)
    from Nota_Entrada_Registro with (nolock) 

    if @cd_novo_rem > @cd_rem
      set @cd_rem = @cd_novo_rem

    -- ENCONTRA NOVO SEQUENCIAL
    select @cd_sequencial = (isnull(max(cd_sequencial),1)+1)
    from Nota_Entrada_Registro
                     
  end

  --print 'passo 0'

-------------------------------------------------------------------------------
  -- GERANDO LIVRO ATRAVÉS DE UMA NF DE SAÍDA (QUANDO A NFE É GERADA P/ NFSAÍDA)
-------------------------------------------------------------------------------
  -- NOTA DE ENTRADA
  -- Lançamento de um Nota de Entrada a partir de uma Nota Fiscal de Saída
-------------------------------------------------------------------------------

--select * from nota_entrada where cd_nota_entrada = 232

 
  --Carlos 09.12.2009

  if ( isnull( (select cd_nota_saida
       from Nota_Entrada with (nolock) 
       where cd_nota_entrada  = @cd_nota_entrada and
         cd_fornecedor        = @cd_fornecedor and
         cd_operacao_fiscal   = @cd_operacao_fiscal and
         cd_serie_nota_fiscal = @cd_serie_nota_fiscal),0) <>  0 )  --O Valor anterior era zero

  begin

    --print('Gerado p/ NFS ')

    select @cd_sequencial as cd_sequencial, 
      identity(int,1,1)   as cd_incremento,
      e.cd_fornecedor, e.cd_nota_entrada, e.cd_operacao_fiscal, e.cd_serie_nota_fiscal,
      e.dt_receb_nota_entrada, sum(s.vl_contabil_item_nota) as vl_contabil_item_nota,
      e.vl_total_nota_entrada,
      f.nm_fantasia_fornecedor, @cd_usuario as cd_usuario, getdate() as dt_usuario,
      e.cd_tributacao, e.cd_destinacao_produto, e.cd_nota_saida      
    into #Nota_Entrada_Saida
    from Nota_Entrada e with (nolock) 
      left outer join Nota_Saida_Item_Registro s on s.cd_nota_saida = e.cd_nota_saida
      left outer join Fornecedor f               on e.cd_fornecedor = f.cd_fornecedor
    where e.cd_nota_entrada  = @cd_nota_entrada and
      e.cd_fornecedor        = @cd_fornecedor and
      e.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      e.cd_operacao_fiscal   = @cd_operacao_fiscal
    group by 
      e.cd_fornecedor, e.cd_nota_entrada, e.cd_operacao_fiscal,
      e.cd_serie_nota_fiscal, e.dt_receb_nota_entrada, e.dt_receb_nota_entrada,
      s.cd_nota_saida, f.nm_fantasia_fornecedor, e.cd_tributacao,
      e.cd_destinacao_produto, e.cd_nota_saida, e.vl_total_nota_entrada

    -- Insere os dados da Nota_Entrada em Nota_Entrada_Registro
    insert into Nota_Entrada_Registro
     (cd_sequencial, cd_rem, cd_fornecedor, cd_nota_entrada, cd_operacao_fiscal,
      cd_serie_nota_fiscal, dt_rem, vl_total_rem, nm_fornec_nota_registro,
      cd_usuario, dt_usuario, cd_tributacao, cd_destinacao_producao, cd_nota_saida ) 
    select
      cd_sequencial, @cd_rem, cd_fornecedor, cd_nota_entrada,
      cd_operacao_fiscal, cd_serie_nota_fiscal, dt_receb_nota_entrada, vl_contabil_item_nota * (vl_total_nota_entrada / isnull(vl_contabil_item_nota,1)),
      nm_fantasia_fornecedor, cd_usuario, dt_usuario, cd_tributacao, cd_destinacao_produto, cd_nota_saida      
    from #Nota_Entrada_Saida

    -- Criação de Tabela temporária com os itens da nota
    --cliente
    --fornecedor

    select 
      identity(int,1,1) as cd_item_rem,
      sum(isnull(s.vl_contabil_item_nota,0))    * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_contabil,
      s.pc_icms_item_nota_saida,
      sum(isnull(s.vl_base_icms_item_nota,0))   * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_bc_icms,
      sum(isnull(s.vl_icms_item_nota_saida,0))  * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_icms,
      sum(isnull(s.vl_icms_isento_item_nota,0)) * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_icms_isento,
      sum(isnull(s.vl_icms_outras_item_nota,0)) * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_icms_outras,
      sum(isnull(s.vl_icms_obs_item_nota,0))    * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_icms_obs,
      sum(isnull(s.vl_base_ipi_item_nota,0))    * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_bc_ipi,
      sum(isnull(s.vl_ipi_item_nota_saida,0))   * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_ipi,
      sum(isnull(s.vl_ipi_isento_item_nota,0))  * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_ipi_isento,
      sum(isnull(s.vl_ipi_outras_item_nota,0))  * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_ipi_outras,
      sum(isnull(s.vl_ipi_obs_item_nota,0))     * (e.vl_total_nota_entrada / sum(isnull(s.vl_contabil_item_nota,1))) as vl_ipi_obs,
      e.sg_estado,
      vw.cd_cnpj,
      vw.nm_razao_social,
      vw.cd_inscestadual,
      e.dt_nota_entrada,
      e.dt_receb_nota_entrada,
      e.cd_tipo_destinatario,
      e.nm_serie_nota_entrada,
      e.cd_tributacao,
      op.ic_destaca_vlr_livro_op_f,
      op.ic_servico_operacao,
      op.ic_contribicms_op_fiscal,
      op.cd_mascara_operacao,
      op.nm_operacao_fiscal,
      se.sg_serie_nota_fiscal,
      op.nm_obs_livro_operacao,
      pt.nm_obs_livro_entrada
    into #Nota_Entrada_Item_Saida
    from Nota_Entrada e with (nolock) 
      left outer join Nota_Saida_Item_Registro s      on s.cd_nota_saida = e.cd_nota_saida
      left outer join Operacao_Fiscal op              on op.cd_operacao_fiscal = e.cd_operacao_fiscal
      left outer join Serie_Nota_Fiscal se            on se.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal
      left outer join Parametro_Tributacao_Entrada pt on pt.cd_tributacao = e.cd_tributacao
      left outer join vw_Destinatario_Rapida vw       on vw.cd_destinatario = e.cd_fornecedor and
                                                         vw.cd_tipo_destinatario = e.cd_tipo_destinatario
    where
      e.cd_fornecedor        = @cd_fornecedor and
      e.cd_nota_entrada      = @cd_nota_entrada and
      e.cd_operacao_fiscal   = @cd_operacao_fiscal and
      e.cd_serie_nota_fiscal = @cd_serie_nota_fiscal
    group by s.pc_icms_item_nota_saida, e.sg_estado, vw.cd_cnpj, vw.nm_razao_social,
      vw.cd_inscestadual, e.dt_nota_entrada, e.dt_receb_nota_entrada, e.cd_tipo_destinatario,
      e.nm_serie_nota_entrada, e.cd_tributacao, op.ic_destaca_vlr_livro_op_f, op.ic_servico_operacao,
      op.ic_contribicms_op_fiscal, op.cd_mascara_operacao, op.nm_operacao_fiscal, se.sg_serie_nota_fiscal,
      op.nm_obs_livro_operacao, pt.nm_obs_livro_entrada, e.vl_total_nota_entrada
            
    -- Insere dados da Nota_Entrada_Item em Nota_Entrada_Item_Registro

    insert into Nota_Entrada_Item_Registro(
      cd_rem, cd_item_rem, cd_item_nota_entrada, cd_item_registro_nota, cd_nota_entrada, cd_fornecedor, 
      cd_operacao_fiscal, cd_serie_nota_fiscal, vl_cont_reg_nota_entrada, pc_icms_reg_nota_entrada,
      vl_bicms_reg_nota_entrada, vl_icms_reg_nota_entrada, vl_icmsisen_reg_nota_entr, vl_icmsoutr_reg_nota_entr,
      vl_icmsobs_reg_nota_entr, vl_bipi_reg_nota_entrada, vl_ipi_reg_nota_entrada, vl_ipiisen_reg_nota_entr,
      vl_ipioutr_reg_nota_entr, vl_ipiobs_reg_nota_entr, cd_usuario, dt_usuario, sg_estado, cd_cnpj,
      nm_razao_social, dt_nota_entrada, dt_receb_nota_entrada, cd_tipo_destinatario, nm_serie_nota_entrada,
      cd_tributacao, cd_mascara_operacao, sg_serie_nota_fiscal, nm_obsicms_reg_nota_entr, nm_obsipi_reg_nota_entr,
      cd_destinatario, cd_sequencial)
    select @cd_rem, cd_item_rem, cd_item_rem, cd_item_rem, @cd_nota_entrada, @cd_fornecedor, @cd_operacao_fiscal,
      @cd_serie_nota_fiscal, vl_contabil, pc_icms_item_nota_saida, vl_bc_icms, vl_icms, vl_icms_isento,
      vl_icms_outras, vl_icms_obs, vl_bc_ipi, vl_ipi, vl_ipi_isento, vl_ipi_outras, vl_ipi_obs, @cd_usuario,
      getDate(), sg_estado, cd_cnpj, nm_razao_social, dt_nota_entrada, dt_receb_nota_entrada, cd_tipo_destinatario,
      nm_serie_nota_entrada, cd_tributacao, cd_mascara_operacao, sg_serie_nota_fiscal, nm_obs_livro_operacao,
      nm_obs_livro_entrada, @cd_fornecedor, @cd_sequencial
    from #Nota_Entrada_Item_Saida

  end

  else

  -- GERANDO LIVRO QUANDO ATRAVÉS DO PROCEDIMENTO NORMAL

  begin

  --print('Gerado p/ Composicao da Tributacao')

  -- Insere os dados da Nota_Entrada em Nota_Entrada_Registro

  insert into Nota_Entrada_Registro
   (cd_sequencial, cd_rem, cd_fornecedor, cd_nota_entrada, cd_operacao_fiscal, cd_serie_nota_fiscal, dt_rem,
    vl_total_rem, nm_fornec_nota_registro, cd_usuario, dt_usuario, cd_tributacao, cd_destinacao_producao, cd_nota_saida ) 
  select @cd_sequencial, @cd_rem, n.cd_fornecedor, n.cd_nota_entrada, n.cd_operacao_fiscal, n.cd_serie_nota_fiscal,
    n.dt_receb_nota_entrada, n.vl_total_nota_entrada, f.nm_fantasia_fornecedor, @cd_usuario, getdate(),
    n.cd_tributacao, n.cd_destinacao_produto, n.cd_nota_saida
  from Nota_Entrada n with (nolock) 
    left outer join Fornecedor f on n.cd_fornecedor = f.cd_fornecedor
  where
    n.cd_nota_entrada      = @cd_nota_entrada and
    n.cd_fornecedor        = @cd_fornecedor and
    n.cd_operacao_fiscal   = @cd_operacao_fiscal and
    n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal   

  ------------------------------------------------------------------------------------------
  -- regras para geração dos registros em nota_Entrada_Item_Registro (Livro de Entradas)
  ------------------------------------------------------------------------------------------
  -- 1 - Deverá ser alimentado da tabela de nota_entrada_item
  -- 2 - Deverá ser utilizado a composição da tributação da nota_entrada quando o registro
  --     em nota_entrada_item não ter.
  -- 3 - Cada registro em nota_entrada_item_registro significará uma linha no livro de entradas
  -- 4 - Não Gerar, caso a Série esteja para Livro = NAO (Séries D1, D2 e D3, por exemplo)
  ------------------------------------------------------------------------------------------

  --print 'tabela auxiliar de itens de nota'

  select 
    ni.*,
    isnull(ni.cd_mascara_classificacao, cf.cd_mascara_classificacao) as cd_masc_class_fiscal,
    n.sg_estado,
    vw.cd_cnpj,
    vw.nm_razao_social,
    vw.cd_inscestadual,
    n.dt_nota_entrada,
    n.dt_receb_nota_entrada,
    n.cd_tipo_destinatario,
    n.nm_serie_nota_entrada,
    n.cd_destinacao_produto,
    op.ic_destaca_vlr_livro_op_f,
    op.ic_servico_operacao,
    op.ic_contribicms_op_fiscal,
    op.cd_mascara_operacao,
    op.nm_operacao_fiscal,
    se.sg_serie_nota_fiscal,
    op.nm_obs_livro_operacao as 'nm_obs_livro_operacao_icms',
    pt.nm_obs_livro_entrada  as 'nm_obs_livro_operacao_ipi',
    case when (round(isnull(n.vl_total_nota_entrada,0),2) = 
               round(isnull(n.vl_prod_nota_entrada,0),2)) then
      'N'
    else
      'S'
    end as 'ic_ipi_destacado',
    n.vl_despac_nota_entrada
  into
    #Nota_Entrada_Item

  from 
    Nota_Entrada n                  with (nolock)
    inner join Nota_Entrada_Item ni with (nolock) on ni.cd_nota_entrada      = n.cd_nota_entrada and
                                                     ni.cd_fornecedor        = n.cd_fornecedor and
                                                     ni.cd_operacao_fiscal   = n.cd_operacao_fiscal and
                                                     ni.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal

    left outer join vw_Destinatario_Rapida vw     on vw.cd_destinatario      = n.cd_fornecedor and
                                                     vw.cd_tipo_destinatario = n.cd_tipo_destinatario

    left outer join Operacao_Fiscal op on op.cd_operacao_fiscal = n.cd_operacao_fiscal
    left outer join Serie_Nota_Fiscal se on se.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
    left outer join Classificacao_Fiscal cf on cf.cd_classificacao_fiscal = ni.cd_classificacao_fiscal
    left outer join Parametro_Tributacao_Entrada pt on pt.cd_tributacao = n.cd_tributacao
  where 
    ni.cd_fornecedor        = @cd_fornecedor and
    ni.cd_nota_entrada      = @cd_nota_entrada and
    ni.cd_operacao_fiscal   = @cd_operacao_fiscal and
    ni.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
    isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
    -- ELIAS 20/12/2005
    isnull(se.ic_rel_contab_serie_nota,'S') = 'S'
    -- APARTIR DE 2005 É NECESSÁRIO GERAR LIVRO DE CFOP DE SERVICO - ELIAS 18/02/2005
--     and
--     isnull(op.ic_servico_operacao,'N') = 'N'
  order by 
    ni.pc_icms_nota_entrada, ni.cd_item_nota_entrada

  --Verifica se Existe ICMS lançado nos itens

  select 
   @vl_soma_icms_item = sum( isnull(pc_icms_nota_entrada,0))
  from
   #Nota_Entrada_Item


  -- Código de Tributação da Nota

  select 
    @cd_tributacao         = cd_tributacao,
    @vl_despac             = isnull(vl_despac_nota_entrada,0),
    @cd_destinacao_produto = isnull(cd_destinacao_produto,0)
  from 
    Nota_Entrada with (nolock) 
  where
    cd_fornecedor        = @cd_fornecedor       and
    cd_nota_entrada      = @cd_nota_entrada     and
    cd_operacao_fiscal   = @cd_operacao_fiscal  and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal       

  declare cGerarRem cursor for

  select cd_item_nota_entrada
  from 
    #Nota_Entrada_Item
  order by 
    isnull(pc_icms_nota_entrada,0), cd_item_nota_entrada    

  open cGerarRem      

  fetch next from cGerarRem into @cd_item_nota_entrada

  -- DADOS DO PRIMEIRO ITEM

  select 
    @cd_mascara_anterior      = cd_masc_class_fiscal,
    @pc_icms_anterior         = isnull(pc_icms_nota_entrada,0),
    @cd_item_anterior         = @cd_item_nota_entrada,
    @pc_icms_red_nota_entrada = isnull(pc_icms_red_nota_entrada,0)
  from
    #Nota_Entrada_Item
  where 
    cd_item_nota_entrada = @cd_item_nota_entrada

  while @@fetch_status = 0
  begin

    -- Carregando dados para quebra do item (CLASSIFICACAO FISCAL E ICMS)
    select
      @cd_mascara_classificacao = cd_masc_class_fiscal,
      @pc_icms                  = isnull(pc_icms_nota_entrada,0),
      @pc_icms_red_nota_entrada = isnull(pc_icms_red_nota_entrada,0)
    from
      #Nota_Entrada_Item
    where 
      cd_item_nota_entrada = @cd_item_nota_entrada

    if (@pc_icms = 0) and (@pc_icms_anterior <> 0)
    begin
      set @pc_icms = @pc_icms_anterior
    end

--    select @cd_item_nota_entrada,@pc_icms,@pc_icms_anterior


--     if (@pc_icms_red_nota_entrada = 0 ) and @pc_icms_reducao_anterior <> 0 )
--     begin
--       set @pc_icms_red_nota_entrada = @pc_icms_reducao_anterior
--     end

    -- Se Houver Quebra, gravar
    -- ELIAS 05/11/2003
    -- Alterado o campo de quebra que era @pc_icms_item e 
    -- deve ser o campo @pc_icms que é carregado na instrução
    -- acima - ELIAS 09/02/2004

    if (@pc_icms <> @pc_icms_anterior) 
    begin

        --print('Gravando qdo Quebra do Perc de ICMS')
        --print('(*) OBS ICMS '+cast(@vl_obs_icms as varchar))
        --print('(*) OBS IPI '+cast(@vl_obs_ipi as varchar))
        --print('2 @vl_contabil '+cast(@vl_contabil as varchar))

       --Carlos 05.09.2005 - Dedução da Base do ICMS do Valor das Despesas Acessórias quando for Lançamento de Frete

       if (@ic_despesa_frete_icms = 'S' ) and (@vl_bc_icms > 0)
       begin
         
         set @vl_bc_icms     = round(( @vl_bc_icms - isnull(@vl_despac,0) ) - (@vl_bc_icms * (@pc_icms_red_nota_entrada/100)),2)
         set @vl_outras_icms = @vl_despac
         --print(' 467 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
         set @vl_despac      = 0
       end

      -- Insere dados da Nota_Entrada_Item em Nota_Entrada_Item_Registro

      insert into Nota_Entrada_Item_Registro(
      	cd_rem,
        cd_item_rem,
        cd_operacao_fiscal,
	cd_classificacao_fiscal,
        cd_mascara_classificacao,
	cd_unidade_medida,
      	qt_item_reg_nota_entrada,
      	vl_cont_reg_nota_entrada,
      	pc_icms_reg_nota_entrada,
      	vl_bicms_reg_nota_entrada,
	vl_icms_reg_nota_entrada,
      	vl_icmsisen_reg_nota_entr,
      	vl_icmsoutr_reg_nota_entr,
      	vl_icmsobs_reg_nota_entr,
      	pc_ipi_reg_nota_entrada,
      	vl_bipi_reg_nota_entrada,
      	vl_ipi_reg_nota_entrada,
      	vl_ipiisen_reg_nota_entr,
      	vl_ipioutr_reg_nota_entr,
      	vl_ipiobs_reg_nota_entr,
      	nm_obsicms_reg_nota_entr,
      	nm_obsipi_reg_nota_entr,
      	cd_carta_liv_reg_nota_ent,
      	cd_tributacao,
      	cd_natdipi_reg_nota_entra,
        cd_usuario,
      	dt_usuario,
        cd_serie_nota_fiscal,
        ic_resumo_entrada,
        ic_servico_item_nota,
        cd_nota_entrada,
        cd_item_nota_entrada,
        cd_item_registro_nota,
        cd_mascara_operacao,
        cd_mascara_conta,
        sg_estado,
        dt_nota_entrada,
        cd_cnpj,
        nm_razao_social,
        cd_destinatario,
        sg_serie_nota_fiscal,
        nm_serie_nota_entrada,
        dt_receb_nota_entrada,
        cd_inscestadual,
        cd_num_formulario,
        ic_contribicms_op_fiscal,
        cd_tipo_destinatario,
        cd_sequencial,
        cd_fornecedor,
        pc_reducao_nota_entrada)
      select
        @cd_rem,
        @cd_item_rem,
        cd_operacao_fiscal,
        cd_classificacao_fiscal,
        @cd_mascara_anterior,
        cd_unidade_medida,
        qt_item_nota_entrada,
        @vl_contabil,
        case when @vl_icms = 0 then 0 else @pc_icms_anterior end, 
        @vl_bc_icms,
        @vl_icms,
        @vl_isento_icms,
        @vl_outras_icms,
        @vl_obs_icms,
        case when @vl_ipi = 0 then 0 else @pc_ipi end,
        @vl_bc_ipi,
        @vl_ipi,
        @vl_isento_ipi,
        @vl_outras_ipi,
        @vl_obs_ipi,
        nm_obs_livro_operacao_icms,
        nm_obs_livro_operacao_ipi,
        null,
        @cd_tributacao,
        null,
        @cd_usuario,
        getdate(),
        cd_serie_nota_fiscal,
        ic_destaca_vlr_livro_op_f,
        ic_servico_operacao,
        cd_nota_entrada,
        cd_item_nota_entrada,
        @cd_item_rem,
        cd_mascara_operacao,
        null,
        sg_estado,
        dt_nota_entrada,
        cd_cnpj,
        nm_razao_social,
        cd_fornecedor,
        sg_serie_nota_fiscal,
        nm_serie_nota_entrada,
        dt_receb_nota_entrada,
        cd_inscestadual,
        null,
        ic_contribicms_op_fiscal,
        cd_tipo_destinatario,
        @cd_sequencial,
        cd_fornecedor,
        @pc_icms_red_nota_entrada 
      from
        #Nota_Entrada_Item

      where
        cd_item_nota_entrada = @cd_item_anterior

      -- APÓS A GRAVAÇÃO, INICIALIZAR OS TOTAIS

      set @cd_item_rem      = @cd_item_rem + 1
      set @vl_contabil      = 0
      set @vl_bc_icms       = 0
      set @pc_icms	    = 0
      set @vl_icms	    = 0
      set @vl_isento_icms   = 0
      set @vl_outras_icms   = 0
      --print(' 585 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
      set @vl_obs_icms      = 0
      set @vl_bc_ipi        = 0
      set @vl_ipi	    = 0
      set @vl_ipi_destacado = 0 
      set @vl_ipi_item      = 0
      set @vl_isento_ipi    = 0
      set @vl_outras_ipi    = 0
      set @vl_obs_ipi       = 0
      set @vl_despac        = 0

    end

    -- carregamento das variáveis

    select
      @cd_tributacao_item = isnull(cd_tributacao,0),
      @vl_produto_item    = round(isnull(vl_total_nota_entr_item,0),2),
      @vl_ipi_destacado   = case when ic_ipi_destacado = 'S' then
                            round(isnull(vl_ipi_nota_entrada,0),2)
                          else
                            0 end,
      @pc_icms_item                  = isnull(pc_icms_nota_entrada,0),
      @pc_ipi_item                   = isnull(pc_ipi_nota_entrada,0),
      @cd_mascara_classificacao      = cd_masc_class_fiscal,
      @cd_classificacao_fiscal       = cd_classificacao_fiscal,
      @cd_destinacao_produto         = isnull(cd_destinacao_produto,0),
      -- ELIAS 29/05/2005
      @cd_produto_item               = isnull(cd_produto,0),
      @pc_icms_red_nota_entrada_item = isnull(pc_icms_red_nota_entrada,0)

    from
      #Nota_Entrada_Item
    where
      cd_item_nota_entrada = @cd_item_nota_entrada

    --select cd_item_nota_entrada, vl_total_nota_entr_item, vl_ipi_nota_entrada, * from #Nota_entrada_item where cd_item_nota_entrada = @cd_item_nota_entrada

    set @cd_item_anterior    = @cd_item_nota_entrada
    set @cd_mascara_anterior = @cd_mascara_classificacao
    set @pc_icms_anterior    = @pc_icms_item
                      
    -- encontrando o código de tributação correto
    if @cd_tributacao_item <> 0
      if @cd_tributacao_item <> @cd_tributacao
        set @cd_tributacao = @cd_tributacao_item
                   
    -- carregamento da composicão da tributação

    select
      identity(int,1,1) as 'cd_composicao_tributacao',  
      c.cd_imposto,
      c.cd_evento_tributacao,
      c.cd_item_composicao,
      c.ic_evento_tributacao
    into
      dbo.#Composicao_Tributacao
    from
      Composicao_Tributacao c,
      Evento_Tributacao e
    where
      e.cd_evento_tributacao = c.cd_evento_tributacao and
      c.cd_tributacao        = @cd_tributacao
    order by
      c.cd_imposto,
      e.cd_ord_evento_tributacao

    --select * from composicao_tributacao where cd_tributacao = 6

    --select @cd_fornecedor, @cd_operacao_fiscal, @cd_produto_item, @cd_tributacao, @cd_classificacao_fiscal

    -- CARREGANDO OS PERCENTUAIS DE REDUÇÃO DO ICMS E IPI

    exec pr_calcula_imposto_entrada @ic_parametro            = 1, 
                                    @cd_fornecedor           = @cd_fornecedor, 
                                    @cd_operacao_fiscal      = @cd_operacao_fiscal, 
                                    @cd_produto              = @cd_produto_item,
                                    @cd_tributacao           = @cd_tributacao, 
                                    @cd_classificacao_fiscal = @cd_classificacao_fiscal,
                                    @pc_base_calc_icms       = @pc_red_bc_icms output, 
                                    @pc_base_calc_ipi        = @pc_red_bc_ipi  output,
                                    @pc_icms                 = @pc_icms_calc   output, 
                                    @pc_ipi                  = @pc_ipi_calc    output, 
                                    --@pc_icms = 0,
                                    --@pc_ipi = 0,
                                    @cd_sit_tributaria = '',
                                    @cd_tributacao_new = 0    

   --select @pc_icms
 
    -- ELIAS 05/11/2003
    --print('@pc_icms_item '+cast(@pc_icms_item as varchar))
    --print('@pc_icms_calc '+cast(@pc_icms_calc as varchar))
    --print('@pc_red_bc_ipi '+cast(@pc_red_bc_ipi as varchar))

    if (@pc_icms_item = 0) and @vl_soma_icms_item<>0
    begin
      set @pc_icms_item = @pc_icms_calc
    end

    --print('@pc_ipi_item '+cast(@pc_ipi_item as varchar))
    --print('@pc_ipi_calc '+cast(@pc_ipi_calc as varchar))
    if (@pc_ipi_item = 0)
      set @pc_ipi_item = @pc_ipi_calc

    --Verifica se existe Lançamento conforme a Destinação
    --select * from destinacao_produto

    select 
      @ic_ipi_bc_icms = isnull(ic_ipi_base_icm_dest_prod,'N')
    from
      Destinacao_Produto with (nolock) 
    where
      cd_destinacao_produto = @cd_destinacao_produto
 

    -- carregando a parametro_tributacao_entrada, para se saber
    -- se o IPI entra na BC do ICMS - ELIAS 12/01/2004

    select 
      @ic_ipi_bc_icms        = isnull(ic_ipi_bc_icms,@ic_ipi_bc_icms),
      @ic_despesa_frete_icms = isnull(ic_despesa_frete_icms,'N') --Frete : Carlos 05.09.2005
    from  
      parametro_tributacao_entrada with (nolock) 
    where
      cd_tributacao = @cd_tributacao
   

    -- se o ipi entrar na BC do ICMS então é necessário acrescentá-lo
    -- neste momento - ELIAS 12/01/2004

    if (@ic_ipi_bc_icms = 'S')
--       set @vl_ipi_bc_icms = ((@vl_produto_item *
--                               case when isnull(@pc_red_bc_ipi,0)>0 then
--                              (@pc_red_bc_ipi/100)
--                              else 1 end ) * (@pc_ipi_item / 100))

     set @vl_ipi_bc_icms = ( cast(
                              cast(round(
                             (@vl_produto_item *
                              case when isnull(@pc_red_bc_ipi,0)>0 then
                             (@pc_red_bc_ipi/100)                  else 1 end 
                             * (@pc_ipi_item / 100) * 100 ),2) as int ) as float )/100)

    else
      set @vl_ipi_bc_icms = 0.00

    --print('Processando Item '+cast(@cd_item_nota_entrada as varchar))
    --print('Destinacao '+cast(@cd_destinacao_produto as varchar))
    
    -- ICMS

    while exists(select top 1 * from #Composicao_Tributacao where cd_imposto = 1)
    begin

      --print('Processamento do ICMS')
                          
      select 
        top 1  
        @cd_composicao_tributacao = cd_composicao_tributacao,
        @cd_evento_tributacao     = cd_evento_tributacao,
        @ic_evento_tributacao     = ic_evento_tributacao
      from 
        #Composicao_Tributacao
      where
        cd_imposto = 1
      order by
        cd_composicao_tributacao 

      --print('Código da Composicao '+cast(@cd_composicao_tributacao as varchar))
      --print('Código do Evento '+cast(@cd_evento_tributacao as varchar))
      --print('Aplicar Evento '+@ic_evento_tributacao)
              
      -- Cálculo
      if (@cd_evento_tributacao = 1) and (@ic_evento_tributacao = 'S') --and (@cd_destinacao_produto <> 2)
      begin       
        --print('Produto '+cast(@vl_produto_item as varchar))
        --print('% Red ICMS '+cast(@pc_red_bc_icms as varchar))      
        --print('% ICMS '+cast(@pc_icms_item as varchar))
        --print('IPI '+cast(@vl_ipi_bc_icms as varchar))

        -- Acrescentado Valor de IPI que compõe a BC do ICMS - ELIAS 12/01/04

        --Antes Carlos 28.10.2007 
        --set @vl_bc_icms_item = (@vl_produto_item * (@pc_red_bc_icms/100)) + @vl_ipi_bc_icms

        set @vl_bc_icms_item = round((@vl_produto_item + @vl_ipi_bc_icms ) - (@vl_produto_item * (@pc_icms_red_nota_entrada_item/100)),2) 

        set @vl_bc_icms = @vl_bc_icms + @vl_bc_icms_item
        set @pc_icms    = @pc_icms_item
        set @vl_icms    = @vl_icms + (@vl_bc_icms_item * (@pc_icms / 100))

        --print('Calculou ICMS')

      end
              
      -- Isentos
      else if (@cd_evento_tributacao = 2) and (@ic_evento_tributacao = 'S')
      begin
        set @vl_isento_icms = @vl_isento_icms + @vl_produto_item
        --print('Calculou Isento de ICMS')
      end
             
      -- Outras
      else if (@cd_evento_tributacao = 3) and (@ic_evento_tributacao = 'S')
      begin

        if (@vl_bc_icms <> 0)
        begin
          set @vl_outras_icms = @vl_outras_icms + @vl_produto_item - (@vl_produto_item - @vl_bc_icms)
          --print(' 752 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
        end
        else
          -- ELIAS 29/03/2005 - Carregará o Valor de Outras com o Valor Contábil
          -- Somente abaixo, após Cálculo do IPI
          -- set @vl_outras_icms = @vl_outras_icms + @vl_produto_item
          set @ic_icms_outras = 'S'
          
      end
            
      -- Observações
      --else if (@cd_evento_tributacao = 4) and (@ic_evento_tributacao = 'S')
      --begin
      --  set @vl_obs_icms = @vl_obs_icms + @vl_produto_item 
        --print('Calculou Obs de ICMS')
      --end
              
      delete from
        dbo.#Composicao_Tributacao
      where 
        cd_composicao_tributacao = @cd_composicao_tributacao

    end    
             
    -- IPI
    while exists(select top 1 * from #Composicao_Tributacao where cd_imposto = 2)
    begin

      --print('Processamento do IPI')

      select 
        top 1
        @cd_composicao_tributacao = cd_composicao_tributacao,
        @cd_evento_tributacao     = cd_evento_tributacao,
        @ic_evento_tributacao     = ic_evento_tributacao
      from 
        #Composicao_Tributacao
      where
        cd_imposto = 2
      order by
        cd_composicao_tributacao desc

      --print('Código da Composicao '+cast(@cd_composicao_tributacao as varchar))
      --print('Código do Evento '+cast(@cd_evento_tributacao as varchar))
      --print('Aplicar Evento '+@ic_evento_tributacao)

      -- Cálculo
      if (@cd_evento_tributacao = 1) and (@ic_evento_tributacao = 'S') -- and (@cd_destinacao_produto <> 2)
      begin
 
        set @vl_bc_ipi_item = (@vl_produto_item * (@pc_red_bc_ipi/100))
        set @vl_bc_ipi      = @vl_bc_ipi + @vl_bc_ipi_item
        set @pc_ipi         = @pc_ipi_item
        set @vl_ipi_item    = (@vl_bc_ipi_item * (@pc_ipi / 100)) 
        set @vl_ipi         = @vl_ipi + @vl_ipi_item

        --print('Calculou IPI') 
        -- Se houver Redução da BC do IPI, verificar se a tributação contém
        -- em sua configuração o código de Outras do IPI, se não houver, então
        -- carrega aqui este valor de outras
        if not exists(select 'x' from Composicao_Tributacao
                      where cd_tributacao = @cd_tributacao and
                            cd_imposto = 2 and
                            cd_evento_tributacao = 3 and
                            ic_evento_tributacao = 'S')
        begin
          set @vl_outras_ipi = @vl_outras_ipi + (@vl_produto_item * (@pc_red_bc_ipi/100))
        end

      end

      -- Isentos

      else if (@cd_evento_tributacao = 2) and (@ic_evento_tributacao = 'S')
      begin         
        set @vl_isento_ipi = @vl_isento_ipi + @vl_produto_item
        --print('Calculou Isento de IPI')   
      end

      -- Outras
      else if (@cd_evento_tributacao = 3) and (@ic_evento_tributacao = 'S')
      begin
        set @vl_outras_ipi = @vl_outras_ipi + (@vl_produto_item * (@pc_red_bc_ipi/100))
        --print('Calculou Outras de IPI')   
      end

      delete from
        #Composicao_Tributacao
      where 
        cd_composicao_tributacao = @cd_composicao_tributacao

    end              
       
    -- ELIAS 05/11/2003 - Agregar o IPI ao Contábil somente se o mesmo foi destacado na NF
    if (@vl_ipi_destacado <> 0) 
      set @vl_contabil      = @vl_contabil + @vl_produto_item + @vl_ipi_item
    else
      set @vl_contabil      = @vl_contabil + @vl_produto_item

    -- ELIAS 29/03/2005 - Carregar o Valor de Outras do ICMS com o Valor Contábil
    if (@ic_icms_outras = 'S')
    begin
      set @vl_outras_icms = @vl_outras_icms + @vl_contabil
      --print(' 853 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
    end 

    drop table #Composicao_Tributacao

    set @pc_icms_anterior = @pc_icms_item      

    fetch next from cGerarRem into @cd_item_nota_entrada
    
    --print('----------------------------------------------------')
    --print('% de Redução do IPI '+cast(@pc_red_bc_ipi as varchar))
    --print('IPI Destacado '+cast(@vl_ipi_destacado as varchar))
    --print('PRODUTO ITEM '+cast(@vl_produto_item as varchar))
    --print('VlrContabil '+cast(@vl_contabil as varchar))
    --print('BCICMS '+cast(@vl_bc_icms as varchar))
    --print('ICMS '+cast(@vl_icms as varchar))
    --print('IS ICMS '+cast(@vl_isento_icms as varchar))
    --print('OU ICMS '+cast(@vl_outras_icms as varchar))
    --print('OBS ICMS '+cast(@vl_obs_icms as varchar))
    --print('BCIPI '+cast(@vl_bc_ipi as varchar))
    --print('IPI '+cast(@vl_ipi as varchar))
    --print('IS IPI '+cast(@vl_isento_ipi as varchar))
    --print('OU IPI '+cast(@vl_outras_ipi as varchar))
    --print('OBS IPI '+cast(@vl_obs_ipi as varchar))

    -- Arrendondando os valores de Outras e Isento
    if ((@vl_contabil - (@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi)) between -3 and 3)
    begin
      set @vl_outras_ipi = @vl_outras_ipi + (@vl_contabil - (@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi))
      set @vl_isento_ipi = @vl_isento_ipi + (@vl_contabil - (@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi))
    end 
    -- ELIAS 24/05/2005
    else begin
      set @vl_outras_ipi = @vl_outras_ipi + (@vl_contabil - (@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi + @vl_ipi - @vl_obs_ipi))
      set @vl_isento_ipi = @vl_isento_ipi + (@vl_contabil - (@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi + @vl_ipi - @vl_obs_ipi))
    end

    if ((@vl_contabil - (@vl_bc_icms + @vl_isento_icms + @vl_outras_icms)) between -3 and 3)
    begin
      set @vl_outras_icms = @vl_outras_icms + (@vl_contabil - (@vl_bc_icms + @vl_isento_icms + @vl_outras_icms))
      --print(' 893 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
      set @vl_isento_icms = @vl_isento_icms + (@vl_contabil - (@vl_bc_icms + @vl_isento_icms + @vl_outras_icms))
    end 
    -- ELIAS 24/05/2005
    else 
    begin
      set @vl_outras_icms = @vl_outras_icms + (@vl_contabil - (@vl_bc_icms + @vl_isento_icms + @vl_outras_icms + @vl_ipi - @vl_obs_ipi))
      --print(' 899 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
      set @vl_isento_icms = @vl_isento_icms + (@vl_contabil - (@vl_bc_icms + @vl_isento_icms + @vl_outras_icms + @vl_ipi - @vl_obs_ipi))
    end

    --print('IS ICMS ARR '+cast(@vl_isento_icms as varchar))
    --print('OU ICMS ARR '+cast(@vl_outras_icms as varchar))
    --print('IS IPI ARR '+cast(@vl_isento_ipi as varchar))
    --print('OU IPI ARR '+cast(@vl_outras_ipi as varchar))

    ---------------------------------------------------------------------------
    -- CÁLCULO DO CAMPO DE OUTRAS DE IPI E DE ICMS
    ---------------------------------------------------------------------------

    -- SE BCICMS = VLCONTABIL E A SOMA BCIPI + ISENTOIPI + OUTRASIPI = VLCONTABIL
    -- OBSIPI = IPI * (-1)
    if (@vl_bc_icms <> @vl_bc_ipi) and (@vl_bc_icms = (@vl_contabil - @vl_ipi_destacado)) and
      ((@vl_bc_ipi + @vl_isento_ipi + @vl_outras_ipi) = (@vl_contabil - @vl_ipi_destacado))
      set @vl_obs_ipi = (@vl_ipi * (-1))
    else
    -- SE NÃO RETEM O IPI E MESMO ASSIM ELE FOI INDICADO NA NOTA FISCAL ENTÃO A
    -- DIFERENÇA (IPI DESTACADO) FICA NO CAMPO DE OUTRAS
    if (@vl_bc_ipi = 0) and 
       ((@vl_bc_icms + @vl_isento_icms + @vl_outras_icms + @vl_obs_icms) = (@vl_isento_ipi + @vl_outras_ipi))
    begin
      set @vl_obs_ipi = @vl_ipi_destacado
      --print('OBS ICMS ARR '+cast(@vl_obs_icms as varchar))
      --print('OBS IPI ARR '+cast(@vl_obs_ipi as varchar))
    end
    else
      set @vl_obs_ipi = 0

    -- SE A BCICMS = VLCONTABIL E NÃO EXISTIR ISENTOIPI E NEM OUTRASIPI ENTÃO
    -- OBSICMS = IPI * -1
    if (@vl_bc_icms <> @vl_bc_ipi) and (@vl_bc_icms = (@vl_contabil - @vl_ipi_destacado)) and 
      ((@vl_isento_ipi + @vl_outras_ipi) = 0)
      set @vl_obs_icms = (@vl_ipi * (-1))
    else
    -- SE CONTER SOMENTE ISENTO OU OUTRAS DE ICMS E EXISTIR IPI, ENTÃO IPI FICA NO CAMPO DE OUTRAS
    if (@vl_bc_icms = 0) and ((@vl_isento_icms <> 0) or (@vl_outras_icms <> 0))
      set @vl_obs_icms = (@vl_ipi * (-1))
    else
      set @vl_obs_icms = 0


  end

  close cGerarRem
  deallocate cGerarRem

  --Carlos 05.09.2005 - Dedução da Base do ICMS do Valor das Despesas Acessórias quando for Lançamento de Frete

  if ( @ic_despesa_frete_icms = 'S' ) and ( @vl_bc_icms>0 ) 
  begin
    set @vl_bc_icms     = @vl_bc_icms - isnull(@vl_despac,0)
    --print(' 953 @vl_outras_icms '+cast(@vl_outras_icms as varchar))
    set @vl_outras_icms = @vl_despac
    set @vl_despac      = 0
  end

  -- Insere dados da Nota_Entrada_Item em Nota_Entrada_Item_Registro
  insert into Nota_Entrada_Item_Registro(
    cd_rem,
    cd_item_rem,
    cd_operacao_fiscal,
    cd_classificacao_fiscal,
    cd_mascara_classificacao,
    cd_unidade_medida,
    qt_item_reg_nota_entrada,
    vl_cont_reg_nota_entrada,
    pc_icms_reg_nota_entrada,
    vl_bicms_reg_nota_entrada,
    vl_icms_reg_nota_entrada,
    vl_icmsisen_reg_nota_entr,
    vl_icmsoutr_reg_nota_entr,
    vl_icmsobs_reg_nota_entr,
    pc_ipi_reg_nota_entrada,
    vl_bipi_reg_nota_entrada,
    vl_ipi_reg_nota_entrada,
    vl_ipiisen_reg_nota_entr,
    vl_ipioutr_reg_nota_entr,
    vl_ipiobs_reg_nota_entr,
    nm_obsicms_reg_nota_entr,
    nm_obsipi_reg_nota_entr,
    cd_carta_liv_reg_nota_ent,
    cd_tributacao,
    cd_natdipi_reg_nota_entra,
    cd_usuario,
    dt_usuario,
    cd_serie_nota_fiscal,
    ic_resumo_entrada,
    ic_servico_item_nota,
    cd_nota_entrada,
    cd_item_nota_entrada,
    cd_item_registro_nota,
    cd_mascara_operacao,
    cd_mascara_conta,
    sg_estado,
    dt_nota_entrada,
    cd_cnpj,
    nm_razao_social,
    cd_destinatario,
    sg_serie_nota_fiscal,
    nm_serie_nota_entrada,
    dt_receb_nota_entrada,
    cd_inscestadual,
    cd_num_formulario,
    ic_contribicms_op_fiscal,
    cd_tipo_destinatario,
    cd_sequencial,
    cd_fornecedor,
    pc_reducao_nota_entrada)
  select
    @cd_rem,
    @cd_item_rem,
    cd_operacao_fiscal,
    cd_classificacao_fiscal,
    cd_masc_class_fiscal,
    cd_unidade_medida,
    qt_item_nota_entrada,
    @vl_contabil,
    case when @vl_icms = 0 then 0 else @pc_icms_item end, 
    @vl_bc_icms,
    @vl_icms,
    @vl_isento_icms,
    @vl_outras_icms,
    @vl_obs_icms,
    case when @vl_ipi = 0 then 0 else @pc_ipi end,
    @vl_bc_ipi,
    @vl_ipi,
    @vl_isento_ipi,
    @vl_outras_ipi,
    @vl_obs_ipi,
    nm_obs_livro_operacao_icms,
    nm_obs_livro_operacao_ipi,
    null,
    @cd_tributacao,
    null,
    @cd_usuario,
    getdate(),
    cd_serie_nota_fiscal,
    ic_destaca_vlr_livro_op_f,
    ic_servico_operacao,
    cd_nota_entrada,
    cd_item_nota_entrada,
    @cd_item_rem,
    cd_mascara_operacao,
    null,
    sg_estado,
    dt_nota_entrada,
    cd_cnpj,
    nm_razao_social,
    cd_fornecedor,
    sg_serie_nota_fiscal,
    nm_serie_nota_entrada,
    dt_receb_nota_entrada,
    cd_inscestadual,
    null,
    ic_contribicms_op_fiscal,
    cd_tipo_destinatario,
    @cd_sequencial,
    cd_fornecedor,
    @pc_icms_red_nota_entrada_item 

  from
    #Nota_Entrada_Item

  where
    cd_item_nota_entrada = @cd_item_anterior

  --aqui 

  select 
    *
  from
    #Nota_Entrada_Item

  where
    cd_item_nota_entrada = @cd_item_anterior

  -- Atualiza o número do REM

  if  @ic_novo_rem = 'S' 
  begin

    update 
      EGISADMIN.dbo.Parametro_Empresa 
    set 
      cd_rem_empresa = isnull(@cd_rem,0) + 1
    where 
      cd_empresa = dbo.fn_empresa()

  end

  -- ELIAS 05/12/2003
  -- exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_sequencial, 'D'        

  -- ELIAS 05/12/2003
  -- Grava o REM na Tabela Nota_Entrada
  update Nota_Entrada
  set cd_rem = @cd_rem
  where
    cd_nota_entrada      = @cd_nota_entrada and
    cd_fornecedor        = @cd_fornecedor and
    cd_operacao_fiscal   = @cd_operacao_fiscal and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal
  
  end


  -----------------------------------------------------------------------------
  -- ARREDONDAMENTO 
  -----------------------------------------------------------------------------
  -- DESCOBRINDO ITEM DE MAIOR VALOR
  select
    top 1 
    @cd_item_rem = cd_item_rem
  from
    Nota_Entrada_Item_Registro with (nolock) 
  where
    cd_nota_entrada          = @cd_nota_entrada and
    cd_operacao_fiscal       = @cd_operacao_fiscal and
    cd_fornecedor            = @cd_fornecedor and
    cd_serie_nota_fiscal     = @cd_serie_nota_fiscal and
    vl_cont_reg_nota_entrada = isnull((select max(vl_cont_reg_nota_entrada) 
                                from Nota_Entrada_Item_registro  
                                where cd_nota_entrada = @cd_nota_entrada and
                                      cd_operacao_fiscal = @cd_operacao_fiscal and
                                      cd_fornecedor = @cd_fornecedor and
                                      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
                                      (isnull(vl_icms_reg_nota_entrada,0)<>0) and
                                      (isnull(vl_ipi_reg_nota_entrada,0)<>0)),0)

  -- VALOR CONTABIL

  if ((select round(sum(vl_cont_reg_nota_entrada),2) from nota_entrada_item_registro
       where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
             cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) <>
    (select round(vl_total_nota_entrada,2) from nota_entrada
     where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
           cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal)) 
  begin

    update 
      Nota_Entrada_Item_Registro
    set
      vl_cont_reg_nota_entrada = round((vl_cont_reg_nota_entrada - ((select round(sum(vl_cont_reg_nota_entrada),2) from nota_entrada_item_registro
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) -
                                                                   (select round(vl_total_nota_entrada,2) from nota_entrada
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal))),2)
    where
      cd_nota_entrada      = @cd_nota_entrada and
      cd_fornecedor        = @cd_fornecedor and
      cd_operacao_fiscal   = @cd_operacao_fiscal and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_item_rem          = @cd_item_rem

  end

  -- ARREDONDAMENTO

  -- ICMS
  if (((select round(sum(vl_icms_reg_nota_entrada),2) from nota_entrada_item_registro
       where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
             cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) -
    (select round(vl_icms_nota_entrada,2) from nota_entrada
     where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
           cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal)) between -0.2 and 0.2)
  begin

    update 
      Nota_Entrada_Item_Registro
    set
      vl_icms_reg_nota_entrada = round((vl_icms_reg_nota_entrada - ((select round(sum(vl_icms_reg_nota_entrada),2) from nota_entrada_item_registro
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) -
                                                                   (select round(vl_icms_nota_entrada,2) from nota_entrada
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal))),2)
    where
      cd_nota_entrada = @cd_nota_entrada and
      cd_fornecedor = @cd_fornecedor and
      cd_operacao_fiscal = @cd_operacao_fiscal and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_item_rem = @cd_item_rem

  end

  -- IPI
  if (((select round(sum(vl_ipi_reg_nota_entrada),2) from nota_entrada_item_registro
        where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
              cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) -
       (select round(vl_ipi_nota_entrada,2) from nota_entrada
        where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
              cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal)) between -0.2 and 0.2)
  begin

    update 
      Nota_Entrada_Item_Registro
    set
      vl_ipi_reg_nota_entrada = round((vl_ipi_reg_nota_entrada - ((select round(sum(vl_ipi_reg_nota_entrada),2) from nota_entrada_item_registro
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) -
                                                                   (select round(vl_ipi_nota_entrada,2) from nota_entrada
                                                                    where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                                                          cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal))),2)
    where
      cd_nota_entrada      = @cd_nota_entrada and
      cd_fornecedor        = @cd_fornecedor and
      cd_operacao_fiscal   = @cd_operacao_fiscal and
      cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      cd_item_rem          = @cd_item_rem

  end  

  --Atualiza a Tabela com os Itens que foram alterados pelo usuário

  if @ic_manutencao = 'S' 
  begin
    delete from nota_entrada_item_registro
    where
      cd_nota_entrada in ( select cd_nota_entrada
                         from
                           #AuxItemRegistro
                         where
                           cd_nota_entrada      = @cd_nota_entrada      and
                           cd_fornecedor        = @cd_fornecedor        and
                           cd_operacao_fiscal   = @cd_operacao_fiscal   and
                           cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
                           isnull(ic_manutencao_fiscal,'N') = 'S' )

    insert into nota_entrada_item_registo
    select
      *
    from
      #AuxItemRegistro
    where
      isnull(ic_manutencao_fiscal,'N') = 'S'     

    drop table #AuxItemRegistro

  end

end 
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Estorno do REM
-------------------------------------------------------------------------------
begin

  -- Apaga os REMs existentes
  delete from
    Nota_Entrada_Registro
  where
    cd_fornecedor        = @cd_fornecedor and
    cd_nota_entrada      = @cd_nota_entrada and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
    cd_operacao_fiscal   = @cd_operacao_fiscal

  delete from
    Nota_Entrada_Item_Registro
  where
    cd_fornecedor = @cd_fornecedor and
    cd_nota_entrada = @cd_nota_entrada and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
    cd_operacao_fiscal   = @cd_operacao_fiscal

end
else
return

