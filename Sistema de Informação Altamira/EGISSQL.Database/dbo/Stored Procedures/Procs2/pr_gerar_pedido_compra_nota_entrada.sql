
create procedure pr_gerar_pedido_compra_nota_entrada
@cd_fornecedor		int,
@cd_nota_entrada	int,
@cd_serie_nota		int,
@cd_operacao_fiscal	int,
@cd_requisicao_compra   int,
@ds_pedido_compra 	varchar(200),
@cd_plano_compra  	int,
@cd_centro_custo  	int,
@cd_aplicacao_produto 	int,
@cd_plano_financeiro 	int,
@ic_aprov_pedido_compra char(1),
@cd_usuario		int,
@cd_departamento	int

as

------------------------------------------------------------------------------------------
-- SOMENTE EXECUTA CASO ENCONTRE A NF CORRESPONDENTE
------------------------------------------------------------------------------------------
if not exists(select cd_nota_entrada from Nota_Entrada n
              where 
                n.cd_fornecedor        = @cd_fornecedor   and
                n.cd_nota_entrada      = @cd_nota_entrada and
                n.cd_serie_nota_fiscal = @cd_serie_nota   and
                n.cd_operacao_fiscal   = @cd_operacao_fiscal)
  return


declare @Tabela		  		varchar(50)
declare @cd_pedido_compra 		int
declare @cd_comprador			int
declare @cd_tipo_conta_pagar    	int
declare @qt_bruto_nota_entrada 		float
declare @qt_liquido_nota_entrada 	float
declare @vl_total_nota_entrada 		float
declare @vl_ipi_nota_entrada 		float
declare @vl_frete_nota_entrada 		float
declare @vl_total_nota_ipi 		float
declare @cd_tipo_aprovacao 		int
declare @cd_usuario_aprovacao           int
declare @vl_pedido_compra_empresa       float -- Variável para descobrir teto do pedido.
declare @ic_teto_aprovacao              char(1)
declare @cd_documento_pagar             int

-----------------------------------------
-- GERAÇÃO DO CÓDIGO ÚNICO DO PEDIDO DE COMPRA
-----------------------------------------
print('Gerando o Código Sequencial')
set @Tabela = cast(DB_NAME()+'.dbo.Pedido_Compra' as varchar(50))
exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_compra', @codigo = @cd_pedido_compra output
exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_compra, 'D'

-----------------------------------------
-- ACERTA O NÚMERO DO PEDIDO DE COMPRA PARA EVITAR ERROS NA MIGRAÇÃO
-----------------------------------------
print 'Pedido de Compra nº '+cast(@cd_pedido_compra as varchar)

-----------------------------------------
-- SELECIONANDO O COMPRADOR PADRÃO 
-----------------------------------------
print('Selecionando o Comprador Padrão')
select 
  @cd_comprador = isnull(cd_comprador, (select top 1 cd_comprador 
                                       from Comprador 
                                       where 
                                         ic_padrao_comprador = 'S'))
from EgisAdmin.dbo.Usuario
where
  cd_usuario=@cd_usuario
  

-----------------------------------------
-- CAMPOS NÃO ENCONTRADOS NA NOTA DE ENTRADA E NÃO GRAVADOS NO PC
-----------------------------------------
-- cd_contrato_fornecedor
-- cd_comprador
-- dt_cambio_pedido_compra
-- nm_ref_pedido_compra
-- nm_contato_conf_ped_comp (Contato Confirmação)
-- cd_tipo_entrega_produto (1 - Normal)
-- cd_tipo_local_entrega (1 - Empresa)
-- cd_fase_produto_contato
-- dt_vcto_pedido_compra
-- cd_tipo_comunicacao
-- cd_departamento
-- cd_local_entrega_empresa, (1 - Empresa)
-- cd_requisicao_compra,

