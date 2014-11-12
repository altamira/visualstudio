
-------------------------------------------------------------------------------
--sp_helptext pr_processa_pedido_venda_nextel
-------------------------------------------------------------------------------
--pr_processa_pedido_venda_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Douglas Di Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Pedido de Venda Nextel
--                   para a Carteira de Pedido de Venda do Egis
--
--Data             : 20.09.2008
--Alteração        : 23.09.2008 - Flag para Controle de Geração do Pedido 
-- 
-- 24.09.2008 - Desenvolvimento da Rotina de pendências - Carlos Fernandes
-- 25.09.2008 - Complemento da Rotina - Carlos Fernandes
-- 10.10.2008 - Ajuste do flag de fechamento    - Carlos Fernandes
-- 19.11.2008 - Ajustes e Geração do Transporte - Carlos Fernandes
-- 25.11.2008 - Ajuste do Financeiro - Carlos Fernandes
-- 02.12.2008 - Ajuste do Número do Pedido de Compra do Cliente - Carlos Fernandes
-- 17.12.2008 - Novo atributo na tabela de item de pedido - Carlos Fernandes
-- 06.01.2008 - Ajustes conforme Simulação - Carlos Fernandes
-- 12.01.2008 - Geração da Nota Fiscal Automaticamente dos pedidos totalmente liberados - Carlos Fernandes
-- 19.01.2009 - Ajuste do Pedido Cancelado - Carlos Fernandes
-- 02.02.2009 - Não Gera Produto Inativo - Carlos Fernandes
-- 05.03.2009 - ajustes - Carlos Fernandes
-- 23.02.2009 - Quantidade / Tabela de Unidade de Venda do Pedido - Carlos Fernandes
-- 31.03.2009 - Liberação da Validaçao do Estoque - Carlos Fernandes
-- 02.04.2009 - Unidade de Medida - Carlos Fernandes
-- 06.04.2009 - Transportadora - Carlos Fernandes
-- 14.04.2009 - Verificação da Pendência - água funda - Carlos Fernandes
-- 24.04.2009 - Trava da rotina para Não permitir duplicidade - Carlos Fernandes
-- 05.05.2009 - Condição de Pagamento - Carlos Fernandes
-- 19.11.2009 - Complemento dos novos campos do Pedido de Venda - Carlos Fernandes
-- 26.03.2010 - Novos Campos do Pedido - Carlos Fernandes
-- 19.09.2010 - Novos Campos do Pedido - Carlos Fernandes
-- 22.12.2010 - Ajustes - Carlos Fernandes
-------------------------------------------------------------------------------------------------
create procedure pr_processa_pedido_venda_nextel
@cd_pedido_venda int      = 0,
@cd_usuario      int      = 0,
@cd_cliente      int      = 0,
@cd_vendedor     int      = 0,
@dt_geracao      datetime = null

as

--select @cd_pedido_venda

------------------------------------------------------------------------------
-- Criação de um Índice
------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_Pedido_Venda_Pedido_Compra')
------------------------------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_Pedido_Venda_Pedido_Compra ON Pedido_Venda
	(
	cd_pdcompra_pedido_venda
	) ON [PRIMARY]

--PEDIDO_VENDA
------------------------------------------------------------------------------

declare @cd_pdcompra_pedido_venda     varchar(40)
declare @cd_pedido                    int
--declare @cd_cliente               int
--declare @cd_vendedor              int
declare @nm_obs_pendencia             varchar(60)
declare @dt_hoje                      datetime
declare @nm_fantasia_cliente          varchar(15) 
declare @cd_veiculo                   int
declare @cd_motorista                 int
declare @cd_criterio_visita           int
declare @cd_tipo_pedido               int
declare @ic_gera_transporte           char(1) 
declare @vl_limite_credito            float 
declare @ic_tipo_pedido_compra        char(1)
declare @cd_condicao_pagamento        int 
declare @cd_condicao_pagamento_pedido int 
declare @ic_gera_nota_saida           int 
declare @ic_geracao_nota_automatica   char(1)
declare @cd_operacao_fiscal           int
declare @cd_transportadora            int
declare @ic_libera_credito            char(1)
declare @ic_credito_forma_pagamento   char(1) --Liberação automática de Crédito
declare @dt_credito_pedido_venda      datetime
declare @cd_usuario_credito           int

--Data da Liberação de Crédito quando for automática
set @dt_credito_pedido_venda = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--select * from cliente_informacao_credito

------------------------------------------------------------------------------
--Verifica a Tabela de Configuração de Entrada do Pedido
------------------------------------------------------------------------------

  select
    @cd_tipo_pedido             = isnull(cd_tipo_pedido,1),
    @ic_gera_transporte         = isnull(ic_gera_transporte,'N'),  --geração dados do transporte do pedido 
    @vl_limite_credito          = isnull(vl_limite_credito,0),
    @ic_tipo_pedido_compra      = isnull(ic_tipo_pedido_compra,'R'),
    @ic_geracao_nota_automatica = isnull(ic_geracao_nota_automatica,'N'),
    @cd_operacao_fiscal         = isnull(cd_operacao_fiscal,0),
    @cd_transportadora          = isnull(cd_transportadora,0),
    @ic_libera_credito          = isnull(ic_libera_credito,'N'),
    @cd_usuario_credito         = isnull(cd_usuario_credito,@cd_usuario)
  from
    Config_Pedido_EDI with (nolock) 
  where
    cd_empresa = dbo.fn_empresa() 


--select * from pedido_venda_nextel
------------------------------------------------------------------------------

if @ic_tipo_pedido_compra = 'R'
  set @cd_pdcompra_pedido_venda = cast(@cd_pedido_venda as varchar(40))
else
  set @cd_pdcompra_pedido_venda = cast( rtrim(ltrim(cast(@cd_pedido_venda as varchar)))+'-'+
                                        rtrim(ltrim(cast(@cd_vendedor     as varchar)))+'-'+
                                        rtrim(ltrim(cast(@cd_cliente      as varchar)))  as varchar(40) )


--select @cd_pdcompra_pedido_venda

