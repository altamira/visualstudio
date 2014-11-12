
CREATE PROCEDURE pr_gerar_documento_receber
-----------------------------------------------------------------------------------------------------------------
--pr_gerar_documento_receber
-----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
-----------------------------------------------------------------------------------------------------------------
--Stored Procedure   : Microsoft SQL Server 2000
--Autor(es)          :  Carlos Cardoso Fernandes
--Banco de Dados     : EgisSQL
--Objetivo           : Geração/Atualização dos documentos a receber.
--Data               : 
--Atualizado         : 09.01.2003 - Acerto p/ gravação do tipo de 
--                     destinatário no Documento_Receber - ELIAS
--	                 : 12.01.2003 - Cancelamento/Devolução da Nota Fiscal - Fabio Cesar
-- 	                 : 01.04.2003 - Devolução parcial do contas a receber - Johnny Mendes de Souza
--                   : 20/05/2003 - Acerto para geração do número incremental de série corretamente, 
--                                  que passa a ser feito na tabela de Parcelas anteriormente, por
--                                  isso excluído rotinas que estavam aqui para geração na tabela
--                                  de Documentos - ELIAS
--                   : 21/05/2003 - Acerto no Parâmetro 5 - Exclusão da Condição
--                                - and dt_cancelamento_documento is not null
--                                - Essa condição dava problema na ativação do
--                                - documento devolvido. - Daniel C. Neto.
--                   : 22/05/2003 - Johnny - Incluão do parâmetro 7 para geração do contas a receber 
--                                - pelo pedido de venda
--                   : 09/06/2003 - Inclusão dos campos cd_vendedor e cd_pedido_venda que não estavam
--                                  sendo carregados na pr_documento_receber - ELIAS
--                   : 13/06/2003 - Acerto de campo que faltava em tabela temporária na rotina de 
--                                  Ativação - ELIAS
--                   : 22/06/2003 - Verifica se o documento já foi baixado, impedindo prosseguir,
--                                  com a geração - ELIAS
--                   : 16.01.2004 - Gerar o documento já com o pago através do crédito de ICMS
--                                  de acordo com a nota fiscal - Fabio
--                   : 11/02/2004 - Inclusão de Rotina para geração de Identificações customizadas. - Daniel C. Neto.
--                   : 03.03.2004 - Inclusão de novo parâmetro(8) para cancelamento das duplicatas, geradas através
--                                  do pedido de venda. Igor Gama
--                   : 22.03.2004 - Foi criada uma consistência para sair da geração do documento caso o valor estiver zero
--                   : 29/03/2004 - Comentado, ou melhor, EXCLUIDO a validação INFELIZ que o PROGRAMADOR fez em 22/03/2004
--                                  pois a mesma estava sendo feita antes de ao menos CARREGAR O VALOR INICIAL,
--                                  ou seja, NUNCA GERANDO O DOCUMENTO A RECEBER. Foi criado mais um filtro ao selecionar
--                                  a Nota_Saida_Parcela, para não trazer valores nulos ou zerados. - ELIAS
--                   : 05/06/2004 - Modificado para gerar somente as Parcelas ainda não quitadas. - Daniel C. Neto.
--                   : 30/07/2004 - Acertado para gerar sempre os documentos com o valor principal, quando estes tiverem
--                                  crédito de devolução gerado pelo Movimento de Caixa - ELIAS
--                   : 06/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                   :            - Verificado Arrendamento do Saldo do Documento Receber ( Carlos/Paulo )
--                   : 08/01/2005 - Checagem do Processo de Devolução de Documento pela Nota Fiscal - Carlos
--                     17/01/2005 - Incluído campo de tipo_documento no parametro 7 - Daniel C. Neto.
--                   : 16.09.2005 - Busca do Portador Padrão / Específico do Cliente - Carlos Fernandes
--                   : 18.10.2005 - Colocado o Plano financeiro escolhido na nota para ser gravado. - Rafael Santiago.
--                   : 13.12.2005 - Centro de Custo / Plano Financeiro direto do Faturamento p/ Contas a Receber - Carlos Fernandes
--                     30/10/2006 - Incluído rotina para gerar documento a receber rateado - Daniel C. Neto.
--                     17/11/2006 - Centro de Custo Rateado só funcionará para a Cydak - Daniel C. neto.
--                     07.08.2007 - Gravação da Observação da Parcela - Carlos Fernandes
--                     17.12.2007 - Acerto do Plano_Financeiro - Carlos Fernandes
-- 19.12.2007 - Rateio do Plano Financeiro do Documento a Receber por Categoria de Produto - Carlos Fernandes       
-- 29.04.2008 - Atualização Manual de Documentos Automaticamente - Carlos Fernandes
-- 31.07.2008 - Verificação da Rotina - Carlos Fernandes
-- 20.01.2010 - Não gerar a Parcela no Contas a Receber mesmo que no Pedido de Venda - Gere a Parcela - Carlos Fernandes
-- 15.02.2010 - Tipo do Destinatario - Carlos Fernandes 
-- 20.04.2010 - Na geração por Pedido de Venda, se tiver baixado não gerar novamente - Carlos Fernandes
-- 12.05.2010 - Ajustes quando geração Pedido de Venda - Carlos Fernandes
-- 19.06.2010 - Data do Cancelamento não gravar com Hora - Carlos Fernandes
-- 10.10.2010 - Geração pelo Número de Identificação da Nota Fiscal - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------------------------
@ic_parametro 	int      = 0,
@cd_nota_saida  int      = 0, --Irá receber também o pedido de venda quando geração for pelo pedido
@dt_inicial	datetime = '',
@dt_final	datetime = '',
@cd_usuario	int      = 0

as

  declare @cd_documento_receber      int
  declare @cd_parcela_nota_saida     int
  declare @vl_parcela_nota_saida     float
  declare @dt_parcela_nota_saida     datetime
  declare @dt_nota_saida	     datetime
  declare @cd_cliente		     int
  declare @cd_pedido_venda	     int
  declare @cd_ordem_servico          int
  declare @cd_vendedor 		     int
  declare @cd_ident_parc_nota_saida  varchar(25)
  declare @nm_obs_parcela_nota_saida varchar(40)
  declare @Tabela		     varchar(50)
  declare @cd_plano_financeiro       int
  declare @cd_centro_custo           int
  declare @cd_portador               int
  declare @cd_portador_exp           int -- Portador para exportação Clelson(05.04.2005)
  declare @cd_tipo_documento         int
  declare @cd_tipo_cobranca          int

  declare @cd_tipo_destinatario      int
  declare @ic_credito_icms_nota      char(1)
  declare @ic_centro_custo_scr       char(1)

  declare @vl_credito_devolucao      money
  declare @vl_saldo_documento	     float
  declare @ds_documento_receber	     varchar(400)

  -- variáveis usadas somente no cancelamento e devolução
  declare @nm_mot_cancel_nota_saida  varchar(50)
  declare @dt_cancel_nota_saida      datetime

  -- necessário para exportação
  declare @cd_moeda                  int
  declare @cd_embarque_chave         int
  declare @dt_usuario                datetime

  -- controla se deve baixar automaticamente o Documento à Receber
--   declare @ic_baixa_autom_scr char(1)

  declare @ic_rateio int

  set @ic_rateio  = dbo.fn_ver_uso_custom('RATEIO')
  set @dt_usuario = getdate()

  -- campos default p/ documentos gerados automaticamente

  select
    @cd_portador         = cd_portador,
    @cd_tipo_documento   = cd_tipo_documento,
    @cd_tipo_cobranca    = cd_tipo_cobranca,
    @ic_centro_custo_scr = isnull(ic_centro_custo_scr,'N') 
  from  
    Parametro_Financeiro with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

--select * from cliente_informacao_credito
  
