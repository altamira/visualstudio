
CREATE PROCEDURE pr_documento_receber

-------------------------------------------------------------------------------------------------
--pr_documento_receber
-------------------------------------------------------------------------------------------------
--Global Business Solution Ltda.                           2004
-------------------------------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Elias P. Silva / Johnny Mendes de Souza
--                       Carlos Fernandes
--Banco de Dados       : Egissql
--Objetivo             : Rotinas de geração/gravação de Documento_Receber
--                        
--Data                 : 29/10/2001
--Atualizado           : 30/10/2001 
--                     : 18/02/2002 - Inclusão de novos campos na consulta (parâmetro 1) - ELIAS
--                     : 19/02/2002 - Exclusão dos novos campos da consulta - Igor Gama--                     :  04/03/2002 - Consulta de Documentos em Aberto no Período - Elias
--                     : 13/03/2002 - Modificação de vl_saldo_documento de FLoat p/ decimal - Daniel C. Neto
--                     : 01/04/2002 - Migraçãp p/ EGISSQL - Elias
--                     : 24/04/2002 - Inclusão do campo cd_nota_saida - ELIAS
--                     : 24/04/2002 - Inclusão dos campos dt_pagto_document_receber e vl_pagto_document_receber - ELIAS
--                     : 11/06/2002 - Inclusão do campo ic_tipo_lancamento onde é identificado se é Automático ou
--                                    Manual - ELIAS
--                     : 13/06/2002 - Inclusão do campo cd_tipo_liquidação - ELIAS
--                     : 01/07/2002 - Inclusão de valor default ao parametro @dt_usuario - ELIAS
--                     : 30/09/2002 - Inclusão de campo ic_envio_documento - ELIAS
--                     : 11/10/2002 - Mudado filtro por data de vencimento - parâmetro 5 - Daniel C. Neto.
--                     : 09/01/2003 - Inclusão de campo cd_tipo_destinatario - Daniel c. Neto.
--    	               : 10/01/2003 - Modificações Gerais - Daniel C. Neto.
--                     : 27/01/2003 - Incluido a Data de Retorno do Banco - Carlos
--                     : 31/03/2003 - Mudado calculo do campo VL_CREDITO_PENDENTE de (+) para (-)
--                     : 15/07/2003 - Inclusão de campo ic_credito_icms_documento - DUELA
--                     : 11/08/2003 - Inclusão de valor default ao parâmetro já existente ic_credito_icms_documento - ELIAS
--                     : 17/08/2003 - Inclusão do campo 'd.ic_anuencia_documento' - DANIEL DUELA
--                     : 03/03/2003 - Alteração no filtro de Consulta. Caso o parâmetro 'ic_consulta_parcial_doc'
--                                    da tabela 'Parametro_Financeiro' estiver setado com SIM, é feita apenas
--                                    uma consulta parcial (LIKE) - DANIEL DUELA
--                     : 22/03/2003 - Alteração no filtro de Consulta. Apresentava erro, pois alguns documentos
--                                    começavam com '0'.  - DANIEL DUELA/CARRASCO
--                     : 01/04/2004 - Acerto no parâmetro 5 - Daniel C. Neto.
--                     : 24.05.2004 - Foi alterado para o campo de emissão da nota sempre vir como "N" por padrão - Fabio Cesar
--                     : 25/05/2004 - Acerto no Parametro = 1 e = 5 para otimização da performace - ELIAS
--                     : 22/06/2004 - Incluído plano financeiro - Daniel C. Neto
--                     : 08/10/2004 - Retirado Replace de Pesquisa da Identificação para Melhorar a Performace - ELIAS
--                     : 14/10/2004 - Incluído Moeda - Daniel C. Neto.
--                     : 21/10/2004 - Incluído Chave do Embarque de Exportação - ELIAS
--                     : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 06/01/2005 - Arredondamento de 0,01 centavo na baixa do documento ( Carlos / Paulo )
--                     : 12.02.2005 - Inclusão da Loja na Consulta - Carlos Fernandes            
-- 28/02/2005 - Tirado arredondamento do valor de saldo no campo para evitar problemas de 0,01 - Daniel C. Neto.
--                     : 11/07/2005 - Adicionado o Usuario na Procedure.
--		       : 30/08/2005 - Inclusão de relacionamento entre as tabelas Documento_Receber - Cliente
--                       Cliente - Cliente_Grupo e inserção do campo nm_cliente_grupo na stored procedure (Wellington)  	
--                     : 23.11.2005 - Centro de Custo - Carlos Fernandes
--                     : 27/01/2006 - Acerto no filtro aplicado no vl_saldo_documento  -  Wilder Mendes de Souza
--                     : 08.02.2006 - Conversão para outras Moedas - Carlos Fernandes
--                     : 03.04.2006 - Tipo de Consulta - aberto / todos - Carlos Fernandes
--                     : 29.01.2007 - Adicionando nome do portador - Anderson
--                     : 08.02.2007 - Adicionando dia da semana - Anderson
--                     : 13.05.2007 - Data Remessa/Retorno/Número do Cheque - Carlos Fernandes
--                     : 18.07.2007 - Código/Máscara do Plano Financeiro - Carlos Fernandes
--                     : 07.12.2007 - Status de Qualificação - Carlos Fernandes
--                     : 17.12.2007 - Verificação do Saldo do Documento - Carlos Fernandes
-- 05.05.2008 - Ajuste do Saldo do Documento Receber - Carlos Fernandes
-- 20.05.2008 - Gravação do Movimento de Caixa no Contas a Receber - Carlos Fernandes
-- 09.03.2009 - Ajuste para Documentos Baixados - Carlos Fernandes
-- 21.03.2009 - Pesquisa pelo Pedido de Venda - Carlos Fernandes
-- 03.04.2009 - Forma de Pagamento - Carlos Fernandes
-- 07.09.2009 - Consistência da Data de Emissão Menor que a Data de Emissão da Nota Fiscal - Carlos Fernandes
-- 12.05.2010 - Geração pelo Pedido de Venda - Carlos Fernandes
-- 18.09.2010 - Coluna de Status para Identificar o Documento - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------
-- OBS: - Cuidado ao incluir parâmetros nessa procedure, pois ela está sendo usada tambem
-- no SFI ( Financeiro ) , na tela de Notas de Débito de Despesa.
-- Daniel C. Neto. - 05/08/2003
------------------------------------------------------------------------------------------
-- 13.12.2010 - Mostrar a Conta Corrente da Seleção Duplicatas p/ Banco - Carlos Fernandes