set @cd_pedido                    = @cd_pedido_venda
set @cd_veiculo                   = 0
set @cd_motorista                 = 0
set @cd_criterio_visita           = 0 
set @nm_obs_pendencia             = ''
set @dt_hoje                      = getdate()
set @nm_fantasia_cliente          = ''
set @cd_condicao_pagamento        = 0
set @cd_condicao_pagamento_pedido = 0
set @ic_gera_nota_saida           = 0 --Gera Nota Fiscal de Saída
                                      --Caso não tenha pendência

if @dt_geracao is null
begin
   --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)
   set @dt_geracao = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

--select @dt_geracao

--Verifica se o Pedido de Compra do Cliente já se Transformou em Pedido de Venda

if exists (select top 1 cd_pdcompra_pedido_venda 
           from
             Pedido_Venda with (nolock) 
           where
             cd_pdcompra_pedido_venda = @cd_pdcompra_pedido_venda and
             dt_cancelamento_pedido is null )
begin

  print 'já Cadastrado : ' + @cd_pdcompra_pedido_venda

  --Atualiza a Tabela de Status da Pendência--------------------------------------------------------------
  --pedido_venda_nextel

  update
    pedido_venda_nextel
  set
    cd_status_pedido_nextel = 1   --Pedido já Existe
  where
    cd_pedido_venda = @cd_pedido_venda

  --Não Gera o Pedido de Venda
  set @cd_pedido = 0

end

--Geração do Pedido de Venda--------------------------------------------------------------

--select @cd_pedido

if @cd_pedido > 0

begin

  declare @Tabela		     varchar(80)
  --declare @cd_pedido_venda     int

  -- Nome da Tabela usada na geração e liberação de códigos

  set @Tabela          = cast(DB_NAME()+'.dbo.Pedido_Venda' as varchar(80))
  set @cd_pedido_venda = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_pedido_venda output
	
  while exists(Select top 1 'x' from pedido_venda where cd_pedido_venda = @cd_pedido_venda)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_pedido_venda output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'
 
------------------------------------------------------------------------------
  --Tabela de parâmetros de geração de pedido de venda automática 
------------------------------------------------------------------------------
  --select * from config_pedido_edi
  
  --select @ic_gera_transporte

  --select * from pedido_venda_nextel
  --delete from pedido_venda_nextel

  --pedido_venda

