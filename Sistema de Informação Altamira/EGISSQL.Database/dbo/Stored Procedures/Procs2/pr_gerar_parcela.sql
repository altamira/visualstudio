
CREATE  PROCEDURE pr_gerar_parcela
-------------------------------------------------------------------------------
--pr_gerar_parcela
-------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                    2004
-------------------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)        : Fabio
--                  : Elias Pereira da Silva
-- Banco de Dados   : EGISSQL
-- Objetivo         : Gerar Parcelas de Pagamento para:
--	                  - Proposta Comercial
--        	          - Pedido de Venda
--		                - Faturamento
-- Data             : 04.05.2002
-- Atualizado       : 01.07.2002 - Elias p/ Faturamento
--                  : 05.07.2002 - Fabio descontar o IPI somente no Faturamento
--                  : 09.01.2003 - Fabio - Gera somente documento a receber para as notas onde o tipo de movimento de estoque é de saída
--                  : 05/08/2002 - Geração da identificação da Parcela - ELIAS
--                  : 09/08/2002 - Acerto da Geração da Identificação - ELIAS
--    	            : 03.02.2003 - Implementação para atualização das datas de parcelas específicas (Faturamento) - FABIO
--                  : 04/05/2003 - Procedimento para aproximação da data de vencimento com dias específicos contidos
--                                 na tabela Condicao_Pagamento_Aprox - FABIO
--                  : 21/05/2003 - Acerto no arredondamento das parcelas que não estava
--                                 sendo feito quando a condição de pagamento continha
--                                 parcela com IPI - ELIAS 21/05/2003
--                  : 18/07/2003 - Incluída rotina que gera parcelas no SCP p/ Faturamento - ELIAS
--                  : 22/07/2003 - Acertado deleção de Documentos a Receber p/ Faturamento - ELIAS 
--                  : 23/09/2003 - Acerto do parâmetro passado a Função de Geração de Número de Identificação
--                                 passando agora a data de emissão, antes era dt vencimento
--                  : 29.01.2004 - Deduzi do valor das parcelas o valor que será retido na fonte
--                  : 11/02/2004 - Inclusão de rotina para identificação customizada de parcelas - Daniel C. Neto.
--                  : 21/10/2004 - Inclusão de Rotina para Geração de Parcelas quando Embarque de Exportação - ELIAS
--                  : 18/11/2004 - Inclusão de Rotina para Geração de Parcelas quando Embarque de Importação - ELIAS
--                  : 10/12/2004 - Acerto no Cabeçalho -  Sérgio Cardoso
--                  : 21/05/2005 - Geração com a Data de (E)missão ou (S)aída quando NFS dependendo do Parâmetro
--                                 de Faturamento - ELIAS
-- @ic_parametro    : 1 -> Define que se trata de Proposta
--	                  2 -> Define que se trata de Pedido
--	                  3 -> Define que se trata de Faturamento
--                    4 -> Faturamento para Nota de Serviço
--                    5 -> Faturamento de Nota de Entrada
--
-- @cd_documento    : codigo do documento(Ex. No caso da Proposta o cd_consulta)
-- @cd_usuario      : Usuário que gerou as parcelas
--                  : 03.10.2005 - Inclusão do total do INSS para abater na parcela. - Rafael Santiago
--                  : 27.07.2006 - Verificação da Dedução do PIS/COFINS da parcela - Carlos Fernandes
--                                 Utilizando novo parâmetro - Parametro-Faturamento
--                    27/07/2006 - Acerto para não gerar Parcela Indevida para o PV, mesmo configurado corretamente - LUDINEI
--                    24.08.2006 - Dedução do PIS/COFINS foi corrigida para realizar em função do parametro de faturamento:
--                                 * Foi corrigido para ler da tabela "Parametro_Faturamento" o parâmetro para realizar 
--                                   a dedução do PIS/COFINS conforme definido pela empresa
--                                 * Quanto a CFOP estava marcada para "PIS", "COFINS", "CSLL" os mesmos eram deduzidos 
--                                   mesmo se o parametro de faturamento estivesse marcado para não deduzir (posição dos "or/and") - FABIO CESAR
--                    04.09.2006 - Não filtrar a condição de pagamento ativa ou não no faturamento - FABIO CESAR
--                    30/10/2006 - Incluído rotina para gravar centro de custo automaticamente. - Daniel C. Neto.
--                    22.05.2007 - Dedução do PIS/COFINS na Parcela - Carlos Fernandes
--                    11.06.2007 - Acertos Gerais na Dedução PIS/COFINS - Carlos Fernandes
--                    07.09.2007 - Verificação da Data Específica e Dia da Semana Específico - Carlos Fernandes
-- 29.11.2007 - Numeração da Parcela - Carlos Fernandes.
-- 17.12.2007 - Plano_Financeiro     - Carlos Fernandes.
-- 19.12.2007 - Rateio do Plano Financeiro por Categoria de Produto - Carlos Fernandes.
-- 07.02.2008 - Acerto da geração da parcela para dia semana específico - Carlos Fernandes
-- 18.03.2008 - Verificação do caso para edição de Parcela Específica - Carlos/Felipe.
-- 07.01.2009 - Busca do Plano da Condição de Pagamento - Carlos Fernandes
-- 16.03.2009 - Ajuste da Parcela gerada pelo Embarque, colocado data de previsão - Carlos Fernandes
-- 04.05.2009 - Verificação dos números de dígito - Carlos Fernandes
-- 20.08.2009 - Verificação do ICMS quando Zona Franca - Carlos Fernandes
-- 21.01.2010 - Verificação quando a geração é pelo Pedido de Venda - Carlos Fernandes
-- 20.04.2010 - Quando for pedido checar se a Parcela está baixa e não alterar - Carlos Fernandes
-- 26.05.2010 - Arredondamento no Final e colocar na última parcela - Carlos Fernandes
-- 19.06.2010 - Cancelamento de Duplicata pelo Pedido de Venda/Data sem Hora - Carlos Fernandes
-- 10.10.2010 - Geração da Parcela com o número da Identificação da Nota Fiscal - Carlos Fernandes
-- 19.10.2010 - Dedução do valor que não é comercial - Carlos Fernandes
-- 02.11.2010 - Novo Cálculo de Parcela --> Fora o Mês de Faturamento - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------------
-- Parametros

@ic_parametro        integer = 0,
@cd_documento        integer = 0,
@cd_usuario          integer = 0

as

--select @ic_parametro

declare 

   @cd_condicao_pagamento        integer,        -- Condição de Pagamento definida para a consulta
   @dt_emissao                   datetime,       -- Data base para geração das parcelas
   @vl_total_geral               float,          -- Valor Total  do Documento sem Alteração do IPI
   @vl_total_documento           float,          -- Valor Total  do Documento
   @vl_ipi_documento             float,          -- Valor do IPI do Documento
   @vl_total_parcela             float,          -- Valor Total do Documento
   @qt_parcela_ipi               int,            -- Valor Total do Documento
   @cd_parcela	                 int,            -- Código da parcela para identifica-la
   @dt_vencimento                datetime,       -- Data de vencimento da parcela
   @dt_primeiraEntrega           datetime,       -- Data da primeira entrega 
   @qt_dia_cond_parcela_pgto     int,            -- Número de dia
   @cd_semana		         int,            -- Dia da semana específico
   @ic_executar 	         char(1),        -- Define se deverá ser gerada a tabela temporária com as parcelas
   @icout                        int,            -- Contador
   @cd_identificacao             varchar(25),    -- Identificaçãoo da Parcela (Num. Doc. SCR) - ELIAS   
   @ic_utiliza_parc_editada      char(1),	 -- Informa se será utilizada a data da parcela do pedido de venda na parcela do faturamento
   @cd_utiliza_parc_editada      int,	         -- Código da Pedido onde será retirar a parcela editada que será utilizada caso for utilizada a data da parcela do pedido de venda na parcela do faturamento
   @dt_especifica_parcela        datetime,	 -- Data do vencimento específico utilizado do pedido de venda no faturamento
   @ic_importar_parcela_pv       char(1),        -- Define se irá ser importada as informações do pedido de venda do item no faturamento
   @cd_pedido_venda	         int,            -- Define o pedido de venda base para a utilização de suas parcelas no faturamento, visto sua
   @vl_total_cond_esp_ped        decimal(25,2),  -- Armazena o valor total das parcelas de venda a serem transportadas para o faturamento
   @qt_dia_aproximacao           int,
   @ic_ident_parc_pv             char(1),        -- Informa que a identificação da parcela deve buscar um código prório do PV.
   @ic_gerar_docto_pv            char(1),
   @vl_quitado                   float,
   @ic_data_geracao_parcela      char(1),        -- Tipo de Emissão da Parcela pelo Faturamento (E)missão/(S)aída
   @ic_deduz_pis_cofins_total    char(1),        -- Dedução do Pis Confis para Cálculo das Parcelas
   @cd_plano_financeiro          integer,        -- Guarda o Plano financeiro da Nota de Saida Parcela quando a nota for modificada
   @cd_centro_custo              integer,        -- Guarda o Centro de Custo da Nota de Saida Parcela quando a nota for modificada
   @vl_teto_imposto_retido       decimal(25,2),  -- Teto de Dedução de Imposto Retido
   @ic_deduz_pis_cofins_servico  char(1),        -- Dedução de PIS/COFINS para Serviço
   @qt_parcela                   int,            -- Quantidade de Parcela
   @nm_obs_parcela_nota_saida    varchar(80),    -- Observação  
   @ic_msg_boleto_anexo          char(1),
   @cd_plano_financeiro_condicao int,
   @cd_tipo_destinatario         int,
   @cd_identificacao_nota_saida  int             --Identificação da Parcela com Número da Nota Fiscal por Série---------- 

  --Data de Emissão
 
  set @dt_emissao                  = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
  set @vl_total_documento          = 0.00
  set @vl_total_geral              = 0.00
  set @nm_obs_parcela_nota_saida   = '' 
  set @cd_centro_custo             = 0
  set @cd_identificacao_nota_saida = 0

  --Define por padrão que não é para executar até que tenha realizado todos os testes necessários
  set @ic_executar = 'N'

  --Define que a parcela possui uma identificação especial do pedido de venda

  select 
    @ic_ident_parc_pv  = IsNull(ic_identificacao_parcela,'N'),
    @ic_gerar_docto_pv = IsNull(ic_aba_parcela_pedido,'N')
  from
    Parametro_Comercial with (nolock) 
  where 
    cd_empresa = dbo.fn_empresa()

  -- Define se a Parcela pelo Faturamento deve ser gerada pela Emissão ou pela
  -- data de Saída da Mercadoria - ELIAS 21/05/2005
  -- Por Default (E)missão.

  select
    @ic_data_geracao_parcela     = isnull(ic_data_geracao_parcela,'E'),
    @ic_deduz_pis_cofins_total   = isnull(ic_deduz_pis_cofins_total,'N'),
    @vl_teto_imposto_retido      = isnull(vl_teto_imposto_retido,0),
    @ic_deduz_pis_cofins_servico = isnull(ic_deduz_pis_cofins_servico,'N'),
    @ic_msg_boleto_anexo         = isnull(ic_msg_boleto_anexo,'N')
  from
    Parametro_Faturamento with (nolock) 
  where 
    cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Proposta Comercial
