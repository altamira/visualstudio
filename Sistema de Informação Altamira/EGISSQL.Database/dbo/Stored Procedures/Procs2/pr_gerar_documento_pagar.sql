
CREATE PROCEDURE pr_gerar_documento_pagar
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias P. da Silva
--Banco de Dados: EGISSQL 
--Objetivo      : Gera os Documentos a Pagar das Notas de Entrada
--Data          : 05/09/2002
--Atualizado    : 04/11/2002 - Elias
--              : 18/09/2003 - Carregando o Tipo de Conta através do
--                             Plano de Compras - ELIAS
--              : 17/10/2003 - Acrescentado a Série na Verificação de 
--                             Existência de Documento - ELIAS
--              : 31/10/2003 - Acrescido o parametro cd_documento_pagar a stp - ELIAS
--              : 05/04/2004 - Correção na gravação da Série do documento pagar - DANIEL DUELA
--              : 05/04/2004 - Correção ao excluir parcelas. - Daniel C> Neto.
--              : 16/07/2004 - Não Processa a Deleção caso a identificação seja nula - ELIAS
--              : 18/11/2004 - Criação da Rotina para Geração de Contas a Pagar de Embarque de Importação - ELIAS
-- 19/11/2004 - Criação da Rotina para Geração de Contas a Pagar de Embarque de Importação/ Exportação de Despesa - Daniel C. Neto.
-- Alteração    : 08/12/2004 - Criado parâmetro moeda "ic_parametro = 4" para geração automática de doctos. à pagar através do embarque de exportação - Paulo Santos
--                28/01/2004 - Acerto no Carregamento do Tipo de Conta e Pano Financeiro quando no Plano de Compra
--                             estiver Zerado e não apenas quando estiver vazio. - ELIAS
--                12.02.2005 - Acerto para Grava o cd_loja no Contas a Pagar - Carlos Fernandes.
--	          07.04.2005 - Inclusão da moeda padrão - Clelson Camargo
--                04.09.2005 - Acerto da busca da Moeda Padrão do Cadastro da Empresa - Carlos Fernandes
--                08.09.2005 - Acerto da busca do Plano Financeiro - Carlos Fernandes
--                07.02.2006 - Gravação do Centro de Custo - Carlos Fernandes
--                11.04.2006 - Plano Financeiro Alterado no Recebimento - Carlos Fernandes
--                19/10/2006 - Incluído execução de procedure para ratear Centro de Custos nas parcelas da nota de entrada
--                           - Daniel C. Neto.
--                12.11.2006 - Inclusão do Portador - Carlos Fernandes
--                14.02.2007 - Inclusão da Situação do Documento - 1 - Aberto - Default - Anderson. 
--                19.04.2007 - Correção do Plano Financeiro que vem do Pedido de Compra - Anderson. 
--                09.10.2007 - Checagem do Plnao Financeiro - Carlos Fernandes
--                21.11.2007 - Geração do Rateio do Centro de Custo a partir da nota de entrada - Carlos Fernandes
-- 29.04.2008 - Verificação da Geração pelo Faturamento - Carlos/Felipe
-- 27.11.2008 - Importação - Carlos Fernandes
-- 04.12.2008 - Pedido de Importação - Carlos Fernandes
-- 08.12.2009 - Referência novo campo na tabela documento_pagar - Carlos Fernandes
-- 17.04.2010 - Soma dos valores totais da Nota quando existe mais que 1 CFOP - Carlos Fernandes
-- 31.05.2010 - Novo atributo - cd_tipo_destinatario - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------
@ic_parametro         int = 0 ,
@cd_nota_entrada      int = 0 ,
@cd_fornecedor        int = null,
@cd_serie_nota_fiscal int = 0,
@cd_usuario           int = 0,
@cd_documento_pagar   int = null,
@cd_moeda             int = null,
@cd_plano_financeiro  int = 0

as