------------------------------------------------------------------------------
--Montagem da Tabela Temporária do Pedido de Venda
------------------------------------------------------------------------------

  select
    distinct
    @cd_pedido_venda                   as cd_pedido_venda,
    pn.dt_pedido_venda_nextel          as dt_pedido_venda,
    pn.cd_vendedor                     as cd_vendedor_pedido,
    pn.cd_vendedor_interno             as cd_vendedor_interno,
    'N'                                as ic_emitido_pedido_venda,
   cast(null as varchar)               as ds_pedido_venda,
   cast(null as varchar)               as ds_pedido_venda_fatura,
   cast(null as varchar)               as ds_cancelamento_pedido,

   --rotina de geração de crédito e controle de pendências

   null                                as cd_usuario_credito_pedido,
   null                                as dt_credito_pedido_venda,
   'N'                                 as ic_smo_pedido_venda,
   cast(0.00 as float)                 as vl_total_pedido_venda,
   cast(0.00 as float)                 as qt_liquido_pedido_venda,
   cast(0.00 as float)                 as qt_bruto_pedido_venda,
   null                                as dt_conferido_pedido_venda,
   'N'                                     as ic_pcp_pedido_venda,
   'N'                                     as ic_lista_pcp_pedido_venda,
   'N'                                     as ic_processo_pedido_venda,
   'N'                                     as ic_lista_processo_pedido,
   'N'                                     as ic_imed_pedido_venda,
   'N'                                     as ic_lista_imed_pedido,
   null                                    as nm_alteracao_pedido_venda,
   'N'                                     as ic_consignacao_pedido,
   null                                    as dt_cambio_pedido_venda,
   null                                    as cd_cliente_entrega,
   'N'                                     as ic_op_triang_pedido_venda,
   'N'                                     as ic_nf_op_triang_pedido,
   null                                    as nm_contato_op_triang,

   --Montagem do Número do Pedido de Compra conforme o Parâmetro

   case when @ic_tipo_pedido_compra = 'R'
   then cast(pn.cd_pedido_venda as varchar(40))
   else cast( rtrim(ltrim(cast(pn.cd_pedido_venda as varchar)))+'-'+
              rtrim(ltrim(cast(pn.cd_vendedor     as varchar)))+'-'+
              rtrim(ltrim(cast(pn.cd_cliente      as varchar)))  as varchar(40) )
   end                                     as cd_pdcompra_pedido_venda,
   --cast(pn.cd_pedido_venda as varchar(40)) as cd_pdcompra_pedido_venda,
   null                                    as cd_processo_exportacao,
   pn.cd_cliente,
   null                                 as cd_tipo_frete,
   null                                 as cd_tipo_restricao_pedido,
   --Parâmetro
   isnull(pn.cd_destinacao_produto,3)   as cd_destinacao_produto,
   isnull(@cd_tipo_pedido,1)            as cd_tipo_pedido,
   @cd_transportadora                   as cd_transportadora,
   pn.cd_vendedor,
   1                                    as cd_tipo_endereco,
   1                                    as cd_moeda,
   null                                 as cd_contato,
   @cd_usuario                          as cd_usuario,
   getdate()                            as dt_usuario,
   null                                 as dt_cancelamento_pedido,
   --Fazer a busca da condição de pagagamento conforme o dia de pagamento
   pn.cd_condicao_pagamento             as cd_condicao_pagamento,
   1                                    as cd_status_pedido,
   1                                    as cd_tipo_entrega_produto,
   cast(pn.cd_pedido_venda  as varchar) as nm_referencia_consulta,
   null                                 as vl_custo_financeiro,
   null                                 as ic_custo_financeiro,
   null                                 as vl_tx_mensal_cust_fin,
   1                                    as cd_tipo_pagamento_frete,
   null                                 as nm_assina_pedido,
   null                                 as ic_fax_pedido,
   null                                 as ic_mail_pedido,
   cast(0.00 as float)                  as vl_total_pedido_ipi,
   cast(0.00 as float)                  as vl_total_ipi,
   cast(null as varchar)                as ds_observacao_pedido,
   null                                 as cd_usuario_atendente,
   'S'                                  as ic_fechado_pedido,
   null                                 as ic_vendedor_interno,
   null                                 as cd_representante,
   null                                 as ic_transf_matriz,
   null                                 as ic_digitacao,
   'S'                                  as ic_pedido_venda,
   null                                 as hr_inicial_pedido,
   'N'                                  as ic_outro_cliente,
   'S'                                  as ic_fechamento_total,
   'N'                                  as ic_operacao_triangular,
   'N'                                  as ic_fatsmo_pedido,
   cast('' as varchar)                  as ds_ativacao_pedido,
   null                                 as dt_ativacao_pedido,
   cast('' as varchar)                  as ds_obs_fat_pedido,
   'N'                                  as ic_obs_corpo_nf,
   getdate()                            as dt_fechamento_pedido,
   null                                 as cd_cliente_faturar,
   1                                    as cd_tipo_local_entrega,
   null                                 as ic_etiq_emb_pedido_venda,
   null                                 as cd_consulta,
   null                                 as dt_alteracao_pedido_venda,
   null                                 as ic_dt_especifica_ped_vend,
   null                                 as ic_dt_especifica_consulta,
   null                                 as ic_fat_pedido_venda,
   null                                 as ic_fat_total_pedido_venda,
   null                                 as qt_volume_pedido_venda,
   null                                 as qt_fatpbru_pedido_venda,
   null                                 as ic_permite_agrupar_pedido,
   null                                 as qt_fatpliq_pedido_venda,
   null                                 as vl_indice_pedido_venda,
   null                                 as vl_sedex_pedido_venda,
   null                                 as pc_desconto_pedido_venda,
   --Buscar da Tabela de Preço
   0.20                                 as pc_comissao_pedido_venda,
   null                                 as cd_plano_financeiro,
   cast('' as varchar)                  as ds_multa_pedido_venda,
   null                                 as vl_freq_multa_ped_venda,
   null                                 as vl_base_multa_ped_venda,
   null                                 as pc_limite_multa_ped_venda,
   null                                 as pc_multa_pedido_venda,
   null                                 as cd_fase_produto_contrato,
   null                                 as nm_obs_restricao_pedido,
   null                                 as cd_usu_restricao_pedido,
   null                                 as dt_lib_restricao_pedido,
   null                                 as nm_contato_op_triang_ped,
   null                                 as ic_amostra_pedido_venda,
   null                                 as ic_alteracao_pedido_venda,
   null                                 as ic_calcula_sedex,
   cast(0.00 as float )                 as vl_frete_pedido_venda,
   'S'                                  as ic_calcula_peso,
   null                                 as ic_subs_trib_pedido_venda,
   null                                 as ic_credito_icms_pedido,
   null                                 as cd_usu_lib_fat_min_pedido,
   null                                 as dt_lib_fat_min_pedido,
   null                                 as cd_identificacao_empresa,
   null                                 as pc_comissao_especifico,
   null                                 as dt_ativacao_pedido_venda,
   null                                 as cd_exportador,
   null                                 as ic_atualizar_valor_cambio_fat,
   null                                 as cd_tipo_documento,
   null                                 as cd_loja,
   null                                 as cd_usuario_alteracao,
   null                                 as ic_garantia_pedido_venda,
   null                                 as cd_aplicacao_produto,
   null                                 as ic_comissao_pedido_venda,
   null                                 as cd_motivo_liberacao,
   null                                 as ic_entrega_futura,
   null                                 as modalidade,
   null                                 as modalidade1,
   null                                 as cd_modalidade,
   null                                 as cd_pedido_venda_origem,
   getdate()                            as dt_entrada_pedido,
   null                                 as dt_cond_pagto_pedido,
   null                                 as cd_usuario_cond_pagto_ped,
   null                                 as vl_credito_liberacao,
   null                                 as vl_credito_liberado,
   null                                 as cd_centro_custo,
   null                                 as ic_bloqueio_licenca,
   null                                 as cd_licenca_bloqueada,
   null                                 as nm_bloqueio_licenca,
   null                                 as dt_bloqueio_licenca,
   null                                 as cd_usuario_bloqueio_licenca,
   null                                 as vl_mp_aplicacada_pedido,
   null                                 as vl_mo_aplicada_pedido,
   null                                 as cd_usuario_impressao,
   null                                 as cd_cliente_origem,
   null                                 as cd_situacao_pedido,
   null                                 as qt_total_item_pedido,
   null                                 as ic_bonificacao_pedido_venda,
   null                                 as pc_promocional_pedido,
   null                                 as cd_tipo_reajuste,
   null                                 as vl_icms_st

into
  #pedido_venda

from
  pedido_venda_nextel    pn with (nolock) 
  left outer join cliente c with (nolock) on c.cd_cliente = pn.cd_cliente

where
  pn.cd_pedido_venda = @cd_pedido             and
  isnull(pn.ic_gerado_pedido_venda,'N') = 'N' and
  pn.cd_cliente      = @cd_cliente            and
  pn.cd_vendedor     = @cd_vendedor           

  --@cd_pdcompra_pedido_venda not in ( select cd_pdcompra_pedido_venda from pedido_venda )
  --and pn.cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda ) 

--select @cd_pedido_venda,@cd_pedido,@cd_cliente,@cd_vendedor,@cd_pdcompra_pedido_venda
--select * from #pedido_venda


select
  @nm_fantasia_cliente        = c.nm_fantasia_cliente,
  @cd_criterio_visita         = isnull(c.cd_criterio_visita,0),
  @cd_condicao_pagamento      = isnull(c.cd_condicao_pagamento,0),
  @ic_credito_forma_pagamento = isnull(fp.ic_credito_forma_pagamento,'N')