-------------------------------------------------------------------------------------------
begin
     --Verifica se na tabela de proposta a proposta informada possui condição de pagamento 
     --e se essa condição de pagamento está ativa
  if exists(SELECT 'x' FROM Consulta with (nolock) INNER JOIN
              Condicao_Pagamento     with (nolock) ON Consulta.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Consulta.cd_consulta = @cd_documento) AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))
  begin
	
    --Define a condição de pagamento que será utilizada

    SELECT @cd_condicao_pagamento = Consulta.cd_condicao_pagamento,
	   @dt_emissao            = case when Consulta.dt_consulta is null
                                    then @dt_emissao else Consulta.dt_consulta end,
	   @vl_total_documento    = isnull(Consulta.vl_total_consulta,0),
	   @vl_ipi_documento      = isnull(Consulta.vl_total_ipi,0),
	   @dt_primeiraEntrega    = IsNull((Select min(dt_entrega_consulta) 
                                            from consulta_itens with (nolock) 
                                            where 
                                              consulta_itens.cd_consulta = Consulta.cd_consulta),convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121))
    FROM Consulta           with (nolock) INNER JOIN
         Condicao_Pagamento with (nolock) ON Consulta.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
    WHERE (Consulta.cd_consulta = @cd_documento)

    set @ic_executar = 'S'

  end

end

-------------------------------------------------------------------------------------------
if @ic_parametro = 2 --Pedido de Venda
-----------------------------------------------------------------------------------------
begin

  if @ic_gerar_docto_pv='N'
    Return

  --Verifica se na tabela de proposta a proposta informada possui condição de pagamento e se essa condição de pagamento está ativa
  if exists(SELECT 'x' FROM Pedido_Venda with (nolock) INNER JOIN
              Condicao_Pagamento         with (nolock) ON Pedido_Venda.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Pedido_Venda.cd_pedido_venda = @cd_documento) AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))
  begin

	--Define a condição de pagamento que será utilizada
    SELECT @cd_condicao_pagamento = Pedido_Venda.cd_condicao_pagamento,
	   @dt_emissao            = case when Pedido_Venda.dt_pedido_venda is null 
                                    then @dt_emissao
                                    else Pedido_Venda.dt_pedido_venda end,
	   @vl_total_documento    = isnull(Pedido_Venda.vl_total_pedido_ipi,0),
	   @vl_ipi_documento      = isnull(Pedido_Venda.vl_total_ipi,0),
	   @dt_primeiraEntrega    = IsNull((Select min(dt_entrega_vendas_pedido)
                                    from Pedido_Venda_Item with (nolock) 
                                    where 
                                      Pedido_Venda_Item.cd_pedido_venda = Pedido_Venda.cd_pedido_venda),convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121))
    FROM Pedido_Venda       with (nolock) INNER JOIN
         Condicao_Pagamento with (nolock) ON Pedido_Venda.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
    WHERE (Pedido_Venda.cd_pedido_venda = @cd_documento)

    set @ic_executar = 'S'

  end

end

-------------------------------------------------------------------------------------------
if ( @ic_parametro in (3,4) ) --Faturamento Normal ou de Serviço.
-------------------------------------------------------------------------------------------
begin

  --No caso de faturamento não verifica se a condição de pagamento é ativa, visto a seguinte situação
  --Ex. É aberta uma condição de pagamento para um PV específico porém posteriormente a mesma é inativada
  --para que não venha a ser utilizada por outra venda porém o pedido em questão precisará ser faturado normalmente
  --Verifica se na tabela de nota saída a nota fiscal informada
  -- possui condição de pagamento e se essa condição de pagamento está ativa

  if exists(SELECT 'x' 
            FROM Nota_Saida         WITH (NOLOCK) INNER JOIN
                 Condicao_Pagamento WITH (NOLOCK) ON Nota_Saida.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Nota_Saida.cd_nota_saida = @cd_documento) ) --AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))
  begin

    ------------------------------------------------------------------------
    -- Caso já haja documentos gerados pelo pedido de venda,
    -- sistema selecionará todos os documentos gerados já pagos
    -- para fazer a diferença com o valor total da nota e gerar parcelas
    -- apenas do que ainda não foi pago.
    ------------------------------------------------------------------------

    if @ic_gerar_docto_pv = 'S'
    begin
      select
        @vl_quitado =
          isnull(( sum(isnull(drp.vl_pagamento_documento, 0))
           - sum(isnull(drp.vl_juros_pagamento, 0))     
           + sum(isnull(drp.vl_desconto_documento, 0))
           + sum(isnull(drp.vl_abatimento_documento, 0))
           - sum(isnull(drp.vl_despesa_bancaria, 0))
           + sum(isnull(drp.vl_reembolso_documento, 0))
           - sum(isnull(drp.vl_credito_pendente, 0)) ),0)
      from
        Documento_Receber dr with (nolock) inner join
        ( select 
            pvp.cd_ident_parc_ped_venda 
          from 
            Pedido_Venda_Parcela pvp with (nolock) 
          where 
            pvp.cd_pedido_venda in (select cd_pedido_venda 
                                    from nota_saida_item with (nolock) 
                                    where cd_nota_saida = @cd_documento)) drs on drs.cd_ident_parc_ped_venda = dr.cd_identificacao 
                                    inner join
        Documento_Receber_Pagamento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
    end
    else
      set @vl_quitado = 0

    -- ELIAS 07/07/2004 - QUANDO FOR PELO FATURAMENTO UTILIZAR O TIPO DE GERAÇÃO
    -- DA IDENTIFICAÇÃO PELA NUMERAÇÃO DA NOTA E NUNCA PELO PEDIDO, MESMO GERADO
    -- ANTERIORMENTE PELO PEDIDO
    set @ic_ident_parc_pv = 'N'    

    --Define a condição de pagamento que será utilizada
    -- ELIAS 21/05/2005 - Escolhe a Data de (E)missão ou (S)aída
    -- dependendo do Parâmetro de Faturamento

    SELECT 
        @cd_condicao_pagamento = isnull(Nota_Saida.cd_condicao_pagamento,1),
	@dt_emissao            = case when (@ic_data_geracao_parcela = 'S') then
                                 case when Nota_Saida.dt_saida_nota_saida is null
                                 then Nota_Saida.dt_nota_saida else Nota_Saida.dt_saida_nota_saida end
                                 else
                                    case when Nota_Saida.dt_nota_saida is null
                                    then @dt_emissao else Nota_Saida.dt_nota_saida end
                                 end,

--Antes
-- 	@vl_total_documento    = Nota_Saida.vl_total - 
--                                  ( ( IsNull(Nota_Saida.vl_irrf_nota_saida,0) + IsNull(Nota_Saida.vl_inss_nota_saida,0) +
--                                      IsNull(Nota_Saida.vl_iss_retido,0)
--                                      + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' or isnull(opf.ic_pis_operacao_fiscal,'N')   ='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_cofins,0) else 0.00 end
--                                      + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' or isnull(opf.ic_cofins_operacao_fiscal,'N')='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_pis,0)    else 0.00 end
--                                      + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' or isnull(opf.ic_pis_operacao_fiscal,'N')   ='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_csll,0)   else 0.00 end ))
--                                      - IsNull(@vl_quitado,0),

