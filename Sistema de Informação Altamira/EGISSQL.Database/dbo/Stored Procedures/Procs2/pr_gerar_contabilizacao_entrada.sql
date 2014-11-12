
---------------------------------------------------------------------------------------------------------
--pr_gerar_contabilizacao_entrada
---------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2003
---------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias Pereira da Silva
--Banco de Dados: EGISSQL 
--Objetivo      : Gera os Registros de Contabilização
--Data          : 08/10/2003
--Atualizado    : 28/10/2003 - Data da Contabilização = Data de Recebimento - ELIAS
--                30/10/2003 - Inclusão do IPI - ELIAS
--                31/10/2003 - Inclusão de Rotina para buscar a Classificação da CFOP quando
--                             não encontrar no parâmetro_entrada - ELIAS
--                10/11/2003 - Buscando Tributação do Cabeçalho e não do item - ELIAS
--                12/11/2003 - Desconsiderar a Destinação na Busca do Parametro de Entradas - ELIAS/PAULINHO  
--                11/03/2004 - Considerar o Flag no Parametro_Contabilidade para utilizar
--                             ou não apenas o Lançamento Padrao Presente na CFOP - ELIAS
--                16/03/2004 - Acerto na leitura do flag de parâmetro_contabilizacao considerando
--                             quando o mesmo é null (uso do isnull) - ELIAS
--                11/05/2004 - Inserção de Contabilização para IRRF, ISS, INSS, PIS, COFINS e CSLL - DUELA
--                19/05/2004 - ESTAVA MULTIPLICANDO INDEVIDAMENTE OS VALORES DE IPI - ELIAS
--                29/06/2004 - Passa a buscar a Destinação do Produto da CFOP - ELIAS
--                16/07/2004 - Carrega o Valor do IPI do Fiscal caso tenha sido calculado e o usuário não o informou - ELIAS 
--                19/11/2004 - Acerto na Instrução Select que quando serviço não buscava corretamente o valor da contabilização
--                             foi necessário a criação de uma tabela temporária - ELIAS
--                29/03/2005 - Retirado verificação utilizando @@CURSOR_ROWS e feito leitura direta da Tabela - ELIAS 
--                19/08/2005 - Acerto no Cálculo do IPI não destacado na NF e somente destacado no Livro de Entrada - ELIAS
--                             Acerto na geração da contabilização quando continha o mesmo Lançamento Padrão, 
--                             mas com Planos de Compras diferentes - ELIAS
--                19.12.2006 - Contabilização do PIS/COFINS - Calculando os valores para Contabilização mesmo
--                             não existindo o valor na Nota de Entrada conforme Operação Fiscal - Carlos Fernandes
--                26.03.2007 - Base com 50% de Redução - Carlos Fernandes
--                27.03.2007 - Acerto da Contabilização quando existe alteração do registro de entrada - Carlos Ferandes
--                30.03.2007 - Notas com alteração do IPI
--                07.05.2007 - Contas Crédito - Carlso Fernandes/Anderson
--                19.08.2007 - Acerto da Contabilização PIS/COFINS - Super Simples - NÃO GERAR
--                06.09.2007 - Acerto do Plano de Compra - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------------
create procedure pr_gerar_contabilizacao_entrada
@ic_parametro         int = 0,
@cd_nota_entrada      int = 0,
@cd_fornecedor        int = 0,
@cd_operacao_fiscal   int = 0,
@cd_serie_nota_fiscal int = 0,
@cd_usuario           int = 0
as

