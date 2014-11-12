
CREATE PROCEDURE pr_gerar_documento_pagar_ordem_servico
------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EGISSQL 
--Objetivo         : Gera os Documentos a Pagar das Ordem de Serviços
--Data             : 02.01.2006
--Atualizado       : 03.01.2006
--                 : 17.01.2006 - Acerto da Geração do Número do documento
--                 : 30.01.2006 - Não permitir geração de documento já gerado - Carlos Fernandes
--                 : 06.02.2006 - Geração Sintética com os itens lançados na Ordem Serviço
------------------------------------------------------------------------------------------------------------------
@ic_parametro         int = 0,
@cd_ordem_servico     int = 0,
@cd_usuario           int = 0,
@cd_documento_pagar   int = 0,
@cd_moeda             int = 0,
@ic_tipo_geracao      char(1) = 'A' --Sintética ou Análitica ( Individual por item lançados )

as

  -- variáveis locais
  declare @cd_parcela                 int
  declare @vl_parcela                 decimal(25,2)
  declare @nm_obs_parcela             varchar(40)
  declare @dt_parcela                 datetime
  declare @dt_emissao                 datetime
  declare @cd_plano_financeiro        int
  declare @cd_tipo_conta_pagar        int
  declare @cd_identificacao_documento varchar(25)
  declare @nm_fantasia_fornecedor     varchar(30)
  declare @cd_identificacao           varchar(80)
  declare @cd_item_despesa            int
  declare @cd_empresa_diversa         int
  declare @cd_favorecido              int
  declare @nm_observacao              varchar(80)
  declare @Tabela                     varchar(50)
  declare @cd_tipo_documento          int
  declare @cd_fornecedor              int
  declare @cd_serie_nota_fiscal       int
  declare @sg_serie_nota_fiscal       varchar(10)
  declare @cd_documento_despesa       varchar(15)
  declare @cd_centro_custo            int

  set @cd_plano_financeiro = 0 

  -- Atrubui uma moeda padrao se for nula -- Clelson(07.04.2005)

  if (isnull(@cd_moeda,0) = 0)
  begin
    --select @cd_moeda = cd_moeda from parametro_financeiro where cd_empresa = dbo.fn_empresa()
    --Carlos 04.09.2005 - Empresa     
    select @cd_moeda = isnull(cd_moeda,1) from egisadmin.dbo.empresa  where cd_empresa = dbo.fn_empresa()
  end

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Geração Automática do Contas a Pagar
-------------------------------------------------------------------------------
begin


  Create table #DocumentoPagar
   (
        cd_ordem_servico      int,
        cd_item_despesa_ordem int,
        cd_documento_despesa  varchar(15),
        dt_despesa            datetime,
        vl_documento          float,
        cd_empresa_diversa    int,
        cd_favorecido_empresa int,
        nm_tipo_despesa       varchar(40),
        cd_plano_financeiro   int,
        cd_tipo_conta_pagar   int,
        cd_tipo_documento     int,
        cd_documento_pagar    int,
        cd_fornecedor         int,
        nm_observacao         varchar(40),
        cd_centro_custo       int,
        dt_vencimento_despesa datetime

   )
  
    --Montagem da Tabela Auxiliar para gerar o contas a Pagar
    --select * from tipo_despesa
    --select * from Ordem_Servico_Analista_Despesa

    if @ic_tipo_geracao='A' 
    begin
      select 
        osdap.cd_ordem_servico,
        osdap.cd_item_despesa_ordem,
        osdap.cd_documento_despesa,
        osdap.dt_despesa,
        osdap.qt_item_despesa_ordem * vl_item_despesa_ordem as vl_documento,
        isnull(osa.cd_empresa_diversa,0)                    as cd_empresa_diversa,
        osa.cd_favorecido_empresa_div                       as cd_favorecido_empresa,
        td.nm_tipo_despesa,
        td.cd_plano_financeiro,
        td.cd_tipo_conta_pagar,
        td.cd_tipo_documento,
        osdap.cd_documento_pagar,
        isnull(osa.cd_fornecedor,0)                         as cd_fornecedor,
        'OS : '+cast(osdap.cd_ordem_servico as varchar(8))+'-'+
        c.nm_fantasia_cliente                               as nm_observacao,
        osa.cd_centro_custo,
        osa.dt_vencimento_despesa
       into
         #DocumentoPagarAnalitica
       from 
         Ordem_Servico_Analista_Despesa osdap
         inner join tipo_despesa td            on td.cd_tipo_despesa    = osdap.cd_tipo_despesa
         inner join Ordem_Servico_Analista osa on osa.cd_ordem_servico  = osdap.cd_ordem_servico
         left outer join Cliente c             on c.cd_cliente          = osa.cd_cliente
        where
           osdap.cd_ordem_servico = @cd_ordem_servico and
           isnull(td.ic_scp_tipo_despesa,'N') = 'S'   and
           isnull(osdap.cd_documento_pagar,0)=0       --Somente as Despesas ainda não geradas    

       insert into 
         #DocumentoPagar
       select * from
          #DocumentoPagarAnalitica

      end   

    --Sintético

    if @ic_tipo_geracao='S' 
    begin
      select 
        osa.cd_ordem_servico,
        max(osdap.cd_item_despesa_ordem)                          as cd_item_despesa_ordem,
        max(osdap.cd_documento_despesa)                           as cd_documento_despesa,
        max(osdap.dt_despesa)                                     as dt_despesa,
        sum(osdap.qt_item_despesa_ordem * vl_item_despesa_ordem ) as vl_documento,
        max(isnull(osa.cd_empresa_diversa,0))                     as cd_empresa_diversa,
        max(osa.cd_favorecido_empresa_div)                        as cd_favorecido_empresa,
        'Soma Total Despesas OS '                                 as nm_tipo_despesa,
        max(td.cd_plano_financeiro)                               as cd_plano_financeiro,
        max(td.cd_tipo_conta_pagar)                               as cd_tipo_conta_pagar,
        max(td.cd_tipo_documento)                                 as cd_tipo_documento,
        max(osdap.cd_documento_pagar)                             as cd_documento_pagar,
        max(isnull(osa.cd_fornecedor,0))                          as cd_fornecedor,
        'OS : '+cast(osa.cd_ordem_servico                         as varchar(8))+'-'+
            max(c.nm_fantasia_cliente)                            as nm_observacao,
        max(osa.cd_centro_custo)                                  as cd_centro_custo,
        max(osa.dt_vencimento_despesa)                            as dt_vencimento_despesa
       into
         #DocumentoPagarSintetica
       from 
         Ordem_Servico_Analista osa
         inner join Ordem_Servico_Analista_Despesa osdap on osa.cd_ordem_servico  = osdap.cd_ordem_servico
         inner join tipo_despesa td                      on td.cd_tipo_despesa    = osdap.cd_tipo_despesa
         left outer join Cliente c                       on c.cd_cliente          = osa.cd_cliente
       where
         osa.cd_ordem_servico = @cd_ordem_servico 
         and isnull(td.ic_scp_tipo_despesa,'N') = 'S' 
         and isnull(osdap.cd_documento_pagar,0)=0       --Somente as Despesas ainda não geradas    
       group by
         osa.cd_ordem_servico
          
       insert into 
         #DocumentoPagar
       select * from
         #DocumentoPagarSintetica