-- 11.06.2007 ( Carlos Fernandes )

	@vl_total_documento    = ( Nota_Saida.vl_total 
                                   --//- case when isnull( Nota_Saida.vl_simbolico, 0 ) > 0 then 
                                   --                      isnull( Nota_Saida.vl_simbolico, 0 )             else 0.00 end
                                 ) 

                                 - 

                                 ( ( IsNull(Nota_Saida.vl_irrf_nota_saida,0) +  --IRRF
                                     IsNull(Nota_Saida.vl_inss_nota_saida,0) +  --INSS
                                     IsNull(Nota_Saida.vl_iss_retido,0)         --ISS RETIDO
                                   
                                     --Zona Franca
                                     
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_cofins,0) else 0.00 end
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_pis,0)    else 0.00 end
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='S' ) and ( @ic_deduz_pis_cofins_total='S' ) then IsNull(Nota_Saida.vl_csll,0)   else 0.00 end 

                                    --Verifica o Teto de Impostos Retidos ( * )
                                    --Serviço
 
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='N' and isnull(opf.ic_pis_operacao_fiscal,'N')   ='S' ) and Nota_Saida.vl_total>=@vl_teto_imposto_retido and ( @ic_deduz_pis_cofins_servico='S' ) then IsNull(Nota_Saida.vl_cofins,0) else 0.00 end
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='N' and isnull(opf.ic_cofins_operacao_fiscal,'N')='S' ) and Nota_Saida.vl_total>=@vl_teto_imposto_retido and ( @ic_deduz_pis_cofins_servico='S' ) then IsNull(Nota_Saida.vl_pis,0)    else 0.00 end
                                     + case when (isnull(Nota_Saida.ic_zona_franca,'N')='N' and isnull(opf.ic_pis_operacao_fiscal,'N')   ='S' ) and Nota_Saida.vl_total>=@vl_teto_imposto_retido and ( @ic_deduz_pis_cofins_servico='S' ) then IsNull(Nota_Saida.vl_csll,0)   else 0.00 end )

                                     --Verifica a Retenção de PIS/COFINS conforme CFOP---------------------------------

                                     + case when (isnull(opf.ic_ret_piscofins_fiscal,'N')='S' ) and (isnull(c.ic_reter_piscofins_cliente,'N')='S' ) then IsNull(Nota_Saida.vl_cofins_retencao,0) else 0.00 end
                                     + case when (isnull(opf.ic_ret_piscofins_fiscal,'N')='S' ) and (isnull(c.ic_reter_piscofins_cliente,'N')='S' ) then IsNull(Nota_Saida.vl_pis_retencao,0)    else 0.00 end

                                    )

                                     - IsNull(@vl_quitado,0),                   --VALOR QUITADO ANTECIPADO

	@vl_ipi_documento      = isnull(Nota_Saida.vl_ipi,0),

        -- verificar qual a data a ser colocada aqui - ELIAS
	@dt_primeiraEntrega    = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121),

        @nm_obs_parcela_nota_saida = ( select top 1 vw.nm_mensagem_conta 
                                       from 
                                         vw_dados_deposito_cliente vw
                                       where
                                         vw.cd_cliente = Nota_Saida.cd_cliente ),

        @cd_plano_financeiro_condicao = isnull(Condicao_Pagamento.cd_plano_financeiro,0),
        @cd_tipo_destinatario         = isnull(nota_saida.cd_tipo_destinatario,1),
        @cd_identificacao_nota_saida  = case when isnull(nota_saida.cd_identificacao_nota_saida,0)<>0 then
                                          nota_saida.cd_identificacao_nota_saida
                                        else
                                          nota_saida.cd_nota_saida
                                        end
    
--select * from operacao_fiscal

    FROM 
      Nota_Saida                          with (nolock) INNER JOIN 
      Condicao_Pagamento                  with (nolock) on Nota_Saida.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
      LEFT OUTER JOIN Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal           = Nota_Saida.cd_operacao_fiscal
      LEFT OUTER JOIN Cliente c           with (nolock) on c.cd_cliente                     = Nota_Saida.cd_cliente

--select * from cliente

    WHERE 
      (Nota_Saida.cd_nota_saida = @cd_documento)
    

--    select @vl_total_documento

    set @ic_executar = 'S'

    --Verifica a Mensagem do Boleto em Anexo

    if @ic_msg_boleto_anexo = 'S' and rtrim(ltrim(@nm_obs_parcela_nota_saida)) = '' 
    begin
      set @nm_obs_parcela_nota_saida = 'BOLETO ANEXO.'
    end

  end

 --select @nm_obs_parcela_nota_saida

--  select @ic_executar

end

-------------------------------------------------------------------------------------------
if @ic_parametro = 5 -- Faturamento quando nota fiscal for de entrada - ELIAS 17/07/2003
-------------------------------------------------------------------------------------------
begin

  --No caso de faturamento não verifica se a condição de pagamento é ativa, visto a seguinte situação
  --Ex. É aberta uma condição de pagamento para um PV específico porém posteriormente a mesma é inativada
  --para que não venha a ser utilizada por outra venda porém o pedido em questão precisará ser faturado normalmente
  --Verifica se na tabela de nota saída a nota fiscal informada
  -- possui condição de pagamento e se essa condição de pagamento está ativa

  if exists(SELECT 'x' FROM Nota_Saida         with (nolock) INNER JOIN
		            Condicao_Pagamento with (nolock) ON Nota_Saida.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Nota_Saida.cd_nota_saida = @cd_documento) )

--             and 
-- 
--               -- AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S')
-- 
--   	      --Verifica se a nota fiscal é de entrada
-- 	          (select ic_mov_tipo_movimento 
--                    from tipo_movimento_estoque with (nolock) 
--                    where cd_tipo_movimento_estoque =(Select top 1 cd_tipo_movimento_estoque 
--                                                      from Operacao_fiscal with (nolock) 
--                                                      where cd_operacao_fiscal = Nota_Saida.cd_operacao_fiscal)) = 'E') )

  begin
    -- Define a condição de pagamento que será utilizada
    -- ELIAS 21/05/2005 - Escolhe a Data de (E)missão ou (S)aída
    -- dependendo do Parâmetro de Faturamento
    SELECT 
      @cd_condicao_pagamento = Nota_Saida.cd_condicao_pagamento,
--       @dt_emissao            = case when (@ic_data_geracao_parcela = 'S') then
--                                  isnull(Nota_Saida.dt_saida_nota_saida, Nota_Saida.dt_nota_saida)
--                                else
--                                  Nota_Saida.dt_nota_saida
--                                end,
      @dt_emissao            = case when (@ic_data_geracao_parcela = 'S') then
                                 case when Nota_Saida.dt_saida_nota_saida is null
                                 then Nota_Saida.dt_nota_saida else Nota_Saida.dt_saida_nota_saida end
                                 else
                                    case when Nota_Saida.dt_nota_saida is null
                                    then @dt_emissao else Nota_Saida.dt_nota_saida end
                                 end,

      @vl_total_documento    = ( isnull(Nota_Saida.vl_total,0) 
                                 --- case when isnull(nota_saida.vl_simbolico,0)>0 
                                 -- then nota_saida.vl_simbolico else 0.00 end 
                               )
                               - 
                               ( IsNull(Nota_Saida.vl_irrf_nota_saida,0) + IsNull(Nota_Saida.vl_iss_retido,0) + IsNull(Nota_Saida.vl_inss_nota_saida,0) +
                                 + IsNull(Nota_Saida.vl_cofins,0) + IsNull(Nota_Saida.vl_pis,0)
                                 + IsNull(Nota_Saida.vl_csll,0)),

      @vl_ipi_documento      = isnull(Nota_Saida.vl_ipi,0),
      @dt_primeiraEntrega    = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121),  -- verificar qual a data a ser colocada aqui - ELIAS
      @cd_identificacao_nota_saida  = case when isnull(nota_saida.cd_identificacao_nota_saida,0)<>0 then
                                          nota_saida.cd_identificacao_nota_saida
                                        else
                                          nota_saida.cd_nota_saida
                                        end


    FROM 
      Nota_Saida         with (nolock) INNER JOIN
      Condicao_Pagamento with (nolock) ON Nota_Saida.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
    WHERE (Nota_Saida.cd_nota_saida = @cd_documento)
    
    set @ic_executar = 'S'

  end

  --select @ic_executar
  
end

-------------------------------------------------------------------------------------------
if @ic_parametro = 6 --Embarque de Exportação
-------------------------------------------------------------------------------------------
begin
    --Verifica se na tabela de proposta a proposta informada possui condição de pagamento e se essa condição de pagamento está ativa
  if exists(SELECT 'x' FROM Embarque           with (nolock) INNER JOIN
                            Condicao_Pagamento with (nolock) ON Embarque.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Embarque.cd_embarque_chave = @cd_documento) AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))
  begin

    --Define a condição de pagamento que será utilizada
    SELECT 
      @cd_condicao_pagamento = Embarque.cd_condicao_pagamento,
      @dt_emissao            = case when Embarque.dt_embarque is null then @dt_emissao else Embarque.dt_embarque end,
      @vl_total_documento    = Embarque.vl_total_embarque,
      @vl_ipi_documento      = 0.00,
      @dt_primeiraEntrega    = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
    FROM Embarque           with (nolock) INNER JOIN
         Condicao_Pagamento with (nolock) ON Embarque.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
    WHERE (Embarque.cd_embarque_chave = @cd_documento)

    set @ic_executar = 'S'
  end
end

-------------------------------------------------------------------------------------------
if @ic_parametro = 7 --Embarque de Importação
-------------------------------------------------------------------------------------------
begin
  --Verifica se na tabela de proposta a proposta informada possui condição de pagamento e se essa condição de pagamento está ativa
  if exists(SELECT 'x' FROM Embarque_Importacao with (nolock) INNER JOIN
                            Condicao_Pagamento  with (nolock) ON Embarque_Importacao.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
            WHERE (Embarque_Importacao.cd_embarque_chave = @cd_documento) AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))
  begin

    	--Define a condição de pagamento que será utilizada
    SELECT 
      @cd_condicao_pagamento = Embarque_Importacao.cd_condicao_pagamento,
      @dt_emissao            = case when Embarque_Importacao.dt_embarque is null 
                               then case when embarque_importacao.dt_previsao_embarque is null
                                    then @dt_emissao 
                                    else embarque_importacao.dt_previsao_embarque end
                                        
                               else Embarque_Importacao.dt_embarque end,
      @vl_total_documento    = Embarque_Importacao.vl_total_embarque,
      @vl_ipi_documento      = 0.00,
      @dt_primeiraEntrega    = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
    FROM Embarque_Importacao with (nolock) INNER JOIN
         Condicao_Pagamento  with (nolock) ON Embarque_Importacao.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento
    WHERE (Embarque_Importacao.cd_embarque_chave = @cd_documento)

    set @ic_executar = 'S'
  end