begin

  SET NOCOUNT ON
  
  -------------------------------------------------------------------------------
  if @ic_parametro = 1     -- GERAÇÃO DA CONTABILIZAÇÃO
  -------------------------------------------------------------------------------
  begin

    declare @cd_item_nota_entrada      int
    declare @cd_lancamento_padrao      int
    declare @cd_conta_debito 	       int
    declare @cd_conta_credito 	       int
    declare @cd_historico	       int
    declare @nm_historico	       varchar(200)
    declare @nm_fantasia_destinatario  varchar(20)
    declare @cd_plano_compra	       int
    declare @cd_destinacao_produto     int
    declare @cd_item_contabil          int
    declare @cd_tributacao	       int  
    declare @vl_item	               decimal(25,2)
    declare @vl_ipi		       decimal(25,2)
    declare @vl_ipi_reducao            decimal(25,2)
    declare @vl_icms		       decimal(25,2)
    declare @vl_irrf                   decimal(25,2)
    declare @vl_inss		       decimal(25,2)
    declare @vl_iss                    decimal(25,2)
    declare @vl_pis                    decimal(25,2)
    declare @vl_cofins                 decimal(25,2)
    declare @vl_csll	               decimal(25,2)
    declare @vl_item_total	       decimal(25,2)
    declare @vl_ipi_total	       decimal(25,2)
    declare @vl_icms_total	       decimal(25,2)
    declare @vl_irrf_total	       decimal(25,2)
    declare @vl_inss_total             decimal(25,2)
    declare @vl_iss_total              decimal(25,2)
    declare @vl_pis_total              decimal(25,2)
    declare @vl_cofins_total           decimal(25,2)
    declare @vl_csll_total             decimal(25,2)
    declare @ic_simples_fornecedor     char(1) 
    declare @cd_lancamento_anterior    int
    declare @cd_plano_anterior	       int
    declare @cd_destinacao_anterior    int
    declare @cd_tributacao_anterior    int
    declare @nm_fantasia_anterior      varchar(20)
    declare @dt_receb_nota_entrada     datetime
    declare @ic_rateio_ipi             char(1)
    declare @vl_rateio_ipi             decimal(25,2)
    declare @vl_rateio_total           decimal(25,2)   
  
    set @cd_item_contabil = 0  
    set @vl_item_total    = 0
    set @vl_ipi_total     = 0
    set @vl_icms_total    = 0
    set @vl_irrf_total    = 0
    set @vl_inss_total    = 0
    set @vl_iss_total     = 0
    set @vl_pis_total	  = 0
    set @vl_cofins_total  = 0
    set @vl_csll_total	  = 0
    set @ic_rateio_ipi    = 'N'
    set @vl_rateio_ipi    = 0
    set @vl_rateio_total  = 0

    --Verificando todos os planos de Compras
    --Desenvolver rotina

      
    -- APAGANDO OS REGISTROS DE CONTABILIZAÇÃO

    delete from  Nota_Entrada_Contabil
    where cd_nota_entrada      = @cd_nota_entrada and
          cd_fornecedor        = @cd_fornecedor and
          cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
          cd_operacao_fiscal   = @cd_operacao_fiscal  

    --Verificar se o Fornecedor está no Simples

    select 
      @ic_simples_fornecedor = isnull(ic_simples_fornecedor,'N')
    from
      fornecedor f
    where
      f.cd_fornecedor = @cd_fornecedor

    --Montagem de uma tabela auxiliar para Redução do IPI
  
    select
       i.cd_nota_entrada,
       i.cd_fornecedor,
       i.cd_operacao_fiscal,
       i.cd_serie_nota_fiscal,
       i.cd_item_nota_entrada,

       --Verifica se o IPI terá 50% de redução da Base de Cálculo conforme Tributação 
 
       case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(i.vl_ipi_nota_entrada,0)>0 
       then
          i.vl_ipi_nota_entrada*(pte.pc_reducao_bc_ipi/100) 
       else
          case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(i.vl_ipi_nota_entrada,0)=0  
          then
           ( i.vl_contabil_nota_entrada * (pte.pc_reducao_bc_ipi/100) ) * (cf.pc_ipi_classificacao/100) 
          else 
           0.00
         end
      end as vl_ipi_reducao

--select cd_plano_compra,* from nota_entrada_item      
--select * from parametro_tributacao_entrada

    into #Contabilizacao_Entrada_IPI
    from
      nota_entrada_item i
      inner join nota_entrada n with (nolock)                       on  n.cd_nota_entrada       = i.cd_nota_entrada and
                                                                        n.cd_fornecedor         = i.cd_fornecedor and
                                                                        n.cd_operacao_fiscal    = i.cd_operacao_fiscal and
                                                                        n.cd_serie_nota_fiscal  = i.cd_serie_nota_fiscal 
    left outer join Operacao_Fiscal_Contabilizacao op with (nolock) on op.cd_operacao_fiscal    = n.cd_operacao_fiscal and
                                                                       op.cd_tipo_contabilizacao= 1
    left outer join Operacao_Fiscal opf               with (nolock) on opf.cd_operacao_fiscal = n.cd_operacao_fiscal

    left outer join Parametro_Tributacao_entrada pte  with (nolock) on pte.cd_tributacao          = i.cd_tributacao
    left outer join Classificacao_Fiscal cf           with (nolock) on cf.cd_classificacao_fiscal = i.cd_classificacao_fiscal
    where
      n.cd_nota_entrada      = @cd_nota_entrada and
      n.cd_fornecedor        = @cd_fornecedor and
      n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      n.cd_operacao_fiscal   = @cd_operacao_fiscal 

   --select * from #Contabilizacao_Entrada_IPI

    --Montagem dos dados para Contabilização

    --select cd_plano_compra,* from nota_entrada_item

    select
      i.cd_item_nota_entrada,
      op.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)) as vl_total_nota_entr_item,

      isnull(i.vl_ipi_nota_entrada,0)                            as vl_ipi_nota_entrada,

      ( select top 1 cast(isnull(ipi.vl_ipi_reducao,0) as decimal(25,2))
        from
          #Contabilizacao_Entrada_IPI ipi with (nolock)
        where  ipi.cd_nota_entrada      = @cd_nota_entrada and
               ipi.cd_fornecedor        = @cd_fornecedor and
               ipi.cd_operacao_fiscal   = @cd_operacao_fiscal and
               ipi.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
               ipi.cd_item_nota_entrada = i.cd_item_nota_entrada ) as vl_ipi_reducao,

      isnull(i.vl_icms_nota_entrada,0)                           as vl_icms_nota_entrada,
      max(isnull(n.vl_irrf_nota_entrada,0))                      as vl_irrf_nota_entrada,
      max(isnull(n.vl_inss_nota_entrada,0))                      as vl_inss_nota_entrada,
      case when (max(isnull(n.ic_reter_iss,'N'))='S') then
        max(isnull(n.vl_iss_nota_entrada,0)) 
      else 0 end as vl_iss_nota_entrada,
      sum(isnull(i.vl_pis_item_nota,0))                          as vl_pis_nota_entrada,
      sum(isnull(i.vl_cofins_item_nota,0))                       as vl_cofins_nota_entrada,
      max(isnull(n.vl_csll_nota_entrada,0))                      as vl_csll_nota_entrada,
      isnull(i.cd_plano_compra,0)                                as cd_plano_compra,
      isnull(opf.cd_destinacao_produto,0)                        as cd_destinacao_produto,    
      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada
    into #Contabilizacao_Entrada
    from
      nota_entrada_item i       with (nolock) 
      inner join nota_entrada n with (nolock)                       on  n.cd_nota_entrada        = i.cd_nota_entrada and
                                                                        n.cd_fornecedor          = i.cd_fornecedor and
                                                                        n.cd_operacao_fiscal     = i.cd_operacao_fiscal and
                                                                        n.cd_serie_nota_fiscal   = i.cd_serie_nota_fiscal 
    left outer join Operacao_Fiscal_Contabilizacao op with (nolock) on op.cd_operacao_fiscal     = n.cd_operacao_fiscal and
                                                                       op.cd_tipo_contabilizacao = 1

    left outer join Operacao_Fiscal opf               with (nolock) on opf.cd_operacao_fiscal = n.cd_operacao_fiscal


    where
      n.cd_nota_entrada      = @cd_nota_entrada and
      n.cd_fornecedor        = @cd_fornecedor and
      n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      n.cd_operacao_fiscal   = @cd_operacao_fiscal and
      isnull(op.cd_lancamento_padrao,0)<>0 and
      isnull((select isnull(ic_cfop_contab_entrada,'N') from parametro_contabilidade
              where cd_empresa = dbo.fn_empresa()),'N') = 'S'
    group by
      i.cd_item_nota_entrada,
      op.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)),
      isnull(i.vl_ipi_nota_entrada,0),
      isnull(i.vl_icms_nota_entrada,0),
      opf.cd_destinacao_produto,    
      isnull(i.cd_plano_compra,0),
      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada

    union all

    -- Busca o Lançamento Padrão da Tabela Operacao_Fiscal caso não a encontre em Parametro_Entrada