---------------------------------------------------------------------------------------
--Plano Financeiro - Regra - Carlos Fernandes - 08.09.2005
---------------------------------------------------------------------------------------
-- 1=Fornecedor
-- 2=Empresa Diversa
-- 3=Plano de Compra
-- 4=Tipo conta Pagar = Classificação da Conta
-- 5=Operação fiscal
-- 6=Nota Fiscal de Entrada - Alterado pelo Usuário
----------------------------------------------------------------------------------------


  -- variáveis locais

  declare @cd_parcela_nota_entrada  int
  declare @vl_parcela_nota_entrada  decimal(25,2)
  declare @nm_obs_parc_nota_entrada varchar(40)
  declare @dt_parcela_nota_entrada  datetime
  declare @dt_nota_entrada          datetime
  declare @cd_tipo_destinatario     int

  --declare @cd_plano_financeiro      int

  declare @cd_tipo_conta_pagar      int
  declare @cd_pedido_compra         int
  declare @cd_ident_parc_nota_entr  varchar(25)
  declare @nm_fantasia_fornecedor   varchar(30)
  declare @sg_serie_nota_fiscal     varchar(10)
  declare @cd_loja                  int
  declare @cd_centro_custo          int
  declare @cd_portador              int 
  
  declare @cd_identificacao         varchar(80)
  declare @cd_item_despesa          int
  declare @cd_tipo_documento        int
  declare @cd_empresa_diversa       int
  declare @cd_favorecido            int
  declare @nm_observacao            varchar(80)
  declare @Tabela                   varchar(50)

  if isnull(@cd_plano_financeiro,0) = 0
  begin
    set @cd_plano_financeiro = 0 
  end

  set @cd_portador = 0

  --Busca Dados do Parâmetro Financeiro

  select
     @cd_portador = isnull(cd_portador,@cd_portador)
  from
     Parametro_Financeiro with (nolock) 
  where
     cd_empresa= dbo.fn_empresa()     

  -- Atribui uma moeda padrao se for nula -- Clelson(07.04.2005)

  if (@cd_moeda is null)
  begin
    --Parametro_Financeiro
    --select @cd_moeda = cd_moeda from parametro_financeiro where cd_empresa = dbo.fn_empresa()

    --Carlos 04.09.2005 - Empresa     
    select @cd_moeda = isnull(cd_moeda,1) from egisadmin.dbo.empresa with (nolock) 
    where cd_empresa = dbo.fn_empresa()

  end

  -- Série da Nota Fiscal

  select
    top 1
    @sg_serie_nota_fiscal   = s.sg_serie_nota_fiscal,
    @cd_centro_custo        = isnull(n.cd_centro_custo,0),
    @cd_plano_financeiro    = isnull(n.cd_plano_financeiro,0),
    @cd_tipo_destinatario   = isnull(n.cd_tipo_destinatario,2),
    @nm_fantasia_fornecedor = isnull(n.nm_fantasia_destinatario,'')
  from
    Nota_Entrada n                      with (nolock) 
    left outer join Serie_Nota_Fiscal s with (nolock) on s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
  where
    n.cd_nota_entrada      = @cd_nota_entrada and
    n.cd_fornecedor        = @cd_fornecedor and
    n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal


-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Geração Automática do Contas a Pagar
-------------------------------------------------------------------------------
  begin
  
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

    -- Primeiro Pedido de Compra da Lista

    select
      top 1
      @cd_pedido_compra = ni.cd_pedido_compra
    from
      Nota_Entrada_Item ni with (nolock) 
      inner join
      Nota_Entrada n       with (nolock) on ni.cd_nota_entrada     = n.cd_nota_entrada  and
                                            n.cd_nota_entrada      = ni.cd_nota_entrada and
                                            n.cd_fornecedor        = ni.cd_fornecedor   and
                                            n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
 
    where
      n.cd_nota_entrada      = @cd_nota_entrada      and
      n.cd_fornecedor        = @cd_fornecedor        and
      n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
      ni.cd_pedido_compra is not null    

    order by
      ni.cd_item_nota_entrada

    -------------------------------------------------------------------------------
    --Plano Financeiro
    -------------------------------------------------------------------------------
    --1=Fornecedor

    select 
       @cd_plano_financeiro = isnull(f.cd_plano_financeiro,@cd_plano_financeiro)
    from
      fornecedor f                with (nolock) 
      inner join Pedido_Compra pc with (nolock) on pc.cd_fornecedor = f.cd_fornecedor
    where
      @cd_pedido_compra = pc.cd_pedido_compra

    --------------------------------------------------------------------------------     
    --3=Plano de Compra
    --------------------------------------------------------------------------------     
    -- TIPO DE CONTA A PAGAR E PLANO FINANCEIRO
    -- Carrega o Tipo de Conta a Pagar do Plano de Compras
    -- caso não exista no Plano de Compras, utilizar da Operação Fiscal

    select
      @cd_tipo_conta_pagar = isnull(pl.cd_tipo_conta_pagar,0),
      @cd_plano_financeiro = case when isnull(pc.cd_plano_financeiro,0)=0 then isnull(@cd_plano_financeiro,0) else isnull(pc.cd_plano_financeiro,0) end,
      --@cd_plano_financeiro = case when @cd_plano_financeiro=0 then isnull(pc.cd_plano_financeiro,0) else @cd_plano_financeiro end,
      @cd_centro_custo     = isnull(pc.cd_centro_custo,@cd_centro_custo)
    from
      Pedido_Compra pc,
      Plano_Compra pl  
    where
      pl.cd_plano_compra  = pc.cd_plano_compra and
      pc.cd_pedido_compra = @cd_pedido_compra


    -- Tabela temporária com as informações da Parcela  

    select distinct
      np.cd_nota_entrada,
      np.cd_fornecedor,
      max(np.cd_operacao_fiscal)            as cd_operacao_fiscal,
      np.cd_serie_nota_fiscal,
      np.cd_parcela_nota_entrada,
 
      --
      sum(np.vl_parcela_nota_entrada)       as vl_parcela_nota_entrada,
      max(np.nm_obs_parc_nota_entrada)      as nm_obs_parc_nota_entrada,
      max(np.dt_parcela_nota_entrada)       as dt_parcela_nota_entrada,
      max(n.dt_nota_entrada)                as dt_nota_entrada,
      max(s.sg_serie_nota_fiscal)           as sg_serie_nota_fiscal,
         
      -- ELIAS 28/01/2005
      -- Plano Financeiro

      max(case when (isnull(@cd_plano_financeiro,0)=0 and isnull(tc.cd_plano_financeiro,0) = 0) then
        op.cd_plano_financeiro
      else 
        case when  (isnull(@cd_plano_financeiro,0)=0 and isnull(tc.cd_plano_financeiro,0) <> 0) then
             tc.cd_plano_financeiro
             else 
             @cd_plano_financeiro end
      end)                                        as cd_plano_financeiro,

      max(case when (isnull(@cd_tipo_conta_pagar,0)=0) then
        tc.cd_tipo_conta_pagar
      else 
        @cd_tipo_conta_pagar
      end)                                            as cd_tipo_conta_pagar,

      max(np.cd_ident_parc_nota_entr)                 as cd_ident_parc_nota_entr,
      max(np.cd_documento_pagar)                      as cd_documento_pagar,
      max(isnull(n.cd_loja,0))                        as cd_loja,
      max(isnull(n.cd_centro_custo,@cd_centro_custo)) as cd_centro_custo 

    into
      #Nota_Entrada_Parcela

    from
      Nota_Entrada_Parcela np        with (nolock)
      left outer join Nota_Entrada n with (nolock) 
    on
      n.cd_nota_entrada      = np.cd_nota_entrada      and
      n.cd_fornecedor        = np.cd_fornecedor        and
      n.cd_operacao_fiscal   = np.cd_operacao_fiscal   and
      n.cd_serie_nota_fiscal = np.cd_serie_nota_fiscal
    left outer join                  
      Operacao_Fiscal op             with (nolock) 
    on
      op.cd_operacao_fiscal = n.cd_operacao_fiscal
    left outer join
      Tipo_Conta_Pagar tc            with (nolock) 
    on
      tc.cd_plano_financeiro = op.cd_plano_financeiro
    left outer join
      Serie_Nota_Fiscal s            with (nolock) 
    on
      s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal

    where
      np.cd_nota_entrada      = @cd_nota_entrada and
      np.cd_fornecedor        = @cd_fornecedor and
      np.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

    group by
      np.cd_nota_entrada,
      np.cd_fornecedor,
      np.cd_serie_nota_fiscal,
      np.cd_parcela_nota_entrada


    --select * from tipo_conta_pagar

    -- Nome Fantasia do Fornecedor

    select
      @nm_fantasia_fornecedor = isnull(nm_fantasia_fornecedor,@nm_fantasia_fornecedor)
    from
      Fornecedor with (nolock) 
    where
      cd_fornecedor = @cd_fornecedor

