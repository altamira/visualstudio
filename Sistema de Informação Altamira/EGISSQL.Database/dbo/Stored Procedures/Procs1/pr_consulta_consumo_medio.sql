
CREATE PROCEDURE pr_consulta_consumo_medio
---------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : ?
--Banco de Dados  : EGISSQL
--Objetivo        : Realiza a consulta do consumo médio do produto em
--									uma dada fase.							
--Data            : ?
--Atualizado      : 05.01.2004 - Fabio - Correção na formatação da data inicial
-- 17/03/2004 - Usado função para consumo médio trimestral - Daniel C. Neto.
-- 17/03/2004 - Recálculo da quantidade de dias - Daniel C. Neto.
-- 25/05/2004 - Otimizando Perfomance, criada duas sessões para evitar or no filtro - ELIAS
-- 01.11.2007 - Verificação lentidão - Carlos Fernandes
-- 20.08.2008 - Acertos Diversos - Carlos Fernandes
-- 23.06.2010 - Ajustes Diversos / Saldo - Carlos Fernandes
--------------------------------------------------------------------
@ic_parametro        int = 0, 
@cd_produto          int = 0,
@cd_fase_produto     int = 0,
@dias                int = 0

AS

declare @data_inicial datetime
declare @data_final   datetime 
declare @cd_ano       int
declare @cd_mes       int

  -----------------------------------------------------
  -- Calcular as Datas
  -----------------------------------------------------
  SET DATEFORMAT ymd

  SET NOCOUNT ON

  -- Decompor data final
  set @cd_ano = Year( Getdate() )
  set @cd_mes = Month( Getdate() )

  -- Data Final do Período
  set @data_final = dateadd( dd , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )

--   print 'Dt. Final'
--   print @data_final

  -- Definir a data Inicial para o cálculo Trimestral
  set @data_inicial = dateadd( mm , -2, @data_final )
  set @cd_mes       = Month( @data_inicial ) 
  set @cd_ano       = Year( @data_inicial ) 
  set @data_inicial = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)

--   print 'Dt. Inicial Calc. Trim.'
--   print @data_inicial

--select @data_inicial
--select @data_final


--Busca a Fase do Produto de Baixa

if @cd_produto<>0 and @cd_fase_produto<>0 
begin

  select
    @cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)>0 then
                          p.cd_fase_produto_baixa
                       else
                          @cd_fase_produto
                       end
  from
    produto p with (nolock)
  where
    p.cd_produto = @cd_produto 

end

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Saldo do Estoque do Produto
-------------------------------------------------------------------------------
begin

  if (isnull(@cd_produto,0) = 0)  --Fabio: Adicionado para evitar processamento desnecessário  
    select 
      0    as cd_produto,
      ''   as cd_mascara_produto,
      ''   as Produto,
      ''   as Produto_Fantasia, 
      ''   as Marca, 
      0.00 as Peso_Bruto,
      0.00 as Peso_Liquido,
      ''   as Grupo,
      ''   as Mascara_grupo,
      ''   as Medida,
      ''   as Serie,
      0.00      as Saldo_Estoque_Atual,
      0.00      as Saldo_Estoque_Disponivel,
      getdate() as Data_Saldo_Atual,
      0.00      as Saldo_Estoque_Min,
      0.00      as Saldo_Estoque_Terceiro,
      0.00      as Saldo_Estoque_Consignacao,
      0.00      as Saldo_Estoque_Requisicao,
      0.00      as Saldo_Estoque_Pedido_Compra,
      0.00      as total    
  
  else if (isnull(@cd_fase_produto,0) = 0)    
    -- QUANDO NÃO INFORMADA FASE
    select 
      p.cd_produto,
      p.cd_mascara_produto,
      p.nm_produto                 as Produto,
      p.nm_fantasia_produto        as Produto_Fantasia, 
      p.nm_marca_produto           as Marca, 
      p.qt_peso_liquido            as Peso_Bruto,
      p.qt_peso_bruto              as Peso_Liquido,
      gp.nm_grupo_produto          as Grupo,
      gp.cd_mascara_grupo_produto  as Mascara_grupo,
      um.nm_unidade_medida         as Medida,
      sp.nm_serie_produto          as Serie,
      ps.qt_saldo_atual_produto    as Saldo_Estoque_Atual,
      ps.qt_saldo_reserva_produto  as Saldo_Estoque_Disponivel,
      ps.dt_atual_produto          as Data_Saldo_Atual,
      ps.qt_minimo_produto         as Saldo_Estoque_Min,
      ps.qt_terceiro_produto       as Saldo_Estoque_Terceiro,
      ps.qt_consig_produto         as Saldo_Estoque_Consignacao,
      ps.qt_req_compra_produto     as Saldo_Estoque_Requisicao,
      ps.qt_pd_compra_produto      as Saldo_Estoque_Pedido_Compra,
      dbo.fn_consumo_medio(@cd_fase_produto, 
                           @cd_produto, 
                           @data_inicial, 
                           @data_final) as total  
    from produto p              with (nolock)
    inner join produto_saldo ps with (nolock)        on p.cd_produto         = @cd_produto   and
                                                        ps.cd_produto        = p.cd_produto  and
                                                        ps.cd_fase_produto   = case when 
                                                                                isnull(p.cd_fase_produto_baixa,0)>0 then
                                                                                  p.cd_fase_produto_baixa
                                                                                else
                                                                                  ps.cd_fase_produto
                                                                                end

    left outer join unidade_medida um  with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join grupo_produto gp with (nolock)   on gp.cd_grupo_produto  = p.cd_grupo_produto
    left outer join serie_produto sp with (nolock)   on sp.cd_serie_produto  = p.cd_serie_produto

  else
    -- QUANDO É INFORMADA A FASE
    select top 1
      p.cd_produto,
      p.cd_mascara_produto,
      p.nm_produto                 as Produto,
      p.nm_fantasia_produto        as Produto_Fantasia, 
      p.nm_marca_produto           as Marca, 
      p.qt_peso_liquido            as Peso_Bruto,
      p.qt_peso_bruto              as Peso_Liquido,
      gp.nm_grupo_produto          as Grupo,
      gp.cd_mascara_grupo_produto  as Mascara_grupo,
      um.nm_unidade_medida         as Medida,
      sp.nm_serie_produto          as Serie,
      ps.qt_saldo_atual_produto    as Saldo_Estoque_Atual,
      ps.qt_saldo_reserva_produto  as Saldo_Estoque_Disponivel,
      ps.dt_atual_produto          as Data_Saldo_Atual,
      ps.qt_minimo_produto         as Saldo_Estoque_Min,
      ps.qt_terceiro_produto       as Saldo_Estoque_Terceiro,
      ps.qt_consig_produto         as Saldo_Estoque_Consignacao,
      ps.qt_req_compra_produto     as Saldo_Estoque_Requisicao,
      ps.qt_pd_compra_produto      as Saldo_Estoque_Pedido_Compra,
      dbo.fn_consumo_medio(@cd_fase_produto, 
                           @cd_produto, 
                           @data_inicial, 
                           @data_final) as total  
    from produto p              with (nolock, index(pk_produto))
    inner join produto_saldo ps with (nolock, index(pk_produto_saldo))   
    on p.cd_produto       = @cd_produto  and
       ps.cd_produto      = @cd_produto and
       ps.cd_fase_produto = @cd_fase_produto
    left outer join unidade_medida um  with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join grupo_produto gp with (nolock)   on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join serie_produto sp with (nolock)   on sp.cd_serie_produto = p.cd_serie_produto   

end

SET NOCOUNT OFF
  