from
  Cliente c                                     with (nolock) 
  left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente         = c.cd_cliente
  left outer join Forma_Pagamento            fp with (nolock) on fp.cd_forma_pagamento = ci.cd_forma_pagamento

where
  c.cd_cliente = @cd_cliente

--Geração das Pendências do Pedido de Venda

if @cd_cliente = 0 or @cd_vendedor = 0 or @cd_condicao_pagamento_pedido=0
begin

  select
    @cd_cliente                   = isnull(cd_cliente,0),
    @cd_vendedor                  = isnull(cd_vendedor,0),
    @cd_condicao_pagamento_pedido = isnull(cd_condicao_pagamento,0)
  from
    #pedido_venda

end

--10 : Cliente

if @cd_cliente = 0
begin

  set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

  set @nm_obs_pendencia = cast('PV: '+rtrim(ltrim(cast(@cd_pedido_venda as varchar))) + ' Cliente não Cadastrado ' as varchar(60))

  exec pr_gera_pendencia_pedido_venda
    @cd_pedido_venda,
    10,              --Cliente
    @cd_usuario,
    @nm_obs_pendencia,
    0    

end

--11 : Vendedor

if @cd_vendedor = 0
begin

  set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

  set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Vendedor não Cadastrado ' as varchar(60))

  exec pr_gera_pendencia_pedido_venda
    @cd_pedido_venda,
    11,              --Vendedor
    @cd_usuario,
    @nm_obs_pendencia,
    0    

end

--Condição de Pagamento

--select * from tipo_pendencia_financeira

-- if @cd_condicao_pagamento <> @cd_condicao_pagamento_pedido --Cliente <> Pedido de VEnda
-- begin
--   set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

--   set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Cond.Pagamento Cliente <> Pedido ' as varchar(60))
-- 
--   exec pr_gera_pendencia_pedido_venda
--     @cd_pedido_venda,
--     15,              --Cond. Pagamento
--     @cd_usuario,
--     @nm_obs_pendencia,
--     0    

--end

--Tabela de Preço

--Produto Inativo

--Produto não Cadastrado


------------------------------------------------------------------------------
--Geração da Tabela Temporária de Transporte
------------------------------------------------------------------------------

if @ic_gera_transporte='S' 
begin

--   select
--     @cd_criterio_visita = isnull(cd_criterio_visita,0)
--   from
--     cliente c with (nolock) 
--   where
--     c.cd_cliente = @cd_cliente

  --select * from veiculo_area_regiao

  --Veículo

  select 
    top 1
    @cd_veiculo = isnull(cd_veiculo,0)
  from
    Veiculo_Area_Regiao va     with (nolock) 
    inner join area_entrega ae with (nolock) on ae.cd_area_entrega = va.cd_area_entrega
  where
    va.cd_vendedor        = @cd_vendedor  and
    ae.cd_criterio_visita = @cd_criterio_visita 

  --Motorista

  --select * from veiculo
  --select * from motorista

  select
    top 1
    @cd_motorista = isnull(cd_motorista,0)
  from
    Motorista with (nolock) 
  where
    cd_veiculo = @cd_veiculo

  --select * from pedido_venda_transporte

  select
    @cd_pedido_venda as cd_pedido_venda,
    @cd_veiculo      as cd_veiculo,
    @cd_motorista    as cd_motorista,
    'Gerado Nextel'  as nm_obs_pedido_transporte,
    @cd_usuario      as cd_usuario,
    getdate()        as dt_usuario
  into  
    #pedido_venda_transporte  

end

--select * from #pedido_venda

--select * from pedido_venda_nextel

--select * from pedido_venda_nextel

-------------------------------------------------------------------------------
--Itens do Pedido de Venda
-------------------------------------------------------------------------------