-----------------------------------------------------------------------------------------
if @ic_parametro = 1   -- Geração de Documentos à Receber Automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- Nesta geração é preciso verificar se é habilitado ao módulo a geração automática
    if ((select isnull(ic_auto_scr_empresa,'S') from parametro_comercial with (nolock) 
         where cd_empresa = dbo.fn_empresa()) = 'N')
      begin
        print('Geração Automática não Habilitada p/ Módulo Comercial!')
        return
      end  

    -- Verifica se a Duplicata já foi paga em algum momento, impedindo a 
    -- geração - ELIAS 22/07/2003

    if exists(select 
                top 1 'x' 
              from 
                documento_receber_pagamento drp,
                documento_receber dr
              where
                dr.cd_documento_receber = drp.cd_documento_receber and
                dr.cd_nota_saida        = @cd_nota_saida)
      begin
        print('Duplicata já baixada!')
        return
      end
                

    if @ic_centro_custo_scr  = 'S' and @ic_rateio = 1
    begin
     
      delete from Documento_Receber_Centro_Custo
      where cd_documento_receber in ( select x.cd_documento_receber
				      from
				        Documento_Receber x with (nolock) 
	  			      where 
				        x.cd_nota_saida      = @cd_nota_saida    and
					x.ic_tipo_lancamento = 'A'          and
					isnull(x.vl_saldo_documento,0) <> 0 ) --and