-- 
    select
      i.cd_item_nota_entrada,
      p.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)) as vl_total_nota_entr_item,

      isnull(i.vl_ipi_nota_entrada,0)                            as vl_ipi_nota_entrada,

      ( select top 1 cast(isnull(ipi.vl_ipi_reducao,0) as decimal(25,2))
        from
          #Contabilizacao_Entrada_IPI ipi with (nolock)
        where  ipi.cd_nota_entrada      = @cd_nota_entrada and
               ipi.cd_fornecedor        = @cd_fornecedor and
               ipi.cd_operacao_fiscal   = @cd_operacao_fiscal and
               ipi.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
               ipi.cd_item_nota_entrada = i.cd_item_nota_entrada ) as vl_ipi_reducao,

      isnull(i.vl_icms_nota_entrada,0)                           as vl_icms_nota_entrada,
      max(isnull(n.vl_irrf_nota_entrada,0))                      as vl_irrf_nota_entrada,
      max(isnull(n.vl_inss_nota_entrada,0))                      as vl_inss_nota_entrada,
      case when (max(isnull(n.ic_reter_iss,'N'))='S') then
        max(isnull(n.vl_iss_nota_entrada,0)) 
      else 0.00 end as vl_iss_nota_entrada,
      sum(isnull(i.vl_pis_item_nota,0))                          as vl_pis_nota_entrada,
      sum(isnull(i.vl_cofins_item_nota,0))                       as vl_cofins_nota_entrada,
      max(isnull(n.vl_csll_nota_entrada,0))                      as vl_csll_nota_entrada,

--      i.cd_plano_compra,

      max(case when isnull(i.cd_plano_compra,0)<>0
      then
        i.cd_plano_compra
      else
        case when isnull(pci.cd_plano_compra,0)=0
        then
           pc.cd_plano_compra
        else
           pci.cd_plano_compra end
      end)                                                        as cd_plano_compra,

      opf.cd_destinacao_produto,    
      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada

--into 
--    #Contabilizacao_Entrada

    from
      nota_entrada_item i                               with (nolock) 
      inner join nota_entrada n                         with (nolock) on n.cd_nota_entrada       = i.cd_nota_entrada and
                                                                       n.cd_fornecedor           = i.cd_fornecedor and
                                                                       n.cd_operacao_fiscal      = i.cd_operacao_fiscal and
                                                                       n.cd_serie_nota_fiscal    = i.cd_serie_nota_fiscal 
    left outer join Pedido_Compra pc                  with (nolock) on pc.cd_pedido_compra       = i.cd_pedido_compra
    left outer join Pedido_Compra_Item pci            with (nolock) on pci.cd_pedido_compra      = i.cd_pedido_compra and
                                                                       pci.cd_item_pedido_compra = i.cd_item_pedido_compra
    left outer join Parametro_Entrada p               with (nolock) on p.cd_operacao_fiscal      = i.cd_operacao_fiscal and
                                                                       p.cd_plano_compra         = 
                                                                                           case when isnull(i.cd_plano_compra,0)>0 then
                                                                                             i.cd_plano_compra
                                                                                           else
                                                                                           case when isnull(pci.cd_plano_compra,0)=0
                                                                                           then
                                                                                             pc.cd_plano_compra
                                                                                           else pci.cd_plano_compra end 
                                                                                           end
    left outer join Operacao_Fiscal opf               with (nolock) on opf.cd_operacao_fiscal = n.cd_operacao_fiscal        

    where
      n.cd_nota_entrada      = @cd_nota_entrada      and
      n.cd_fornecedor        = @cd_fornecedor        and
      n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      n.cd_operacao_fiscal   = @cd_operacao_fiscal   and
      isnull(p.cd_lancamento_padrao,0)<>0            and
      isnull((select isnull(ic_cfop_contab_entrada,'N') from parametro_contabilidade
              where cd_empresa = dbo.fn_empresa()),'N') = 'S'
    group by
      i.cd_item_nota_entrada,
      p.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)),
      isnull(i.vl_ipi_nota_entrada,0),
      isnull(i.vl_icms_nota_entrada,0),
      opf.cd_destinacao_produto,    
--      i.cd_plano_compra,

      case when isnull(i.cd_plano_compra,0)>0 then
        i.cd_plano_compra
      else
        case when isnull(pci.cd_plano_compra,0)=0
        then
           pc.cd_plano_compra
        else 
           pci.cd_plano_compra end
      end,

      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada

    union all

    --select * from nota_entrada_item

    select
      i.cd_item_nota_entrada,
      op.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)) as vl_total_nota_entr_item,

      isnull(i.vl_ipi_nota_entrada,0)                            as vl_ipi_nota_entrada,

      ( select top 1 cast(isnull(ipi.vl_ipi_reducao,0) as decimal(25,2))
        from
          #Contabilizacao_Entrada_IPI ipi with (nolock)
        where  ipi.cd_nota_entrada      = @cd_nota_entrada and
               ipi.cd_fornecedor        = @cd_fornecedor and
               ipi.cd_operacao_fiscal   = @cd_operacao_fiscal and
               ipi.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
               ipi.cd_item_nota_entrada = i.cd_item_nota_entrada ) as vl_ipi_reducao,

      isnull(i.vl_icms_nota_entrada,0)      as vl_icms_nota_entrada,
      max(isnull(n.vl_irrf_nota_entrada,0)) as vl_irrf_nota_entrada,
      max(isnull(n.vl_inss_nota_entrada,0)) as vl_inss_nota_entrada,
      case when (max(isnull(n.ic_reter_iss,'N'))='S') then
        max(isnull(n.vl_iss_nota_entrada,0))
      else 0 end as vl_iss_nota_entrada,
      sum(isnull(i.vl_pis_item_nota,0))                          as vl_pis_nota_entrada,
      sum(isnull(i.vl_cofins_item_nota,0))                       as vl_cofins_nota_entrada,
      max(isnull(n.vl_csll_nota_entrada,0))                      as vl_csll_nota_entrada,