--       select * from
--         #DocumentoPagarSintetica

    end   

    --select * from ordem_servico_analista_despesa

    --select * from #Documentopagar

    -- leitura das despesas e geração das duplicatas
    while exists(select top 1 cd_ordem_servico from #DocumentoPagar)
      begin

        select
          top 1
          @cd_ordem_servico         = cd_ordem_servico,
          @cd_item_despesa          = cd_item_despesa_ordem,
          @vl_parcela               = cast(str(vl_documento,25,2) as decimal(25,2)),
          @dt_parcela               = dt_vencimento_despesa,
          @dt_emissao               = dt_despesa,
          @cd_empresa_diversa       = cd_empresa_diversa,
          @cd_favorecido            = cd_favorecido_empresa,
          @cd_tipo_conta_pagar      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @nm_observacao            = nm_observacao + '-'+cd_documento_despesa,
          @cd_documento_pagar       = cd_documento_pagar,
          @cd_tipo_documento        = cd_tipo_documento,
          @cd_fornecedor            = cd_fornecedor,
          @cd_documento_despesa     = cast ( cd_documento_despesa as varchar(15) ),
          @cd_centro_custo          = cd_centro_custo
        from
          #DocumentoPagar

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

        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

        --Verifica se é Documento para empresa Diversa
        if @cd_fornecedor = 0 --and @cd_empresa_diversa>0
        begin
       
          --Gera o próximo número sequencial para o documento diverso
          exec pr_novo_documento_diverso 14, @cd_identificacao output  
     
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
            cd_centro_custo)
          values (
            @cd_documento_pagar,
            'DIV-'+ @cd_identificacao,
            @dt_emissao,
            @dt_parcela,
            @vl_parcela,
            @vl_parcela,
            @cd_tipo_documento,  
            @cd_tipo_conta_pagar,
            @cd_plano_financeiro,
            @cd_empresa_diversa,
            @cd_favorecido,
            @cd_usuario,
            getDate(),
            dbo.fn_empresa(),
            @nm_observacao,
            @cd_moeda,
            @cd_centro_custo)
        end
         
        --Verifica se o documento é de Fornecedor
        if @cd_fornecedor > 0 and @cd_empresa_diversa=0
        begin
          -- Nome Fantasia do Fornecedor
          select
            @nm_fantasia_fornecedor = nm_fantasia_fornecedor
          from
            Fornecedor
          where
            cd_fornecedor = @cd_fornecedor

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
          cd_centro_custo)
        values (
          @cd_documento_pagar,
          @cd_identificacao_documento,
          @dt_emissao,
          @dt_parcela,
          @vl_parcela,
          @cd_documento_despesa,
          cast(@sg_serie_nota_fiscal as char(10)),
          @cd_serie_nota_fiscal,
          @nm_obs_parcela,
          @vl_parcela,
          @cd_tipo_documento,
          @cd_tipo_conta_pagar,
          @cd_fornecedor,
          @cd_usuario,
          getDate(),
          0, --Pedido de Compra
          @cd_plano_financeiro,
          @nm_fantasia_fornecedor,
          0, --Loja
          @cd_moeda,
          @cd_centro_custo)
         
        end          

        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

        --Atualiza a Ordem de Serviço com o Documento Pagar
        update
          Ordem_Servico_Analista_Despesa          
        set
          cd_documento_pagar = @cd_documento_pagar
        where
          @cd_ordem_servico         = cd_ordem_servico      and
          @cd_item_despesa          = cd_item_despesa_ordem
 

        --deleta o Registro da Tabela temporária
        delete from #DocumentoPagar
        where
          @cd_ordem_servico         = cd_ordem_servico      and
          @cd_item_despesa          = cd_item_despesa_ordem
     
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
        delete from 
          Documento_Pagar 
        where 
          cd_documento_pagar = @cd_documento_pagar

    end


  end
else
  return