@ic_parametro 		    int,
@dt_inicial 		    datetime,
@dt_final 		    datetime,
@cd_documento_receber	    int,
@cd_identificacao	    varchar(25),
@dt_emissao_documento	    datetime,
@dt_vencimento_documento    datetime,
@dt_vencimento_original	    datetime,
@vl_documento_receber	    float,
@vl_saldo_documento	    float, 
@dt_cancelamento_documento  datetime,
@nm_cancelamento_documento  varchar(60),
@cd_modulo            	    int,
@cd_banco_documento_recebe  varchar(30),
@ds_documento_receber       varchar(400),
@ic_emissao_documento	    char(1) = 'N',
@ic_envio_documento	    char(1) = 'N',
@dt_envio_banco_documento   datetime,
@dt_contabil_documento	    datetime,
@cd_portador		    int    = 0,
@cd_tipo_cobranca	    int    = 0,
@cd_cliente		    int    = 0,
@cd_tipo_documento	    int    = 0,
@cd_pedido_venda	    int    = 0,
@cd_nota_saida              int    = 0,
@cd_vendedor		    int    = 0,
@dt_pagto_document_receber  datetime,
@vl_pagto_document_receber  float,
@ic_tipo_lancamento	    char(1),
@cd_tipo_liquidacao	    int,
@cd_plano_financeiro	    int,
@cd_usuario		    int,
@dt_usuario		    datetime,
@cd_tipo_destinatario	    int,
@vl_abatimento_documento    float,
@vl_reembolso_documento     float,
@dt_devolucao_documento     datetime,
@nm_devolucao_documento     varchar(40),
@ic_credito_icms_documento  char(1)      = 'N',
@cd_moeda                   int          = 1,
@cd_embarque_chave          int          = 0,
@cd_loja                    int          = 0,
@cd_centro_custo            int          = 0,
@ic_tipo_consulta           char(1)      = 'A',
@cd_ordem_servico           int          = 0,
@nm_destinatario            varchar(100) = '',
@cd_movimento_caixa         int          = 0,
@ic_consistencia            char(1)      = 'S'

AS

  if ((@dt_usuario = null) or (@dt_usuario = ''))
    set @dt_usuario = getdate()

  if ( ( @ic_emissao_documento = null ) or ( @ic_emissao_documento = '' ) )
    set @ic_emissao_documento = 'N'

  declare @vl_moeda float

  set @vl_moeda = ( case when isnull(dbo.fn_vl_moeda(@cd_moeda),0) = 0
                         then 1
                         else dbo.fn_vl_moeda(@cd_moeda) 
                         end )


  declare @ic_vcto_menor_emissao char(1) 

  select
    @ic_vcto_menor_emissao = isnull(ic_vcto_menor_emissao,'N')
  from
    parametro_financeiro with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  --select @vl_moeda

  declare @dt_hoje datetime

  set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

begin transaction