--      i.cd_plano_compra,
      case when isnull(i.cd_plano_compra,0)>0 then
        i.cd_plano_compra
      else
      case when isnull(pci.cd_plano_compra,0)=0
      then
           pc.cd_plano_compra
      else pci.cd_plano_compra end 
      end                                                        as cd_plano_compra,
      op.cd_destinacao_produto,    
      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada
    from
      nota_entrada_item i                            with (nolock) 
    inner join nota_entrada n                        with (nolock) on n.cd_nota_entrada          = i.cd_nota_entrada and
                                                                      n.cd_fornecedor            = i.cd_fornecedor and
                                                                      n.cd_operacao_fiscal       = i.cd_operacao_fiscal and
                                                                      n.cd_serie_nota_fiscal     = i.cd_serie_nota_fiscal 
    left outer join Pedido_Compra pc                  with (nolock) on pc.cd_pedido_compra       = i.cd_pedido_compra
    left outer join Pedido_Compra_Item pci            with (nolock) on pci.cd_pedido_compra      = i.cd_pedido_compra and
                                                                       pci.cd_item_pedido_compra = i.cd_item_pedido_compra
    left outer join Operacao_Fiscal op                with (nolock) on op.cd_operacao_fiscal     = n.cd_operacao_fiscal

    where
      n.cd_nota_entrada      = @cd_nota_entrada and
      n.cd_fornecedor        = @cd_fornecedor and
      n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      n.cd_operacao_fiscal   = @cd_operacao_fiscal and
      (isnull(op.cd_lancamento_padrao,0)<>0) and 
      (isnull((select isnull(ic_cfop_contab_entrada,'N') from parametro_contabilidade
               where cd_empresa = dbo.fn_empresa()),'N') = 'S') and not exists (select 'x' 
                                                                                from 
                                                                                  Nota_Entrada_Item i
                                                                                left outer join Pedido_Compra pc  on 
                                                                                  pc.cd_pedido_compra = i.cd_pedido_compra 
                                                                                left outer join Pedido_Compra_Item pci  on 
                                                                                  pci.cd_pedido_compra = i.cd_pedido_compra and
                                                                                  pci.cd_item_pedido_compra = i.cd_item_pedido_compra 
                                                                                left outer join Parametro_Entrada p on 
                                                                                  p.cd_operacao_fiscal = i.cd_operacao_fiscal and
                                                                                  p.cd_plano_compra =   case when isnull(i.cd_plano_compra,0)>0 then
                                                                                                          i.cd_plano_compra
                                                                                                        else
                                                                                                        case when isnull(pci.cd_plano_compra,0)=0
                                                                                                      then
                                                                                                        pc.cd_plano_compra
                                                                                                      else pci.cd_plano_compra end 
                                                                                                      end
                                                                                where
  			                                                                          i.cd_nota_entrada = @cd_nota_entrada and 
                                             			                                i.cd_fornecedor = @cd_fornecedor and
     										                                                          i.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and 
  			                                                                          i.cd_operacao_fiscal = @cd_operacao_fiscal and
                                            			                                (isnull(p.cd_lancamento_padrao,0)<>0)) and
                                                                     			        isnull((select isnull(ic_cfop_contab_entrada,'N') from parametro_contabilidade
                                                                              		        where cd_empresa = dbo.fn_empresa()),'N') = 'N'
    group by
      i.cd_item_nota_entrada,
      op.cd_lancamento_padrao,
      cast(isnull(i.vl_total_nota_entr_item,0) as decimal(25,2)),
      isnull(i.vl_ipi_nota_entrada,0),
      isnull(i.vl_icms_nota_entrada,0),
      op.cd_destinacao_produto,    
      case when isnull(i.cd_plano_compra,0)>0 then
        i.cd_plano_compra
      else
      case when isnull(pci.cd_plano_compra,0)=0
      then
         pc.cd_plano_compra
      else pci.cd_plano_compra end
      end,
      n.cd_tributacao,
      n.nm_fantasia_destinatario,
      n.dt_receb_nota_entrada
    order by
      op.cd_lancamento_padrao,
      cd_item_nota_entrada

    --mostra a tabela de contabilização