select
 @cd_pedido_venda                            as cd_pedido_venda,
 pn.cd_item_pedido_venda,
 pn.dt_pedido_venda_nextel                   as dt_item_pedido_venda,
 isnull(pn.qt_item_pedido_venda_nextel,0.00) as qt_item_pedido_venda,
 isnull(pn.qt_item_pedido_venda_nextel,0.00) as qt_saldo_pedido_venda,
 isnull(pn.dt_entrega_pedido,getdate())      as dt_entrega_vendas_pedido,
 isnull(pn.dt_entrega_pedido,getdate())      as dt_entrega_fabrica_pedido,
 cast('' as varchar)                         as ds_produto_pedido_venda,

 case when isnull(pn.vl_item_total_pedido,0.00)<>0
 then
   isnull(pn.vl_item_total_pedido,0.00)
 else
  isnull(( select
    isnull(tpp.vl_tabela_produto,0)
  from
    Tabela_Preco_Produto tpp
  where
    tpp.cd_tabela_preco = 1 and
    tpp.cd_produto = p.cd_produto ),0)

 end                                         as vl_unitario_item_pedido,
 --SELECT * from tabela_preco_produto 

 --buscar o valor da tabela 
 case when isnull(pn.vl_item_total_pedido,0.00)<>0 then
    isnull(pn.vl_item_total_pedido,0.00)     
 else

  isnull(( select
    isnull(tpp.vl_tabela_produto,0)
  from
    Tabela_Preco_Produto tpp
  where
    tpp.cd_tabela_preco = 1 and
    tpp.cd_produto = p.cd_produto ),0)
 end                                         as vl_lista_item_pedido,


 null                                        as pc_desconto_item_pedido,
 null                                        as dt_cancelamento_item,
 null                                        as dt_estoque_item_pedido,
 cast(@cd_pedido as varchar)                 as cd_pdcompra_item_pedido,
 null                                        as dt_reprog_item_pedido,
 isnull(pn.qt_item_pedido_venda_nextel,0.00)*
 isnull(p.qt_peso_liquido,0)                 as qt_liquido_item_pedido,
 isnull(pn.qt_item_pedido_venda_nextel,0.00)*
 isnull(p.qt_peso_bruto,0)                   as qt_bruto_item_pedido,
 null                                        as ic_fatura_item_pedido,
 'S'                                         as ic_reserva_item_pedido,
 null                                        as ic_tipo_montagem_item,
 null                                        as ic_montagem_g_item_pedido,
 null                                        as ic_subs_tributaria_item,
 null                                        as cd_posicao_item_pedido,
 null                                        as cd_os_tipo_pedido_venda,
 null                                        as ic_desconto_item_pedido,
 null                                        as dt_desconto_item_pedido,
 null                                        as vl_indice_item_pedido,
 p.cd_grupo_produto,
 pn .cd_produto,
 cp.cd_grupo_categoria                       as cd_grupo_categoria,
 p.cd_categoria_produto,
 null                                        as cd_pedido_rep_pedido,
 null                                        as cd_item_pedidorep_pedido,
 null                                        as cd_ocorrencia,
 null                                        as cd_consulta,
 @cd_usuario                                 as cd_usuario,
 getdate()                                   as dt_usuario,
 null                                  as nm_mot_canc_item_pedido,
 null                                  as nm_obs_restricao_pedido,
 null                                  as cd_item_consulta,
 null                                  as ic_etiqueta_emb_pedido,
 isnull(cf.pc_ipi_classificacao,0)     as pc_ipi_item,
 isnull(pf.pc_aliquota_icms_produto,0) as pc_icms_item,
 null                                  as pc_reducao_base_item,
 null                                  as dt_necessidade_cliente,
 null                                  as qt_dia_entrega_cliente,
 null                                  as dt_entrega_cliente,
 'N'                                   as ic_smo_item_pedido_venda,
 null                                  as cd_om,
 null                                  as ic_controle_pcp_pedido,
 null                                  as nm_mat_canc_item_pedido,
 null                                  as cd_servico,
 'N'                                   as ic_produto_especial,
 null                                  as cd_produto_concorrente,
 null                                  as ic_orcamento_pedido_venda,
 cast('' as varchar)                   as ds_produto_pedido,
 p.nm_produto                          as nm_produto_pedido,
 p.cd_serie_produto,
 isnull(cf.pc_ipi_classificacao,0)     as pc_ipi,
 isnull(pf.pc_aliquota_icms_produto,0) as pc_icms,
 null                                  as qt_dia_entrega_pedido,
 'S'                                   as ic_sel_fechamento,
 null                                  as dt_ativacao_item,
 null                                  as nm_mot_ativ_item_pedido,
 p.nm_fantasia_produto,
 null                                  as ic_etiqueta_emb_ped_venda,
 getdate()                             as dt_fechamento_pedido,
 cast('' as varchar)                   as ds_progfat_pedido_venda,
 'P'                                   as ic_pedido_venda_item,
 null                                  as ic_ordsep_pedido_venda,
 null                                  as ic_progfat_item_pedido,
 null                                  as qt_progfat_item_pedido,
 null                                  as cd_referencia_produto,
 null                                  as ic_libpcp_item_pedido,
 cast('' as varchar)                   as ds_observacao_fabrica,
 null                                  as nm_observacao_fabrica1,
 null                                  as nm_observacao_fabrica2,
 --Unidade de Medida Correta
 --02.04.2009
 pn.cd_unidade_medida                  as cd_unidade_medida,
 null                                  as pc_reducao_icms,
 null                                  as pc_desconto_sobre_desc,
 null                                  as nm_desconto_item_pedido,
 null                                  as cd_item_contrato,
 null                                  as cd_contrato_fornecimento,
 null                                  as nm_kardex_item_ped_venda,
 null                                  as ic_gprgcnc_pedido_venda,
 null                                  as cd_pedido_importacao,
 null                                  as cd_item_pedido_importacao,
 null                                  as dt_progfat_item_pedido,
 null                                  as qt_cancelado_item_pedido,
 null                                  as qt_ativado_pedido_venda,
 null                                  as cd_mes,
 null                                  as cd_ano,
 'N'                                   as ic_mp66_item_pedido,
 null                                  as ic_montagem_item_pedido,
 null                                  as ic_reserva_estrutura_item,
 null                                  as ic_estrutura_item_pedido,
 0.00                                  as vl_frete_item_pedido,
 null                                  as cd_usuario_lib_desconto,
 null                                  as dt_moeda_cotacao,
 null                                  as vl_moeda_cotacao,
 null                                  as cd_moeda_cotacao,
 null                                  as dt_zera_saldo_pedido_item,
 null                                  as cd_lote_produto,
 null                                  as cd_num_serie_item_pedido,
 null                                  as cd_lote_item_pedido,
 null                                  as ic_controle_mapa_pedido,
 null                                  as cd_tipo_embalagem,
 null                                  as dt_validade_item_pedido,
 null                                  as cd_movimento_caixa,
 null                                  as vl_custo_financ_item,
 null                                  as qt_garantia_item_pedido,
 null                                  as cd_tipo_montagem,
 null                                  as cd_montagem,
 null                                  as cd_usuario_ordsep,
 null                                  as ic_kit_grupo_produto,
 null                                  as cd_sub_produto_especial,
 null                                  as cd_plano_financeiro,
 null                                  as dt_fluxo_caixa,
 null                                  as ic_fluxo_caixa,
 cast('' as varchar)                   as ds_servico_item_pedido,
 null                                  as dt_reservado_montagem,
 null                                  as cd_usuario_montagem,
 null                                  as ic_imediato_produto,
 cf.cd_mascara_classificacao           as cd_mascara_classificacao,
 null                                  as cd_desenho_item_pedido,
 null                                  as cd_rev_des_item_pedido,
 null                                  as cd_centro_custo,
 null                                  as qt_area_produto,
 null                                  as cd_produto_estampo,
 null                                  as vl_digitado_item_desconto,
 null                                  as cd_lote_Item_anterior,
 null                                  as cd_programacao_entrega,
 null                                  as ic_estoque_fatura,
 null                                  as ic_estoque_venda,
 null                                  as ic_manut_mapa_producao,
 null                                  as pc_comissao_item_pedido,
 null                                  as cd_produto_servico,
 null                                  as ic_baixa_composicao_item,
 case when isnull(pf.vl_ipi_produto_fiscal,0)>0 then
   isnull(pf.vl_ipi_produto_fiscal,0)
 else 
   isnull(cf.vl_ipi_classificacao,0) 
 end                                   as vl_unitario_ipi_produto,
 null                                  as ic_desc_prom_item_pedido,
 pn.cd_tabela_preco,
 null                                  as cd_motivo_reprogramacao,
 null                                  as qt_estoque,
 null                                  as dt_estoque,
 null                                  as dt_atendimento,
 null                                  as qt_atendimento,
 null                                  as nm_forma,
 null                                  as cd_documento,
 null                                  as cd_item_documento,
 null                                  as nm_obs_atendimento,
 null                                  as qt_atendimento_1,
 null                                  as qt_atendimento_2,
 null                                  as qt_atendimento_3,
 null                                  as vl_bc_icms_st,
 null                                  as vl_item_icms_st,
 'N'                                   as ic_sel_mrp_item_pedido