end

-------------------------------------------------------------------------------------------  
if @ic_parametro = 8 -- Assistencia Tecnica
-------------------------------------------------------------------------------------------  
begin  
     --Verifica se na tabela de proposta a proposta informada possui condição de pagamento   
     --e se essa condição de pagamento está ativa  
  if exists(SELECT 'x' FROM Ordem_Servico      with (nolock) INNER JOIN  
                            Condicao_Pagamento with (nolock) ON Ordem_Servico.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento  
            WHERE (Ordem_Servico.cd_ordem_servico = @cd_documento) AND (IsNull(Condicao_Pagamento.ic_ativo,'S') = 'S'))  
  begin  
   
    --Define a condição de pagamento que será utilizada  
  
    SELECT
    @cd_condicao_pagamento = Ordem_Servico.cd_condicao_pagamento,  
    @dt_emissao            = isnull(Ordem_Servico.dt_fechamento_ordem_serv, @dt_emissao),  
    @vl_total_documento    = Ordem_Servico.vl_total_ordem_servico,  
    @vl_ipi_documento      = 0.00,  
    @dt_primeiraEntrega    = isnull(Ordem_Servico.dt_visita_ordem_servico, convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121))  
    FROM Ordem_Servico      with (nolock) INNER JOIN  
         Condicao_Pagamento with (nolock) ON Ordem_Servico.cd_condicao_pagamento = Condicao_Pagamento.cd_condicao_pagamento  
    WHERE (Ordem_Servico.cd_ordem_servico = @cd_documento)  
  
    set @ic_executar = 'S'  
  end  
end  

----------------------------------------------------------------------------------------------------
--Verifica se os teste necessários foram executados corretamente
----------------------------------------------------------------------------------------------------

if @ic_executar = 'S'
begin

  --Total do Documento

  set @vl_total_geral = @vl_total_documento

  -- Verifica se existe alguma parcela que nela deva ser vinculado o IPI

  Select @qt_parcela_ipi = count(cd_condicao_parcela_pgto) 
  From 
    Condicao_Pagamento_Parcela with (nolock) 
  where 
    cd_condicao_pagamento = @cd_condicao_pagamento and isnull(ic_ipi_cond_parcela_pgto,'N') = 'S'

  -- caso tenha que inserir o ipi em uma das parcelas ou mais, separá-lo do valor total - ELIAS 21/05/2003

  if @qt_parcela_ipi > 0 
  begin
    set @vl_total_documento = @vl_total_documento - @vl_ipi_documento
  end 

  -- Gerar parcelas em uma tabela temporária

  Select 
    @cd_documento       as cd_documento,     --Documento ao qual está relacionado
    IDENTITY(int, 1, 1) as cd_parcela,       --Código sequencial
    @dt_emissao         as dt_parcela,       --Data de vencimento
    @dt_emissao	        as dt_emissao,

    --Valor a ser pago-------------------------------------------------------------------------------------------

    cast(str(((@vl_total_documento * cpp.pc_condicao_parcela_pgto) / 100),25,2) as decimal(25,2)) as vl_parcela,

    cpp.qt_dia_cond_parcela_pgto,                                           --qtd. de dias
    isnull(cpp.ic_ipi_cond_parcela_pgto,'N')  as ic_ipi_cond_parcela_pgto,  --Embutir nesta parcela IPI
    cpp.cd_semana,    		                                            --Dia da semana específico
    isnull(cpp.ic_vctodia_parcela_pgto,'N')   as ic_vctodia_parcela_pgto,   --Define se será um dia da semana específico
    isnull(cpp.ic_fora_semana_parcela_pg,'N') as ic_fora_semana_parcela_pg, --Fora da semana de entrega
    isnull(cpp.ic_vctoespecif_pagto_parc,'N') as ic_vctoespecif_pagto_parc, --Vencimento específico          
    isnull(cpp.ic_liquido_parcela_pagto,'N')  as  ic_liquido_parcela_pagto, --Dias líquidos
    @cd_usuario                               as cd_usuario,                --Usuário
    getdate()                                 as dt_usuario,                --Dt. da Atualização	   
    'N'                                       as ic_quitada,                --Ainda não foram quitadas                                  
    cast(0.00 as float )                      as vl_ipi_parcela,            --Valor do IPI da Parcela
    isnull(cpp.ic_fora_mes_parcela,'N')       as ic_fora_mes_parcela        --Fora o Mês de Faturamento            

  into #Parcela

  from 
    Condicao_Pagamento_Parcela cpp with (nolock) 

  where 
    cpp.cd_condicao_pagamento = @cd_condicao_pagamento

  -- Anderson - 09/01/2007 - Corrigindo ordem das parcelas - OS - 0-scr-261206-0930

  order by
    cpp.qt_dia_cond_parcela_pgto

--  select * from #Parcela

  select
    @qt_parcela = isnull( count(*),0 )
  from 
    Condicao_Pagamento_Parcela with (nolock) 
  where 
    Condicao_Pagamento_Parcela.cd_condicao_pagamento = @cd_condicao_pagamento
  group by
    cd_condicao_pagamento

  --select * from Condicao_Pagamento_Parcela where Condicao_Pagamento_Parcela.cd_condicao_pagamento = @cd_condicao_pagamento
  --select * from #Parcela

  /*======================================================================================*/
  /*======================================================================================*/
  /*  			Realiza o Tratamento do Valor da parcela  			*/
  /*======================================================================================*/
  /*======================================================================================*/

  --Arredondamento
  --Verifica se a somatória das parcelas está inferior ao total do documento
  --Antes --> Carlos/Márcio M. --> 06.07.2010

--   Select 
--     @vl_total_parcela = sum( round(isnull(vl_parcela,0),2) ) 
--   from
--     #Parcela
-- 
--   set @vl_total_parcela = @vl_total_documento - @vl_total_parcela
-- 
--   if @vl_total_parcela != 0
--   begin
--     update #Parcela
--     set 
--       vl_parcela = vl_parcela + @vl_total_parcela
--     where
--       cd_parcela = 1 --Define que se trata da primeira parcela
--   end
-- 
  --select * from #Parcela
	
  --Verifica em qual parcela será vinculado o IPI caso o mesmo venha a ser embutido
 
  if @qt_parcela_ipi > 0
  begin

    --Define quantas parcelas possui o IPI embutido

    set @vl_ipi_documento =

        round(@vl_ipi_documento

        /

        ( case when @qt_parcela_ipi>0 then
            @qt_parcela_ipi
          else
            1
          end ),2)
  
    update 
      #Parcela
    set 
      vl_parcela     = vl_parcela + @vl_ipi_documento,
      vl_ipi_parcela = @vl_ipi_documento
    where
      isnull(ic_ipi_cond_parcela_pgto,'N') = 'S'

  end

--  select * from #Parcela

  --Arredondamento
  --Verifica se a somatória das parcelas está inferior ao total do documento

  Select 
    @vl_total_parcela = sum( round( isnull(vl_parcela,0)    , 2)),
    @vl_ipi_documento = sum( round( isnull(vl_ipi_parcela,0),2) )
  from
    #Parcela

  --Calculo do Novo Arredondamento

  set @vl_total_parcela = @vl_total_geral - @vl_total_parcela

  if @vl_total_parcela != 0
  begin
    update #Parcela
    set 
      vl_parcela = vl_parcela + @vl_total_parcela 
    where
      cd_parcela = 1 --Define que se trata da primeira parcela
  end
  

  /*======================================================================================*/
  /*======================================================================================*/
  /*  			Realiza o Tratamento da Data da parcela  			*/
  /*======================================================================================*/
  /*======================================================================================*/
	
  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/

--   select 
--     IsNull(ic_vctoespecif_pagto_parc,'N') as c1,
--     IsNull(ic_fora_semana_parcela_pg,'N') as c2,
--     IsNull(ic_liquido_parcela_pagto,'N')  as c3

--  from
--    #Parcela

  update #Parcela
  set 
    dt_parcela = dt_parcela + isnull(qt_dia_cond_parcela_pgto,0)
  where 
    IsNull(ic_vctoespecif_pagto_parc,'N') = 'N' and 
    IsNull(ic_fora_semana_parcela_pg,'N') = 'N' and
    IsNull(ic_liquido_parcela_pagto,'N')  = 'N' and
    IsNull(ic_vctodia_parcela_pgto,'N')   = 'N' 

--   select
--     IsNull(ic_vctoespecif_pagto_parc,'N') as '1',
--     IsNull(ic_fora_semana_parcela_pg,'N') as '2',
--     IsNull(ic_liquido_parcela_pagto,'N')  as '3', 
--     IsNull(ic_vctodia_parcela_pgto,'N')   as '4',
--   * from condicao_pagamento_parcela 
--   where cd_condicao_pagamento = 1

  --select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS
	Não são contadas a semana de 
	entrega.
  ======================================*/

  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      qt_dia_cond_parcela_pgto 
    from #Parcela
    where 
      isNull(ic_liquido_parcela_pagto,'N')  = 'N' and 
      IsNull(ic_fora_semana_parcela_pg,'N') = 'S'
    order by
      cd_parcela

  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  WHILE @@FETCH_STATUS = 0
  Begin
    set @icout = 0

    while @icout < @qt_dia_cond_parcela_pgto
    begin
      set @dt_vencimento = DATEADD(day, 1, @dt_vencimento)
      if DatePart(wk,@dt_vencimento) != DatePart(wk,@dt_primeiraEntrega)
        set @icout = @icout + 1
    end

    --Atualiza a parcela

    Update 
      #Parcela 
    set dt_parcela = @dt_vencimento 
    where 
      cd_parcela = @cd_parcela

    FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  end

  CLOSE cParcela
  DEALLOCATE cParcela