-----------------------------------------------------------------------------------------
if @ic_parametro = 1  --Consulta dos Documentos a Receber Em aberto No Período 
-----------------------------------------------------------------------------------------
begin

  select 
    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_vencimento_original,

    --Verifica a Conversão da Moeda

    case when @cd_moeda <> isnull(d.cd_moeda,1)
    then
      (d.vl_documento_receber/@vl_moeda ) 
    else
      d.vl_documento_receber                                   
    end                                                        as 'vl_documento_receber',

    case when @cd_moeda <> isnull(d.cd_moeda,1) then
       cast(str(d.vl_saldo_documento/@vl_moeda,25,2) as decimal(25,2))
    else
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) 
    end

    -

    isnull(d.vl_abatimento_documento,0)                        as 'vl_saldo_documento',

    d.dt_cancelamento_documento,
    d.nm_cancelamento_documento,
    d.cd_modulo,      
    d.cd_banco_documento_recebe,
    cast(d.ds_documento_receber as varchar(400)) as ds_documento_receber,
    d.ic_emissao_documento,
    d.ic_envio_documento,
    d.dt_envio_banco_documento,
    d.dt_contabil_documento,
    d.cd_portador,
    d.cd_tipo_cobranca,
    d.cd_cliente,
    vw.nm_fantasia     as 'nm_fantasia_destinatario',
    vw.nm_razao_social as 'nm_razao_social_destinatario',
    vw.cd_telefone,
    vw.cd_ddd,
    d.cd_tipo_documento,
    d.cd_pedido_venda,
    d.cd_nota_saida,
    d.cd_vendedor,
    d.dt_pagto_document_receber,
    d.vl_pagto_document_receber,
    d.ic_tipo_lancamento,
    d.cd_tipo_liquidacao,
    d.cd_plano_financeiro,
    d.cd_usuario,
    d.dt_usuario,
    d.cd_tipo_destinatario,
    d.vl_abatimento_documento,
    d.vl_reembolso_documento,
    d.dt_devolucao_documento,
    d.nm_devolucao_documento,
    d.dt_retorno_banco_doc,
    d.ic_credito_icms_documento,
    d.cd_loja,
    l.nm_fantasia_loja,
    u.nm_fantasia_usuario,
    cg.nm_cliente_grupo,
    d.cd_centro_custo,
    cc.nm_centro_custo,
    cr.nm_cheque_receber,
    cr.dt_deposito_cheque_recebe,
    dra.nm_obs_documento              as nm_obs_documento_analise,
    fp.nm_forma_pagamento

  from
    Documento_receber d with (nolock)
  -- ELIAS 25/05/2004
  inner join vw_destinatario_rapida vw  on  vw.cd_destinatario = d.cd_cliente and
                                            vw.cd_tipo_destinatario = d.cd_tipo_destinatario
 
  left outer join Loja l                on l.cd_loja = d.cd_loja 
  left outer join EgisAdmin.dbo.usuario u  on d.cd_usuario = u.cd_usuario
   
  left outer join Cliente cl            on cl.cd_cliente = d.cd_cliente
  left outer join Cliente_grupo cg      on cg.cd_cliente_grupo = cl.cd_cliente
  left outer join Centro_Custo cc       on cc.cd_centro_custo  = d.cd_centro_custo
  left outer join Cheque_Receber_Composicao crc on crc.cd_documento_receber = d.cd_documento_receber
  left outer join Cheque_Receber            cr  on cr.cd_cheque_receber     = crc.cd_cheque_receber
  left outer join Documento_Receber_Analise dra on dra.cd_documento_receber = d.cd_documento_receber
  left outer join Cliente_Informacao_Credito ci on ci.cd_cliente            = cl.cd_cliente
  left outer join Forma_Pagamento            fp on fp.cd_forma_pagamento    = ci.cd_forma_pagamento
  where 
    d.cd_identificacao = @cd_identificacao

  goto TrataErro

end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Inserção de Novo Documento
-----------------------------------------------------------------------------------------
  begin
--print 'Aqui'
--Print @cd_ordem_servico
    --Na Inserção Valor do Saldo Deve Ser Igual ao Valor do Documento
--    if isnull(@vl_abatimento_documento,0) = 0 begin
      --set @vl_saldo_documento = @vl_documento_receber
--    end

      set @vl_saldo_documento = isnull(@vl_documento_receber,00) 
    
      set @vl_saldo_documento  = @vl_saldo_documento + case when isnull(round(@vl_documento_receber - @vl_saldo_documento,2),0) = 0.01 then 0.01 else 0.00 end      --Verifica se Documento Já Existe

    if exists(select 
                top 1 'x'
              from 
                Documento_Receber with (nolock) 
              where 
                cd_identificacao = @cd_identificacao) 
      begin
        if @ic_consistencia = 'S'
           raiserror('Nº do documento já cadastrado!', 16, 1)
        goto TrataErro
      end
    else
      --Verifica se Valor Informado Para Documento é Válido   
      if @vl_documento_receber <= 0
        begin
          raiserror('Valor do documento deve ser maior que 0,00!', 16, 1)
          goto TrataErro
        end
      else
        --Verifica se Data de Vencimento é Inferior a Data de Emissão
        if @ic_vcto_menor_emissao = 'N' and @dt_vencimento_documento < @dt_emissao_documento
          begin
            raiserror('Data de vencimento deve ser superior a data de emissão!', 16, 1)
            goto TrataErro
          end
        else
          begin
            insert into Documento_Receber (
              cd_documento_receber,
              cd_identificacao,
              dt_emissao_documento,
              dt_vencimento_documento,
              dt_vencimento_original,
              vl_documento_receber,
              vl_saldo_documento,
              dt_cancelamento_documento,
              nm_cancelamento_documento,
              cd_modulo,
              cd_banco_documento_recebe,
              ds_documento_receber,
              ic_emissao_documento,
              ic_envio_documento,
              dt_envio_banco_documento,
              dt_contabil_documento,
              cd_portador,
              cd_tipo_cobranca,
              cd_cliente,
              cd_tipo_documento,
              cd_pedido_venda,
              cd_nota_saida,
              cd_vendedor,
              dt_pagto_document_receber,
              vl_pagto_document_receber,
              ic_tipo_lancamento,    -- 11/06/2002
              d.cd_tipo_liquidacao,  -- 13/06/2002
              d.cd_plano_financeiro,
              cd_usuario,
              dt_usuario,
      	      cd_tipo_destinatario,
              vl_abatimento_documento,
              vl_reembolso_documento,
              dt_devolucao_documento,
              nm_devolucao_documento,
              ic_credito_icms_documento,
              cd_moeda,
              cd_loja,
              cd_embarque_chave,
              cd_centro_custo,
              cd_ordem_servico,
              cd_movimento_caixa )
            values (
              @cd_documento_receber,
              @cd_identificacao,
              @dt_emissao_documento,
              @dt_vencimento_documento,
              @dt_vencimento_original,
              @vl_documento_receber,

              --@vl_saldo_documento,
              --Identificação do Problema de Arredodamento do Saldo 0,01
              --06.01.2005

              --@vl_saldo_documento + case when isnull(round(@vl_documento_receber - @vl_saldo_documento,2),0) = 0.01 then 0.01 else 0.00 end,
              @vl_saldo_documento,

              @dt_cancelamento_documento,
              @nm_cancelamento_documento,
              @cd_modulo,
              @cd_banco_documento_recebe,
              @ds_documento_receber,
              @ic_emissao_documento,
              @ic_envio_documento,
              @dt_envio_banco_documento,
              @dt_contabil_documento,
              @cd_portador,
              @cd_tipo_cobranca,
              @cd_cliente,
              @cd_tipo_documento,
              @cd_pedido_venda,
              @cd_nota_saida,
              @cd_vendedor,
              @dt_pagto_document_receber,
              @vl_pagto_document_receber,
              @ic_tipo_lancamento, 
              @cd_tipo_liquidacao,
              @cd_plano_financeiro,
              @cd_usuario,
              @dt_usuario,
      	      @cd_tipo_destinatario,
              @vl_abatimento_documento,
              @vl_reembolso_documento,
      	      @dt_devolucao_documento,
      	      @nm_devolucao_documento,
              @ic_credito_icms_documento,
              @cd_moeda,
              @cd_loja,
              @cd_embarque_chave,
              @cd_centro_custo,
              @cd_ordem_servico,
              isnull(@cd_movimento_caixa,0) )     
          end

  end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Alteração de Documento