-----------------------------------------
-- SOMANDO OS VALORES TOTAIS DO PC APENAS DOS ITENS DA NF QUE NÃO
-- CONTÊM PEDIDOS DE COMPRA
-----------------------------------------
if exists(select cd_nota_entrada 
          from Nota_Entrada_Item
          where 
            cd_fornecedor        = @cd_fornecedor and
            cd_nota_entrada      = @cd_nota_entrada and
            cd_serie_nota_fiscal = @cd_serie_nota and
            cd_operacao_fiscal   = @cd_operacao_fiscal and
            isnull(cd_pedido_compra,0) <> 0)
begin
  print('Encontrou itens na NF que não contêm PC')
  select  
    @qt_bruto_nota_entrada   = sum(isnull(qt_pesbru_nota_entrada,0)),
    @qt_liquido_nota_entrada = sum(isnull(qt_pesliq_nota_entrada,0)),
    @vl_total_nota_entrada   = sum(isnull(vl_total_nota_entr_item,0)),
    @vl_ipi_nota_entrada     = sum(isnull(vl_ipi_nota_entrada,0)),
    @vl_frete_nota_entrada   = 0,
    @vl_total_nota_ipi       = sum(isnull(vl_ipi_nota_entrada,0) + isnull(vl_total_nota_entr_item,0))
  from
    Nota_Entrada_Item
  where
    cd_fornecedor        = @cd_fornecedor and
    cd_nota_entrada      = @cd_nota_entrada and
    cd_serie_nota_fiscal = @cd_serie_nota and
    cd_operacao_fiscal   = @cd_operacao_fiscal and
    isnull(cd_pedido_compra,0) = 0   
end

-----------------------------------------
-- CRIAÇÃO DO REGISTRO NA TABELA PEDIDO_COMPRA
-----------------------------------------
print('Criando PC Cabecalho')

insert into pedido_compra
 (cd_pedido_compra,
  dt_pedido_compra,
  cd_fornecedor,
  cd_transportadora,
  ic_pedido_compra,	
  ds_pedido_compra,
  cd_destinacao_produto,
  cd_tipo_pedido,
  cd_tipo_endereco,
  cd_moeda,
  cd_condicao_pagamento,
  cd_status_pedido,
  qt_pesobruto_pedido_compra,
  qt_pesoliq_pedido_compra,
  vl_total_pedido_compra,
  dt_nec_pedido_compra,
  dt_conf_pedido_compra,
  cd_plano_compra,
  cd_centro_custo,
  cd_usuario,
  dt_usuario,
  vl_total_ipi_pedido,
  vl_frete_pedido_compra,
  ic_fechado_pedido_compra,
  cd_aplicacao_produto,
  vl_total_pedido_ipi,
  cd_plano_financeiro,
  ic_aprov_comprador_pedido,
  ic_consignacao_pedido,
  ic_aprov_pedido_compra,
  cd_requisicao_compra,  
  cd_comprador,
  cd_tipo_entrega_produto,
  cd_tipo_local_entrega,
  cd_local_entrega_empresa,
  cd_departamento,
  ic_pedido_gerado_autom) -- Pedido de compra gerado automaticamente!
select
  @cd_pedido_compra,
  n.dt_receb_nota_entrada,
  n.cd_fornecedor,
  n.cd_transportadora,
  'S',
  @ds_pedido_compra,
  n.cd_destinacao_produto,
  3, -- PEDIDO DE COMPRA PADRÃO
  1, -- ÚNICO
  1, -- REAL
  n.cd_condicao_pagamento,
  9, -- PEDIDO RECEBIDO
  isnull(@qt_bruto_nota_entrada,n.qt_bruto_nota_entrada),
  isnull(@qt_liquido_nota_entrada,n.qt_liquido_nota_entrada),
  isnull(@vl_total_nota_entrada,n.vl_total_nota_entrada),
  n.dt_receb_nota_entrada,
  n.dt_receb_nota_entrada,
  @cd_plano_compra,
  @cd_centro_custo,
  @cd_usuario,
  getDate(),
  isnull(@vl_ipi_nota_entrada,n.vl_ipi_nota_entrada),
  isnull(@vl_frete_nota_entrada,n.vl_frete_nota_entrada),
  'S',
  @cd_aplicacao_produto,
  isnull(@vl_total_nota_ipi,(isnull(n.vl_ipi_nota_entrada,0) + n.vl_total_nota_entrada)),
  @cd_plano_financeiro,
  @ic_aprov_pedido_compra,
  'N',
  @ic_aprov_pedido_compra,
  @cd_requisicao_compra,
  @cd_comprador,
  1,  -- NORMAL
  1,  -- EMPRESA
  1,  -- EMPRESA
  @cd_departamento,
  'S'