--  select * from #Parcela
	
  /*======================================
    PARCELAS COM NÚMERO DE DIAS ÚTEIS
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/

  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      qt_dia_cond_parcela_pgto 
    from #Parcela
    where 
      isNull(ic_liquido_parcela_pagto,'N')  = 'S' and 
      IsNull(ic_vctoespecif_pagto_parc,'N') = 'N' and 
      IsNull(ic_fora_semana_parcela_pg,'N') = 'N' and
      IsNull(ic_vctodia_parcela_pgto,'N')   = 'N' 
    order by
      cd_parcela

  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  WHILE @@FETCH_STATUS = 0
  Begin
    set @icout = 0

    while @icout < @qt_dia_cond_parcela_pgto
    begin

      --set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, @qt_dia_cond_parcela_pgto, @dt_vencimento)),'S','U')
      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, 1, @dt_vencimento)),'S','U')
      set @icout = @icout + 1

      --select @dt_vencimento

    end

    --Atualiza a parcela

    Update #Parcela 
    set dt_parcela   = @dt_vencimento 
    where cd_parcela = @cd_parcela
    FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  end

  CLOSE      cParcela
  DEALLOCATE cParcela

  --select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS ÚTEIS
	Não são contadas a semana de 
	entrega e vencimento específico
  ======================================*/

  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      qt_dia_cond_parcela_pgto 
    from 
      #Parcela
    where 
      isNull(ic_liquido_parcela_pagto,'N')  = 'S' and
      IsNull(ic_fora_semana_parcela_pg,'N') = 'S'
    order by
      cd_parcela

  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  WHILE @@FETCH_STATUS = 0
  Begin
    set @icout = 0
    while @icout < @qt_dia_cond_parcela_pgto
    begin
      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, 1, @dt_vencimento)),'S','U')

      if DatePart(wk,@dt_vencimento) != DatePart(wk,@dt_primeiraEntrega)
        set @icout = @icout + 1
    end

    --Atualiza a parcela
    Update #Parcela 
    set dt_parcela   = @dt_vencimento 
    where cd_parcela = @cd_parcela

    FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @qt_dia_cond_parcela_pgto

  end

  CLOSE      cParcela
  DEALLOCATE cParcela

--  select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS 
    EM QUE O DIA DO PAGAMENTO CAI NO 
    DIA DA SEMANA ESPECIFICADO
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/

  declare cParcela CURSOR FOR
  Select 
    cd_parcela, 
    dt_parcela, 
    cd_semana,
    qt_dia_cond_parcela_pgto 
 
  from #Parcela
  where 
    IsNull(ic_vctodia_parcela_pgto,'N')   = 'S'  and 
    isNull(ic_liquido_parcela_pagto,'N')  = 'N'  and 
    isNull(ic_fora_semana_parcela_pg,'N') = 'N'  and
    IsNull(ic_vctoespecif_pagto_parc,'N') = 'N' 
  order by
    cd_parcela

  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana, @qt_dia_cond_parcela_pgto 

  WHILE @@FETCH_STATUS = 0
  Begin
    if DatePart(dw,@dt_vencimento) = @cd_semana
    begin

      --Antes 
      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, @qt_dia_cond_parcela_pgto, @dt_vencimento)),'S','U')

      --set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, 0, @dt_vencimento)),'S','U')

--dt_parcela + isnull(qt_dia_cond_parcela_pgto,0)

      Update #Parcela 
      set dt_parcela   = @dt_vencimento 
      where cd_parcela = @cd_parcela

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana, @qt_dia_cond_parcela_pgto 
	   
    end 
    else
      set @dt_vencimento = DATEADD(day, 1, @dt_vencimento) 
  end

  CLOSE cParcela
  DEALLOCATE cParcela

  --select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS 
    EM QUE O DIA DO PAGAMENTO CAI NO 
    DIA DA SEMANA ESPECIFICADO
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/

  declare cParcela CURSOR FOR
  Select 
    cd_parcela, 
    dt_parcela, 
    cd_semana,
    qt_dia_cond_parcela_pgto 
 
  from #Parcela
  where 
    IsNull(ic_vctodia_parcela_pgto,'N')   = 'S'  and 
    isNull(ic_liquido_parcela_pagto,'N')  = 'N'  and 
    isNull(ic_fora_semana_parcela_pg,'N') = 'N'  and
    IsNull(ic_vctoespecif_pagto_parc,'N') = 'S' 
  order by
    cd_parcela

  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana, @qt_dia_cond_parcela_pgto 

  WHILE @@FETCH_STATUS = 0
  Begin
    if DatePart(dw,@dt_vencimento) = @cd_semana
    begin

      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, @qt_dia_cond_parcela_pgto, @dt_vencimento)),'S','U')

      Update #Parcela 
      set dt_parcela   = @dt_vencimento 
      where cd_parcela = @cd_parcela

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana, @qt_dia_cond_parcela_pgto 
	   
    end 
    else
      set @dt_vencimento = DATEADD(day, 1, @dt_vencimento) 
  end

  CLOSE cParcela
  DEALLOCATE cParcela


  --select * from #Parcela

--  select * from #Parcela
--  select @dt_vencimento
--  select * from condicao_pagamento_parcela where cd_condicao_pagamento = 40

  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS 
    EM QUE O DIA DO PAGAMENTO CAI NO 
    DIA DA SEMANA ESPECIFICADO
	Não são contadas a semana de 
	entrega e vencimento específico
  ======================================*/
  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      cd_semana 
    from 
      #Parcela
    where 
      IsNull(ic_vctodia_parcela_pgto,'N')   = 'S'  and 
      isNull(ic_liquido_parcela_pagto,'N')  = 'N' and 
      isNull(ic_fora_semana_parcela_pg,'N') = 'S'
    order by
      cd_parcela
	
  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana

  WHILE @@FETCH_STATUS = 0
  Begin
    if (DatePart(dw,@dt_vencimento) = @cd_semana) and 
        (DatePart(wk,@dt_vencimento) != DatePart(wk,@dt_primeiraEntrega))
    begin
      Update #Parcela 
      set dt_parcela = @dt_vencimento 
      where cd_parcela = @cd_parcela

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana	   
    end 
    else
      set @dt_vencimento = DATEADD(day, 1, @dt_vencimento) 
  end

  CLOSE      cParcela
  DEALLOCATE cParcela

--  select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS ÚTEIS 
    EM QUE O DIA DO PAGAMENTO CAI NO 
    DIA DA SEMANA ESPECIFICADO
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/
  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      cd_semana 
    from 
      #Parcela
    where 
      IsNull(ic_vctodia_parcela_pgto,'N')   = 'S'	and 
      isNull(ic_liquido_parcela_pagto,'N')  = 'S' and 
      isNull(ic_fora_semana_parcela_pg,'N') = 'N'
    order by
      cd_parcela
	
  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana

  WHILE @@FETCH_STATUS = 0
  Begin

    if DatePart(dw,@dt_vencimento) = @cd_semana
    begin
      Update #Parcela 
      set dt_parcela = @dt_vencimento 
      where cd_parcela = @cd_parcela

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana	   
    end 
    else
      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, 1, @dt_vencimento)),'S','U')
  end

  CLOSE cParcela
  DEALLOCATE cParcela
	
--  select * from #Parcela

  /*======================================
    PARCELAS COM NÚMERO DE DIAS ÚTEIS 
    EM QUE O DIA DO PAGAMENTO CAI NO 
    DIA DA SEMANA ESPECIFICADO
	São contadas a semana de 
	entrega e vencimento específico
  ======================================*/
  declare cParcela CURSOR FOR
    Select 
      cd_parcela, 
      dt_parcela, 
      cd_semana 
   from #Parcela
   where 
     IsNull(ic_vctodia_parcela_pgto,'N')   = 'S'  and 
     isNull(ic_liquido_parcela_pagto,'N')  = 'S'	and 
     isNull(ic_fora_semana_parcela_pg,'N') = 'S'
    order by
      cd_parcela
	
  Open cParcela
	
  FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana

  WHILE @@FETCH_STATUS = 0
  Begin
    if (DatePart(dw,@dt_vencimento) = @cd_semana) and 
       (DatePart(wk,@dt_vencimento) != DatePart(wk,@dt_primeiraEntrega))
    begin
      Update #Parcela 
      set dt_parcela = @dt_vencimento 
      where cd_parcela = @cd_parcela

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana	   
    end 
    else
      set @dt_vencimento = dbo.fn_dia_util((DATEADD(day, 1, @dt_vencimento)),'S','U')
  end

  CLOSE      cParcela
  DEALLOCATE cParcela