-----------------------------------------------------------------------------------------
  begin
    --Verifica se Valor Informado Para Documento é Válido   
    if @vl_documento_receber <= 0
      begin
        raiserror('Valor do documento deve ser maior que 0,00!', 16, 1)
        goto TrataErro
      end  
    else    
      --Verifica se Data de Vencimento é Inferior a Data de Emissão 
      if @dt_vencimento_documento < @dt_emissao_documento
        begin
          raiserror('Data de vencimento deve ser superior a data de emissão!', 16, 1)
          goto TrataErro
        end
    else
      begin
        --CALCULA NOVO SALDO
        set @vl_saldo_documento = @vl_documento_receber - ( isnull((select 
                                                                     sum(isnull(vl_pagamento_documento, 0))
                                                                   - sum(isnull(vl_juros_pagamento, 0))     
                                                                   + sum(isnull(vl_desconto_documento, 0))
                                                                   + sum(isnull(vl_abatimento_documento, 0))
                                                                   - sum(isnull(vl_despesa_bancaria, 0))
                                                                   + sum(isnull(vl_reembolso_documento, 0))
                                                                   - sum(isnull(vl_credito_pendente, 0))
                                                                   from 
                                                                     Documento_Receber_Pagamento with (nolock) 
                                                                   where 
                                                                     cd_documento_receber = @cd_documento_receber), 0))
      end
    
    --Verifica se há data data de cancelamento do documento   

    if @dt_cancelamento_documento is not null
      begin
        if exists(select cd_documento_receber from documento_receber_pagamento with (nolock) 
                  where cd_documento_receber=@cd_documento_receber)
          begin
            raiserror('Não é possível cancelar o documento pois existe(m) baixas para o título!', 16, 1)
            goto TrataErro
          end  
        else
          begin
            set @dt_devolucao_documento=null
            set @nm_devolucao_documento=null
            set @vl_saldo_documento=0
            set @cd_tipo_liquidacao=2 --TIPO DE Liquidacao CANCELADO
          end
      end
     --Verifica se há data de devolucao do documento
    else if @dt_devolucao_documento is not null
      begin
        if exists(select cd_documento_receber 
                  from documento_receber_pagamento with (nolock) 
                  where cd_documento_receber=@cd_documento_receber)
          begin
            raiserror('Não é possível devolver o documento pois existe(m) baixas para o título!', 16, 1)
            goto TrataErro
          end  
        else
          begin
            set @dt_cancelamento_documento=null
            set @nm_cancelamento_documento=null
            set @vl_saldo_documento=0
            set @cd_tipo_liquidacao=1 -- Tipo de Liquidacao DEVOLVIDO
          end       
      end
     
     --ATUALIZA REGISTRO

         update
            Documento_Receber
          set
            cd_identificacao	          = @cd_identificacao,
            dt_emissao_documento  	  = @dt_emissao_documento,
            dt_vencimento_documento	  = @dt_vencimento_documento,
            vl_documento_receber	  = @vl_documento_receber,
            vl_saldo_documento		  = @vl_saldo_documento,
            dt_cancelamento_documento	  = @dt_cancelamento_documento,
            nm_cancelamento_documento	  = @nm_cancelamento_documento,
            cd_modulo			  = @cd_modulo,
            cd_banco_documento_recebe     = @cd_banco_documento_recebe,
            ds_documento_receber	  = @ds_documento_receber,
            ic_emissao_documento	  = @ic_emissao_documento,
            ic_envio_documento		  = @ic_envio_documento,
            dt_envio_banco_documento      = @dt_envio_banco_documento,
            dt_contabil_documento	  = @dt_contabil_documento,
            cd_portador			  = @cd_portador,
            cd_tipo_cobranca		  = @cd_tipo_cobranca,
            cd_cliente			  = @cd_cliente,
            cd_tipo_documento		  = @cd_tipo_documento,
            cd_pedido_venda		  = @cd_pedido_venda,
            cd_nota_saida                 = @cd_nota_saida,
            cd_vendedor			  = @cd_vendedor,
            dt_pagto_document_receber     = @dt_pagto_document_receber,
            vl_pagto_document_receber     = @vl_pagto_document_receber,
            ic_tipo_lancamento		  = @ic_tipo_lancamento,
            cd_tipo_liquidacao	          = @cd_tipo_liquidacao,
            cd_plano_financeiro	          = @cd_plano_financeiro,
            cd_usuario			  = @cd_usuario,
            dt_usuario            	  = @dt_usuario,
      	    cd_tipo_destinatario	  = @cd_tipo_destinatario,
            vl_abatimento_documento       = @vl_abatimento_documento,
            vl_reembolso_documento        = @vl_reembolso_documento,
            dt_devolucao_documento        = @dt_devolucao_documento,
            nm_devolucao_documento        = @nm_devolucao_documento,
            ic_credito_icms_documento     = @ic_credito_icms_documento,
            cd_moeda                      = @cd_moeda,
            cd_loja                       = @cd_loja,
            cd_embarque_chave             = @cd_embarque_chave,
            cd_centro_custo               = @cd_centro_custo,
            cd_ordem_servico              = @cd_ordem_servico,
            cd_movimento_caixa            = isnull(@cd_movimento_caixa,0)
          where
            cd_documento_receber = @cd_documento_receber

  end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Exclusão de Documento