--      select * from 
--        Documento_Pagar 
--      where 
--        cd_documento_pagar in (select cd_documento_pagar from #Nota_Entrada_Parcela)


    -- verifica se as duplicatas geradas anteriormente já foram pagas
    if exists (select top 1 'x' from documento_pagar_pagamento where
               cd_documento_pagar in (select cd_documento_pagar from #Nota_Entrada_Parcela))
      raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                 Não foi possível gerar as parcelas novamente.', 16,1)
    else 
    begin

--      declare @erro varchar(250)

--      set @erro = 'Documento: ' + (select top 1 cast(cd_documento_pagar as varchar) from #Nota_Entrada_Parcela)

--      raiserror(@erro, 16,1)
      delete from 
        Documento_Pagar_Centro_Custo
      where 
        cd_documento_pagar in ( select cd_documento_pagar
                                from Documento_Pagar with (nolock) 
                                where cd_nota_fiscal_entrada = @cd_nota_entrada and
                                      cd_fornecedor          = @cd_fornecedor and
                                      cd_serie_nota_fiscal   = @cd_serie_nota_fiscal )

      delete from 
        Documento_Pagar 
      where 
        cd_nota_fiscal_entrada = @cd_nota_entrada and
        cd_fornecedor          = @cd_fornecedor and
        cd_serie_nota_fiscal   = @cd_serie_nota_fiscal 


    end   

    -- leitura das parcelas e geração das duplicatas

    while exists(select cd_parcela_nota_entrada from #Nota_Entrada_Parcela)
      begin
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        select
          top 1
          @cd_parcela_nota_entrada  = cd_parcela_nota_entrada,
          @vl_parcela_nota_entrada  = cast(str(vl_parcela_nota_entrada,25,2) as decimal(25,2)),
          @nm_obs_parc_nota_entrada = nm_obs_parc_nota_entrada,
          @sg_serie_nota_fiscal     = sg_serie_nota_fiscal,
          @dt_nota_entrada          = dt_nota_entrada,
          @dt_parcela_nota_entrada  = dt_parcela_nota_entrada,
          @cd_ident_parc_nota_entr  = cd_ident_parc_nota_entr,
          @cd_tipo_conta_pagar      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @cd_loja                  = cd_loja,
          @cd_centro_custo          = cd_centro_custo
        from
          #Nota_Entrada_Parcela

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          cd_nota_fiscal_entrada,
          cd_serie_nota_fiscal_entr,
          cd_serie_nota_fiscal,
          nm_observacao_documento,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_fornecedor,
          cd_usuario,
          dt_usuario,
          cd_pedido_compra,
          cd_plano_financeiro,
          nm_fantasia_fornecedor,
          cd_loja,
	  cd_moeda,
          cd_centro_custo,
          cd_portador,
          cd_situacao_documento,
          nm_ref_documento_pagar,
          cd_tipo_destinatario)
        values (
          @cd_documento_pagar,
          @cd_ident_parc_nota_entr,
          @dt_nota_entrada,
          @dt_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          @cd_nota_entrada,
          cast(@sg_serie_nota_fiscal as char(10)),
          @cd_serie_nota_fiscal,
          @nm_obs_parc_nota_entrada,
          @vl_parcela_nota_entrada,
          2,  -- Nota Fiscal
          @cd_tipo_conta_pagar,
          @cd_fornecedor,
          @cd_usuario,
          getDate(),
          @cd_pedido_compra,
          @cd_plano_financeiro,
          @nm_fantasia_fornecedor,
          @cd_loja,
          @cd_moeda,
          @cd_centro_custo,
          @cd_portador,
          1,
          cast(dbo.fn_strzero(datepart(mm,@dt_nota_entrada),2) as varchar(02))+'/'+
          cast(datepart(yyyy,@dt_nota_entrada) as varchar(04)),
          @cd_tipo_destinatario         )
        
          -- Procedure para ratear o centro de custo dos documentos do item da nota de entrada

          exec pr_gera_doc_pagar_centro_custo 
              @cd_documento_pagar, 
              @cd_nota_entrada,
              @cd_fornecedor,
              0,
              @cd_serie_nota_fiscal,
              @cd_usuario


          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

          -- Gravação do Documento a Pagar na Parcela - ELIAS 31/10/2003
          update 
            Nota_Entrada_Parcela
          set 
            cd_documento_pagar = @cd_documento_pagar 
          from
            Nota_Entrada_Parcela a,
            #Nota_Entrada_Parcela b
          where
            a.cd_nota_entrada         = b.cd_nota_entrada and
            a.cd_fornecedor           = b.cd_fornecedor and
            a.cd_operacao_fiscal      = b.cd_operacao_fiscal and
            a.cd_serie_nota_fiscal    = b.cd_serie_nota_fiscal and
            a.cd_parcela_nota_entrada = @cd_parcela_nota_entrada
           
          delete from
            #Nota_Entrada_Parcela
          where
            cd_parcela_nota_entrada = @cd_parcela_nota_entrada
            
      end 
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2           -- Estornar Títulos Gerados Automáticamente
-------------------------------------------------------------------------------
  begin
    if isnull(@cd_documento_pagar,0) <> 0
    begin

      if exists (select top 1 'x' from documento_pagar_pagamento where
                 cd_documento_pagar = @cd_documento_pagar)
        raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                   Não foi possível apagar os títulos.', 16,1)
      else
   
        delete Documento_Pagar_Contabil
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete Documento_Pagar_Plano_Financ
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete Documento_Pagar_Imposto
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete Documento_Pagar_Doc
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete Documento_Pagar_Cod_Barra
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete from 
          Documento_Pagar_Centro_Custo
        where 
          cd_documento_pagar = @cd_documento_pagar

        delete from 
          Documento_Pagar 
        where 
          cd_documento_pagar = @cd_documento_pagar
    
    end


  end
else
-------------------------------------------------------------------------------
if @ic_parametro = 3  -- Geração Automática do Contas a Pagar pelo Embarque
-------------------------------------------------------------------------------
  begin

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

    declare @cd_embarque_chave int
    
    select
      e.cd_pedido_importacao,
      ep.cd_parcela_embarque,
      e.dt_embarque,
      cast(str(ep.vl_parcela_embarque,25,2) as decimal(25,2)) as 'vl_parcela_embarque',     
      ep.dt_vcto_parcela_embarque,
      f.nm_fantasia_fornecedor,
      pv.cd_fornecedor,
      ep.cd_ident_parc_embarque,
      e.cd_embarque_chave
    into
      #Embarque_Importacao_Parcela
    from
      Embarque_Importacao e                     with (nolock) 
      inner join Embarque_Importacao_Parcela ep with (nolock) on e.cd_embarque = ep.cd_embarque and e.cd_pedido_importacao = ep.cd_pedido_importacao
      inner join Pedido_Importacao pv           with (nolock) on e.cd_pedido_importacao = pv.cd_pedido_importacao
      inner join Fornecedor f                   with (nolock) on pv.cd_fornecedor = f.cd_fornecedor
    where
      e.cd_embarque_chave = @cd_nota_entrada
    order by
      ep.cd_parcela_embarque


    -- verifica se as duplicatas geradas anteriormente já foram pagas
    if exists (select top 1 'x' from documento_pagar_pagamento where
               cd_documento_pagar in (select cd_documento_pagar from Documento_Pagar where cd_embarque_chave = @cd_nota_entrada))
      raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                 Não foi possível gerar as parcelas novamente.', 16,1)
    else 
    begin
 
      delete from 
        Documento_Pagar 
      where 
        cd_embarque_chave = @cd_nota_entrada
    end   
    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_parcela_embarque from #Embarque_Importacao_Parcela)
      begin
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        select
          top 1
          @cd_parcela_nota_entrada  = cd_parcela_embarque,
          @vl_parcela_nota_entrada  = cast(str(vl_parcela_embarque,25,2) as decimal(25,2)),
          @dt_parcela_nota_entrada  = dt_vcto_parcela_embarque,
          @cd_ident_parc_nota_entr  = cd_ident_parc_embarque,
          @dt_nota_entrada          = dt_embarque,
          @nm_fantasia_fornecedor   = nm_fantasia_fornecedor,
          @cd_fornecedor            = cd_fornecedor,
          @cd_embarque_chave        = cd_embarque_chave,
          @cd_tipo_conta_pagar      = 1,
          @cd_plano_financeiro      = 1
        from
          #Embarque_Importacao_Parcela

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_plano_financeiro,
          cd_fornecedor,
          cd_usuario,
          dt_usuario,
          nm_fantasia_fornecedor,
          cd_empresa,
          cd_embarque_chave,
          cd_situacao_documento,
          nm_ref_documento_pagar )
        values (
          @cd_documento_pagar,
          @cd_ident_parc_nota_entr,
          @dt_nota_entrada,
          @dt_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          2,  -- Nota Fiscal
          @cd_tipo_conta_pagar,
          @cd_plano_financeiro,
          @cd_fornecedor,
          @cd_usuario,
          getDate(),
          @nm_fantasia_fornecedor,
          dbo.fn_empresa(),
          @cd_embarque_chave,
          1,
          cast(dbo.fn_strzero(datepart(mm,@dt_nota_entrada),2) as varchar(02))+'/'+
          cast(datepart(yyyy,@dt_nota_entrada) as varchar(04))
          )
        
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   
          
          delete from
            #Embarque_Importacao_Parcela
          where
            cd_parcela_embarque = @cd_parcela_nota_entrada
            
      end 
  end

else
-------------------------------------------------------------------------------
if @ic_parametro = 4  -- Geração Automática do Contas a Pagar pelo Embarque Exportação Despesa
-------------------------------------------------------------------------------
  begin
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))
   
    /* -- Comentei este select devido não estar buscando o cd_tipo_conta_pagar - psantos 16/12/2004
      select
      e.cd_item_despesa_embarque,
      GetDate() as dt_emissao_despesa,
      e.dt_vencimento_despesa,
      cast(str(e.vl_despesa_embarque,25,2) as decimal(25,2)) as 'vl_parcela_embarque',     
      e.cd_empresa_diversa,
      e.cd_favorecido_empresa,
      tde.cd_tipo_conta_pagar,
      e.cd_plano_financeiro, 
      e.cd_documento_Pagar,
      e.nm_obs_despesa_embarque,
      e.cd_moeda
    into
      #Embarque_Exportacao_Despesa
    from
      Embarque_Despesa e 
      left outer join Tipo_Despesa_comex tde on tde.cd_tipo_despesa_comex = e.cd_tipo_despesa_comex
    where
      e.cd_embarque = @cd_nota_entrada and
      e.cd_pedido_venda = @cd_fornecedor
    order by
      e.cd_item_despesa_embarque*/

    select
      cd_item_despesa_embarque,
      GetDate() as dt_emissao_despesa,
      dt_vencimento_despesa,
      cast(str(vl_despesa_embarque,25,2) as decimal(25,2)) as 'vl_parcela_embarque',     
      cd_empresa_diversa,
      cd_favorecido_empresa,
      cd_tipo_conta_pagar,
      cd_plano_financeiro, 
      cd_documento_Pagar,
      nm_obs_despesa_embarque,
      cd_moeda
    into
      #Embarque_Exportacao_Despesa
    from
      Embarque_Despesa
    where
      cd_embarque = @cd_nota_entrada and
      cd_pedido_venda = @cd_fornecedor
    order by
      cd_item_despesa_embarque

    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_documento_pagar from #Embarque_Exportacao_Despesa)
      begin

        select
          top 1
          @cd_documento_pagar       = cd_documento_pagar,
          @cd_item_despesa          = cd_item_despesa_embarque,
          @vl_parcela_nota_entrada  = cast(str(vl_parcela_embarque,25,2) as decimal(25,2)),
          @dt_parcela_nota_entrada  = dt_vencimento_despesa,
          @dt_nota_entrada          = dt_emissao_despesa,
          @cd_empresa_diversa       = cd_empresa_diversa,
          @cd_favorecido            = cd_favorecido_empresa,
          @cd_tipo_conta_pagar      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @nm_observacao            = nm_obs_despesa_embarque,
          @cd_moeda                 = cd_moeda
        from
          #Embarque_Exportacao_Despesa

        -- verifica se as duplicatas geradas anteriormente já foram pagas
        if exists (select top 1 'x' from documento_pagar_pagamento where
                   cd_documento_pagar in (select cd_documento_pagar from Documento_Pagar where cd_documento_pagar = @cd_documento_pagar))
          raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente! 
                     Não foi possível gerar as despesas novamente.', 16,1)
        else 
        begin
          delete from 
            Documento_Pagar 
          where 
            cd_documento_pagar = @cd_documento_pagar
        end   

        exec pr_novo_documento_diverso 14, @cd_identificacao output
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_plano_financeiro,
          cd_empresa_diversa,
          cd_favorecido_empresa,
          cd_usuario,
          dt_usuario,
          cd_empresa, 
          nm_observacao_documento,
          cd_moeda,
          cd_situacao_documento,
          nm_ref_documento_pagar )
        values (
          @cd_documento_pagar,
          'DIV-'+ @cd_identificacao,
          @dt_nota_entrada,
          @dt_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          2,  -- Nota Fiscal
          @cd_tipo_conta_pagar,
          @cd_plano_financeiro,
          @cd_empresa_diversa,
          @cd_favorecido,
          @cd_usuario,
          getDate(),
          dbo.fn_empresa(),
          @nm_observacao,
          @cd_moeda,
          1,
          cast(dbo.fn_strzero(datepart(mm,@dt_nota_entrada),2) as varchar(02))+'/'+
          cast(datepart(yyyy,@dt_nota_entrada) as varchar(04))
          )
        
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

          update Embarque_Despesa
          set cd_documento_pagar = @cd_documento_pagar
          where
            cd_embarque = @cd_nota_entrada and
            cd_pedido_venda = @cd_fornecedor and
            cd_item_despesa_embarque = @cd_item_despesa
        
          delete from
            #Embarque_Exportacao_Despesa
          where
            cd_item_despesa_embarque = @cd_item_despesa
      end 
  end