--  select * from #Parcela

  /*======================================
    REALIZA A APROXIMAÇÃO DAS PARCELAS 
    COM DATA DE VENCIMENTO ESPECIFICADOS
    EX. VENCIMENTO NO DIA 5 DE MÊS, 
	VENCIMENTO NO DIA 10 DE MÊS
  ======================================*/

  if exists(Select 'x' from Condicao_Pagamento_Aprox where cd_condicao_pagamento = @cd_condicao_pagamento)
  BEGIN
	
    declare cParcela CURSOR FOR
      Select 
        cd_parcela, 
	dt_parcela, 
	cd_semana 
      from 
	#Parcela
      order by
        cd_parcela
		
    Open cParcela
		
    FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana
		
    WHILE @@FETCH_STATUS = 0
    Begin
      --Verifica a primeira data apartir da data do vencimento calculada que é permitido o recebimento
      if exists(Select 'x' from Condicao_Pagamento_Aprox 
		where (cd_condicao_pagamento = @cd_condicao_pagamento) and 
		      (qt_dia_aproximacao >= day(@dt_vencimento)))
      begin
	Select top 1 
	  @qt_dia_aproximacao = (qt_dia_aproximacao - day(@dt_vencimento))
	from 
	  Condicao_Pagamento_Aprox with (nolock) 
	where 
	  (cd_condicao_pagamento = @cd_condicao_pagamento) and 
	  (qt_dia_aproximacao >= day(@dt_vencimento)) 
	order by 
	  qt_dia_aproximacao asc

	Update #Parcela 
	set dt_parcela = dateadd(day, @qt_dia_aproximacao, @dt_vencimento) 
	where cd_parcela = @cd_parcela

      end
      else
      begin
	Select top 1 @qt_dia_aproximacao = isnull(qt_dia_aproximacao,0) 
	from Condicao_Pagamento_Aprox with (nolock)  
	where (cd_condicao_pagamento = @cd_condicao_pagamento) 
	order by qt_dia_aproximacao asc

	Update #Parcela 
	set dt_parcela = cast((month(@dt_vencimento) + 1) as varchar(2)) + '/' + cast(@qt_dia_aproximacao  as varchar(2)) + '/' + cast(year(@dt_vencimento) as varchar(4)) 
	where cd_parcela = @cd_parcela
      end

      FETCH NEXT FROM cParcela into @cd_parcela, @dt_vencimento, @cd_semana
    end
	
    CLOSE cParcela
    DEALLOCATE cParcela

  END

  --Carlos 02.11.2010 --> Fora o Mês

  /*======================================
    PARCELAS COM NÚMERO DE DIAS CORRIDOS
	Não são contadas o mês do Faturamento
	
  ======================================*/

  update #Parcela
  set 
    dt_parcela = dbo.fn_primeiro_dia_proximo_mes(dt_emissao) + isnull(qt_dia_cond_parcela_pgto,0)
  where 
    IsNull(ic_vctoespecif_pagto_parc,'N') = 'N' and 
    IsNull(ic_fora_semana_parcela_pg,'N') = 'N' and
    IsNull(ic_liquido_parcela_pagto,'N')  = 'N' and
    IsNull(ic_vctodia_parcela_pgto,'N')   = 'N' and 
    IsNull(ic_fora_mes_parcela,'N')       = 'S'


--   order by
--     cd_parcela



  --select * from #Parcela


  /*======================================
    GRAVAÇÃO DAS INFORMAÇÕES NAS TABELAS
    ESPECIFICADAS DE ACORDO COM O PARAMETRO
  ======================================*/
  /* ========= 1 - PROPOSTA COMERCIAL =========== */
  if @ic_parametro = 1
  begin
	 --Exclui parcelas desatualizadas
    delete from Consulta_Parcela 
    where cd_consulta = @cd_documento

    --Recriar as parcelas
    Insert into Consulta_Parcela
     (cd_consulta,
      cd_parcela_consulta,
      dt_vcto_parcela_consulta,
      vl_parcela_consulta,
      cd_usuario,
      dt_usuario,
      ic_dt_especifica_consulta)
    Select 
      cd_documento,
      cd_parcela,
      dt_parcela,
      vl_parcela,
      cd_usuario,
      dt_usuario,
      IsNull(ic_vctoespecif_pagto_parc,'N')		 
    From 
      #Parcela
  end 

  /* ========= 2 - PEDIDO DE VENDA =========== */

  if @ic_parametro = 2
  begin
    /* Modificado p/ Johnny em 22/03/2003 */

    --Exclui parcelas desatualizadas	   
    delete from 
      Pedido_Venda_Parcela 
    where 
      cd_pedido_venda = @cd_documento


    -- Monta uma tabela auxiliar e verifica se o documento foi Pago

    select
      d.cd_documento_receber
    into
      #DocumentoPago
    from
      Documento_Receber d                       with (nolock) 
      inner join documento_receber_pagamento dp with (nolock) on dp.cd_documento_receber = d.cd_documento_receber

    where
      cd_pedido_venda    = @cd_documento and
      ic_tipo_lancamento = 'A'            

    --select * from #DocumentoPago

    --Deleta o Contas a Receber

    delete from 
      documento_receber 
    where 
      cd_pedido_venda = @cd_documento
      --Carlos 20.01.2010
      and isnull(cd_nota_saida,0)=0   
      and cd_documento_receber not in ( select cd_documento_receber from #DocumentoPago )

    drop table #DocumentoPago


    while exists(select top 1 cd_parcela from #Parcela)
    begin

      select top 1
        @cd_parcela    = cd_parcela,
        @dt_vencimento = dt_parcela,
        @dt_emissao    = dt_emissao
      from
        #Parcela


      if @ic_ident_parc_pv = 'S' 
      begin
        if @cd_identificacao_nota_saida>0 
          set @cd_identificacao = dbo.fn_serie_docto_customizada(@cd_identificacao_nota_saida, 'P')			
        else
          set @cd_identificacao = dbo.fn_serie_docto_customizada(@cd_documento, 'P')			

      end
      else
        --ccf : 20.01.2010 --> Verificar ( TMBEVO ) como vai ficar ....
        if @cd_identificacao_nota_saida>0 
           set @cd_identificacao = ltrim(rtrim(cast(@cd_identificacao_nota_saida as varchar)))+'-'+cast(@cd_parcela as varchar)
        else
          --set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'P', @qt_parcela )		
          set @cd_identificacao = ltrim(rtrim(cast(@cd_documento as varchar)))+'-'+cast(@cd_parcela as varchar)

      --ccf : 20.01.2010
      --select @ic_ident_parc_pv,@cd_identificacao

      Insert into Pedido_Venda_Parcela
        (cd_pedido_venda,
         cd_parcela_ped_venda,
         dt_vcto_parcela_ped_venda,
         vl_parcela_ped_venda,
         cd_usuario,
         dt_usuario,
         ic_dt_especifica_ped_vend,
         cd_ident_parc_ped_venda)

      Select 
        cd_documento,
        cd_parcela,
        dt_parcela,
        vl_parcela,
        cd_usuario,
        dt_usuario,
        IsNull(ic_vctoespecif_pagto_parc,'N'),
        @cd_identificacao
      From 
        #Parcela

      Where  
        cd_parcela = @cd_parcela

      delete from
        #Parcela
      where
        cd_parcela = @cd_parcela

    end

  end 

  /* ======== 3 ou 4 - FATURAMENTO =========== */
  --select @ic_parametro

  if ( @ic_parametro = 3 ) or  ( @ic_parametro = 4 ) or
     ( @ic_parametro = 5 )  --Faturamento
  begin
   
    --Anderson - 09/01/2006 - OS 0-SFT-081206-1044
    --Ao alterar qualquer dado da nota fiscal, o sistema gera as parcelas da nota_saida_parcela novamente
    --e por isso estava perdendo o plano financeiro e o centro de custo selecionado pelo usuario.
    --Estou pegando os dados em suas variaveis e criando a parcela com esses dados.

    Select
      top 1
      @cd_plano_financeiro = isnull(cd_plano_financeiro,0),
      @cd_centro_custo     = isnull(cd_centro_custo,0)
    From
      Nota_Saida_Parcela with (nolock) 
      
    where
      cd_nota_saida = @cd_documento 

    --Verifica se o Plano Financeiro está zerado na Tabela de Parcela e busca do parâmetro financeiro

    if @cd_plano_financeiro = 0
    begin

      --Verificar na tabela de CFOP
    
      select
        @cd_plano_financeiro       = isnull(opf.cd_plano_financeiro,0)
      from
        Nota_Saida ns                  with (nolock)
        inner join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
      where
        cd_nota_saida = @cd_documento 

      --Verifica o Parâmetro Financeiro

      if @cd_plano_financeiro = 0
      begin 

        select 
          @cd_plano_financeiro = isnull(cd_plano_financeiro,0)
        from
          parametro_financeiro with (nolock) 
        where 
          cd_empresa = dbo.fn_empresa()  
 
      end           
    
    end

    --Define o Plano Financeiro da Condição de Pagamento

    if @cd_plano_financeiro_condicao>0 
       set @cd_plano_financeiro = @cd_plano_financeiro_condicao

    --select @cd_plano_financeiro

    --Caso Continuar Zero coloca Null 

    if @cd_plano_financeiro = 0
       set @cd_plano_financeiro = null

    if @cd_centro_custo = 0
    begin
      select 
        @cd_centro_custo     = isnull(cd_centro_custo,0) 
      from
        parametro_financeiro with (nolock) 
      where 
        cd_empresa = dbo.fn_empresa()  

      if @cd_centro_custo = 0
        set @cd_centro_custo = null

    end

    --Exclui parcelas desatualizadas	   

    delete from Nota_Saida_Parcela 
    where  
      cd_nota_saida = @cd_documento

--     select *  from Nota_Saida_Parcela 
--     where  
--       cd_nota_saida = @cd_documento

    --select @cd_documento

    -------------------------------------------------------------------------------------------------------
    --Verifica se estamos gerando parcelas de contas a receber
    -------------------------------------------------------------------------------------------------------

    if ( @ic_parametro ) = 3 or ( @ic_parametro = 4 )
    begin

      if @ic_gerar_docto_pv = 'S'
      begin

        update Documento_Receber      
        set dt_cancelamento_documento = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121),
            nm_cancelamento_documento = 'Cancelamento Automático gerado pela Nota Fiscal Nº ' + cast(@cd_documento as varchar)
        where
          cd_documento_receber in ( select
                                      cd_documento_receber
                                    from
                                      Documento_Receber dr with (nolock) inner join
                                      ( select 
                                          pvp.cd_ident_parc_ped_venda 
                                        from 
                                          Pedido_Venda_Parcela pvp inner join
                                          Nota_Saida_Item nsi on nsi.cd_pedido_venda = pvp.cd_pedido_venda and
                                                                 nsi.cd_nota_Saida   = @cd_documento )  drs
                                      on drs.cd_ident_parc_ped_venda = dr.cd_identificacao
                                    where
                                      dr.vl_saldo_documento > 0 )


      end