-----------------------------------------------------------------------------------------
  begin
    --Verifica se Existem Baixas Para o Documento a Ser Deletado
    if exists(select 
                top 1 'x'
              from 
                Documento_Receber_Pagamento
              where 
                cd_documento_receber = @cd_documento_receber)
      begin
        raiserror('Existe(m) baixa(s) para este documento! Não é possível excluí-lo!', 16, 1)
        goto TrataErro          
      end
    else
      delete from
        Documento_Receber_Instrucao
      where
        cd_documento_receber = @cd_documento_receber

      delete from
        Documento_Receber
      where
        cd_documento_receber = @cd_documento_receber            
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5 -- listagem dos documentos em aberto
-------------------------------------------------------------------------------
  begin

  if @cd_pedido_venda is null
  begin
     set @cd_pedido_venda = 0
  end

  -- FORMA NOVA
  -- ELIAS 25/05/2004
  -- SE A IDENTIFICAÇÃO FOR VAZIA, SÓ TEM UMA FORMA DE PESQUISAR

  if (isnull(@cd_identificacao,'&') = '&') and @cd_pedido_venda = 0
  begin

    --select * from documento_receber

    --print '1'

    select 
      '1'                                               as A,

      case when isnull(d.vl_saldo_documento,0)=0 then
        'Baixado'
      else
        case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento >= @dt_hoje
        then
          'Aberto'
        else
         case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento < @dt_hoje then
           'Vencido'
         end     
        end
      end                                               as nm_status_documento,

      d.cd_documento_receber,
      d.cd_identificacao,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      d.dt_vencimento_original,

      case when isnull(d.vl_saldo_documento,0)=0 then
        0
      else
        cast(@dt_hoje - d.dt_vencimento_documento as int)
      end                                               as qt_dia_documento,

    --Verifica a Conversão da Moeda

    case when @cd_moeda <> isnull(d.cd_moeda,1)
    then
      (d.vl_documento_receber/@vl_moeda ) 
    else
      d.vl_documento_receber                                   
    end                                                        as 'vl_documento_receber',

    case when @cd_moeda <> isnull(d.cd_moeda,1) then
       cast(str(d.vl_saldo_documento/@vl_moeda,25,2) as decimal(25,2))
    else
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) 
    end
    -
    isnull(d.vl_abatimento_documento,0)                        as 'vl_saldo_documento',

      d.dt_cancelamento_documento,
      d.nm_cancelamento_documento,
      d.cd_modulo,      
      d.cd_banco_documento_recebe,
      cast(d.ds_documento_receber as varchar(400)) as ds_documento_receber,
      d.ic_emissao_documento,
      d.ic_envio_documento,
      d.dt_envio_banco_documento,
      d.dt_contabil_documento,
      d.cd_portador,
      d.cd_tipo_cobranca,
      d.cd_cliente,
      -- elias 25/04/2004
      vw.nm_razao_social as 'nm_razao_social_destinatario',
      vw.cd_telefone,
      vw.cd_ddd,
      vw.nm_fantasia     as 'nm_fantasia_cliente',
      d.cd_tipo_documento,
      d.cd_pedido_venda,

      d.cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                                   as cd_identificacao_nota_saida,

      d.cd_vendedor,
      d.dt_pagto_document_receber,
      d.vl_pagto_document_receber,
      d.ic_tipo_lancamento,	-- 11/06/2002
      d.cd_tipo_liquidacao,
      d.cd_plano_financeiro,
      p.sg_portador,
      p.nm_portador,
      d.cd_usuario,
      d.dt_usuario,
      d.cd_tipo_destinatario,
      d.vl_abatimento_documento,
      d.vl_reembolso_documento,
      d.dt_devolucao_documento,
      d.nm_devolucao_documento,
      d.dt_retorno_banco_doc,
      d.ic_credito_icms_documento,
      d.ic_anuencia_documento,
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      d.cd_moeda,
      d.cd_loja,
      l.nm_fantasia_loja,
      u.nm_fantasia_usuario,
      cg.nm_cliente_grupo,
      d.cd_centro_custo,
      cc.nm_centro_custo,
      (select sg_semana from semana where cd_semana = DATEPART(dw , d.dt_vencimento_documento)) as dia_semana,
      case when isnull(d.ic_emissao_documento,'N') = 'S' then 'Sim' else 'Não' end as sg_emissao_documento,
      cr.nm_cheque_receber,
      cr.dt_deposito_cheque_recebe,
      dra.nm_obs_documento              as nm_obs_documento_analise,
      fp.nm_forma_pagamento,
      d.cd_conta_banco_remessa,
      vwc.conta 


    from
      documento_receber d                           with (nolock)
      inner join vw_destinatario_rapida vw          with (nolock) on  d.cd_cliente = vw.cd_destinatario and
                                                                      d.cd_tipo_destinatario = vw.cd_tipo_destinatario
      left outer join portador p                    with (nolock) on  d.cd_portador = p.cd_portador
      left outer join Plano_Financeiro pf           with (nolock) on pf.cd_plano_financeiro = d.cd_plano_financeiro
      left outer join Loja l                        with (nolock) on l.cd_loja = d.cd_loja
      left outer join EgisAdmin.dbo.usuario u       with (nolock) on d.cd_usuario = u.cd_usuario
      left outer join Cliente cl                    with (nolock) on cl.cd_cliente = d.cd_cliente
      left outer join Cliente_grupo cg              with (nolock) on cg.cd_cliente_grupo = cl.cd_cliente_grupo
      left outer join Centro_Custo cc               with (nolock) on cc.cd_centro_custo  = d.cd_centro_custo
      left outer join Cheque_Receber_Composicao crc with (nolock) on crc.cd_documento_receber = d.cd_documento_receber
      left outer join Cheque_Receber            cr  with (nolock) on cr.cd_cheque_receber     = crc.cd_cheque_receber
      left outer join Documento_Receber_Analise dra with (nolock) on dra.cd_documento_receber = d.cd_documento_receber
      left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente            = cl.cd_cliente
      left outer join Forma_Pagamento            fp with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento

      left outer join Nota_Saida ns                 with (nolock) on ns.cd_nota_saida         = d.cd_nota_saida
      left outer join vw_conta_corrente vwc         with (nolock) on vwc.cd_conta_banco       = d.cd_conta_banco_remessa

    where 
      d.dt_vencimento_documento           between @dt_inicial and @dt_final and
      d.dt_cancelamento_documento         is null                           and
      d.dt_devolucao_documento            is null                           
      and ((IsNull(@nm_destinatario,'') = '') or ( vw.nm_fantasia like @nm_destinatario + '%' ))
      --Saldo do Documento 
      and 