--					x.cd_documento_receber not in (select y.cd_documento_receber from documento_receber_pagamento y
--  					                               where y.cd_documento_receber = x.cd_documento_receber) )
   end


    -- Na geração automática excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualque motivo tiveram de ser 
    -- geradas novamente

    delete
      Documento_Receber
    where 
      cd_nota_saida      = @cd_nota_saida    and
      ic_tipo_lancamento = 'A'          and
      isnull(vl_saldo_documento,0) <> 0 and
      cd_documento_receber not in (select cd_documento_receber 
                                   from documento_receber_pagamento with (nolock) 
                                   where cd_documento_receber = Documento_Receber.cd_documento_receber) 

    -- Se a venda foi realizada pelo Caixa "GCA" pegar
    -- o valor do crédito de devolução - Eduardo - 23/12/2003

    select top 1
      @vl_credito_devolucao = isnull(mc.vl_credito_devolucao,0)
    from
      Nota_Saida ns                          with (nolock) 
      inner Join Movimento_Caixa_Pedido mped with (nolock) on mped.cd_pedido_venda  = ns.cd_pedido_venda
      inner Join Movimento_Caixa mc          with (nolock) on mc.cd_movimento_caixa = mped.cd_movimento_caixa
    where
      ns.cd_nota_saida = @cd_nota_saida

    set @vl_credito_devolucao = isnull(@vl_credito_devolucao,0)   

    --print convert(varchar,@vl_credito_devolucao)

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))
  
    -- Tabela temporária c/ todas as parcelas da Nota Fiscal de Saída

    select
      p.cd_nota_saida,
      p.cd_parcela_nota_saida,
      cast(str(p.vl_parcela_nota_saida,25,2) as decimal(25,2)) as 'vl_parcela_nota_saida',     
      p.dt_parcela_nota_saida,
      n.cd_tipo_destinatario,     
      n.cd_cliente,
      --Pedido de Venda
      case when isnull(n.cd_pedido_venda,0)>0 then
         n.cd_pedido_venda
      else
        ( select top 1 isnull(i.cd_pedido_venda,0) 
          from
            nota_saida_item i where i.cd_nota_saida = n.cd_nota_saida and i.cd_pedido_venda>0
            order by i.cd_pedido_venda )
       
      end                                                      as 'cd_pedido_venda',
      n.cd_vendedor,
      n.dt_nota_saida,
      p.cd_ident_parc_nota_saida,
      case 
        when 
          isnull(p.cd_plano_financeiro,0)<>0 -- is not null
        then 
          p.cd_plano_financeiro 
        when 
          isnull(o.cd_plano_financeiro,0)<>0 -- is not null 
        then 
          o.cd_plano_financeiro 
        else 
          f.cd_plano_financeiro 
      end                                       as cd_plano_financeiro,    

      n.ic_credito_icms_nota,
      d.cd_tipo_cobranca,
      cic.cd_portador,
      p.cd_centro_custo,
      p.nm_obs_parcela_nota_saida

    into
      #Nota_Saida_Parcela

    from
      Nota_Saida_Parcela p                    with (nolock) 
      left outer join Nota_Saida n            with (nolock) on p.cd_nota_saida        = n.cd_nota_saida
      left outer join Operacao_Fiscal o       with (nolock) on n.cd_operacao_fiscal   = o.cd_operacao_fiscal
      left outer join Parametro_Financeiro f  with (nolock) on f.cd_empresa           = dbo.fn_empresa()
      left outer join vw_destinatario d       with (nolock) on n.cd_tipo_destinatario = d.cd_tipo_destinatario and
                                                               n.cd_cliente           = d.cd_destinatario
      left outer join 
               cliente_informacao_credito cic with (nolock) on cic.cd_cliente = n.cd_cliente

    where
      IsNull(p.ic_parcela_quitada,'N') = 'N' and 
      -- ELIAS 29/03/2004
      (isnull(p.vl_parcela_nota_saida,0)<>0) and
      p.cd_nota_saida = @cd_nota_saida and
      n.cd_nota_saida        is not null and
      n.dt_cancel_nota_saida is null
    order by
      p.cd_nota_saida,
      p.cd_parcela_nota_saida

    -- Apagar a tabela temporária de Parcelas no Caixa

    while exists(select cd_nota_saida from #Nota_Saida_Parcela)
    begin
     
        -- campos da tabela de parcelas
        select top 1
          @cd_nota_saida            = cd_nota_saida,
          @cd_parcela_nota_saida    = cd_parcela_nota_saida,
          @vl_parcela_nota_saida    = vl_parcela_nota_saida,
          @dt_parcela_nota_saida    = dt_parcela_nota_saida,
          @dt_nota_saida            = dt_nota_saida,
          @cd_cliente               = cd_cliente,
          /* ELIAS 09/06/2003 */
          @cd_pedido_venda          = cd_pedido_venda,
          @cd_vendedor              = cd_vendedor,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          /* Fabio 23.07.2003 */
          @ic_credito_icms_nota = (case ic_credito_icms_nota
                                   when 'S' then 
                                     'S'
                                   else
                                     'N'
                                   end),
          @cd_plano_financeiro      = cd_plano_financeiro,
          @cd_centro_custo          = cd_centro_custo,
          @cd_ident_parc_nota_saida = cd_ident_parc_nota_saida,
          @cd_tipo_cobranca         = isnull(cd_tipo_cobranca, @cd_tipo_cobranca),
          --Carlos 16.09.2005
          @cd_portador              = case when isnull(cd_portador,0) = 0 then @cd_portador 
                                                                          else cd_portador end,
          @nm_obs_parcela_nota_saida=nm_obs_parcela_nota_saida
          /* Eduardo 12/11/2003 */
-- -- --           , @ic_baixa_autom_scr       = ic_baixa_autom_scr
        from
          #Nota_Saida_Parcela

        order by  
          cd_nota_saida,
          cd_parcela_nota_saida

        -- Se houver crédito de Devolução, gerar um abatimento no Valor da Duplicata
        -- ELIAS 30/07/2004 - Não deduzir o Crédito de Devolução do Valor Principal
        -- carregá-lo no campo correto no momento da geração do documento
        if ( @vl_credito_devolucao > 0 ) begin
          --set @vl_parcela_nota_saida = @vl_parcela_nota_saida - @vl_credito_devolucao
          set @ds_documento_receber = 'Ger. Autom. - Gerado com Crédito de Devolução'
        end
        else begin
          set @ds_documento_receber = 'Geração Automática p/ Faturamento. '+rtrim(ltrim(@nm_obs_parcela_nota_saida))
        end

        -- ELIAS 30/07/2004 - O Saldo deve ser descontado do Crédito de Devolução
        set @vl_saldo_documento = isnull(@vl_parcela_nota_saida,0) - isnull(@vl_credito_devolucao,0)

        --print('Atualizando SCR')

        if ( @vl_parcela_nota_saida > 0 ) begin

	        -- campo chave utilizando a tabela de códigos
	        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output
	
	        while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
	        begin
	    	    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
		        -- limpeza da tabela de código
	    	    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
	    	  end
	
	        -- montagem da identificação do documento

                --select @vl_parcela_nota_saida
             
                --print 'gera documento'
 
	        exec pr_documento_receber 
	           2, 
	           null, 
	           null, 
	           @cd_documento_receber, 
	           @cd_ident_parc_nota_saida,
	           @dt_nota_saida, 
	           @dt_parcela_nota_saida, 
	           @dt_parcela_nota_saida, 
	           @vl_parcela_nota_saida,
	           @vl_saldo_documento,           --Saldo do Documento Receber
	           null, 
	           null, 
	           0, 
	           null, 
	           @ds_documento_receber,
	           'N', 
	           null,
	           null, 
	           null, 
	           @cd_portador, 
	           @cd_tipo_cobranca, 
	           @cd_cliente, 
	           @cd_tipo_documento, 
	           @cd_pedido_venda, 
	           @cd_nota_saida, 
	           @cd_vendedor,
	           null, 
	           0, 
	           'A', 
	           null, 
	           @cd_plano_financeiro, 
	           @cd_usuario, 
	           '',
	           @cd_tipo_destinatario,
             -- ELIAS 30/07/2004 - Carregando crédito de devolução no campo de 
             -- abatimento
	           @vl_credito_devolucao,
	           0,
	           null, 
	           '',
	           @ic_credito_icms_nota,
                   1,  --Moeda R$
                   0,
                   0, --@cd_loja,
                   @cd_centro_custo

                --select @ic_centro_custo_scr

		if @ic_centro_custo_scr  = 'S' and @ic_rateio = 1
		  insert into Documento_Receber_Centro_Custo
		  ( cd_documento_receber,
		    cd_item_documento,
		    cd_centro_custo,
                    cd_item_centro_custo,
                    pc_centro_custo,
                    vl_centro_custo,
                    cd_usuario,
                    dt_usuario )
                  values (@cd_documento_receber,1,@cd_centro_custo,0, 100, @vl_parcela_nota_saida, @cd_usuario,GetDate())
	        
	        -- limpesa da tabela de código
	        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        end
	
        -- Executa a Baixa Automática do Contas à Receber
-- -- --         if ( @ic_baixa_autom_scr = 'S' )
-- -- --         begin
-- -- -- 
-- -- --           print('Baixando autimaticamente')
-- -- -- 
-- -- --           exec pr_documento_receber_pagamento
-- -- --             2,                      -- @ic_parametro			        int,
-- -- --             @cd_documento_receber,  -- @cd_documento_receber 		  int,
-- -- --             1,                      -- @cd_item_documento_receber	int,
-- -- --             @dt_parcela_nota_saida, -- @dt_pagamento_documento		datetime,
-- -- --             @vl_parcela_nota_saida, -- @vl_pagamento_documento		float,
-- -- --             0,    -- @vl_juros_pagamento		  float,
-- -- --             0,    -- @vl_desconto_documento		float,
-- -- --             0,    -- @vl_abatimento_documento	float,
-- -- --             0,    -- @vl_despesa_bancaria		  float,
-- -- --             null, -- @cd_recibo_documento		  varchar(20),
-- -- --             '',   -- @ic_tipo_abatimento		  char(1),
-- -- --             '',   -- @ic_tipo_liquidacao		  char(1),
-- -- --             0,    -- @vl_reembolso_documento	float,
-- -- --             0,    -- @vl_credito_pendente		  float,
-- -- --             '',   -- @ic_desconto_comissao		char(1),
-- -- --             @cd_usuario, -- @cd_usuario			  int,
-- -- --             '',   -- @dt_usuario			        datetime,
-- -- --             '',   -- @nm_obs_documento		    varchar(50),
-- -- --             4,    -- @cd_tipo_liquidacao      int,
-- -- --             null, -- @cd_banco                int,
-- -- --             null  -- @cd_conta_banco          int
-- -- -- 
-- -- --         end


        if @cd_plano_financeiro>0 
        begin
          update Nota_Saida_Parcela
          set
             cd_plano_financeiro = @cd_plano_financeiro
          where cd_nota_saida         = @cd_nota_saida and
                cd_parcela_nota_saida = @cd_parcela_nota_saida

        end
      
        -- exclusão do registro usado
        delete #Nota_Saida_Parcela
        where cd_nota_saida         = @cd_nota_saida and
              cd_parcela_nota_saida = @cd_parcela_nota_saida

      end

     --Deleta a tabela temporária
     drop table #Nota_Saida_Parcela

     --select '1111'

     --Gera o Rateiro do Documentos a Receber por centro de Custo
     exec pr_geracao_rateio_documento_receber_categoria @cd_nota_saida,null,null,@cd_usuario
   

   end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Gera as Duplicatas à Receber Manualmente
-----------------------------------------------------------------------------------------
  begin

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    -- Tabela temporária c/ todas as parcelas do período

    select
      p.cd_nota_saida,
      p.cd_parcela_nota_saida,
      cast(str(p.vl_parcela_nota_saida,25,2) as decimal(25,2)) as 'vl_parcela_nota_saida',
      p.dt_parcela_nota_saida,
      n.cd_cliente,
      d.cd_tipo_cobranca,
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.dt_nota_saida,
      p.cd_ident_parc_nota_saida,
      case 
        when 
          p.cd_plano_financeiro is not null
        then 
          p.cd_plano_financeiro 
        when 
          o.cd_plano_financeiro is not null 
        then 
          o.cd_plano_financeiro 
        else 
          f.cd_plano_financeiro 
        end as cd_plano_financeiro,
      n.ic_credito_icms_nota,
      cic.cd_portador,
      n.cd_tipo_destinatario

--select cd_tipo_destinatario,* from nota_saida

    into
      #Nota_Saida_Parcela_Data

    from
      Nota_Saida_Parcela p with (nolock)
      left outer join Nota_Saida n                   on p.cd_nota_saida = n.cd_nota_saida
      left outer join Operacao_Fiscal o              on n.cd_operacao_fiscal = o.cd_operacao_fiscal
      left outer join Parametro_Financeiro f         on f.cd_empresa = dbo.fn_empresa()
      left outer join vw_destinatario d              on n.cd_cliente           = d.cd_destinatario and
                                                        n.cd_tipo_destinatario = d.cd_tipo_destinatario
      left outer join Cliente_Informacao_Credito cic on cic.cd_cliente = n.cd_cliente
           
    where
      -- ELIAS 29/03/2004
      (isnull(p.vl_parcela_nota_saida,0)<>0)            and
      isnull(p.ic_scr_parcela_nota_saida,'N') <> 'S'    and
      n.dt_nota_saida between @dt_inicial and @dt_final and
      n.cd_nota_saida            is not null            and
      n.dt_cancel_nota_saida     is null                and
      p.cd_ident_parc_nota_saida not in ( select cd_identificacao from documento_receber )
    order by
      p.cd_nota_saida,
      p.cd_parcela_nota_saida

--Mostra a Tabela
--    select * from #Nota_Saida_Parcela_Data
  
 while exists(select top 1 cd_nota_saida from #Nota_Saida_Parcela_Data)
      begin
     
        -- campos da tabela de parcelas

        select
          top 1
          @cd_nota_saida            = cd_nota_saida,
          @cd_parcela_nota_saida    = cd_parcela_nota_saida,
          @vl_parcela_nota_saida    = vl_parcela_nota_saida,
          @dt_parcela_nota_saida    = dt_parcela_nota_saida,
          @dt_nota_saida            = dt_nota_saida,
          @cd_cliente               = cd_cliente,          
          /* ELIAS 09/06/2003 */
          @cd_pedido_venda          = cd_pedido_venda,
          @cd_vendedor              = cd_vendedor,
          @cd_plano_financeiro	    = cd_plano_financeiro,
          @cd_ident_parc_nota_saida = cd_ident_parc_nota_saida,
   	      /* Fabio 22.07.2003 */
	  @ic_credito_icms_nota     = ic_credito_icms_nota,
          @cd_tipo_cobranca         = isnull(cd_tipo_cobranca, @cd_tipo_cobranca),
          --Carlos 16.09.2005
          @cd_portador              = case when isnull(cd_portador,0) = 0 then @cd_portador 
                                                                          else cd_portador end,
          @cd_tipo_destinatario     = cd_tipo_destinatario

        from
          #Nota_Saida_Parcela_Data

        order by   
          cd_nota_saida,
          cd_parcela_nota_saida

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

        exec dbo.pr_documento_receber 
           @ic_parametro              = 2, 
           @dt_inicial                = null, 
           @dt_final                  = null, 
           @cd_documento_receber      = @cd_documento_receber, 
           @cd_identificacao          = @cd_ident_parc_nota_saida,
           @dt_emissao_documento      = @dt_nota_saida, 
           @dt_vencimento_documento   = @dt_parcela_nota_saida, 
           @dt_vencimento_original    = @dt_parcela_nota_saida, 
           @vl_documento_receber      = @vl_parcela_nota_saida,
           @vl_saldo_documento        = @vl_parcela_nota_saida, 
           @dt_cancelamento_documento = null,         
	   @nm_cancelamento_documento = null, 
           @cd_modulo                 = 0, 
           @cd_banco_documento_recebe = null, 
           @ds_documento_receber      = 'Geração Automática p/ Faturamento.', 
           @ic_envio_documento        = 'N', 
           @dt_envio_banco_documento  = null,
           @dt_contabil_documento     = null, 
           @cd_portador               = @cd_portador, 
           @cd_tipo_cobranca          = @cd_tipo_cobranca, 
           @cd_cliente                = @cd_cliente, 
           @cd_tipo_documento         = @cd_tipo_documento, 
           @cd_pedido_venda           = @cd_pedido_venda, 
           @cd_nota_saida             = @cd_nota_saida, 
           @cd_vendedor               = @cd_vendedor,
           @dt_pagto_document_receber = null, 
           @vl_pagto_document_receber = 0, 
           @ic_tipo_lancamento        = 'A', 
           @cd_tipo_liquidacao        = null, 
           @cd_plano_financeiro       = @cd_plano_financeiro, 
           @cd_usuario                = @cd_usuario, 
           @dt_usuario                = @dt_usuario,
           @cd_tipo_destinatario      = @cd_tipo_destinatario,
           @vl_abatimento_documento   = 0,
           @vl_reembolso_documento    = 0,
           @dt_devolucao_documento    = null,
           @nm_devolucao_documento    = @ic_credito_icms_nota --Define que não trata-se de um pagamento usando crédito de ICMS para o pagamento

        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        -- Atualização da Tabela de Parcelas
        --update 
        --  Nota_Saida_Parcela
        --set
        --  ic_scr_parcela_nota_saida = 'S'
        --where
        --  cd_nota_saida = @cd_nota_saida and
        --  cd_parcela_nota_saida = @cd_parcela_nota_saida

        if @cd_plano_financeiro>0 
        begin
          update Nota_Saida_Parcela
          set
             cd_plano_financeiro = @cd_plano_financeiro
          where cd_nota_saida         = @cd_nota_saida and
                cd_parcela_nota_saida = @cd_parcela_nota_saida

        end

        -- exclusão do registro usado

        delete 
          #Nota_Saida_Parcela_Data
        where
          @cd_nota_saida = cd_nota_saida and
          @cd_parcela_nota_saida = cd_parcela_nota_saida

      end

     drop table #Nota_Saida_Parcela_Data

   end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Cancelamento dos documentos gerados automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- tabela temporária com as informações p/ o cancelamento
    select
      d.cd_documento_receber,
      d.cd_cliente,
      d.cd_tipo_destinatario,
      n.cd_nota_saida,
      n.nm_mot_cancel_nota_saida,
      n.dt_cancel_nota_saida
    into
      #Nota_Saida_Parcela_Cancelada
    from
      Documento_Receber d            with (nolock) 
      left outer join   Nota_Saida n with (nolock) on d.cd_nota_saida = n.cd_nota_saida
    where
      n.cd_status_nota = 7 and
      n.cd_nota_saida  = @cd_nota_saida
   
    while exists(select top 1 cd_nota_saida from #Nota_Saida_Parcela_Cancelada)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_nota_saida            = cd_nota_saida,
          @nm_mot_cancel_nota_saida = nm_mot_cancel_nota_saida,
          @dt_cancel_nota_saida     = dt_cancel_nota_saida,
          @cd_documento_receber     = cd_documento_receber
        from
          #Nota_Saida_Parcela_Cancelada

        -- cancelamento do documento automático
   
     update 
          Documento_Receber 
        set
          vl_saldo_documento        = 0.00,
          dt_cancelamento_documento = @dt_cancel_nota_saida,        
	  nm_cancelamento_documento = @nm_mot_cancel_nota_saida,
          cd_tipo_liquidacao        = 2,  -- Cancelamento
          cd_usuario                = @cd_usuario,
          dt_usuario                = getDate()
        where
          cd_documento_receber = @cd_documento_receber          


        -- exclusão do registro usado
        delete 
          #Nota_Saida_Parcela_Cancelada
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #Nota_Saida_Parcela_Cancelada                                       

  end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Devolução Total dos documentos gerados automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- tabela temporária com as informações p/ o cancelamento
    select
      d.cd_documento_receber,
      d.cd_cliente,
      d.cd_tipo_destinatario,
      n.cd_nota_saida,
      n.nm_mot_cancel_nota_saida,
      n.dt_cancel_nota_saida
    into
      #Nota_Saida_Parcela_Devolvida
    from
      Documento_Receber d with (nolock) 
    left outer join
      Nota_Saida n
    on
      d.cd_nota_saida = n.cd_nota_saida
    where
      n.cd_status_nota = 4 and
      n.cd_nota_saida  = @cd_nota_saida

   
    while exists(select top 1 cd_nota_saida from #Nota_Saida_Parcela_Devolvida)
      begin
     
        -- campos da tabela de parcelas

        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario, 
          @cd_nota_saida            = cd_nota_saida,
          @nm_mot_cancel_nota_saida = nm_mot_cancel_nota_saida,
          @dt_cancel_nota_saida     = dt_cancel_nota_saida,
          @cd_documento_receber     = cd_documento_receber
        from
          #Nota_Saida_Parcela_Devolvida

        -- devolução do documento automático
        update 
          Documento_Receber 
        set
          vl_saldo_documento     = 0.00,
          dt_devolucao_documento = @dt_cancel_nota_saida,
          nm_devolucao_documento = @nm_mot_cancel_nota_saida,
          cd_tipo_liquidacao     = 1,  -- Devolução
          cd_usuario             = @cd_usuario,    
      	  dt_usuario             = getDate()
        where
          cd_documento_receber = @cd_documento_receber          

        -- exclusão do registro usado
        delete 
          #Nota_Saida_Parcela_Devolvida
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #Nota_Saida_Parcela_Devolvida
                                       
  end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 5 -- Reativação de Duplicata Cancelada/Devolvida Indevidamente
-----------------------------------------------------------------------------------------
  begin

    -- tabela temporária com as informações p/ a ativação

    select
      d.cd_documento_receber,
      d.cd_cliente,
      d.cd_tipo_destinatario,
      n.cd_nota_saida,
      /* ELIAS 09/06/2003 */
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.nm_mot_cancel_nota_saida,
      n.dt_cancel_nota_saida,
      dt.cd_tipo_cobranca
    into
      #Nota_Saida_Parcela_Ativacao

    from
      Documento_Receber d with (nolock)                               left outer join
      Nota_Saida n        on d.cd_nota_saida        = n.cd_nota_saida left outer join
      vw_destinatario dt  on n.cd_tipo_destinatario = dt.cd_tipo_destinatario and n.cd_cliente = dt.cd_destinatario
    where
      (n.cd_status_nota = 5) and -- Ele já ativou a nota!!!
      n.cd_nota_saida = @cd_nota_saida
   
    while exists(select top 1 cd_nota_saida from #Nota_Saida_Parcela_Ativacao)
      begin
     
        -- campos da tabela de parcelas

        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario, 
          @cd_nota_saida            = cd_nota_saida,
          /* ELIAS 09/06/2003 */
          @cd_pedido_venda          = cd_pedido_venda,
          @cd_vendedor              = cd_vendedor,
          @nm_mot_cancel_nota_saida = nm_mot_cancel_nota_saida,
          @dt_cancel_nota_saida     = dt_cancel_nota_saida,
          @cd_documento_receber     = cd_documento_receber,
          @cd_tipo_cobranca         = isnull(cd_tipo_cobranca, @cd_tipo_cobranca)
        from
          #Nota_Saida_Parcela_Ativacao

        -- devolução do documento automático
        update 
          Documento_Receber 
        set
          vl_saldo_documento        = vl_documento_receber,
          dt_devolucao_documento    = Null,
          nm_devolucao_documento    = Null,
          cd_tipo_liquidacao        = Null,
          cd_usuario                = @cd_usuario,    
      	  dt_usuario                = getDate(),
          dt_cancelamento_documento = Null,
          nm_cancelamento_documento = Null
        where
          cd_documento_receber = @cd_documento_receber          

        -- exclusão do registro usado
        delete 
          #Nota_Saida_Parcela_Ativacao
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #Nota_Saida_Parcela_Ativacao                                


/*
    -- Na reativação excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualquer motivo tiveram de ser 
    -- geradas novamente
    delete
      Documento_Receber
    where
      cd_nota_saida = @cd_nota_saida and
      ic_tipo_lancamento = 'A' and
      (dt_devolucao_documento is not null or
       dt_cancelamento_documento is not null)

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    -- Tabela temporária c/ todas as parcelas do período
    select
      p.cd_nota_saida,
      p.cd_parcela_nota_saida,
      cast(str(p.vl_parcela_nota_saida,25,2) as decimal(25,2)) as 'vl_parcela_nota_saida',
      p.dt_parcela_nota_saida,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.dt_nota_saida,
      p.cd_ident_parc_nota_saida,
      case when 
        o.cd_plano_financeiro is not null 
      then 
        o.cd_plano_financeiro 
      else 
        f.cd_plano_financeiro 
      end as cd_plano_financeiro
    into
      #Nota_Saida_Parcela_Reativacao
    from
      Nota_Saida_Parcela p
    left outer join
      Nota_Saida n
    on
      p.cd_nota_saida = n.cd_nota_saida
    left outer join
      Operacao_Fiscal o
    on
      n.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Parametro_Financeiro f
    on
      f.cd_empresa = dbo.fn_empresa()
    where
      p.cd_nota_saida = @cd_nota_saida and
      n.cd_nota_saida is not null and
      n.dt_cancel_nota_saida is null
    order by
      p.cd_nota_saida,
      p.cd_parcela_nota_saida

    while exists(select top 1 cd_nota_saida from #Nota_Saida_Parcela_Reativacao)
    begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_nota_saida            = cd_nota_saida,
          @cd_parcela_nota_saida    = cd_parcela_nota_saida,
          @vl_parcela_nota_saida    = vl_parcela_nota_saida,
          @dt_parcela_nota_saida    = dt_parcela_nota_saida,
          @dt_nota_saida            = dt_nota_saida,
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_plano_financeiro	    = cd_plano_financeiro,
          @cd_ident_parc_nota_saida = cd_ident_parc_nota_saida
        from
          #Nota_Saida_Parcela_Reativacao
        order by   
          cd_nota_saida,
          cd_parcela_nota_saida

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

/* Não tem necessidade de gerar o código 2 vezes....pois isso pode dar conflito qdo dois usuários <> tentatem
 gerar parcela simultaneamente. 
      	while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
      	begin
	        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
    	     -- limpeza da tabela de código
	        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
      	end
*/

-- 	PRINT 'CHEGOU ATÉ AQUI'

        -- geração do documento à receber

        exec dbo.pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento_receber, 
           @cd_ident_parc_nota_saida,
           @dt_nota_saida, 
           @dt_parcela_nota_saida, 
           @dt_parcela_nota_saida, 
           @vl_parcela_nota_saida,
           @vl_parcela_nota_saida, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática p/ Faturamento. - Reativação', 
           'N', 
           null,
           null, 
	     null,
           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_cliente, 
           @cd_tipo_documento, 
           @cd_pedido_venda, 
           @cd_nota_saida, 
           @cd_vendedor,
           null, 
           0,      
      	   'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario, 
           @dt_usuario, --getdate(),
           @cd_tipo_destinatario,
           0,
           0,
           null,
           @ic_credito_icms_nota
		   

        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        -- Atualização da Tabela de Parcelas
        --update 
        --  Nota_Saida_Parcela
        --set
        --  ic_scr_parcela_nota_saida = 'S'
        --where
        -- cd_nota_saida = @cd_nota_saida and
        --  cd_parcela_nota_saida = @cd_parcela_nota_saida

        if @cd_plano_financeiro>0 
        begin
          update Nota_Saida_Parcela
          set
             cd_plano_financeiro = @cd_plano_financeiro
          where cd_nota_saida         = @cd_nota_saida and
                cd_parcela_nota_saida = @cd_parcela_nota_saida

        end


        -- exclusão do registro usado
        delete 
          #Nota_Saida_Parcela_Reativacao    
        where
          @cd_nota_saida         = cd_nota_saida and
          @cd_parcela_nota_saida = cd_parcela_nota_saida

      end

     drop table #Nota_Saida_Parcela_Reativacao
*/
   end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 6 -- Devolução Parcial de Nota Fiscal
-----------------------------------------------------------------------------------------
begin
  return
/*
  declare @cd_nota_credito int

  --Verificando se nota foi devolvida
  if exists(select top 1 'x' from Nota_Saida where cd_nota_saida = @cd_nota_saida and dt_nota_dev_nota_saida is not null)
  begin
    --Verificando se existem parcelas
    if exists(select top 1 'x' from Nota_Saida_Parcela where cd_nota_saida = @cd_nota_saida)
    begin
           
      --Verificando se nota já foi devolvida
      if exists(select top 1 'x' from Nota_Credito_Item where cd_nota_saida = @cd_nota_saida)
      begin
        --Atualização de nota de crédito já existente
        select 1
      end
      else
      begin
        --Inclusão de nota de crédito

        --Gerando código da nota de crédito
				Set @Tabela = Db_Name() + '.dbo.Nota_Credito'
				exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_nota_credito', @codigo = @cd_nota_credito output
   
        insert into 
          nota_credito
          (cd_nota_credito, 
           dt_emissao_nota_credito, 
           dt_vencto_nota_credito, 
           vl_nota_credito, 
           ds_nota_credito, 
           ic_emitida_nota_credito, 
           cd_usuario, 
           dt_usuario, 
           cd_cliente)
        select
           @cd_nota_credito,
           getdate(),
           getdate(),
           sum(),
        from
          Nota_Saida_Item
        
      
        --Liberando código gerado para a nota de crédito
    		exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_nota_credito, 'D'	
      end       

    end
    else
      return  
  end
  else
    return
*/
end else

------------------------------------------------------------------------------------------------
if @ic_parametro = 7   -- Geração de Documentos à Receber Automaticamente Pelo Pedido de Venda
------------------------------------------------------------------------------------------------
  begin

    declare @ic_identificacao_parcela char(1)
    declare @cd_tipo_doc              int 
    declare @ic_auto_scr_empresa      char(1)
    declare @ic_gera_scr_pedido       char(1)
 
    select
       @ic_identificacao_parcela = IsNull(ic_identificacao_parcela,''),
       @ic_auto_scr_empresa      = Isnull(ic_auto_scr_empresa,'S'),
       @ic_gera_scr_pedido       = isnull(ic_gera_scr_pedido,'S')

    from
       Parametro_Comercial with (nolock) 

    where 
      cd_empresa = dbo.fn_empresa() 

    --Verifica se Gera Contas a Receber pelo Pedido

    if @ic_gera_scr_pedido = 'N' 
    begin
      return
    end
				      
    -- Nesta geração é preciso verificar se é habilitado ao módulo a geração automática

    if @ic_auto_scr_empresa='N'
      begin
        print('Geração Automática não Habilitada p/ Módulo Comercial!')
        return
      end  


    -- Monta uma tabela auxiliar e verifica se o documento foi Pago

    select
      d.cd_documento_receber
    into
      #DocumentoPago
    from
      Documento_Receber d                       with (nolock)  
      inner join documento_receber_pagamento dp with (nolock) on dp.cd_documento_receber = d.cd_documento_receber

    where
      cd_pedido_venda    = @cd_nota_saida and
      ic_tipo_lancamento = 'A'            

    --select * from #DocumentoPago
      
    if exists ( select cd_documento_receber from #DocumentoPago )
    begin
      --drop table #DocumentoPago
      print('Pedido já possui Documento a Receber Baixado - Verifique !')
      --return
    end

    print 'Geração Normal'

    -- Na geração automática excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualque motivo tiveram de ser 
    -- geradas novamente

    delete
      Documento_Receber

    where
      cd_pedido_venda    = @cd_nota_saida and
      ic_tipo_lancamento = 'A'   and
      vl_saldo_documento <> 0    and
      isnull(cd_nota_saida,0)=0  --Verifica se já foi Gerado Nota Fiscal de Saída 
                                 --ccf 20.01.2010
      --12.05.2010
      and
      cd_documento_receber not in ( select cd_documento_receber from #DocumentoPago )

    drop table #DocumentoPago
      
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))
  
    -- Tabela temporária c/ todas as parcelas do Pedido de Venda

    select
      pvp.cd_pedido_venda,
      pvp.cd_parcela_ped_venda,
      cast(str(pvp.vl_parcela_ped_venda,25,2) as decimal(25,2)) as 'vl_parcela_ped_venda',     
      pvp.dt_vcto_parcela_ped_venda,
      1                           as cd_tipo_destinatario,     
      pv.cd_cliente,
      pv.cd_vendedor,
      pv.dt_pedido_venda,
      pvp.cd_ident_parc_ped_venda as cd_ident_parc_ped_venda,
      IDENTITY(int, 1, 1)         as Inc,
      pc.cd_plano_financeiro,
      pv.ic_credito_icms_pedido,
      pvp.cd_tipo_documento,
      cic.cd_portador

    into
      #Pedido_Venda_Parcela

    from
      Pedido_Venda_Parcela pvp                       with (nolock) 
      left outer join Pedido_Venda         pv        with (nolock) on pvp.cd_pedido_venda = pv.cd_pedido_venda
      left outer join Parametro_Comercial  pc        with (nolock) on pc.cd_empresa       = dbo.fn_empresa()
      left outer join Cliente_Informacao_Credito cic with (nolock) on cic.cd_cliente      = pv.cd_cliente
    where
      pvp.cd_pedido_venda = @cd_nota_saida  and
      pv.cd_pedido_venda        is not null and
      pv.dt_cancelamento_pedido is null
    order by
      pvp.cd_pedido_venda,
      pvp.cd_parcela_ped_venda

    while exists(select cd_pedido_venda from #Pedido_Venda_Parcela)
    begin
     
        -- campos da tabela de parcelas

        select
          top 1
          @cd_pedido_venda          = cd_pedido_venda,
          @cd_parcela_nota_saida    = cd_parcela_ped_venda,
          @vl_parcela_nota_saida    = vl_parcela_ped_venda,
          @dt_parcela_nota_saida    = dt_vcto_parcela_ped_venda,
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @cd_ident_parc_nota_saida = cd_ident_parc_ped_venda,
          @cd_vendedor		    = cd_vendedor,
          @dt_nota_saida            = dt_pedido_venda,
          @ic_credito_icms_nota     = ic_credito_icms_pedido,
          @cd_tipo_doc              = ( case when IsNull(cd_tipo_documento,0) = 0 then
                                          @cd_tipo_documento else IsNull(cd_tipo_documento,0) end),
          --Carlos 16.09.2005
          @cd_portador              = case when isnull(cd_portador,0) = 0 then @cd_portador 
                                                                          else cd_portador end

        from
          #Pedido_Venda_Parcela

        order by  
          cd_pedido_venda,
          cd_parcela_ped_venda

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

        while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
          begin
	    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
	    -- limpeza da tabela de código
	    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
      	  end


        -- montagem da identificação do documento

        exec pr_documento_receber 
           2,                         --parametro
           null,                      --data inicial
           null,                      --data final
           @cd_documento_receber,     --número do documento receber
           @cd_ident_parc_nota_saida, --identificação parcela
           @dt_nota_saida,            --Emissão
           @dt_parcela_nota_saida,    --Vencimento
           @dt_parcela_nota_saida,    --Vencimento Original
           @vl_parcela_nota_saida,    --Valor
           @vl_parcela_nota_saida,    --Saldo
           null,                      --Cancelamento
           null,                      --Motivo
           0,                         --Módulo
           null,                      --Número Bancário
           'Geração Automática Pelo Pedido de Venda.', --Observação 
           'N',                       --Emitido
           null,                      --Envio
           null,                      --Data Envio
           null,                      --Data Contabil
           @cd_portador,              --Portador
           @cd_tipo_cobranca,         --Cobrança
           @cd_cliente,               --cliente
           @cd_tipo_doc,              --tipo documento
           @cd_pedido_venda,          --pedido de venda
           null,                      --nota de saída
           @cd_vendedor,              --vendedor
           null,                      --data pagamento
           0,                         --valor do pagamento
           'A',                       --tipo Lançamento
           null,                      --tipo liquidacao
           @cd_plano_financeiro,      --plano financeiro
           @cd_usuario,               --usuario
           @dt_usuario,               --data
           @cd_tipo_destinatario,     --tipo de destinatario
           0,                         --valor abatimento
           0,                         --valor reembolso
           null,                      --data devolucao documento
           null,                      --motivo devolucao
           @ic_credito_icms_nota, --Define que o pedido será pago com o crédito de ICMS
           1,                     --Moeda
           0,                     --Embarque
           null,                  --Loja
           null,                  --Centro Custo
           null,                   --Tipo
           null,                   --Ordem
           null,                   --     
           null,
           'N'

--@cd_moeda                   int          = 1,
-- @cd_embarque_chave          int          = 0,
-- @cd_loja                    int          = 0,
-- @cd_centro_custo            int          = 0,
-- @ic_tipo_consulta           char(1)      = 'A',
-- @cd_ordem_servico           int          = 0,
-- @nm_destinatario            varchar(100) = '',
-- @cd_movimento_caixa         int          = 0,
-- @ic_consistencia            char(1)      = 'S'
    
        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

      
        -- exclusão do registro usado

        delete 
          #Pedido_Venda_Parcela
        where
          cd_pedido_venda         = @cd_nota_saida and
          cd_parcela_ped_venda    = @cd_parcela_nota_saida

      end

     drop table #Pedido_Venda_Parcela

  end

else 
-----------------------------------------------------------------------------------------
if @ic_parametro = 8   -- Cancelamento de Documentos à Receber gerado Pelo Pedido de Venda
-----------------------------------------------------------------------------------------
begin

    --No Delphi, fazer a verificação se as parcelas já foram pagas, caso afirmativo, não deixar cancelar
    -- as parcelas e nem o pedido de venda.
    -- tabela temporária com as informações p/ o cancelamento

    select
      d.cd_documento_receber,
      d.cd_cliente,
      d.cd_tipo_destinatario,
      n.cd_pedido_venda,
      n.ds_cancelamento_pedido,
      n.dt_cancelamento_pedido
    into
      #Pedido_Venda_Parcela_Cancelada
    from
      Documento_Receber d with (nolock) 
      left outer join     
	  Pedido_Venda n
    on
      d.cd_pedido_venda = n.cd_pedido_venda
    where
      n.cd_status_pedido = 7 and
      n.cd_pedido_venda = @cd_nota_saida
   
    while exists(select top 1 cd_pedido_venda from #Pedido_Venda_Parcela_Cancelada)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_nota_saida            = cd_pedido_venda,
          @nm_mot_cancel_nota_saida = ds_cancelamento_pedido,
          @dt_cancel_nota_saida     = dt_cancelamento_pedido,
          @cd_documento_receber     = cd_documento_receber
        from
          #Pedido_Venda_Parcela_Cancelada

        -- cancelamento do documento automático
   
     update 
          Documento_Receber 
        set
          vl_saldo_documento        = 0.00,
          dt_cancelamento_documento = @dt_cancel_nota_saida,        
	  nm_cancelamento_documento = @nm_mot_cancel_nota_saida,
          cd_tipo_liquidacao        = 2,  -- Cancelamento
          cd_usuario                = @cd_usuario,
          dt_usuario                = getDate()
        where
          cd_documento_receber = @cd_documento_receber


        -- exclusão do registro usado

        delete 
          #Pedido_Venda_Parcela_Cancelada
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #Pedido_Venda_Parcela_Cancelada

end else
-----------------------------------------------------------------------------------------
if @ic_parametro = 9 -- Geração de Documentos à Receber Automaticamente Pelo Embarque de Exportação
-----------------------------------------------------------------------------------------
  begin

  if (isnull((select ic_embarque_gera_SCR from parametro_exportacao where cd_empresa = dbo.fn_empresa()),'N') = 'S')
	  begin
	    -- Na geração automática excluir as duplicatas já existentes que foram
	    -- geradas anteriormente e que por qualque motivo tiveram de ser 
	    -- geradas novamente
	    delete
	      Documento_Receber
	    where
	      cd_embarque_chave = @cd_nota_saida and
	      ic_tipo_lancamento = 'A' and
	      vl_saldo_documento <> 0
	    
	    -- Nome da Tabela usada na geração e liberação de códigos
	    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))
	  
	    -- Tabela temporária c/ todas as parcelas do Embarque
	    select
	      e.cd_pedido_venda,
	      ep.cd_parcela_embarque,
	      e.cd_moeda,
	      cast(str(ep.vl_parcela_embarque,25,2) as decimal(25,2)) as 'vl_parcela_embarque',     
	      ep.dt_vcto_parcela_embarque,
	      1 as cd_tipo_destinatario,     
	      pv.cd_cliente,
	      pv.cd_vendedor,
	      pv.dt_pedido_venda,
	      ep.cd_ident_parc_embarque,
	      IDENTITY(int, 1, 1) AS Inc,
	      isnull(pv.cd_plano_financeiro,pf.cd_plano_financeiro) as cd_plano_financeiro,
	      pv.ic_credito_icms_pedido,
	      e.cd_embarque_chave,
	      (select top 1 p.cd_portador from Portador p where p.cd_banco = e.cd_banco_cobranca) as cd_portador
	    into
	      #Embarque_Parcela
	    from
	      Embarque e 
	      inner join Embarque_Parcela ep 
	        on e.cd_embarque = ep.cd_embarque and e.cd_pedido_venda = ep.cd_pedido_venda
	      inner join Pedido_Venda pv
	        on e.cd_pedido_venda = pv.cd_pedido_venda
	      left outer join Parametro_Financeiro pf
	        on pf.cd_empresa = dbo.fn_empresa()        
	    where
	      e.cd_embarque_chave = @cd_nota_saida
	    order by
	      ep.cd_parcela_embarque
	
	    while exists(select cd_parcela_embarque from #Embarque_Parcela)
	    begin
	        -- campos da tabela de parcelas
	        select
	          top 1
	          @cd_pedido_venda          = cd_pedido_venda,
	          @cd_parcela_nota_saida    = cd_parcela_embarque,
	          @cd_moeda                 = cd_moeda,
	          @vl_parcela_nota_saida    = vl_parcela_embarque,
	          @dt_parcela_nota_saida    = dt_vcto_parcela_embarque,
	          @cd_cliente               = cd_cliente,
	          @cd_tipo_destinatario     = cd_tipo_destinatario,
	          @cd_plano_financeiro      = cd_plano_financeiro,
	    	  @cd_ident_parc_nota_saida = cd_ident_parc_embarque,
	          @cd_vendedor	            = cd_vendedor,
	          @dt_nota_saida            = dt_pedido_venda,
	          @ic_credito_icms_nota     = ic_credito_icms_pedido,
	          @cd_embarque_chave        = cd_embarque_chave,
	          @cd_portador_exp          = IsNull(cd_portador, @cd_portador)
	        from
	          #Embarque_Parcela
	        order by  
	          cd_parcela_embarque
	
		if (@cd_portador_exp is null) set @cd_portador_exp = @cd_portador

	        -- campo chave utilizando a tabela de códigos
	        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output
	
	        while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
	        begin
	    	    exec egisadmin.dbo.sp_pegacodigo @tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
	    	    -- limpeza da tabela de código
	    	    exec egisadmin.dbo.sp_liberacodigo @tabela, @cd_documento_receber, 'd'
	    	  end
	
	        -- montagem da identificação do documento
	        exec pr_documento_receber 
	           2, 
	           null, 
	           null, 
	           @cd_documento_receber, 
	           @cd_ident_parc_nota_saida,
	           @dt_nota_saida, 
	           @dt_parcela_nota_saida, 
	           @dt_parcela_nota_saida, 
	           @vl_parcela_nota_saida,
	           @vl_parcela_nota_saida, 
	           null, 
	           null, 
	           0, 
	           null, 
	           'Geração Automática Pelo Embarque de Exportação.', 
	           'N', 
	           null,
	           null, 
	           null, 
	           @cd_portador_exp, 
	           @cd_tipo_cobranca, 
	           @cd_cliente, 
	           @cd_tipo_documento, 
	           @cd_pedido_venda, 
	           null, 
	           @cd_vendedor,
	           null, 
	           0, 
	           'A', 
	           null, 
	           @cd_plano_financeiro, 
	           @cd_usuario, 
	           @dt_usuario,
	           1, --@cd_tipo_destinatario,
	           0,
	           0,
	           null, 
	           null,
	           @ic_credito_icms_nota, --Define que o pedido será pago com o crédito de ICMS
	           @cd_moeda,
	           @cd_embarque_chave
 	        
	        -- limpesa da tabela de código
	        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
	
	      
	        -- exclusão do registro usado
	
	        delete 
	          #Embarque_Parcela
	        where          
	          cd_parcela_embarque    = @cd_parcela_nota_saida
	
	      end

	     drop table #Embarque_Parcela
	  end
  end
else 
-----------------------------------------------------------------------------------------
if @ic_parametro = 10   -- Cancelamento de Documentos à Receber Gerado Pelo Embarque
-----------------------------------------------------------------------------------------
begin

    -- No Delphi, fazer a verificação se as parcelas já foram pagas, caso afirmativo, não deixar cancelar
    -- as parcelas e nem o pedido de venda.
    -- tabela temporária com as informações p/ o cancelamento
    select
      d.cd_documento_receber,
      d.cd_cliente,
      d.cd_tipo_destinatario,
      p.cd_pedido_venda,
      p.ds_cancelamento_pedido,
      p.dt_cancelamento_pedido
    into
      #Embarque_Parcela_Cancelada
    from
      Documento_Receber d
    left outer join     
  	  Pedido_Venda p
    on
      d.cd_pedido_venda = p.cd_pedido_venda
    where
      d.cd_embarque_chave = @cd_nota_saida
   
    while exists(select top 1 cd_pedido_venda from #Embarque_Parcela_Cancelada)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_nota_saida            = cd_pedido_venda,
          @nm_mot_cancel_nota_saida = ds_cancelamento_pedido,
          @dt_cancel_nota_saida     = dt_cancelamento_pedido,
          @cd_documento_receber     = cd_documento_receber
        from
          #Embarque_Parcela_Cancelada

        -- cancelamento do documento automático
   
        update 
          Documento_Receber 
        set
          vl_saldo_documento = 0.00,
          dt_cancelamento_documento = @dt_cancel_nota_saida,        
    		  nm_cancelamento_documento = @nm_mot_cancel_nota_saida,
          cd_tipo_liquidacao = 2,  -- Cancelamento
          cd_usuario = @cd_usuario,
          dt_usuario = getDate()
        where
          cd_documento_receber = @cd_documento_receber


        -- exclusão do registro usado
        delete 
          #Embarque_Parcela_Cancelada
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #Embarque_Parcela_Cancelada

end
-----------------------------------------------------------------------------------------
if @ic_parametro = 11   -- Geração de Documentos à Receber Automaticamente Pelo Ordem Serviço
-----------------------------------------------------------------------------------------
  begin
    Print 'Parametro - 11'
    declare @ic_identificacao_parcela_os char(1)
    declare @cd_tipo_doc_os int 

    set @ic_identificacao_parcela_os = IsNull(( select top 1 ic_identificacao_parcela 
                        		      from Parametro_Comercial 
			                      where cd_empresa = dbo.fn_empresa()),'N')
				      

    -- Nesta geração é preciso verificar se é habilitado ao módulo a geração automática
    if ((select ic_auto_scr_empresa from parametro_comercial where cd_empresa = dbo.fn_empresa()) = 'N')
      begin
        print('Geração Automática não Habilitada p/ Módulo Comercial!')
        return
      end  

    -- Na geração automática excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualque motivo tiveram de ser 
    -- geradas novamente
    Print 'Deletando Doc receber'
    delete
      Documento_Receber
    where
      cd_ordem_servico    = @cd_nota_saida and
      ic_tipo_lancamento = 'A' and
      vl_saldo_documento <> 0
    
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))
  
    -- Tabela temporária c/ todas as parcelas do Pedido de Venda
    Print 'Cria a Tabela'
    select
      osp.cd_ordem_servico,
      osp.cd_parcela_ord_serv,
      cast(str(osp.vl_parcela_ord_serv,25,2) as decimal(25,2)) as 'vl_parcela_ord_serv',     
      osp.dt_vcto_parcela_ord_serv,
      1 as cd_tipo_destinatario,     
      os.cd_cliente,
      u.cd_vendedor as cd_vendedor,
      os.dt_fechamento_ordem_serv,
      osp.cd_ident_parc_ord_serv as cd_ident_parc_ord_serv,
      IDENTITY(int, 1, 1) AS Inc,
      pc.cd_plano_financeiro,
      'N' as ic_credito_icms_ord_serv,
      osp.cd_tipo_documento,
      cic.cd_portador
    into
      #Ordem_Servico_Parcela
    from
      Ordem_Servico_Parcela osp left outer join
      Ordem_Servico         os  on osp.cd_ordem_servico = os.cd_ordem_servico left outer join
      Parametro_Comercial   pc  on pc.cd_empresa = dbo.fn_empresa() left outer join 
      Cliente_Informacao_Credito cic on cic.cd_cliente = os.cd_cliente left outer join
		EGISAdmin.dbo.Usuario u   on (u.cd_usuario = os.cd_usuario)
    where
      osp.cd_ordem_servico = @cd_nota_saida and
      os.cd_ordem_servico is not null and
      os.dt_cancelamento_ordem_serv is null
    order by
      osp.cd_ordem_servico,
      osp.cd_parcela_ord_serv

    --Este select não deixava o delphi executar a procedure
    --Comentado por Anderson - 28/02/2007
    --Select * from #Ordem_Servico_Parcela

    Print 'Laço'
    while exists(select cd_ordem_servico from #Ordem_Servico_Parcela)
    begin
     
        -- campos da tabela de parcelas
        Print 'Valores as Variaveis'
        select
          top 1
          @cd_ordem_servico         = cd_ordem_servico,
          @cd_parcela_nota_saida    = cd_parcela_ord_serv,
          @vl_parcela_nota_saida    = vl_parcela_ord_serv,
          @dt_parcela_nota_saida    = isnull(dt_vcto_parcela_ord_serv, getdate()),
          @cd_cliente               = cd_cliente,
          @cd_tipo_destinatario     = cd_tipo_destinatario,
          @cd_plano_financeiro      = cd_plano_financeiro,
   	    @cd_ident_parc_nota_saida = cd_ident_parc_ord_serv,
          @cd_vendedor		         = cd_vendedor,
          @dt_nota_saida            = isnull(dt_fechamento_ordem_serv, getdate()),
          @ic_credito_icms_nota     = ic_credito_icms_ord_serv,
          @cd_tipo_doc_os           = ( case when IsNull(cd_tipo_documento,0) = 0 then
                                       @cd_tipo_documento else IsNull(cd_tipo_documento,0) end),
          --Carlos 16.09.2005
          @cd_portador              = case when isnull(cd_portador,0) = 0 then @cd_portador 
                                                                          else cd_portador end

        from
          #Ordem_Servico_Parcela

        order by  
          cd_ordem_servico,
          cd_parcela_ord_serv

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

        while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
        begin
      	    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
	          -- limpeza da tabela de código
	          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
        end


        -- montagem da identificação do documento
        --Print 'Gera o Docuemnto a Receber'

        exec pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento_receber, 
           @cd_ident_parc_nota_saida,
           @dt_nota_saida, 
           @dt_parcela_nota_saida, 
           @dt_parcela_nota_saida, 
           @vl_parcela_nota_saida,
           @vl_parcela_nota_saida, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática Pelo Pedido de Venda.', 
           'N', 
           null,
           null, 
           null, 

           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_cliente, 
           @cd_tipo_doc_os, 
           Null, 
           null, 
           @cd_vendedor,
           null,
           0, 
           'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario,
           @dt_usuario,
           1, --Tipo de Destinatario -->Cliente
           0,
           0,
           null, 
			  '',
           @ic_credito_icms_nota, --Define que o pedido será pago com o crédito de ICMS
 			  1,  --Moeda R$
			  0,
			  0, --@cd_loja,
           0,
 			  'A',
 			  @cd_ordem_servico
        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

      
        -- exclusão do registro usado

        delete 
          #Ordem_Servico_Parcela
        where
          cd_ordem_servico     = @cd_nota_saida and
          cd_parcela_ord_serv  = @cd_parcela_nota_saida

      end

     drop table #Ordem_Servico_Parcela

  end
else
  return