--      else
--      Comentado temporiariamente por Carrasco em 30/10/2006 
--      Na procedure pr_gerar_documento_receber ele já apaga as parcelas do documento fazendo verificações consistentes
--      Não há necessidade de apagar aqui antes.
--      begin
	--Verifica se não existe um documento a receber já pago
/* 	if not exists(select top 1 'x' 
	              from 
	                documento_receber_pagamento drp,
		        documento_receber dr
		      where
		        dr.cd_documento_receber = drp.cd_documento_receber and
		        dr.cd_nota_saida = @cd_documento)
          delete Documento_Receber where cd_nota_saida = @cd_documento */
--      end
    end
    else --Caso as parcelas forem referentes ao contas a pagar
      begin
        delete from documento_pagar where cd_nota_saida = @cd_documento
      end
	
    --Inicia o processo de geração das parcelas na tabela Nota_Saida_Parcela

    while exists(select top 1 cd_parcela from #Parcela)
    begin
	
      Select top 1
        @cd_parcela    = cd_parcela,
	@dt_vencimento = dt_parcela,
        @dt_emissao    = dt_emissao
      from
	#Parcela

      --Define a identificação da parcela que será gerada para o Documento

      if ( @ic_parametro ) = 3 or ( @ic_parametro = 4 ) --Receber
      begin
        if @ic_ident_parc_pv = 'S' 
        begin
          --Seleciona 
          select 
	    @cd_pedido_venda = IsNull(max(nsi.cd_pedido_venda),0)
          from 
	    nota_saida_item nsi with (nolock) 
	  where
            nsi.cd_nota_saida = @cd_documento

          if ( @cd_pedido_venda > 0 )
            set @cd_identificacao = dbo.fn_serie_docto_customizada(@cd_pedido_venda, 'N')
          else
            set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'N', @qt_parcela )			

        end
        else
          if @cd_identificacao_nota_saida>0 
            set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_identificacao_nota_saida as varchar(25)), @dt_emissao, 'N', @qt_parcela)			
            --set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'N', @qt_parcela)			
          else        
            set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'N', @qt_parcela)			
      end 
      else --Pagar
        begin
          --set @cd_identificacao = cast(@cd_documento as varchar(10))
          --Carlos 17.09.2010
          if @cd_identificacao_nota_saida>0 
            set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_identificacao_nota_saida as varchar(25)), @dt_emissao, 'N', @qt_parcela)			
            --set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'N', @qt_parcela)			
          else
            set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'N', @qt_parcela)			

	end

      --select @cd_identificacao_nota_saida
      --select @cd_identificacao
  
      --Recriar as parcelas
   
      --select @nm_obs_parcela_nota_saida

      if not exists ( select 'x' from Nota_Saida_Parcela where cd_nota_saida = @cd_documento ) and
         ( @ic_gerar_docto_pv = 'S' ) and (@vl_quitado <> 0)

        Insert into Nota_Saida_Parcela
	 ( cd_nota_saida, 
           cd_num_formulario_nota,
           cd_parcela_nota_saida,
     	   dt_parcela_nota_saida,
           vl_parcela_nota_saida,
           ic_scr_parcela_nota_saida,
	   ic_dup_parcela_nota_saida,
 	   cd_usuario,
           dt_usuario,
           cd_ident_parc_nota_saida,
           ic_vctoespecif_pagto_parc,
           ic_parcela_quitada,
           cd_plano_financeiro,
           cd_centro_custo,
           nm_obs_parcela_nota_saida )
        Select 
	  cd_documento, 
	  (Select top 1 cd_num_formulario_nota 
           from 
             nota_saida with (nolock) 
           where 
             cd_nota_saida = cd_documento),
	  1,
	  cast(convert(varchar,GetDate(),101) as datetime),
	  cast(str(@vl_quitado,25,2) as decimal(25,2)),
	  'N',
	  'N',
	  cd_usuario,
	  dt_usuario,
	  'QUITADO',
	  'N',
          'S',
          @cd_plano_financeiro,
          @cd_centro_custo,
          @nm_obs_parcela_nota_saida
	From 
	  #Parcela
        Where
	  cd_parcela = @cd_parcela

     --Mostra a Tabela Gerada
     --select * from #Parcela
           
      Insert into Nota_Saida_Parcela
      ( cd_nota_saida, 
        cd_num_formulario_nota,
	cd_parcela_nota_saida,
	dt_parcela_nota_saida,
	vl_parcela_nota_saida,
	ic_scr_parcela_nota_saida,
	ic_dup_parcela_nota_saida,
	cd_usuario,
	dt_usuario,
	cd_ident_parc_nota_saida,
	ic_vctoespecif_pagto_parc,
        ic_parcela_quitada,
        cd_plano_financeiro,
        cd_centro_custo,
        nm_obs_parcela_nota_saida )
      Select 
	cd_documento, 
	(Select top 1 cd_num_formulario_nota from nota_saida with (nolock) 
         where cd_nota_saida = cd_documento),
	( case when @vl_quitado <> 0 then cd_parcela + 1 else cd_parcela end ) ,
	dt_parcela,
	cast(str(vl_parcela,25,2) as decimal(25,2)),
	'N',
	'N',
	cd_usuario,
	dt_usuario,

	@cd_identificacao,

	IsNull(ic_vctoespecif_pagto_parc,'N'),
        'N',
        @cd_plano_financeiro,
        @cd_centro_custo,
        @nm_obs_parcela_nota_saida

      From 
	#Parcela

      Where
	cd_parcela = @cd_parcela

      --select @cd_identificacao

      --select * from #Parcela
      --select * from nota_saida_parcela where cd_nota_saida = 604

      --Verifica se a empresa definiu que as parcelas de faturamento terão seus dados alterados
      --em função das parcelas de pedido de venda

      select @ic_importar_parcela_pv = IsNull(ic_importar_parcela_pv,'N') 
      from 
        parametro_faturamento with (nolock) 
      where 
        cd_empresa = dbo.fn_empresa()
	