into
  #pedido_venda_item

from
  pedido_venda_nextel pn                  with (nolock) 
  left outer join cliente c               with (nolock) on c.cd_cliente               = pn.cd_cliente
  left outer join produto p               with (nolock) on p.cd_produto               = pn.cd_produto
  left outer join produto_fiscal pf       with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  left outer join categoria_produto cp    with (nolock) on cp.cd_categoria_produto    = p.cd_categoria_produto
  left outer join status_produto sp       with (nolock) on sp.cd_status_produto       = p.cd_status_produto

where
  pn.cd_pedido_venda = @cd_pedido        and
  pn.cd_cliente      = @cd_cliente       and
  pn.cd_vendedor     = @cd_vendedor      and
  isnull(sp.ic_permitir_venda,'N') = 'S' 
  

--Gera a Tabela de Unidade do Pedido de Venda

--select * from pedido_venda_item_unidade

select
 @cd_pedido_venda                            as cd_pedido_venda,
 pn.cd_item_pedido_venda,
 isnull(pn.qt_item_pedido_venda_nextel,0.00) as qt_embalagem,
 isnull(pn.qt_item_pedido_venda_nextel,0.00) as qt_unidade,
 p.cd_tipo_embalagem,                       
 p.qt_multiplo_embalagem,
 cast('' as varchar)                         as nm_obs_unidade,
 @cd_usuario                                 as cd_usuario,
 getdate()                                   as dt_usuario
into
  #pedido_venda_item_unidade

from
  pedido_venda_nextel pn                  with (nolock) 
  left outer join produto p               with (nolock) on p.cd_produto               = pn.cd_produto
  left outer join status_produto sp       with (nolock) on sp.cd_status_produto       = p.cd_status_produto

where
  pn.cd_pedido_venda = @cd_pedido    and
  isnull(sp.ic_permitir_venda,'N') = 'S'


--select * from status_produto

--select * from pedido_venda_nextel
--select * from produto_fiscal
--select * from classificacao_fiscal


--select * from #pedido_venda_item


--Calcula o Total do pedido de Venda

declare @vl_total_pedido_venda float
declare @vl_total_ipi          float
declare @qt_peso_liquido       float
declare @qt_peso_bruto         float

set @vl_total_pedido_venda = 0
set @vl_total_ipi          = 0

select
  @vl_total_pedido_venda = sum ( qt_item_pedido_venda * vl_unitario_item_pedido ),
  @vl_total_ipi          = sum ( case when pc_ipi >0 
                                 then ( qt_item_pedido_venda * vl_unitario_item_pedido  ) * (pc_ipi/100) 
                                 else ( qt_item_pedido_venda * vl_unitario_ipi_produto  ) end ),
  
  @qt_peso_liquido       = sum ( qt_liquido_item_pedido ),                                           
  @qt_peso_bruto         = sum ( qt_bruto_item_pedido )
from
  #pedido_venda_item


--select @vl_total_ipi,@vl_total_pedido_venda

--select @vl_total_pedido_venda
--select * from pedido_venda

--print '2'

update
  #pedido_venda
set
  vl_total_pedido_venda   = @vl_total_pedido_venda,
  vl_total_pedido_ipi     = @vl_total_pedido_venda + @vl_total_ipi,
  vl_total_ipi            = @vl_total_ipi,
  qt_liquido_pedido_venda = @qt_peso_liquido,
  qt_bruto_pedido_venda   = @qt_peso_bruto 
from
  #pedido_venda

--print '3'

------------------------------------------------------------------------------------------------
--Grava o Pedido de Venda
------------------------------------------------------------------------------------------------

insert into 
  pedido_venda
select
  *
from
  #pedido_venda
where
  cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda )

--select * from #pedido_venda

------------------------------------------------------------------------------------------------
--Grava os Dados do Transporte do Pedido de Venda
------------------------------------------------------------------------------------------------

if @cd_veiculo>0
begin

  --select * from pedido_venda_transporte
--   delete from pedido_venda_transporte 
--   where
--     cd_pedido_venda = @cd_pedido_venda

  insert into 
    pedido_venda_transporte
  select
    *
  from
    #pedido_venda_transporte
  where
    cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda_transporte with (nolock) )

end

------------------------------------------------------------------------------------------------
--Grava o item do Pedido de venda
------------------------------------------------------------------------------------------------

insert into
  pedido_venda_item
select
  *
from
  #pedido_venda_item

------------------------------------------------------------------------------------------------
--Grava o item da Unidade do Pedido de venda
------------------------------------------------------------------------------------------------

insert into
  pedido_venda_item_unidade
select
  *
from
  #pedido_venda_item_unidade


-------------------------------------------------------------------------------
--Reserva do Estoque
-------------------------------------------------------------------------------
--produto_saldo

declare @cd_item_pedido_venda     int
declare @cme                      int
declare @cd_produto               int
declare @cd_fase_produto          int
declare @qt_produto_atualizacao   float
declare @vl_unitario_movimento    float
declare @vl_total_movimento       float
declare @nm_historico_movimento   varchar(40)
declare @qt_saldo_reserva_produto float
declare @cd_tabela_preco          int
declare @cd_tabela_preco_produto  int
declare @cd_mascara_produto       varchar(20)
declare @vl_tabela_produto        float
declare @ic_embalagem_unidade     char(1)