--       cast(str(isnull(d.vl_saldo_documento,0),25,2) as decimal(25,2)) <> 
--         case when @ic_tipo_consulta = 'A' then 0 else 1.001 end 
     
      cast(str(isnull(d.vl_saldo_documento,0),25,2) as decimal(25,2)) =

       case when @ic_tipo_consulta = 'B' 
       then 0   
       else
         case when @ic_tipo_consulta = 'T'
              then 
                cast(str(isnull(d.vl_saldo_documento,0),25,2) as decimal(25,2))
              else
                case when @ic_tipo_consulta = 'A' then
                  case when cast(str(isnull(d.vl_saldo_documento,0),25,2) as decimal(25,2))>0 then
                     cast(str(isnull(d.vl_saldo_documento,0),25,2) as decimal(25,2))
                  else
                    -1.0001 
                  end
                end           
              end
       end
       --Pesquisa pelo Pedido de Venda
      and isnull(d.cd_pedido_venda,0) = case when @cd_pedido_venda = 0 then isnull(d.cd_pedido_venda,0) else @cd_pedido_venda end

    order by
      d.dt_vencimento_documento desc

  end

  else
  -- SE A IDENTIFICAÇÃO ESTIVER PREENCHIDA, NECESSÁRIO VERIFICAR A FORMA
  -- DE PESQUISA, SE PARCIAL OU TOTAL
  -- 1º PARCIAL

  if ((select isnull(ic_consulta_parcial_doc,'N')
       from Parametro_Financeiro with (nolock) 
       where cd_empresa = dbo.fn_empresa()) = 'S')
  begin