--      select @ic_importar_parcela_pv

      -- Possibilidades 
      --	 S - Sempre, independente de ser data específica ou não
      --	 N - Nunca, sempre solicitar ao usuário a data específica no momento do faturamento
      --	 D - Data Específica, somente atualiza as parcelas com data específica

      if ( @ic_importar_parcela_pv = 'S' ) or ( @ic_importar_parcela_pv = 'D' )
      begin
        --Verifica se a parcela em questão é de vencimento especial
        if exists(Select 'x' from #Parcela 
                  where 
                    cd_parcela = @cd_parcela and 
              	    ((@ic_importar_parcela_pv = 'S') or 
                    ((@ic_importar_parcela_pv = 'D') and 
                    (IsNull(ic_vctoespecif_pagto_parc,'N') = 'S'))))
        begin        
          --Atualiza a parcela com a parcela do pedido de venda vinculado a nota fiscal
          select 
            @cd_pedido_venda = max(nsi.cd_pedido_venda) 
          from 
            nota_saida_item nsi with (nolock) 
          where
            nsi.cd_nota_saida = @cd_documento
	
          --Verifica se a nota possui mais de um pedido de venda
          --neste caso deve ser atualizada somente a data das parcelas
          if exists(select 'x' from nota_saida_item nsi with (nolock) 
                    where nsi.cd_nota_saida = @cd_documento and 
                         IsNull(nsi.cd_pedido_venda,0) <> @cd_pedido_venda)
          begin
            update 
              nota_saida_parcela
            set 
              dt_parcela_nota_saida     = pvp.dt_vcto_parcela_ped_venda,
              ic_vctoespecif_pagto_parc = 'N'
            from 
              Pedido_Venda_Parcela pvp
            where 
   	      pvp.cd_pedido_venda   = @cd_pedido_venda and 
              cd_parcela_ped_venda  = @cd_parcela and
              cd_nota_saida         = @cd_documento and 
              cd_parcela_nota_saida = @cd_parcela
    	  end
	  else --Caso tenha apenas aquele pedido
          begin
            --Verifica se o valor total do documento a ser gerado é igual a somatória das parcelas
            --do pedido de venda
            select
              @vl_total_cond_esp_ped = sum( isnull(vl_parcela_ped_venda,0) )
            from 
              Pedido_Venda_Parcela with (nolock) 
            where 
     	      cd_pedido_venda = @cd_pedido_venda

            --Caso o valor total das parcelas pré-cadastradas no pedido de venda forem igual 
            --ao valor informado na nota fiscal então é realizada a atualização dos valores
            --nas parcelas
            if @vl_total_cond_esp_ped = @vl_total_documento
            begin
	      --Atualiza data e valor
              update 
                nota_saida_parcela
              set 
	        dt_parcela_nota_saida     = pvp.dt_vcto_parcela_ped_venda,
	        vl_parcela_nota_saida     = pvp.vl_parcela_ped_venda,
	        ic_vctoespecif_pagto_parc = 'N'
              from 
	        Pedido_Venda_Parcela pvp
	      where 
	        pvp.cd_pedido_venda   = @cd_pedido_venda and 
                cd_parcela_ped_venda  = @cd_parcela and
	        cd_nota_saida         = @cd_documento and 
                cd_parcela_nota_saida = @cd_parcela
	    end
            else
	    begin
	      --Atualiza somente data
	     update 
	       nota_saida_parcela
	     set 
	       dt_parcela_nota_saida     = pvp.dt_vcto_parcela_ped_venda,
	       ic_vctoespecif_pagto_parc = 'N'
	     from 
	       Pedido_Venda_Parcela pvp
	     where 
	       pvp.cd_pedido_venda   = @cd_pedido_venda and 
               cd_parcela_ped_venda  = @cd_parcela and
	       cd_nota_saida         = @cd_documento and 
               cd_parcela_nota_saida = @cd_parcela
   	    end

          end


        end
      end

      if exists ( select top 1 
  	            cd_centro_custo
		  from Nota_Saida_item x with (nolock) inner join
                       Pedido_Venda y    with (nolock) on x.cd_pedido_venda = y.cd_pedido_venda
		  where x.cd_nota_saida = @cd_documento and 
	                y.cd_centro_custo is not null)
      begin 
        update 
          nota_saida_parcela
        set cd_centro_custo = ( select top 1 
   				  cd_centro_custo
  			        from Nota_Saida_item x with (nolock) inner join
                                     Pedido_Venda y    with (nolock) on x.cd_pedido_venda = y.cd_pedido_venda
				where cd_nota_saida = @cd_documento )
        where 
          cd_nota_saida = @cd_documento
      end

      delete from #Parcela where cd_parcela = @cd_parcela
	
    end                                  
	
    ------------------------------------------------------------------------------------------------   
    --Gerando o documento a receber
    ------------------------------------------------------------------------------------------------

    if ( @ic_parametro ) = 3 or ( @ic_parametro = 4 )
    begin
      --select @ic_parametro
      exec pr_gerar_documento_receber 1, @cd_documento, null, null, @cd_usuario
      --select @ic_parametro
    end
    else if ( @ic_parametro ) = 5
         begin
           --Gerando o Contas a Pagar
           print 'Geração do Contas a Pagar'
           exec pr_gerar_documento_pagar 6,              --Parâmetro
                                         @cd_documento,  --Nota de Entrada
                                         null,           --Fornecedor
                                         null,           --Série
                                         @cd_usuario,	 --Usuário,
                                         null,           --Documento Pagar,
                                         1,              --Moeda,
                                         null            --Plano Financeiro

           print 'Contas a Pagar - Gerado'

	 end	
  end

  -----------------------------------------------------------------------------
  if @ic_parametro = 6  -- Geração do Contas a Receber de Exportação
  -----------------------------------------------------------------------------
  begin

    --Exclui parcelas desatualizadas	   
    delete from 
      Embarque_Parcela
    from 
      Embarque e, 
      Embarque_Parcela ep
    where 
      e.cd_embarque       = ep.cd_embarque and
      e.cd_pedido_venda   = ep.cd_pedido_venda and
      e.cd_embarque_chave = @cd_documento

    delete from 
      documento_receber 
    where 
      cd_embarque_chave = @cd_documento

    while exists(select top 1 cd_parcela from #Parcela)
    begin
      select top 1
        @cd_parcela  = cd_parcela,
        @dt_vencimento = dt_parcela,
        @dt_emissao = dt_emissao
      from
        #Parcela

      select 
        @cd_identificacao = cast(cast(isnull(pv.cd_identificacao_empresa,pv.cd_pedido_venda) as varchar) +'/'+
                            cast(e.cd_embarque as varchar)+'-'+
                            cast((IsNull(count(ep.cd_parcela_embarque),0) + 1) as varchar) as varchar(25))
      from Embarque e inner join Pedido_Venda pv on pv.cd_pedido_venda = e.cd_pedido_venda
                      left outer join Embarque_Parcela ep on e.cd_embarque = ep.cd_embarque and e.cd_pedido_venda = ep.cd_pedido_venda 
      where e.cd_embarque_chave = @cd_documento
      group by pv.cd_identificacao_empresa, pv.cd_pedido_venda, e.cd_embarque

      Insert into Embarque_Parcela
        (cd_pedido_venda,
         cd_embarque,
         cd_parcela_embarque,
         dt_vcto_parcela_embarque,
         vl_parcela_embarque,
         cd_usuario,
         dt_usuario,
         ic_dt_especirfico_embarque,
         cd_ident_parc_embarque)
      Select  
        e.cd_pedido_venda,
        e.cd_embarque,
        p.cd_parcela,
        p.dt_parcela,
        p.vl_parcela,
        p.cd_usuario,
        p.dt_usuario,
        IsNull(p.ic_vctoespecif_pagto_parc,'N'),
        @cd_identificacao
      From 
        #Parcela p,
        Embarque e
      Where  
        p.cd_parcela = @cd_parcela and
        e.cd_embarque_chave = p.cd_documento and
        p.cd_documento = @cd_documento

      delete from
        #Parcela
      where
	      cd_parcela = @cd_parcela
    end

    exec pr_gerar_documento_receber 9, @cd_documento, null, null, @cd_usuario

  end
  -----------------------------------------------------------------------------
  if @ic_parametro = 7  -- Geração dos Documentos a Pagar do Embarque
  -----------------------------------------------------------------------------
  begin

    --Exclui parcelas desatualizadas	   
    delete from 
      Embarque_Importacao_Parcela
    from Embarque_Importacao e, Embarque_Importacao_Parcela ep
    where 
      e.cd_embarque          = ep.cd_embarque and
      e.cd_pedido_importacao = ep.cd_pedido_importacao and
      e.cd_embarque_chave    = @cd_documento

    delete from 
      documento_pagar
    where 
      cd_embarque_chave = @cd_documento

    while exists(select top 1 cd_parcela from #Parcela)
    begin

      select top 1
        @cd_parcela    = cd_parcela,
        @dt_vencimento = dt_parcela,
        @dt_emissao    = dt_emissao
      from
        #Parcela

      select 
        @cd_identificacao = cast(cast(isnull(pv.cd_identificacao_pedido,pv.cd_pedido_importacao) as varchar) +'/'+
                            cast(e.cd_embarque as varchar)+'-'+
                            cast((IsNull(count(ep.cd_parcela_embarque),0) + 1) as varchar) as varchar(25))
      from 
        Embarque_Importacao e with (nolock) inner join 
        Pedido_Importacao pv           on pv.cd_pedido_importacao = e.cd_pedido_importacao left outer join 
        Embarque_Importacao_Parcela ep on e.cd_embarque = ep.cd_embarque and 
                                          e.cd_pedido_importacao = ep.cd_pedido_importacao
      where e.cd_embarque_chave = @cd_documento
      group by 
        pv.cd_identificacao_pedido, 
        pv.cd_pedido_importacao, 
        e.cd_embarque

      Insert into Embarque_Importacao_Parcela
        (cd_pedido_importacao,
         cd_embarque,
         cd_parcela_embarque,
         dt_vcto_parcela_embarque,
         vl_parcela_embarque,
         cd_usuario,
         dt_usuario,
         ic_dt_especifico_embarque,
         cd_ident_parc_embarque)
      Select  
        e.cd_pedido_importacao,
        e.cd_embarque,
        p.cd_parcela,
        p.dt_parcela,
        p.vl_parcela,
        p.cd_usuario,
        p.dt_usuario,
        IsNull(p.ic_vctoespecif_pagto_parc,'N'),
        @cd_identificacao
      From 
        #Parcela p,
        Embarque_Importacao e
      Where  
        p.cd_parcela        = @cd_parcela and
        e.cd_embarque_chave = p.cd_documento and
        p.cd_documento      = @cd_documento

      delete from
        #Parcela
      where
	      cd_parcela = @cd_parcela
    end

    exec pr_gerar_documento_pagar 3, @cd_documento, null, null, @cd_usuario

  end
   -----------------------------------------------------------------------------
  if @ic_parametro = 8  -- Geração dos Documentos a Assistencia Tecnica O.S.
  -----------------------------------------------------------------------------
  begin
    --Exclui parcelas desatualizadas	   
   delete from 
     Ordem_Servico_Parcela 
    where 
      cd_ordem_servico = @cd_documento

    delete from 
      documento_receber 
    where 
      cd_ordem_servico = @cd_documento
 
    while exists(select top 1 cd_parcela from #Parcela)
    begin

      select top 1
        @cd_parcela    = cd_parcela,
        @dt_vencimento = dt_parcela,
        @dt_emissao    = dt_emissao
      from
        #Parcela

      --Identificação da Parcela 
      set @cd_identificacao = dbo.fn_serie_documento_receber(cast(@cd_documento as varchar(25)), @dt_emissao, 'S', @qt_parcela )		
      
      Insert into Ordem_Servico_Parcela
        (cd_ordem_servico,
         cd_parcela_ord_serv,
         dt_vcto_parcela_ord_serv,
         vl_parcela_ord_serv,
         cd_usuario,
         dt_usuario,
         ic_dt_especifica_ord_serv,
         cd_ident_parc_ord_serv)
      Select 
        cd_documento,
        cd_parcela,
        dt_parcela,
        vl_parcela,
        cd_usuario,
        dt_usuario,
        IsNull(ic_vctoespecif_pagto_parc,'N'),
        @cd_identificacao
      From 
        #Parcela
      Where  
        cd_parcela = @cd_parcela

      delete from
        #Parcela
      where
        cd_parcela = @cd_parcela
    end
  end

end  


