
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE  pr_consulta_inventario_produto
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Inventário por Produto
--Data          : 21/05/2003
--Atualizado    : 25/08/2003
-- Acerto de filtro de ano no produto fechamento
-- Daniel C. NEto.
-- 26/08/2003 - Incluído filtro por Status do Produto
--            - Incluído filtro por Categoria.
-- 09/02/2004 - Comentado Filtro que existia no relacionamento entre
--              a tabela Produto e Produto Saldo (... and @dt_base>=getdate())
--              esse filtro não tem lógica, pois a data base passada nunca será
--              maior ou pelo menos igual a data atual. Devido a isso não estava
--              trazendo os dados da tabela Produto_Saldo. - ELIAS
--            - Ordenado por Código - ELIAS
-- 18/02/2004 - Colocado rotina de cálculo do Consumo Médio da mesma
--              forma como já existente na pr_consulta_consumo_medio - ELIAS
-- 08/03/2004 - Comentado forma de filtro do Produto_Fechamento que utilizando
--              as funções month e year estam causando duplicidade devido a 
--              existencia também de registros no produto fechamento no mes anterior - ELIAS
-- 18/03/2004 - Usado função para cálculo do consumo médio - Daniel C. Neto.
-- 16/04/2007 - Adicionando o Campo nm_fase_produto pelo sg_fase_produto - Anderson
-- 20/04/2007 - Simplificando o Inventário para consultar por Produto, Grupo, Fase, Status e Data - Anderson
-- 11.04.2008 - Mostrar a Marca do Produto - Carlos Fernandes
-- 26.08.2008 - Mostrar os produtos com Saldo Zerado Sim ou Não - Carlos Fernandes
-- 12.11.2008 - Verificação da Quantidade de Compras, se está somando Importação - Carlos Fernandes
-- 13.11.2008 - Quantidade de Produção - Carlos Fernandes
-- 31.03.2009 - Mostrar a Embalagem / Quantidade - Carlos Fernandes
-- 14.12.2009 - Ajuste do Filtro da Fase do Produto - Carlos Fernandes
-- 18.11.2010 - Fase do cadastro do Produto - Carlos Fernandes
-- 17.01.2011 - Novo Flag para Mostrar os produtos com Localização - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@ic_parametro         int         = 0, 
@dt_base              datetime    = '',        
@cd_grupo_produto     int         = 0,
@cd_serie_produto     int         = 0,
@cd_produto           int         = 0, -- Não vai ser mais usado.
@cd_fase_produto      int         = 0,
@cd_status_produto    int         = 0,
@cd_categoria_produto int         = 0,
@nm_filtro_produto    varchar(40) = '',
@ic_tipo_pesquisa     char(1)     = 'F',
@ic_saldo_zerado      char(1)     = 'S',
@ic_embalagem_unidade char(1)     = 'N',
@ic_tipo_saldo        char(1)     = 'F',  --(F) Fixa por Fase / (S) Saldo em Diversas Fases
@ic_localizacao       char(1)     = 'N'

AS

set @nm_filtro_produto = isnull(@nm_filtro_produto,'')

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Geral
-------------------------------------------------------------------------------
begin

  --select * from parametro_comercial

  declare @dt_inicial datetime
  declare @dt_final   datetime 
  declare @cd_ano     int
  declare @cd_mes     int

  -----------------------------------------------------
  -- Calcular as Datas
  -----------------------------------------------------
  SET DATEFORMAT ymd

  -- Decompor data final
  set @cd_ano = Year ( Getdate() )
  set @cd_mes = Month( Getdate() )

  -- Data Final do Período
  set @dt_final = dateadd( dd , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )

  -- Definir a data Inicial para o cálculo Trimestral
  set @dt_inicial = dateadd( mm , -2, @dt_final )
  set @cd_mes     = Month  ( @dt_inicial ) 
  set @cd_ano     = Year   ( @dt_inicial ) 
  set @dt_inicial = Cast   ( Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)

  select   
    p.cd_produto,
    p.cd_grupo_produto,
    dbo.fn_mascara_produto(p.cd_produto) 		as cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    f.nm_fase_produto,
    f.sg_fase_produto,
    um.sg_unidade_medida,
    isnull(ps.qt_minimo_produto,0) 			as qt_minimo_produto,
    --dbo.fn_consumo_medio(f.cd_fase_produto,p.cd_produto, @dt_inicial, @dt_final) as qt_consumo_produto, -- Causava lentidao na pesquisa, adicionei o trecho da funcao no left join abaixo - Anderson
    isnull(co.QtdeTrim,0)                               as qt_consumo_produto,
    isnull(ps.qt_saldo_reserva_produto,0)               as qt_saldo_reserva_produto,
    isnull(ps.qt_saldo_atual_produto,
    isnull(pf.qt_atual_prod_fechamento,0)) 		as qt_saldo_atual_produto,
    isnull(ps.qt_req_compra_produto,0) 			as qt_req_compra_produto,
    isnull(ps.qt_pd_compra_produto,0) 	+
    isnull(ps.qt_importacao_produto,0)  		as qt_ped_compra_produto,
    isnull(ps.qt_producao_produto,0)                    as qt_producao_produto,    

