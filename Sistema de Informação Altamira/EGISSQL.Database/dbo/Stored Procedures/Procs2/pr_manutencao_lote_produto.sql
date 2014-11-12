-----------------------------------------------------------------------------------
--pr_manutencao_lote_produto
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2005                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Paulo Santos         
--Banco Dados      : EGISSQL
--Objetivo         : Manutenção do Cadastro de Lote
--Data             : 21.01.2005
--                 : 12.02.2005 - Verificação - Carlos Fernandes
--                 : 22.10.2005 - Acertos - Carlos Fernandes
--                 : 28.10.2005 - Pesquisa de Lotes - Carlos Fernandes
--                   17/10/2006 - Retirado flag do par. 2, pesquisar todos os itens
--                              - do lote de produto - Daniel C. Neto.
-- 18.11.2010 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_manutencao_lote_produto

@ic_parametro        int,
@cd_lote_produto     int,
@nm_ref_lote_produto varchar(25)

as

-----------------------------------------------------------------------------------
if @ic_parametro = 1 -- Tabela Cabeçalho
-----------------------------------------------------------------------------------
 begin

   --print('Codigo Lote Produto Cabeçalho - ' + cast(@cd_lote_produto as varchar))

   select
		lp.cd_lote_produto,
		lp.nm_lote_produto,
		lp.nm_ref_lote_produto,

		case lp.ic_status_lote_produto
                                   when 'A' then 'Aberto'
                                   when 'C' then 'Cancelado'
                                   when 'L' then 'Liquidado' end as ic_status_lote_produto,

		lp.dt_entrada_lote_produto,
		lp.dt_saida_lote_produto,
		lp.dt_inicial_lote_produto,
		lp.dt_final_lote_produto,
		
    case lp.ic_inspecao_lote_produto when 'S' then 'Sim'
                                     when 'N' then 'Não' end as ic_inspecao_lote_produto,
		
    case lp.ic_rastro_lote_produto when 'S' then 'Sim'
                                   when 'N' then 'Não' end as ic_rastro_lote_produto,
		lp.cd_pais,
    pa.nm_pais,
    lp.cd_processo,
    prc.nm_processo,
		lp.nm_obs_lote_produto,
    qt_saldo_atual_lote   = ( select sum(isnull(qt_saldo_atual_lote,0))   from Lote_Produto_Saldo where cd_lote_produto = lp.cd_lote_produto ),
    qt_saldo_reserva_lote = ( select sum(isnull(qt_saldo_reserva_lote,0)) from Lote_Produto_Saldo where cd_lote_produto = lp.cd_lote_produto ),
    lp.ic_estoque_lote_produto,
    lp.cd_loja,
    ( select
        sum(lpi.qt_produto_lote_produto) 
      from
        lote_produto_item lpi left outer join produto pro
         on lpi.cd_produto = pro.cd_produto 
       left outer join unidade_medida uni
         on pro.cd_unidade_medida = uni.cd_unidade_medida
      where lpi.cd_lote_produto = lp.cd_lote_produto ) as QuantidadeSaldoLote

  from 
    lote_produto lp
  left outer join processo prc           on lp.cd_processo = prc.cd_processo 
  left outer join pais pa                on lp.cd_pais = pa.cd_pais
  -- Checa se o valor do parâmetro for igual a zero trazer todos os registros
  where 
    nm_ref_lote_produto like  @nm_ref_lote_produto and
    lp.cd_lote_produto = case when @cd_lote_produto = 0 then lp.cd_lote_produto else @cd_lote_produto end 


 end

--select * from lote_produto

-----------------------------------------------------------------------------------
if @ic_parametro = 2 -- Tabela Detalhe -> Produtos que compõe o Lote de Produto
-----------------------------------------------------------------------------------
 begin

   --print('Codigo Lote Produto Detalhe - ' + cast(@cd_lote_produto as varchar))
   
   select
    --lpi.*,
    lpi.cd_lote_produto,
    lpi.cd_produto,
    lpi.qt_produto_lote_produto,
    lpi.cd_usuario,
    lpi.dt_usuario,
    lpi.nm_obs_item_lote_produto,
    lpi.dt_inicio_item_lote,
    lpi.dt_final_item_lote,
    lpi.cd_peca_item_lote,
    lpi.ic_status_item_lote,
    lpi.cd_box_item_lote,
    lpi.cd_cor,
    lpi.cd_tipo_desenho,
    lpi.cd_fase_produto,
    lpi.cd_loja,
    lpi.qt_largura_item_lote,
    lpi.qt_comp_item_lote,
    lpi.qt_venda_item_lote,
    lpi.qt_reserva_m2_item_lote,
    lpi.qt_saldo_m2_item_lote,
    lpi.qt_saldo_ml_item_lote,
    pro.cd_produto,
    pro.cd_mascara_produto,
    pro.nm_fantasia_produto,
    pro.nm_produto,
    pro.nm_produto_complemento,
    pro.ds_produto,
    uni.cd_unidade_medida,
    uni.sg_unidade_medida,
    cor.nm_cor,
    loj.nm_loja,
    lpi.cd_movimento_lote,
    lpi.cd_movimento_lote_origem,
    lpi.ic_tipo_movimento_lote

   from
    lote_produto_item lpi              with (nolock) 
    left outer join produto pro        on lpi.cd_produto        = pro.cd_produto
    left outer join loja loj           on lpi.cd_loja           = loj.cd_loja 
    left outer join unidade_medida uni on pro.cd_unidade_medida = uni.cd_unidade_medida
    left outer join cor cor            on cor.cd_cor            = pro.cd_cor
   -- Checa se o valor do parâmetro for igual a zero trazer todos os registros

   where lpi.cd_lote_produto = case when @cd_lote_produto = 0 then 
                                lpi.cd_lote_produto
                              else
                                @cd_lote_produto
                              end 
--select * from produto where cd_produto = 12

 end

-----------------------------------------------------------------------------------
if @ic_parametro = 3 -- Soma Quantidade de Saldo Lote
-----------------------------------------------------------------------------------
 begin

--   print('Codigo Lote Produto Detalhe - ' + cast(@cd_lote_produto as varchar))

   select
    sum(lpi.qt_produto_lote_produto) as QuantidadeSaldoLote
   from
    lote_produto_item lpi left outer join produto pro
     on lpi.cd_produto = pro.cd_produto 
   left outer join unidade_medida uni
     on pro.cd_unidade_medida = uni.cd_unidade_medida
  -- Checa se o valor do parâmetro for igual a zero trazer todos os registros
  where lpi.cd_lote_produto = case when @cd_lote_produto = 0 then 
                                lpi.cd_lote_produto
                              else
                                @cd_lote_produto
                              end 
 end