set 
  @nm_historico_movimento = 'PV '+rtrim(ltrim(cast(@cd_pedido_venda      as varchar)))+' - It. '+
              rtrim(ltrim(cast(@cd_item_pedido_venda as varchar)))+' '+@nm_fantasia_cliente

--Busca a Fase do Produto------------------------------------------------------
--select * from parametro_comercial

select
  @cd_fase_produto      = isnull(cd_fase_produto,0),
  @ic_embalagem_unidade = isnull(ic_embalagem_unidade,'N')
  
from
  Parametro_Comercial with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


--Atualizações do Item do Pedido-----------------------------------------------

while exists ( select top 1 cd_item_pedido_venda from #pedido_venda_item )
begin

  select top 1
    @cd_item_pedido_venda     = isnull(i.cd_item_pedido_venda,0),
    @cd_produto               = isnull(i.cd_produto,0),

    --Fase do Produto------------------------------------------------------------
    @cd_fase_produto          = case when isnull(um.cd_fase_produto,0)>0 
                                then
                                  um.cd_fase_produto
                                else
                                  isnull(p.cd_fase_produto_baixa,@cd_fase_produto)
                                end,
                        
    --Quantidade que deve ser baixada/reservada----------------------------------
    @qt_produto_atualizacao   = isnull(i.qt_item_pedido_venda,0),

    @vl_unitario_movimento    = isnull(i.vl_unitario_item_pedido,0),
    @vl_total_movimento       = isnull(i.qt_item_pedido_venda * i.vl_unitario_item_pedido,0),
    @qt_saldo_reserva_produto = isnull(ps.qt_saldo_reserva_produto,0),
    @cd_tabela_preco          = isnull(i.cd_tabela_preco,0),
    @cd_mascara_produto       = isnull(p.cd_mascara_produto,'')
  from
    #pedido_venda_item i
    inner join Produto p              with (nolock) on p.cd_produto         = i.cd_produto
    left outer join Unidade_Medida um with (nolock) on um.cd_unidade_medida = i.cd_unidade_medida
    left outer join Produto_Saldo ps  with (nolock) on ps.cd_produto        = i.cd_produto and
                                                       ps.cd_fase_produto = 
                                                       case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                       then @cd_fase_produto else p.cd_fase_produto_baixa end

  --Checagem do Saldo do Pedido com o Saldo de Estoque

  if @qt_produto_atualizacao<@qt_saldo_reserva_produto 
  begin
     set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

     set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Estoque Insuficiente' as varchar(60))

     exec pr_gera_pendencia_pedido_venda
       @cd_pedido_venda,
       8,              --Estoque Insuficiente
       @cd_usuario,
       @nm_obs_pendencia,
       @cd_item_pedido_venda    

    --select * from tipo_pendencia_financeira

    --Gera a Restrição do Pedido de Venda
    --select * from pedido_venda

--     update
--       pedido_venda
--     set
--       cd_tipo_restricao_pedido = 3 --Estoque
--     from
--       pedido_venda
--     where
--       cd_pedido_venda = @cd_pedido_venda

  end

  --Produto Não Cadastrado

  if @cd_produto = 0
  begin

    set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

    set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Item: '+cast(@cd_item_pedido_venda as varchar) +' Produto não Cadastrado ' as varchar(60))

    exec pr_gera_pendencia_pedido_venda
      @cd_pedido_venda,
      9,              --Outros
      @cd_usuario,
      @nm_obs_pendencia,
      @cd_item_pedido_venda    

  end


  --Checagem da Tabela de Preço do Item do Pedido, Atualizar a Pendência

  --Tabela de Preço
  --

  if @cd_tabela_preco = 0
  begin

    set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

    --select * from tabela_preco
    --select * from tabela_preco_produto
    --select * from tipo_pendencia_financeira

    set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Item: '+cast(@cd_item_pedido_venda as varchar) +' Produto Sem Tabela Preço:'+@cd_mascara_produto as varchar(60))

    exec pr_gera_pendencia_pedido_venda
      @cd_pedido_venda,
      13,              --Outros
      @cd_usuario,
      @nm_obs_pendencia,
      @cd_item_pedido_venda

--     update
--       pedido_venda
--     set
--       cd_tipo_restricao_pedido = 4 --Tabela de Preço
--     from
--       pedido_venda
--     where
--       cd_pedido_venda = @cd_pedido_venda
-- 

  end

  --Tabela de Preço do Produto em Função da Quantidade

  select
    @cd_tabela_preco_produto = cd_tabela_preco,
    @vl_tabela_produto       = vl_tabela_produto
  from
    Tabela_Preco_Produto with (nolock) 
  where
    cd_produto = @cd_produto                            and
    @qt_produto_atualizacao <=  qt_tabela_produto       and
    isnull(vl_tabela_produto,0)>0                       and
    isnull(qt_tabela_produto,0)>0

  order by
    qt_tabela_produto 

---------------------------------------------------------------------------------- 
--Verifica a Tabela de Preço do Pedido com a Tabela do Cadastro do Produto
---------------------------------------------------------------------------------- 
--Comentado em 06.04.2009
---------------------------------------------------------------------------------- 

  if @cd_tabela_preco <> @cd_tabela_preco_produto
  begin

    set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

    set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Item: '+cast(@cd_item_pedido_venda as varchar) +' Tabela : '+cast(@cd_tabela_preco as varchar(2))+'/'+cast(@cd_tabela_preco_produto as varchar(2))+
                                 ' Produto :'+@cd_mascara_produto as varchar(60))

    exec pr_gera_pendencia_pedido_venda
      @cd_pedido_venda,
      14,              --Tabela de Preço Incorreta
      @cd_usuario,
      @nm_obs_pendencia,
      @cd_item_pedido_venda    


    update
      pedido_venda
    set
      cd_tipo_restricao_pedido = 4 --Tabela de Preço
    from
      pedido_venda
    where
      cd_pedido_venda = @cd_pedido_venda

    --Atualiza o Item do Pedido de Venda

    --Recalcula o Pedido de Venda

    --select * from tipo_pendencia_financeira

  end