--select * from produto_saldo

    isnull(ps.qt_saldo_atual_produto,
    isnull(pf.qt_atual_prod_fechamento,0)) + 
    isnull(ps.qt_req_compra_produto,0)+ 
    isnull(ps.qt_pd_compra_produto,0  +
    isnull(ps.qt_producao_produto,0))       		as qt_total_saldo,

    p.cd_fase_produto_baixa,
    ps.cd_fase_produto,
    pf.cd_fase_produto                                  as cd_fase_fechamento,
    gp.nm_grupo_produto,
    cp.nm_categoria_produto,
    cast('' as varchar)                                 as nm_filtro_consulta,
    isnull(m.nm_marca_produto,'')                       as nm_marca_produto,

    rtrim(ltrim(dbo.fn_produto_localizacao(p.cd_produto,ps.cd_fase_produto))) as 'Localizacao',


  Embalagem = case when isnull(p.qt_multiplo_embalagem,0)>0
                then
                  case when (isnull(ps.qt_saldo_atual_produto,0)/p.qt_multiplo_embalagem)>=1 
                  then
                     cast( isnull(ps.qt_saldo_atual_produto,0)/p.qt_multiplo_embalagem as int )
                  else 
                    0.00 
                  end 
                else 
                  0.00
                end,

    Unidade = case when isnull(p.qt_multiplo_embalagem,0)>0 
              then
                case when isnull(ps.qt_saldo_atual_produto,0)/p.qt_multiplo_embalagem < 1 
                then
                  ps.qt_saldo_atual_produto  
                else
                 isnull(ps.qt_saldo_atual_produto,0)
                  - ( p.qt_multiplo_embalagem * cast(isnull(ps.qt_saldo_atual_produto,0) / p.qt_multiplo_embalagem as int ))
                end 
              else
                ps.qt_saldo_atual_produto  
              end
    
  into #Inventario_Produto

  from 
    Produto p                       with(nolock) 

  inner join Produto_saldo ps       with(nolock) on ps.cd_produto      = p.cd_produto and
                                                    ps.cd_fase_produto = 
                                                            case when isnull(@cd_fase_produto,0)=0
                                                            then
                                                              --ps.cd_fase_produto 
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                ps.cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end
                                                            else 
--                                                              @cd_fase_produto
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                @cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end

                                                            end

  left outer join  Produto_Fechamento pf with(nolock) on pf.cd_produto           = p.cd_produto and 
--                                                         pf.cd_fase_produto      = @cd_fase_produto and
                                                         pf.cd_fase_produto      = 
                                                            case when isnull(@cd_fase_produto,0)=0
                                                            then
--                                                              ps.cd_fase_produto 
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                ps.cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end

                                                            else 
                                                              --@cd_fase_produto
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                @cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end


                                                            end
                                                        and  
                                                        (pf.dt_produto_fechamento=@dt_base) --) ) 

  left outer join Unidade_medida um      with(nolock) on p.cd_unidade_medida = um.cd_unidade_medida
  left outer join Grupo_Produto gp       with(nolock) on p.cd_grupo_produto  = gp.cd_grupo_produto
  left outer join Fase_produto f         with(nolock) on f.cd_fase_produto   =
                                         -- isnull(ps.cd_fase_produto, pf.cd_fase_produto)
                                                            case when isnull(@cd_fase_produto,0)=0
                                                            then
                                                              --isnull(ps.cd_fase_produto,pf.cd_fase_produto) 
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                ps.cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end

                                                            else 