--    print '2'

    select 
      '2'                          as A,
      case when isnull(d.vl_saldo_documento,0)=0 then
        'Baixado'
      else
        case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento >= @dt_hoje
        then
          'Aberto'
        else
         case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento < @dt_hoje then
           'Vencido'
         end     
        end
      end                                               as nm_status_documento,
      d.cd_documento_receber,
      d.cd_identificacao,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      d.dt_vencimento_original,

      case when isnull(d.vl_saldo_documento,0)=0 then
        0
      else
        cast(@dt_hoje - d.dt_vencimento_documento as int)
      end                                               as qt_dia_documento,

      --Verifica a Conversão da Moeda

      case when @cd_moeda <> isnull(d.cd_moeda,1)
      then
        (d.vl_documento_receber/@vl_moeda ) 
      else
        d.vl_documento_receber                                   
      end                                                        as 'vl_documento_receber',

      case when @cd_moeda <> isnull(d.cd_moeda,1) then
        cast(str(d.vl_saldo_documento/@vl_moeda,25,2) as decimal(25,2))
      else
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) 
      end 

      -
 
      isnull(d.vl_abatimento_documento,0)                         as 'vl_saldo_documento',

      d.dt_cancelamento_documento,
      d.nm_cancelamento_documento,
      d.cd_modulo,      
      d.cd_banco_documento_recebe,
      cast(d.ds_documento_receber as varchar(400)) as ds_documento_receber,
      d.ic_emissao_documento,
      d.ic_envio_documento,
      d.dt_envio_banco_documento,
      d.dt_contabil_documento,
      d.cd_portador,
      d.cd_tipo_cobranca,
      d.cd_cliente,
      -- ELIAS 25/04/2004
      vw.nm_razao_social as 'nm_razao_social_destinatario',
      vw.cd_telefone,
      vw.cd_ddd,
      vw.nm_fantasia     as 'nm_fantasia_cliente',
      d.cd_tipo_documento,
      d.cd_pedido_venda,
      d.cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                                   as cd_identificacao_nota_saida,

      d.cd_vendedor,
      d.dt_pagto_document_receber,
      d.vl_pagto_document_receber,
      d.ic_tipo_lancamento,	-- 11/06/2002
      d.cd_tipo_liquidacao,
      d.cd_plano_financeiro,
      p.sg_portador,
      p.nm_portador,
      d.cd_usuario,
      d.dt_usuario,
      d.cd_tipo_destinatario,
      d.vl_abatimento_documento,
      d.vl_reembolso_documento,
      d.dt_devolucao_documento,
      d.nm_devolucao_documento,
      d.dt_retorno_banco_doc,
      d.ic_credito_icms_documento,
      d.ic_anuencia_documento,
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      d.cd_moeda,
      d.cd_loja,
      l.nm_fantasia_loja,      
      u.nm_fantasia_usuario,  
      cg.nm_cliente_grupo,
      d.cd_centro_custo,
      cc.nm_centro_custo,
      (select sg_semana from semana with (nolock) 
       where cd_semana = DATEPART(dw , d.dt_vencimento_documento))                   as dia_semana,
      case when isnull(d.ic_emissao_documento,'N') = 'S' then 'Sim' else 'Não' end   as sg_emissao_documento,
      cr.nm_cheque_receber,
      cr.dt_deposito_cheque_recebe,
      dra.nm_obs_documento              as nm_obs_documento_analise,
      fp.nm_forma_pagamento,
      d.cd_conta_banco_remessa,
      vwc.conta 



    from
      Documento_receber d                           with (nolock)
      inner join vw_destinatario_rapida vw          with (nolock) on d.cd_cliente             = vw.cd_destinatario and
                                                                     d.cd_tipo_destinatario   = vw.cd_tipo_destinatario
      left outer join Portador p                    with (nolock) on d.cd_portador            = p.cd_portador
      left outer join Plano_Financeiro pf           with (nolock) on pf.cd_plano_financeiro   = d.cd_plano_financeiro
      left outer join Loja l                        with (nolock) on l.cd_loja                = d.cd_loja
      left outer join EgisAdmin.dbo.usuario u       with (nolock) on d.cd_usuario             = u.cd_usuario
      left outer join Cliente cl                    with (nolock) on cl.cd_cliente            = d.cd_cliente
      left outer join Cliente_grupo cg              with (nolock) on cg.cd_cliente_grupo      = cl.cd_cliente_grupo
      left outer join Centro_Custo cc               with (nolock) on cc.cd_centro_custo       = d.cd_centro_custo
      left outer join Cheque_Receber_Composicao crc with (nolock) on crc.cd_documento_receber = d.cd_documento_receber
      left outer join Cheque_Receber            cr  with (nolock) on cr.cd_cheque_receber     = crc.cd_cheque_receber
      left outer join Documento_Receber_Analise dra with (nolock) on dra.cd_documento_receber = d.cd_documento_receber
      left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente            = cl.cd_cliente
      left outer join Forma_Pagamento            fp with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento

      left outer join Nota_Saida ns                 with (nolock) on ns.cd_nota_saida         = d.cd_nota_saida
      left outer join vw_conta_corrente vwc         with (nolock) on vwc.cd_conta_banco       = d.cd_conta_banco_remessa

