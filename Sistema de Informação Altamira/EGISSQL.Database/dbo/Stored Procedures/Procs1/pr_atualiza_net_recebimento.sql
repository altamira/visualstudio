
create procedure pr_atualiza_net_recebimento
------------------------------------------------------------------------
--GBS - Global Business Solution	             2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)	        : Elias Pereira da Silva
--Banco de Dados        : EGISSQL
--Objetivo              : Atualiza o Valor NET na Nota de Entrada e no Cadastro de Produtos
--Data                  : 13/04/2005
--Alteração             : 31.03.2007 - Verificação da Ordem de dedução do PIS/COFINS
--                                     Carlos Fernandes
-------------------------------------------------------------------------------
@cd_nota_entrada      int,
@cd_fornecedor        int,
@cd_operacao_fiscal   int,
@cd_serie_nota_fiscal int

as
begin

  declare @pc_aliquota_cofins decimal(25,4)
  declare @pc_aliquota_pis    decimal(25,4)
  declare @vl_cotacao         decimal(25,4)
  declare @cd_moeda           int
  declare @dt_cotacao         datetime
  declare @dt_recebimento     datetime

  -- Verifica se Existe Moeda cadastrada na Nota de Entrada

  select @cd_moeda       = isnull(cd_moeda,0),
         @dt_cotacao     = dt_cambio_nota_entrada,
         @dt_recebimento = dt_receb_nota_entrada
  from nota_entrada
  where cd_nota_entrada      = @cd_nota_entrada and
        cd_fornecedor        = @cd_fornecedor and
        cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
        cd_operacao_fiscal   = @cd_operacao_fiscal

  -- Caso não Exista Moeda, ou então é a Moeda Real, carregar
  -- do Parâmetro Financeiro

  if (@cd_moeda = 0) or (@cd_moeda = 1)
    select @cd_moeda = cd_moeda from parametro_financeiro
    where cd_empresa = dbo.fn_empresa()

  -- Se não foi informada nenhuma cotação, então utilizar a Data de Recebimento

  if (isnull(@dt_cotacao,0) = 0)
    set @dt_cotacao = @dt_recebimento

  -- Carregando o Valor da Moeda
  select @vl_cotacao = dbo.fn_vl_moeda_periodo(@cd_moeda,@dt_cotacao)

  --select * from imposto

  -- Carregando a Alíquota do Imposto COFINS (Código 4)
  select top 1 @pc_aliquota_cofins = isnull(pc_imposto,0)
  from
    imposto_aliquota
  where 
    cd_imposto = 4 and dt_imposto_aliquota <= @dt_recebimento
  order by 
    dt_imposto_aliquota

  -- Carregando a Alíquota do Imposto PIS (Código 5)
  select top 1 @pc_aliquota_pis = isnull(pc_imposto,0)
  from
    imposto_aliquota
  where 
    cd_imposto = 5 and dt_imposto_aliquota <= @dt_recebimento
  order by 
    dt_imposto_aliquota


  -- Alterando o Custo NET no item da Nota de Entrada

  update Nota_Entrada_Item
  set vl_custo_net_nota_entrada = (
    (
    (vl_total_nota_entr_item  / qt_item_nota_entrada) -- Valor Unitário da NFE
    -
    (vl_icms_nota_entrada     / qt_item_nota_entrada)    -- Valor do ICMS
    -
    ((vl_total_nota_entr_item / qt_item_nota_entrada) * (@pc_aliquota_cofins / 100)) -- Valor da COFINS
    - 
    ((vl_total_nota_entr_item / qt_item_nota_entrada) * (@pc_aliquota_pis / 100))    -- Valor do PIS
    ) /  
    -- Cotação do Dia
    @vl_cotacao )
  from Nota_Entrada_Item
  where cd_nota_entrada      = @cd_nota_entrada and
        cd_fornecedor        = @cd_fornecedor and
        cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
        cd_operacao_fiscal   = @cd_operacao_fiscal

  -- Atualiza o Custo NET no Produto

  update produto_custo
  set vl_net_outra_moeda = case when isnull(dt_net_outra_moeda,0) <= @dt_cotacao then vl_custo_net_nota_entrada end,
      dt_net_outra_moeda = case when isnull(dt_net_outra_moeda,0) <= @dt_cotacao then @dt_cotacao end
  from produto_custo pc, nota_entrada_item nei
  where nei.cd_nota_entrada = @cd_nota_entrada and
        nei.cd_fornecedor = @cd_fornecedor and
        nei.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
        nei.cd_operacao_fiscal = @cd_operacao_fiscal and
        pc.cd_produto = nei.cd_produto

--   select @cd_moeda, @dt_cotacao, @dt_recebimento, @vl_cotacao, @pc_aliquota_cofins
--   select 
--     (vl_total_nota_entr_item / qt_item_nota_entrada) as vl_unitario,
--     -- Valor do ICMS
--     pc_icms_nota_entrada as pc_icms,
--     (vl_icms_nota_entrada / qt_item_nota_entrada) as vl_icms_item,
--     -- Valor da COFINS
--     ((vl_total_nota_entr_item / qt_item_nota_entrada) *
--      (@pc_aliquota_cofins / 100)) as vl_cofins,
--     -- Cotação do Dia
--     @vl_cotacao as vl_cotacao,
--     vl_custo_net_nota_entrada
--   from nota_entrada_item
--   where cd_nota_entrada = @cd_nota_entrada and
--         cd_fornecedor = @cd_fornecedor and
--         cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
--         cd_operacao_fiscal = @cd_operacao_fiscal 
 
end