--                                                              @cd_fase_produto
                                                              case when isnull(p.cd_fase_produto_baixa,0)=0 then
                                                                @cd_fase_produto
                                                              else
                                                                p.cd_fase_produto_baixa
                                                              end

                                                            end

  left outer join Marca_Produto m        with(nolock) on m.cd_marca_produto      = p.cd_marca_produto  
  left outer join Categoria_Produto cp   with(nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join (

  select
    cd_produto,
    cd_fase_produto,
    ( QtdeProduto / 3 ) as 'QtdeTrim'
  from
  ( 
    select
      me.cd_produto,
      me.cd_fase_produto,
      sum( isnull( me.qt_movimento_estoque, 0 ) ) as 'QtdeProduto'
    from
      Movimento_Estoque me                   with (nolock)
      inner join Tipo_Movimento_Estoque tme  with (nolock)
        on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
    where
      ( me.dt_movimento_estoque >= @dt_inicial ) and
      ( me.dt_movimento_estoque < @dt_final ) and
      ( tme.ic_mov_tipo_movimento = 'S' ) and
      ( isnull(tme.ic_consumo_tipo_movimento,'S') = 'S' ) and
      ( tme.ic_operacao_movto_estoque in ('R','A') ) -- Movimenta o Real ou Ambos    
    group by
      me.cd_produto,
      me.cd_fase_produto

    union all
    
    select
      me.cd_produto,
      me.cd_fase_produto,
      sum( isnull( meCancDev.qt_movimento_estoque, 0 ) * ( case when meCancDev.cd_tipo_movimento_estoque = 13 then 1 else -1 end ) ) as 'QtdeProduto'
    from
      Movimento_Estoque me         with (nolock) inner join 
      Tipo_Movimento_Estoque tme   with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque inner join 
      Movimento_Estoque meCancDev  with (nolock) on  ( meCancDev.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque ) and
                                                     ( meCancDev.cd_documento_movimento = me.cd_documento_movimento ) and
                                                     ( meCancDev.cd_item_documento = me.cd_item_documento ) and
                                                     ( meCancDev.cd_produto = me.cd_produto ) and
                                                     ( meCancDev.cd_fase_produto = me.cd_fase_produto ) and
                                                     ( meCancDev.cd_tipo_movimento_estoque in (10,12,13)) and -- Devolução, Ativação e Cancelamento
                                                     ( meCancDev.cd_movimento_estoque > me.cd_movimento_estoque )
    where
      ( me.dt_movimento_estoque >= @dt_inicial ) and
      ( me.dt_movimento_estoque < @dt_inicial ) and
      ( tme.ic_mov_tipo_movimento = 'S' ) and
      ( isnull(tme.ic_consumo_tipo_movimento,'S') = 'S' ) and
      ( tme.ic_operacao_movto_estoque in ('R','A') ) -- Movimenta o Real ou Ambos    

    group by
      me.cd_produto,
      me.cd_fase_produto
 
  ) Consumo 
  ) co on co.cd_produto      = p.cd_produto and
          co.cd_fase_produto = f.cd_fase_produto
 
 where 
    (( IsNull(p.nm_fantasia_produto,'') like @nm_filtro_produto + '%' and @ic_tipo_pesquisa = 'F') or
     ( IsNull(p.cd_mascara_produto,'')  like @nm_filtro_produto + '%' and @ic_tipo_pesquisa = 'C')) and
    ( p.cd_status_produto     = @cd_status_produto    or isnull(@cd_status_produto,0) = 0 )   and 
    ( p.cd_categoria_produto  = @cd_categoria_produto or isnull(@cd_categoria_produto,0) = 0) and 

    --
    --A Fase de Baixa do Produto não pode ser fixa, porque o produto pode ter saldo em diversas Fases
    --14.04.2009
    --Liberado em 18.11.2010 - Carlos Fernandes
    
    ( isnull(p.cd_fase_produto_baixa,0) = case when @ic_tipo_saldo='F' then @cd_fase_produto
                                          else
                                            isnull(p.cd_fase_produto_baixa,0)
                                          end  
      or isnull(@cd_fase_produto,0)  = 0)

    and

    --

    ( p.cd_grupo_produto      = @cd_grupo_produto     or isnull(@cd_grupo_produto,0) = 0)

  order by 

    p.cd_grupo_produto, 
    p.cd_mascara_produto

  --Verifica se mostra os produtos com Saldo Zerdo

  if @ic_saldo_zerado = 'N'
  begin
    delete from #Inventario_Produto 
    where
      qt_saldo_atual_produto = 0

  end

--Verifica os produtos sem Localização

if @ic_localizacao = 'S'
begin

  delete from #Inventario_Produto 
  where
    Localizacao=''


end

-----------------------------------------------------------------------------------------------------------
--Mostra os dados da tabela 
-----------------------------------------------------------------------------------------------------------

  select
    *,
    cast( dbo.fn_strzero(Embalagem,6) as varchar) + ' + ' + 
    cast( dbo.fn_strzero(Unidade,3)   as varchar)              as nm_embalagem_unidade

  from
    #Inventario_Produto

  order by 
    cd_grupo_produto, 
    cd_mascara_produto


end


--select * from produto_saldo