--select * from documento_receber_pagamento
      
    where 
      (d.cd_identificacao like isnull(@cd_identificacao,'&') + '%' or @cd_pedido_venda>0) and
      ((IsNull(@nm_destinatario,'') = '') or ( vw.nm_fantasia like @nm_destinatario + '%' ))
      --Pesquisa pelo Pedido de Venda
      and isnull(d.cd_pedido_venda,0) = case when @cd_pedido_venda = 0 then isnull(d.cd_pedido_venda,0) else @cd_pedido_venda end

    order by
      d.dt_vencimento_documento desc

  end

  else
    -- 2º TOTAL
    select 
      '3' as A,
      case when isnull(d.vl_saldo_documento,0)=0 then
        'Baixado'
      else
        case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento >= @dt_hoje
        then
          'Aberto'
        else
         case when isnull(d.vl_saldo_documento,0)>0 and d.dt_vencimento_documento < @dt_hoje then
           'Vencido'
         end     
        end
      end  
                                             as nm_status_documento,
      d.cd_documento_receber,
      d.cd_identificacao,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      d.dt_vencimento_original,

      case when isnull(d.vl_saldo_documento,0)=0 then
        0
      else
        cast(@dt_hoje - d.dt_vencimento_documento as int)
      end                                               as qt_dia_documento,

      --Verifica a Conversão da Moeda

      case when @cd_moeda <> isnull(d.cd_moeda,1)
      then
        (d.vl_documento_receber/@vl_moeda ) 
      else
        d.vl_documento_receber                                   
      end                                                        as 'vl_documento_receber',

      case when @cd_moeda <> isnull(d.cd_moeda,1) then
         cast(str(d.vl_saldo_documento/@vl_moeda,25,2) as decimal(25,2))
      else
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) 
      end 
      -
      isnull(d.vl_abatimento_documento,0)                        as 'vl_saldo_documento',

      d.dt_cancelamento_documento,
      d.nm_cancelamento_documento,
      d.cd_modulo,      
      d.cd_banco_documento_recebe,
      cast(d.ds_documento_receber as varchar(400)) as ds_documento_receber,
      d.ic_emissao_documento,
      d.ic_envio_documento,
      d.dt_envio_banco_documento,
      d.dt_contabil_documento,
      d.cd_portador,
      d.cd_tipo_cobranca,
      d.cd_cliente,
      -- ELIAS 25/04/2004
      vw.nm_razao_social as 'nm_razao_social_destinatario',
      vw.cd_telefone,
      vw.cd_ddd,
      vw.nm_fantasia as 'nm_fantasia_cliente',
      d.cd_tipo_documento,
      d.cd_pedido_venda,
      d.cd_nota_saida,
      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                                   as cd_identificacao_nota_saida,
      d.cd_vendedor,
      d.dt_pagto_document_receber,
      d.vl_pagto_document_receber,
      d.ic_tipo_lancamento,	-- 11/06/2002
      d.cd_tipo_liquidacao,
      d.cd_plano_financeiro,
      p.sg_portador,
      p.nm_portador,
      d.cd_usuario,
      d.dt_usuario,
      d.cd_tipo_destinatario,
      d.vl_abatimento_documento,
      d.vl_reembolso_documento,
      d.dt_devolucao_documento,
      d.nm_devolucao_documento,
      d.dt_retorno_banco_doc,
      d.ic_credito_icms_documento,
      d.ic_anuencia_documento,
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      d.cd_moeda,
      d.cd_loja,
      l.nm_fantasia_loja,
      u.nm_fantasia_usuario,
      cg.nm_cliente_grupo,
      d.cd_centro_custo,
      cc.nm_centro_custo,
      (select sg_semana from semana where cd_semana = DATEPART(dw , d.dt_vencimento_documento)) as dia_semana,
      case when isnull(d.ic_emissao_documento,'N') = 'S' then 'Sim' else 'Não' end as sg_emissao_documento,
      cr.nm_cheque_receber,
      cr.dt_deposito_cheque_recebe,
      dra.nm_obs_documento              as nm_obs_documento_analise,
      fp.nm_forma_pagamento,
      d.cd_conta_banco_remessa,
      vwc.conta 


    from
      Documento_receber d with (nolock)
      -- ELIAS 25/05/2004
      inner join vw_destinatario_rapida vw          with (nolock) on d.cd_cliente = vw.cd_destinatario and
                                                                     d.cd_tipo_destinatario = vw.cd_tipo_destinatario
      left outer join Portador p                    with (nolock) on d.cd_portador = p.cd_portador
      left outer join Plano_Financeiro pf           with (nolock) on pf.cd_plano_financeiro = d.cd_plano_financeiro
      left outer join Loja l                        with (nolock) on l.cd_loja = d.cd_loja  
      left outer join EgisAdmin.dbo.usuario u       with (nolock) on d.cd_usuario = u.cd_usuario
      left outer join Cliente cl                    with (nolock) on cl.cd_cliente = d.cd_cliente
      left outer join Cliente_grupo cg              with (nolock) on cg.cd_cliente_grupo = cl.cd_cliente_grupo
      left outer join Centro_Custo cc               with (nolock) on cc.cd_centro_custo  = d.cd_centro_custo
      left outer join Cheque_Receber_Composicao crc with (nolock) on crc.cd_documento_receber = d.cd_documento_receber
      left outer join Cheque_Receber            cr  with (nolock) on cr.cd_cheque_receber     = crc.cd_cheque_receber
      left outer join Documento_Receber_Analise dra with (nolock) on dra.cd_documento_receber = d.cd_documento_receber
      left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente            = cl.cd_cliente
      left outer join Forma_Pagamento            fp with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento

      left outer join Nota_Saida ns                 with (nolock) on ns.cd_nota_saida         = d.cd_nota_saida
      left outer join vw_conta_corrente vwc         with (nolock) on vwc.cd_conta_banco       = d.cd_conta_banco_remessa

    where 
      -- ELIAS 08/10/2004
      d.cd_identificacao = isnull(@cd_identificacao,'&') and
      ((IsNull(@nm_destinatario,'') = '') or ( vw.nm_fantasia like @nm_destinatario + '%' ))
      --(replace(d.cd_identificacao,'-','') = replace(isnull(@cd_identificacao,'&'),'-','')) 
      --Pesquisa pelo Pedido de Venda
      and isnull(d.cd_pedido_venda,0) = case when @cd_pedido_venda = 0 then isnull(d.cd_pedido_venda,0) else @cd_pedido_venda end

    order by
      d.dt_vencimento_documento desc


  goto TrataErro


  end


--Confima Transação Caso Não Tenha Ocorrido Nenhum Erro
TrataErro:
  if @@Error = 0
    commit transaction
  else
    rollback transaction