---------------------------------------------------------------------------------- 

  --Atualização do Estoque

---------------------------------------------------------------------------------- 

   exec pr_Movimenta_estoque  
        1,                       --Inclusão
        2,                       --Tipo de Movimentação de Estoque
        NULL,                    --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_produto_atualizacao, --Quantidade
        NULL,                    --Quantidade Antiga
        @dt_geracao,             --Data do Movimento de Estoque
        @cd_pedido_venda,        --Pedido de Venda
        @cd_item_pedido_venda,   --Item do Pedido
        7,                       --Tipo de Documento
        @dt_geracao,             --Data do Pedido
        NULL,                    --Centro de Custo
        @vl_unitario_movimento,  --Valor Unitário
        @vl_total_movimento,     --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        @nm_historico_movimento, --Histórico
        'S',                     --Mov. Saída
        @cd_cliente,             --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        @dt_geracao,             --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        @nm_fantasia_cliente, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        @cme,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão
 

  delete from #pedido_venda_item
  where
    cd_item_pedido_venda = @cd_item_pedido_venda


end

drop table #pedido_venda
drop table #pedido_venda_item

--Atualiza a Tabela de Pedido Gerado

update
  pedido_venda_nextel
set
  ic_gerado_pedido_venda = 'S'
where
  cd_pedido_venda = @cd_pedido   and
  cd_cliente      = @cd_cliente  and
  cd_vendedor     = @cd_vendedor


--Geração da Situação do Pedido de Venda

--Entrada do Pedido

exec pr_gera_historico_pedido
     1,
     @cd_pedido_venda,
     0,
     569,                     --Histórico
     @dt_geracao,      
     '',
     'Importação de Pedido',
     '',
     '',
     @cd_usuario

--Crédito não Liberado

exec pr_gera_historico_pedido
     1,
     @cd_pedido_venda,
     0,
     4,                     --Histórico
     @dt_geracao,      
     '',
     'Importação de Pedido',
     '',
     '',
     @cd_usuario

--Reserva de Estoque

exec pr_gera_historico_pedido
     1,
     @cd_pedido_venda,
     0,
     104,                    --Histórico
     @dt_geracao,      
     '',
     'Importação de Pedido',
     '',
     '',
     @cd_usuario


--Verificação das Pendências do Pedido de Venda

-- set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Implantação Novo Sistema ' as varchar(60))
-- 
-- exec pr_gera_pendencia_pedido_venda
--      @cd_pedido_venda,
--      1,              --Financeiro deve Autorizar
--      @cd_usuario,
--      @nm_obs_pendencia    


--Verificação do Limite de Crédito para Entrada Automática para Liberação de Crédito

if @vl_total_pedido_venda>@vl_limite_credito
begin

  set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

  --select * from tipo_pendencia_financeira

  set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Total Pedido > Limite de Crédito ' as varchar(60))

  exec pr_gera_pendencia_pedido_venda
     @cd_pedido_venda,
     6,              --Financeiro deve Autorizar
     @cd_usuario,
     @nm_obs_pendencia,
     0    

end

--Valor de Documentos em Receber em Aberto / Saldo Devedor
--select * from documento_receber

declare @vl_saldo_documento float

select
  @vl_saldo_documento = sum( vl_saldo_documento )
from
  documento_receber with (nolock)
where
  cd_cliente = @cd_cliente         and
  isnull(vl_saldo_documento,0)>0 and
  dt_cancelamento_documento is   null      


------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------

if @vl_total_pedido_venda > @vl_saldo_documento
begin

  set @ic_gera_nota_saida           = 1 --Não Gera Nota Fiscal de Saída

  set @nm_obs_pendencia = cast('PV: '+ltrim(rtrim(cast(@cd_pedido_venda as varchar))) + ' Total Pedido > Saldo em Aberto ' as varchar(60))

  exec pr_gera_pendencia_pedido_venda
     @cd_pedido_venda,
     2,              --Financeiro deve Autorizar
     @cd_usuario,
     @nm_obs_pendencia,
     0    

end

--Pendência

exec pr_gera_historico_pedido
     1,
     @cd_pedido_venda,
     0,
     571,                   --Histórico
     @dt_geracao,      
     '',
     'Importação de Pedido/Pendência',
     '',
     '',
     @cd_usuario


--------------------------------------------------------------------------------------------------------
--Liberação de Crédito Automática de Acordo com os Critérios da Empresa
--------------------------------------------------------------------------------------------------------
if @ic_libera_credito='S'
begin
  
  declare @lc int

  set @lc = 0

  --Pedido em Dinheiro

  if @ic_credito_forma_pagamento = 'S' 
  begin
    set @lc = 1
  end

  --Valor do Pedido < Valor do Limite de Crédito

  if @vl_total_pedido_venda<=@vl_limite_credito
  begin
    set @lc = 1
  end
  else
  begin
    set @lc = 0
  end

  --Liberação do Crédito do Pedido

  if @lc = 1 
  begin 

    update
      pedido_venda
    set
      dt_credito_pedido_venda   = @dt_credito_pedido_venda,
      cd_usuario_credito_pedido = @cd_usuario_credito
    from
      Pedido_Venda
    where
      cd_pedido_venda = @cd_pedido_venda

  end  

end


--------------------------------------------------------------------------------------------------------


--Deleta o número do Pedido
--exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'


--Verificar se o parâmetro é para Gerar Nota Automaticamente

--Geração da Nota Fiscal de Saída

if @ic_geracao_nota_automatica='S' and @cd_pedido_venda>0
begin

  exec pr_gera_nota_saida @cd_pedido_venda,
                          @cd_usuario,
                          null,
                          @cd_operacao_fiscal

end

 
end

--select * from produto_fiscal
--select * from pedido_venda where cd_pedido_venda = 1308700
--select * from tipo_pedido
--select * from pedido_venda_item where cd_pedido_venda = 900076
--select * from pedido_venda_pendencia
--select * from pedido_venda where cd_pedido_venda = 45456
--select * from pedido_venda_nextel
--select * from pedido_venda