--    select * from #Contabilizacao_Entrada

    declare cGerarContabilizacao cursor for
    select * from #Contabilizacao_Entrada

    open cGerarContabilizacao  
  
    fetch next from cGerarContabilizacao into @cd_item_nota_entrada, @cd_lancamento_padrao,
                                              @vl_item, @vl_ipi, @vl_ipi_reducao, @vl_icms, @vl_irrf, @vl_inss,
                                              @vl_iss,  @vl_pis, @vl_cofins,      @vl_csll, @cd_plano_compra, 
                                              @cd_destinacao_produto,
                                              @cd_tributacao, @nm_fantasia_destinatario,
                                              @dt_receb_nota_entrada


    -- Verifica se retornou apenas 1 registro e portanto pode-se carregar os Valores Fiscais, caso o usuário
    -- não tenha informado nos itens, mas que é calculado pela rotina de geração do livro fiscal 
    -- ELIAS 16/07/2004        
    -- Retirado verificação utilizando @@CURSOR_ROWS e feito leitura direta da Tabela - ELIAS 29/03/2005

    if ((select count(*) from #Contabilizacao_Entrada) = 1) and (isnull(@vl_ipi,0) = 0)
    begin

      set @vl_ipi = (select sum(isnull(vl_ipi_reg_nota_entrada,0)) from nota_entrada_item_registro
                     where cd_nota_entrada    = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                           cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) 

      set @vl_item = @vl_item - @vl_ipi

    end
    else
    -- Verifica se deverá fazer o Rateio do IPI que está no Livro Fiscal na Contabilização - ELIAS 19/08/2005
    if ((select sum(isnull(vl_ipi_nota_entrada,0)) from #Contabilizacao_Entrada) = 0)
    begin      

      set @vl_rateio_ipi = (select sum(isnull(vl_ipi_reg_nota_entrada,0)) from nota_entrada_item_registro
                            where cd_nota_entrada = @cd_nota_entrada and cd_fornecedor = @cd_fornecedor and
                                  cd_operacao_fiscal = @cd_operacao_fiscal and cd_serie_nota_fiscal = @cd_serie_nota_fiscal) 

      if (@vl_rateio_ipi > 0)    
      begin
        select @vl_rateio_total = sum(isnull(vl_total_nota_entr_item,0)) from #Contabilizacao_Entrada
        set @ic_rateio_ipi = 'S'
      end

      --set @vl_item = @vl_item - isnull(@vl_rateio_ipi,0)

    end
  
    set @cd_lancamento_anterior = @cd_lancamento_padrao
    set @cd_plano_anterior      = @cd_plano_compra
    set @cd_destinacao_anterior = @cd_destinacao_produto
    set @cd_tributacao_anterior = @cd_tributacao

    while @@fetch_status = 0
    begin
  
      if ((@cd_lancamento_padrao <> @cd_lancamento_anterior) or
          (@cd_plano_compra <> @cd_plano_anterior))
      begin

        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DA NF
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 1 - Nota

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 1 )
    
        begin              
    
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 1 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil

          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_contab_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_item_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior)
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DA NF/CUSTO
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 33-Custo da Mercadoria

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 33 )
    
        begin              
    
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 33 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil

          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_contab_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_item_total - @vl_icms_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior)

        end

        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO ICMS
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 2 - ICMS

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 2 )
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 2 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil

          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_icms_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getDate(),
            @vl_icms_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior)
        end
      
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO IPI
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 3 - IPI

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 3 ) and @vl_ipi_total>0
    
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 3 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior


    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_ipi_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao,
            vl_ipi_reducao_nota_entrada)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),

            case when @ic_rateio_ipi = 'S' and @vl_ipi_reducao=0
              then (@vl_item_total/@vl_rateio_total) * @vl_rateio_ipi
            else 
              @vl_ipi_total
            end,

            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior,
            @vl_ipi_reducao )

        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO IRRF
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 16 - IRRF

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 16 )
    
        begin    
  
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico = l.cd_historico_contabil,
            @nm_historico = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 16 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_irrf_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_irrf_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO INSS
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 17 - INSS

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 17 )
    
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico = l.cd_historico_contabil,
            @nm_historico = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 17 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_inss_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_inss_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO ISS
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 19 - ISS

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 19 )
    
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 19 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_iss_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_iss_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
  
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO COFINS
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 20 - COFINS

        --if @ic_simples_fornecedor = 'N' and 
        if 
           exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
           lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 20 )
    
        begin    
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 20 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_cofins_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_cofins_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO PIS
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 21 - PIS

        --if @ic_simples_fornecedor = 'N' and 
        if 
           exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 21 )
    
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 21 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_pis_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_pis_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
        end
  
        ---------------------------------------
        -- INSERINDO CONTABILIZAÇÃO DO CSLL
        ---------------------------------------
        --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
        --Lançamento 22 - CSLL

        if exists (select 'x' from lancamento_padrao l
                   left outer join historico_contabil h 
                     on h.cd_historico_contabil = l.cd_historico_contabil
                   where
                     l.cd_conta_plano = (select
                                            cd_conta_plano
                                          from
                                            lancamento_padrao
                                          where 
                                            cd_lancamento_padrao = @cd_lancamento_anterior) and
                     l.cd_tipo_contabilizacao = 22 )
    
        begin    
  
          set @cd_item_contabil = @cd_item_contabil + 1
    
          select top 1
            @cd_conta_debito  = l.cd_conta_debito,
            @cd_conta_credito = l.cd_conta_credito,
            @cd_historico     = l.cd_historico_contabil,
            @nm_historico     = h.nm_historico_contabil
          from
            lancamento_padrao l
          left outer join historico_contabil h on
            h.cd_historico_contabil = l.cd_historico_contabil
          where
            l.cd_conta_plano = (select
                                  cd_conta_plano
                                from
                                  lancamento_padrao
                                where 
                                  cd_lancamento_padrao = @cd_lancamento_anterior) and
            l.cd_tipo_contabilizacao = 22 and
            l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
          -- Incluindo o Registro no Nota_Entrada_Contabil
          insert into Nota_Entrada_Contabil (
            cd_nota_entrada,
            cd_fornecedor,
            cd_operacao_fiscal,
            cd_serie_nota_fiscal,
            cd_it_contab_nota_entrada,
            dt_contab_nota_entrada,
            cd_lancamento_padrao,
            cd_conta_debito,
            cd_conta_credito,
            cd_historico_contabil,
            nm_historico_nota_entrada,
            cd_usuario,
            dt_usuario,
            vl_csll_nota_entrada,
            cd_plano_compra,
            cd_destinacao_produto,
            cd_tributacao)
          values (
            @cd_nota_entrada,
            @cd_fornecedor,
            @cd_operacao_fiscal,
            @cd_serie_nota_fiscal,
            @cd_item_contabil,
            @dt_receb_nota_entrada,
            @cd_lancamento_anterior,
            @cd_conta_debito,
            @cd_conta_credito,
            @cd_historico,
            @nm_historico,
            @cd_usuario,
            getdate(),
            @vl_csll_total,
            @cd_plano_anterior,
            @cd_destinacao_anterior,
            @cd_tributacao_anterior )
        end
  
        -- INICIALIZANDO AS VARIÁVEIS

        set @vl_item_total   = 0
        set @vl_icms_total   = 0
        set @vl_ipi_total    = 0             
        set @vl_irrf_total   = 0
        set @vl_inss_total   = 0
        set @vl_iss_total    = 0             
        set @vl_pis_total    = 0
        set @vl_cofins_total = 0
        set @vl_csll_total   = 0             

        set @cd_lancamento_anterior = @cd_lancamento_padrao
        set @cd_plano_anterior      = @cd_plano_compra
        set @cd_destinacao_anterior = @cd_destinacao_produto
        set @cd_tributacao_anterior = @cd_tributacao
  
      end
  
      -- SOMATÓRIO DOS TOTAIS

      set @vl_item_total   = @vl_item_total   + isnull(@vl_item,0) + isnull(@vl_ipi,0)
      set @vl_icms_total   = @vl_icms_total   + isnull(@vl_icms,0)
      set @vl_ipi_total    = @vl_ipi_total    + isnull(@vl_ipi,0)  + isnull(@vl_ipi_reducao,0)
      set @vl_irrf_total   = @vl_irrf_total   + isnull(@vl_irrf,0)
      set @vl_inss_total   = @vl_inss_total   + isnull(@vl_inss,0)
      set @vl_iss_total    = @vl_iss_total    + isnull(@vl_iss,0)
      set @vl_pis_total    = @vl_pis_total    + isnull(@vl_pis,0)
      set @vl_cofins_total = @vl_cofins_total + isnull(@vl_cofins,0)
      set @vl_csll_total   = @vl_csll_total   + isnull(@vl_csll,0)

      
      fetch next from cGerarContabilizacao into @cd_item_nota_entrada, @cd_lancamento_padrao,
                                                @vl_item, @vl_ipi, @vl_ipi_reducao,@vl_icms, @vl_irrf, @vl_inss,
                                                @vl_iss, @vl_pis, @vl_cofins, @vl_csll, @cd_plano_compra, 
                                                @cd_destinacao_produto,
                                                @cd_tributacao, @nm_fantasia_destinatario,
                                                @dt_receb_nota_entrada
 
    end 
  
    --Verifica se o cursor ficou com dados, caso não tenha entra nesta condição

    if (@@CURSOR_ROWS <> 0)
    begin
      
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DA NF
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 1 - Nota

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 1 )
  
      begin    
  
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 1 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_contab_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_padrao,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_item_total,
           @cd_plano_compra,
           @cd_destinacao_produto,
           @cd_tributacao)

      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DA NF/CUSTO
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 33 - Custo da Mercadoria Nota

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 33 )
  
      begin    
  
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 33 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_contab_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_padrao,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_item_total - @vl_ipi_total - @vl_icms_total,
           @cd_plano_compra,
           @cd_destinacao_produto,
           @cd_tributacao)

      end
  

      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO ICMS
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 2 - ICMS

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 2 )
  
      begin    
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
         where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 2 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_icms_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getDate(),
           @vl_icms_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end 
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO IPI
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 3 - IPI

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 3 )
  
      begin    
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 3 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
   
         -- Incluindo o Registro no Nota_Entrada_Contabil

         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_ipi_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao,
           vl_ipi_reducao_nota_entrada)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),

           case when @ic_rateio_ipi = 'S' and @vl_ipi_reducao=0
             then (@vl_item_total/@vl_rateio_total) * @vl_rateio_ipi
           else 
             @vl_ipi_total
           end,

           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior,
           @vl_ipi_reducao)

      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO IRRF
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 16 - IRRF
      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 16 )
  
      begin
  
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
    from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 16 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_irrf_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_irrf_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO INSS
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 17 - INSS

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 17 )
  
      begin
  
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 17 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_inss_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_inss_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO ISS
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 19 - ISS

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 19 )
  
      begin
  
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 19 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_iss_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_iss_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO COFINS
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 20 - COFINS

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                  cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 20 )
  
      begin
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 20 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_cofins_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_cofins_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO PIS
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 21 - PIS

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 21 )
  
      begin
        set @cd_item_contabil = @cd_item_contabil + 1
    
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 21 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
    
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_pis_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_pis_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
      end
  
      ---------------------------------------
      -- INSERINDO CONTABILIZAÇÃO DO CSLL
      ---------------------------------------
      --Verifica se existe uma conta contábil para o tipo de lançamento da contabilização
      --Lançamento 22 - CSLL

      if exists (select 'x' from lancamento_padrao l
                 left outer join historico_contabil h 
                   on h.cd_historico_contabil = l.cd_historico_contabil
                 where
                   l.cd_conta_plano = (select
                                          cd_conta_plano
                                        from
                                          lancamento_padrao
                                        where 
                                          cd_lancamento_padrao = @cd_lancamento_anterior) and
                   l.cd_tipo_contabilizacao = 22 )
      begin
      
        set @cd_item_contabil = @cd_item_contabil + 1
      
        select top 1
          @cd_conta_debito  = l.cd_conta_debito,
          @cd_conta_credito = l.cd_conta_credito,
          @cd_historico     = l.cd_historico_contabil,
          @nm_historico     = h.nm_historico_contabil
        from
          lancamento_padrao l
        left outer join historico_contabil h on
          h.cd_historico_contabil = l.cd_historico_contabil
        where
          l.cd_conta_plano = (select
                                cd_conta_plano
                              from
                                lancamento_padrao
                              where 
                                cd_lancamento_padrao = @cd_lancamento_anterior) and
          l.cd_tipo_contabilizacao = 22 and
          l.cd_lancamento_padrao   = @cd_lancamento_anterior
      
         -- Incluindo o Registro no Nota_Entrada_Contabil
         insert into Nota_Entrada_Contabil (
           cd_nota_entrada,
           cd_fornecedor,
           cd_operacao_fiscal,
           cd_serie_nota_fiscal,
           cd_it_contab_nota_entrada,
           dt_contab_nota_entrada,
           cd_lancamento_padrao,
           cd_conta_debito,
           cd_conta_credito,
           cd_historico_contabil,
           nm_historico_nota_entrada,
           cd_usuario,
           dt_usuario,
           vl_csll_nota_entrada,
           cd_plano_compra,
           cd_destinacao_produto,
           cd_tributacao)
         values (
           @cd_nota_entrada,
           @cd_fornecedor,
           @cd_operacao_fiscal,
           @cd_serie_nota_fiscal,
           @cd_item_contabil,
           @dt_receb_nota_entrada,
           @cd_lancamento_anterior,
           @cd_conta_debito,
           @cd_conta_credito,
           @cd_historico,
           @nm_historico,
           @cd_usuario,
           getdate(),
           @vl_csll_total,
           @cd_plano_anterior,
           @cd_destinacao_anterior,
           @cd_tributacao_anterior)
        end 
      end

      --Fecha o cursor e desaloca da memória
      close cGerarContabilizacao
      deallocate cGerarContabilizacao

      --Ajusta o Lançamento conforme o Registro de Saída

    --------------------------------------------------------------------------------------------------
    --Carlos Fernandes
    --Verifica se houve manutenção no Livro de Entrada
    --26.03.2007
    --------------------------------------------------------------------------------------------------
    --select * from nota_entrada_item_registro

    declare @vl_icms_livro            decimal(25,2)
    declare @vl_cont_reg_nota_entrada decimal(25,2)
    declare @vl_ipi_livro             decimal(25,2)


    set @vl_icms_livro = (select sum(isnull(vl_icms_reg_nota_entrada,0)) from nota_entrada_item_registro
                          where cd_nota_entrada      = @cd_nota_entrada and 
                                cd_fornecedor        = @cd_fornecedor   and
                                cd_operacao_fiscal   = @cd_operacao_fiscal and 
                                cd_serie_nota_fiscal = @cd_serie_nota_fiscal ) 

    set @vl_cont_reg_nota_entrada = (select sum(isnull(vl_cont_reg_nota_entrada,0)) from nota_entrada_item_registro
                          where cd_nota_entrada      = @cd_nota_entrada and 
                                cd_fornecedor        = @cd_fornecedor   and
                                cd_operacao_fiscal   = @cd_operacao_fiscal and 
                                cd_serie_nota_fiscal = @cd_serie_nota_fiscal ) 

    set @vl_ipi_livro = (select sum(isnull(vl_ipi_reg_nota_entrada,0)) from nota_entrada_item_registro
                          where cd_nota_entrada      = @cd_nota_entrada and 
                                cd_fornecedor        = @cd_fornecedor   and
                                cd_operacao_fiscal   = @cd_operacao_fiscal and 
                                cd_serie_nota_fiscal = @cd_serie_nota_fiscal ) 


    --select * from nota_entrada_contabil

    update
      Nota_Entrada_Contabil
    set
      vl_icms_nota_entrada  = case when @vl_icms_livro <> isnull(nec.vl_icms_nota_entrada,0)
                                   then @vl_icms_livro 
                                   else nec.vl_icms_nota_entrada end

    from
      Nota_Entrada_Contabil nec
    where nec.cd_nota_entrada           = @cd_nota_entrada      and 
          nec.cd_fornecedor             = @cd_fornecedor        and
          nec.cd_operacao_fiscal        = @cd_operacao_fiscal   and 
          nec.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and
          nec.cd_it_contab_nota_entrada = 2 --ICMS

    update
      Nota_Entrada_Contabil
    set

      vl_contab_nota_entrada = case when @vl_cont_reg_nota_entrada <> isnull(nec.vl_contab_nota_entrada,0) and 
                                         @vl_cont_reg_nota_entrada>0
                                    then
                                         @vl_cont_reg_nota_entrada
                                    else
                                         nec.vl_contab_nota_entrada end

    from
      Nota_Entrada_Contabil nec
    where nec.cd_nota_entrada           = @cd_nota_entrada      and 
          nec.cd_fornecedor             = @cd_fornecedor        and
          nec.cd_operacao_fiscal        = @cd_operacao_fiscal   and 
          nec.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and
          nec.cd_it_contab_nota_entrada = 1 --COMPRA

    update
      Nota_Entrada_Contabil
    set
      vl_ipi_nota_entrada  = case when @vl_ipi_livro <> isnull(nec.vl_ipi_nota_entrada,0) --and isnull(nec.vl_ipi_reducao_nota_entrada,0)=0
                                  then @vl_ipi_livro 
                                  else nec.vl_ipi_nota_entrada end

    from
      Nota_Entrada_Contabil nec
    where nec.cd_nota_entrada           = @cd_nota_entrada      and 
          nec.cd_fornecedor             = @cd_fornecedor        and
          nec.cd_operacao_fiscal        = @cd_operacao_fiscal   and 
          nec.cd_serie_nota_fiscal      = @cd_serie_nota_fiscal and
          nec.cd_it_contab_nota_entrada = 3 --IPI

    end 

    -------------------------------------------------------------------------------
    else if @ic_parametro = 2   -- EXCLUSÃO DE LANCAMENTOS
    -------------------------------------------------------------------------------
    begin
    
      delete from
        Nota_Entrada_Contabil
      where
        cd_nota_entrada      = @cd_nota_entrada and
        cd_fornecedor        = @cd_fornecedor and
        cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
        cd_operacao_fiscal   = @cd_operacao_fiscal
    end

end