else
-------------------------------------------------------------------------------
if @ic_parametro = 5  -- Geração Automática do Contas a Pagar pelo Embarque Importação Despesa
-------------------------------------------------------------------------------
  begin

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))


    select
      e.cd_item_despesa_embarque,
      --GetDate()                                              as dt_emissao_despesa,
      convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121) as dt_emissao_despesa,
      e.dt_vencimento_despesa,
      cast(str(e.vl_despesa_embarque,25,2) as decimal(25,2))   as 'vl_parcela_embarque',     
      e.cd_empresa_diversa,
      e.cd_favorecido_empresa,
      tde.cd_tipo_conta_pagar,
      e.cd_plano_financeiro, 
      e.cd_documento_Pagar,
      e.nm_obs_despesa_embarque,
      e.cd_centro_custo,
      tde.cd_tipo_documento
    into
      #Embarque_Importacao_Despesa
    from
      Embarque_Importacao_Despesa e          with (nolock) 
      left outer join Tipo_Despesa_comex tde with (nolock) on tde.cd_tipo_despesa_comex = e.cd_tipo_despesa_comex
    where
      e.cd_embarque          = @cd_nota_entrada and
      e.cd_pedido_importacao = @cd_fornecedor
    order by
      e.cd_item_despesa_embarque

    --select * from tipo_documento
    --select * from tipo_despesa_comex

    -- leitura das parcelas e geração das duplicatas

    while exists(select cd_documento_pagar from #Embarque_Importacao_Despesa)
      begin

        select
          top 1
          @cd_documento_pagar       = cd_documento_pagar,
          @cd_item_despesa          = cd_item_despesa_embarque,
          @vl_parcela_nota_entrada  = cast(str(vl_parcela_embarque,25,2) as decimal(25,2)),
          @dt_parcela_nota_entrada  = dt_vencimento_despesa,
          @dt_nota_entrada          = dt_emissao_despesa,
          @cd_empresa_diversa       = cd_empresa_diversa,
          @cd_favorecido            = cd_favorecido_empresa,
          @cd_tipo_conta_pagar      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @nm_observacao            = nm_obs_despesa_embarque,
          @cd_centro_custo          = cd_centro_custo,
          @cd_tipo_documento        = cd_tipo_documento
        from
          #Embarque_Importacao_Despesa

        -- verifica se as duplicatas geradas anteriormente já foram pagas
        if exists (select top 1 'x' from documento_pagar_pagamento where
                   cd_documento_pagar in (select cd_documento_pagar from Documento_Pagar where cd_documento_pagar = @cd_documento_pagar))
          raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente! 
                     Não foi possível gerar as despesas novamente.', 16,1)
        else 
        begin
     
          delete from 
            Documento_Pagar 
          where 
            cd_documento_pagar = @cd_documento_pagar

        end   


        exec pr_novo_documento_diverso 14, @cd_identificacao output
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_plano_financeiro,
          cd_empresa_diversa,
          cd_favorecido_empresa,
          cd_usuario,
          dt_usuario,
          cd_empresa, 
          nm_observacao_documento,
          cd_situacao_documento,
          cd_centro_custo,
          cd_pedido_importacao,
          nm_ref_documento_pagar
           )
        values (
          @cd_documento_pagar,
          'DIV-'+ @cd_identificacao,
          @dt_nota_entrada,
          @dt_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          @vl_parcela_nota_entrada,
          @cd_tipo_documento,
          @cd_tipo_conta_pagar,
          @cd_plano_financeiro,
          @cd_empresa_diversa,
          @cd_favorecido,
          @cd_usuario,
          getDate(),
          dbo.fn_empresa(),
          @nm_observacao,
          1,
          @cd_centro_custo,
          @cd_fornecedor,    --Pedido de Importação ( Está sendo usado nesta variável )
          cast(dbo.fn_strzero(datepart(mm,@dt_nota_entrada),2) as varchar(02))+'/'+
          cast(datepart(yyyy,@dt_nota_entrada) as varchar(04))
          )
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

          update Embarque_Importacao_Despesa
          set cd_documento_pagar = @cd_documento_pagar
          where
            cd_embarque              = @cd_nota_entrada and
            cd_pedido_importacao     = @cd_fornecedor   and
            cd_item_despesa_embarque = @cd_item_despesa
           
          
          delete from
            #Embarque_Importacao_Despesa
          where
            cd_item_despesa_embarque = @cd_item_despesa
            
      end 
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 6  -- Geração Automática do Contas a Pagar p/ Faturamento
-------------------------------------------------------------------------------
  begin

    --select * from operacao_fiscal

    -- variáveis locais
    declare @cd_parcela_nota_saida    int
    declare @vl_parcela_nota_saida    decimal(25,2)
    declare @dt_parcela_nota_saida    datetime
    declare @dt_nota_saida            datetime
    declare @cd_ident_parc_nota_saida varchar(25)
    declare @nm_fantasia_cliente      varchar(30)
  
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

    -- Tabela temporária com as informações da Parcela  

    select
      np.cd_parcela_nota_saida,
      np.vl_parcela_nota_saida,
      np.nm_obs_parcela_nota_saida,
      np.dt_parcela_nota_saida,
      n.dt_nota_saida,
      op.cd_plano_financeiro,
      tc.cd_tipo_conta_pagar,
      np.cd_ident_parc_nota_saida

    into
      #Nota_Saida_Parcela
    from
      Nota_Saida_Parcela np with (nolock) 
    left outer join
      Nota_Saida n
    on
      n.cd_nota_saida = np.cd_nota_saida    
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = n.cd_operacao_fiscal
    left outer join
      Tipo_Conta_Pagar tc
    on
      tc.cd_plano_financeiro = op.cd_plano_financeiro
    where
      np.cd_nota_saida = @cd_nota_entrada 

    --Define o Cliente ou Fornecedor
    --select * from nota_saida

    select
      @cd_fornecedor          = isnull(ns.cd_cliente,0),
      @nm_fantasia_fornecedor = ns.nm_fantasia_nota_saida,
      @cd_tipo_destinatario   = ns.cd_tipo_destinatario
    from
      nota_saida ns
    where
      ns.cd_nota_saida = @cd_nota_entrada


    -- verifica se as duplicatas geradas anteriormente já foram pagas
    if exists(select 
	        cd_documento_pagar
	      from
                Documento_Pagar with (nolock) 
              where
                cd_nota_saida = @cd_nota_entrada and
                cd_fornecedor = @cd_fornecedor and
                vl_saldo_documento_pagar = 0)
      raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                 Não foi possível gerar as parcelas novamente.', 16,1)
    else
      -- apaga as duplicatas existentes para a geração de novas

      delete from 
        Documento_Pagar 
      where 
        cd_nota_saida = @cd_nota_entrada and
        cd_fornecedor = @cd_fornecedor
       
    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_parcela_nota_saida from #Nota_Saida_Parcela)
      begin
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        select
          top 1
          @cd_parcela_nota_saida     = cd_parcela_nota_saida,
          @vl_parcela_nota_saida     = cast(str(vl_parcela_nota_saida,25,2) as decimal(25,2)),
          @dt_nota_saida             = dt_nota_saida,
          @dt_parcela_nota_saida     = dt_parcela_nota_saida,
          @cd_ident_parc_nota_saida  = cd_ident_parc_nota_saida,
          @cd_tipo_conta_pagar       = cd_tipo_conta_pagar,
          @cd_plano_financeiro       = cd_plano_financeiro

        from
          #Nota_Saida_Parcela

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          cd_nota_fiscal_entrada,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_fornecedor,
          cd_usuario,
          dt_usuario,
          cd_pedido_compra,
          cd_plano_financeiro,
          nm_fantasia_fornecedor,
          cd_nota_saida,
          nm_ref_documento_pagar,
          cd_tipo_destinatario )

        values (
          @cd_documento_pagar,
          @cd_ident_parc_nota_saida,
          @dt_nota_saida,
          @dt_parcela_nota_saida,
          @vl_parcela_nota_saida,
          @cd_nota_entrada,
          @vl_parcela_nota_saida,
          2,  -- Nota Fiscal
          @cd_tipo_conta_pagar,

          @cd_fornecedor,
          @cd_usuario,
          getDate(),
          @cd_pedido_compra,
          @cd_plano_financeiro,
          @nm_fantasia_fornecedor,
          @cd_nota_entrada,
          cast(dbo.fn_strzero(datepart(mm,@dt_nota_saida),2) as varchar(02))+'/'+
          cast(datepart(yyyy,@dt_nota_saida) as varchar(04)),
          @cd_tipo_destinatario)

       
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'        


          delete from
            #Nota_Saida_Parcela
          where
            cd_parcela_nota_saida = @cd_parcela_nota_saida
            
      end 

  end


--end

else
  return