from
  Nota_Entrada n
where
  n.cd_fornecedor        = @cd_fornecedor and
  n.cd_nota_entrada      = @cd_nota_entrada and
  n.cd_serie_nota_fiscal = @cd_serie_nota and
  n.cd_operacao_fiscal   = @cd_operacao_fiscal

--select cd_pedido_compra,* from nota_entrada_item

select cd_documento_pagar 
into #Documento 
from Nota_entrada_Parcela
where
  cd_fornecedor        = @cd_fornecedor and
  cd_nota_entrada      = @cd_nota_entrada and
  cd_serie_nota_fiscal = @cd_serie_nota

while exists( select 'x' from #Documento)
begin
  select top 1 
    @cd_documento_pagar = cd_documento_pagar
  from 
    #Documento

  update Documento_Pagar
  set cd_pedido_compra = @cd_pedido_compra
  where cd_documento_pagar = @cd_documento_Pagar

  delete from #Documento where cd_documento_pagar = @cd_documento_pagar
end
  
-----------------------------------------
-- CRIAÇÃO DA TABELA DE PEDIDO_COMPRA_ITEM
-----------------------------------------
print('Criando PC Item') 
insert into Pedido_Compra_Item
  (cd_requisicao_compra_item,
  cd_requisicao_compra,
  cd_pedido_compra,
  cd_item_pedido_compra,
  dt_item_pedido_compra,
  qt_item_pedido_compra,
  qt_saldo_item_ped_compra,
  dt_entrega_item_ped_compr,
  vl_custo_item_ped_compra,
  vl_item_unitario_ped_comp,
  vl_total_item_pedido_comp,
  ds_item_pedido_compra,
  pc_item_descto_ped_compra,
  cd_produto,
  cd_servico,
  cd_plano_compra,
  cd_categoria_produto,
  dt_item_nec_ped_compra,
  cd_moeda,
  qt_item_pesliq_ped_compra,
  qt_item_pesbr_ped_compra,
  cd_pedido_venda,
  cd_item_pedido_venda,
  qt_item_entrada_ped_compr,
  cd_centro_custo,
  cd_usuario,
  dt_usuario,
--  nm_item_prodesp_ped_compr,
  cd_unidade_medida,
  cd_maquina,
  ic_produto_especial,
  ic_pedido_compra_item,
  nm_fantasia_produto,
  nm_produto,
  PC_IPI,
  nm_marca_item_pedido,
  cd_mascara_produto,
  ds_obs_pedido_compra,
  ic_aprov_comprador_pedido,
  cd_plano_financeiro)
select
  r.cd_item_requisicao_compra,
  @cd_requisicao_compra,
  @cd_pedido_compra,
  i.cd_item_nota_entrada,
  n.dt_receb_nota_entrada,
  i.qt_item_nota_entrada,
  0,
  i.dt_item_receb_nota_entrad,
  i.vl_custo_nota_entrada,
  i.vl_item_nota_entrada,
  i.vl_item_nota_entrada,
  -- ELIAS 28/06/2005 - Acrescentado o Nome do Serviço digitado pelo
  -- usuário, mesmo que não tenha informado a Descrição.
  case i.ic_tipo_nota_entrada_item 
    when 'S' then 
      IsNull(i.nm_produto_nota_entrada + cast(i.ds_servico as varchar(40)),i.nm_produto_nota_entrada)
    else
      i.nm_produto_nota_entrada
  end as nm_produto_nota_entrada,
  i.pc_desc_nota_entrada,
  i.cd_produto,
  i.cd_servico,
  @cd_plano_compra,
  r.cd_categoria_produto,
  i.dt_item_receb_nota_entrad,
  1,
  i.qt_pesliq_nota_entrada,
  i.qt_pesbru_nota_entrada,
  r.cd_pedido_venda,
  r.cd_item_pedido_venda,
  i.qt_item_nota_entrada,
  @cd_centro_custo,
  @cd_usuario,
  getdate(),
--  case when i.cd_produto is null then
--    i.nm_produto_nota_entrada
--  else null end,
  i.cd_unidade_medida,
  r.cd_maquina,
  case when (i.cd_produto is null) and (i.ic_tipo_nota_entrada_item = 'P') then
    'S' 
  else 
    'N' end,
  i.ic_tipo_nota_entrada_item,
  p.nm_fantasia_produto,
  case when i.cd_produto is null then
    i.nm_produto_nota_entrada
  else p.nm_produto end,
  i.pc_ipi_nota_entrada,
  pc.nm_marca_produto,
  p.cd_mascara_produto,
  @ds_pedido_compra,
  @ic_aprov_pedido_compra,
  @cd_plano_financeiro
from
  Nota_Entrada_Item i 
inner join Nota_Entrada n on
  i.cd_nota_entrada = n.cd_nota_entrada and
  i.cd_fornecedor = n.cd_fornecedor and
  i.cd_operacao_fiscal = n.cd_operacao_fiscal and
  i.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
left outer join Requisicao_Compra_Item r on
  i.cd_requisicao_compra = r.cd_requisicao_compra and
  i.cd_item_requisicao_compra = r.cd_item_requisicao_compra
left outer join Produto p on
  i.cd_produto = p.cd_produto
left outer join Produto_Compra pc on
  i.cd_produto = pc.cd_produto
where
  i.cd_fornecedor = @cd_fornecedor and
  i.cd_nota_entrada = @cd_nota_entrada and
  i.cd_serie_nota_fiscal = @cd_serie_nota and
  i.cd_operacao_fiscal = @cd_operacao_fiscal and
  isnull(i.cd_pedido_compra,0) = 0

-----------------------------------------
-- CRIAÇÃO DO REGISTRO EM PEDIDO_COMPRA_APROVACAO CASO JÁ ESTEJA APROVADO
-----------------------------------------
if @ic_aprov_pedido_compra = 'S'
begin

  -- Valor do Teto de Aprovação
  set @vl_pedido_compra_empresa = 
    ( select vl_pedido_compra_empresa 
      from Parametro_Suprimento 
      where cd_empresa = dbo.fn_empresa() )

  
  if ( select ic_liberado_comprador 
       from 
         parametro_suprimento
       where cd_empresa = dbo.fn_empresa() ) = 'S'
  begin

    -- Utilizar o Mesmo Usuário que Fez a NFE que irá gerar o PC
    set @cd_usuario_aprovacao = @cd_usuario

    if not exists (
      select 'x' from Pedido_Compra_Aprovacao where
        cd_pedido_compra = @cd_pedido_compra and
        cd_tipo_aprovacao = 1 )
    insert into Pedido_Compra_Aprovacao
     (cd_pedido_compra,
      cd_tipo_aprovacao,
      cd_usuario_aprovacao,
      dt_usuario_aprovacao,
      cd_usuario,
      dt_usuario,
      cd_item_aprovacao_pedido)    
    values
     (@cd_pedido_compra, 
      1, 
      @cd_usuario_aprovacao,
      getDate(),
      @cd_usuario,
      getDate(),
      0)  -- Todos os Itens
  end

  -- Necessário sempre existir a configuração necessária na
  -- tabela departamento_aprovacao para o tipo de aprovação e
  -- o Departamento escolhido - ELIAS 28/06/2005
  select distinct
    cd_tipo_aprovacao, 
    ic_teto_tipo_aprovacao,
    @cd_usuario_aprovacao as 'cd_usuario_aprovacao'
  into #Departamento_Aprovacao
  from Tipo_Aprovacao
  where 
    ic_auto_tipo_aprovacao = 'S'
  order by 1
  
  while exists ( select 'x' from #Departamento_Aprovacao ) 
  begin
    select 
      @cd_tipo_aprovacao= cd_tipo_aprovacao,
      @cd_usuario_aprovacao = cd_usuario_aprovacao,
      @ic_teto_aprovacao = IsNull(ic_teto_tipo_aprovacao,'N')
    from
      #Departamento_Aprovacao

    print(@vl_total_nota_ipi)

    if (@ic_teto_aprovacao = 'S' and 
       ( select (isnull(n.vl_ipi_nota_entrada,0) + n.vl_total_nota_entrada)
         from
           Nota_Entrada n
         where
           n.cd_fornecedor = @cd_fornecedor and
           n.cd_nota_entrada = @cd_nota_entrada and
           n.cd_serie_nota_fiscal = @cd_serie_nota and
           n.cd_operacao_fiscal = @cd_operacao_fiscal ) > @vl_pedido_compra_empresa) or
       (@ic_teto_aprovacao = 'N')

      if not exists (
        select 'x' from Pedido_Compra_Aprovacao where
          cd_pedido_compra = @cd_pedido_compra and
          cd_tipo_aprovacao = @cd_tipo_aprovacao )

      insert into Pedido_Compra_Aprovacao
       (cd_pedido_compra,
        cd_tipo_aprovacao,
        cd_usuario_aprovacao,
        dt_usuario_aprovacao,
        cd_usuario,
        dt_usuario,
        cd_item_aprovacao_pedido)    
      values
       (@cd_pedido_compra, 
        @cd_tipo_aprovacao, 
        @cd_usuario_aprovacao,
        getDate(),
        @cd_usuario,
        getDate(),
        0)  -- Todos os Itens

    delete from #Departamento_Aprovacao 
    where cd_tipo_aprovacao = @cd_tipo_aprovacao
  end

end

-----------------------------------------
-- ATUALIZAÇÃO DA NOTA FISCAL COM AS INFORMAÇÕES DO PEDIDO DE COMPRA GERADO
-----------------------------------------
print('Atualizando NF Item')
update
  Nota_Entrada_Item
set
  cd_pedido_compra      = @cd_pedido_compra,
  cd_item_pedido_compra = p.cd_item_pedido_compra,
  cd_plano_compra       = @cd_plano_compra
from
  Pedido_Compra_Item p,
  Nota_Entrada_Item i
where
  p.cd_pedido_compra      = @cd_pedido_compra and
  p.cd_item_pedido_compra = i.cd_item_nota_entrada and
  i.cd_fornecedor         = @cd_fornecedor and
  i.cd_nota_entrada       = @cd_nota_entrada and
  i.cd_serie_nota_fiscal  = @cd_serie_nota and
  i.cd_operacao_fiscal    = @cd_operacao_fiscal

-----------------------------------------
-- ATUALIZAÇÃO DO CONTAS À PAGAR
-----------------------------------------
print('Atualizando o SCP')
select
  @cd_tipo_conta_pagar = cd_tipo_conta_pagar
from
  Plano_Compra pl
where
  cd_plano_compra = @cd_plano_compra

update Documento_Pagar
set 
  cd_tipo_conta_pagar = @cd_tipo_conta_pagar,
  cd_plano_financeiro = @cd_plano_financeiro
where
  cd_nota_fiscal_entrada = @cd_nota_entrada and
  cd_fornecedor          = @cd_fornecedor

------------------------------------------------------------------------------------------
--Mostra o Pedido de Compra
------------------------------------------------------------------------------------------
--select @cd_pedido_compra as cd_pedido_compra
   
