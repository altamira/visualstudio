
CREATE PROCEDURE pr_analise_importacao_reposicao_estoque

@PeriodoAnalise   Int = 0,
@Giro             Int = 0,
@MinimoDias       Int = 0,
@MaximoDias       Int = 0,
@Fase             Int = 0,
@PrazoImpAerea    Int = 0,
@PrazoImpMaritima Int = 0,
@Produto	  varchar(30) = '',
@AbaixoMinimo	  char(1) = 'N'

AS

  set nocount on

  --Pegando data de hoje
  declare @Hoje datetime
  set @Hoje = convert(varchar,getdate(),101)

  --Buscando moedas e última cotação
  select
    m.cd_moeda,
    m.sg_moeda,
    (select top 1 vl_moeda from valor_moeda where cd_moeda = m.cd_moeda and isnull(vl_moeda,0) > 0 order by dt_moeda desc) as vl_moeda
  into
    #Moeda
  from
    Moeda m

  --Buscando dados dos produtos para análise
  --Sistema deve buscar todos os produtos existentes na tabela produto_saldo da fase informada pelo usuário
  select
    p.cd_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    pa.sg_pais,
    um.sg_unidade_medida,
    case when isnull(p.qt_multiplo_embalagem,1) = 0 then 
      1 
    else
      isnull(p.qt_multiplo_embalagem,1) 		
    end 					as qt_multiplo_embalagem,
    case when isnull(p.vl_fator_conversao_produt,1) = 0 then
      1
    else
      isnull(p.vl_fator_conversao_produt,1) 	
    end 					as vl_conversao,

    isnull(ps.qt_minimo_produto,0) 		as qt_minimo,
    isnull(ps.qt_saldo_atual_produto,0) 	as qt_atual,
    isnull(ps.qt_saldo_reserva_produto,0)	as qt_disponivel,
    m.sg_moeda,
    m.vl_moeda,
    isnull(i.vl_produto_importacao,0)		as vl_fob,
    isnull(pc.vl_custo_contabil_produto,0)	as vl_custo,
    isnull(psub.nm_fantasia_produto,'.')	as nm_produto_substituto,
    p.cd_substituto_produto			as cd_produto_substituto,
    pa.cd_pais,
    um.cd_unidade_medida,
    p.cd_mascara_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto   
  into
    #Produto
  from
    Produto			p	inner join
    Produto_Saldo		ps	on p.cd_produto 		= ps.cd_produto 	left outer join
    Produto_Importacao		i	on p.cd_produto			= i.cd_produto 		left outer join
    Pais			pa	on isnull(i.cd_pais_procedencia,
                                                  p.cd_origem_produto)	= pa.cd_pais		left outer join
    Unidade_Medida		um	on p.cd_unidade_medida		= um.cd_unidade_medida	left outer join
    #Moeda			m	on isnull(i.cd_moeda,
                                                  pa.cd_moeda)		= m.cd_moeda		left outer join
    Status_Produto		sp	on p.cd_status_produto		= sp.cd_status_produto	left outer join
    Produto_Custo		pc	on p.cd_produto			= pc.cd_produto		left outer join
    Produto			psub	on p.cd_substituto_produto	= psub.cd_produto
  where
    ps.cd_fase_produto = @Fase and
    (exists (select 0 from movimento_estoque me, tipo_movimento_estoque tme
             where me.cd_produto = p.cd_produto
               and me.cd_tipo_movimento_estoque  = tme.cd_tipo_movimento_estoque
               and tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto'
               and me.dt_movimento_estoque between DATEADD(mm,-@PeriodoAnalise+1,@Hoje) and @Hoje
               and me.cd_fase_produto 		 = @Fase
               and tme.ic_mov_tipo_movimento 	 = 'S'
               and me.cd_tipo_documento_estoque <> 1) or
             isnull(ps.qt_minimo_produto,0) > 0) and
    sp.ic_bloqueia_uso_produto = 'N' and
    isnull(pc.ic_estoque_produto,'S') = 'S'
    and p.nm_fantasia_produto like @Produto + '%'
    and (cast(isnull(ps.qt_saldo_reserva_produto,0) as money) < case when @AbaixoMinimo = 'S' then isnull(ps.qt_minimo_produto,0) else 999999 end and 
         isnull(ps.qt_minimo_produto,0) > case when @AbaixoMinimo = 'S' then 0 else -999999 end )

  --Buscando material em transito requisição
  select
    rci.cd_produto,
    sum(rci.qt_item_requisicao_compra*p.vl_conversao) as qt_requisitado
  into
    #Requisitado
  from
    Requisicao_Compra_Item 	rci 	inner join
    #Produto			p	on rci.cd_produto = p.cd_produto
  where
    not exists (select 0 from pedido_compra_item where cd_requisicao_compra = rci.cd_requisicao_compra and cd_requisicao_compra_item = rci.cd_item_requisicao_compra)
    and not exists (select 0 from pedido_importacao_item where cd_requisicao_compra = rci.cd_requisicao_compra and cd_item_requisicao_compra = rci.cd_item_requisicao_compra)
    and isnull(rci.cd_produto,0) > 0
  group by
    rci.cd_produto

  --Buscando material em pedido de importacao
  select
    pii.cd_produto,
    sum(pii.qt_saldo_item_ped_imp*p.vl_conversao) as qt_importado
  into
    #Importado
  from
    Pedido_Importacao_Item 	pii 	inner join
    #Produto			p	on pii.cd_produto = p.cd_produto
  where
    isnull(pii.cd_produto,0) > 0
    and pii.dt_cancel_item_ped_imp is null
    and isnull(pii.qt_saldo_item_ped_imp,0) > 0
  group by
    pii.cd_produto

  --Buscando material em pedido de compra
  select
    pci.cd_produto,
    sum(pci.qt_saldo_item_ped_compra*p.vl_conversao) as qt_comprado
  into
    #Comprado
  from
    Pedido_Compra_Item 		pci 	inner join
    #Produto			p	on pci.cd_produto = p.cd_produto
  where
    isnull(pci.cd_produto,0) > 0
    and pci.dt_item_canc_ped_compra is null
    and isnull(pci.qt_saldo_item_ped_compra,0) > 0
  group by
    pci.cd_produto

  --Pegando informações de giro, freqência e clientes
  select
    me.cd_produto,
    sum(me.qt_movimento_estoque) / @PeriodoAnalise 	as qt_media_mensal,
    count(distinct month(me.dt_movimento_Estoque)) 	as qt_frequencia,
    count(distinct me.nm_destinatario) 			as qt_cliente
  into
    #Estoque
  from
    Movimento_Estoque 		me 	inner join
    Tipo_Movimento_Estoque 	tme	on me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque inner join
    #Produto			p	on me.cd_produto = p.cd_produto
  where
    me.dt_movimento_estoque between DATEADD(mm,-@PeriodoAnalise+1,@Hoje) and @Hoje
    and tme.nm_atributo_produto_saldo 	= 'qt_saldo_atual_produto'
    and tme.ic_mov_tipo_movimento 	= 'S'
    and me.cd_fase_produto 		= @Fase
    and me.cd_tipo_documento_estoque <> 1
  group by
    me.cd_produto
  order by
    4 desc

  --Unificando tabelas
  select
    p.cd_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    p.sg_pais,
    p.sg_unidade_medida,
    p.qt_multiplo_embalagem,
    p.vl_conversao,
    p.qt_minimo,
    p.qt_atual,
    p.qt_disponivel,

    isnull(e.qt_media_mensal,0) 			as qt_media_mensal,
    isnull(e.qt_frequencia,0) 				as qt_frequencia,
    isnull(e.qt_cliente,0) 				as qt_cliente,

    case when isnull(e.qt_media_mensal,0) = 0 then 
      0
    else
      p.qt_disponivel / e.qt_media_mensal * 30 
    end 						as qt_duracao_disponivel,

    isnull(r.qt_requisitado,0)				as qt_requisitado,
    isnull(i.qt_importado,0)				as qt_importado,
    isnull(c.qt_comprado,0)				as qt_comprado,

    isnull(r.qt_requisitado,0) +
    isnull(i.qt_importado,0)   +
    isnull(c.qt_comprado,0)				as qt_transito,

    case when isnull(e.qt_media_mensal,0) = 0 then 
      0
    else
      (isnull(r.qt_requisitado,0) + isnull(i.qt_importado,0) + isnull(c.qt_comprado,0)) 
      / e.qt_media_mensal * 30 
    end 						as qt_duracao_transito,

    p.sg_moeda,
    p.vl_moeda,
    p.vl_fob,
    p.vl_custo,
    p.cd_produto_substituto,
    p.nm_produto_substituto,
    p.cd_pais,
    p.cd_unidade_medida,
    p.cd_mascara_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto   
  into
    #Importar
  from
    #Produto			p	left outer join
    #Estoque			e	on p.cd_produto			= e.cd_produto left outer join
    #Requisitado		r	on p.cd_produto			= r.cd_produto left outer join
    #Importado			i	on p.cd_produto			= i.cd_produto left outer join
    #Comprado			c	on p.cd_produto			= c.cd_produto
  where
    (e.qt_frequencia between @Giro and @PeriodoAnalise and
    
    (
    --Duração disponível
    case when isnull(e.qt_media_mensal,0) = 0 then 
      0
    else
      p.qt_disponivel / e.qt_media_mensal * 30 
    end
    +
    --Duração transito
    case when isnull(e.qt_media_mensal,0) = 0 then 
      0
    else
      (isnull(r.qt_requisitado,0) + isnull(i.qt_importado,0) + isnull(c.qt_comprado,0)) 
      / e.qt_media_mensal * 30 
    end 		
    ) < @MaximoDias) or

    (p.qt_disponivel + (isnull(r.qt_requisitado,0) + isnull(i.qt_importado,0) + isnull(c.qt_comprado,0)) < p.qt_minimo and
     p.qt_minimo > 0)

  select
    --Verificando se o aéreo + maritmo é igual a zero e se tem mínimo para importar
    --Caso tenha importar mínimo - disponível + transito

      case when

        (case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) < (@PrazoImpMaritima - @PrazoImpAerea) then
          (@PrazoImpMaritima - (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) - @PrazoImpAerea)
          * qt_media_mensal / 30 
        else
          0
        end)
        +
        (case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) between @PrazoImpAerea and @MaximoDias then
        (@MaximoDias - (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) )
        * qt_media_mensal / 30
        else
          case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) < @PrazoImpAerea then
            (@MaximoDias - @PrazoImpAerea)
	    * qt_media_mensal / 30
          else
            0
          end
        end) = 0 and qt_minimo > 0 then 

          isnull(qt_minimo,0) - isnull(qt_disponivel,0) + isnull(qt_transito,0)
      else

         case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) < (@PrazoImpMaritima - @PrazoImpAerea) then
          (@PrazoImpMaritima - (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) - @PrazoImpAerea)
          * qt_media_mensal / 30 
        else
          0
        end 
      end / vl_conversao as qt_aereo,


      case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) between @PrazoImpAerea and @MaximoDias then
        (@MaximoDias - (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) )
        * qt_media_mensal / 30
      else
        case when (isnull(qt_duracao_disponivel,0) + isnull(qt_duracao_transito,0)) < @PrazoImpAerea then
          (@MaximoDias - @PrazoImpAerea)
	  * qt_media_mensal / 30
        else
          0
        end
      end / vl_conversao as qt_maritmo,

    cd_produto,
    nm_fantasia_produto,
    nm_produto,
    sg_pais,
    sg_unidade_medida,
    qt_multiplo_embalagem,
    vl_conversao,
    qt_minimo,
    qt_atual,
    qt_disponivel,
    qt_media_mensal,
    qt_frequencia,
    qt_cliente,
    qt_duracao_disponivel,
    qt_requisitado,
    qt_importado,
    qt_comprado,
    qt_transito,
    qt_duracao_transito,
    sg_moeda,
    vl_moeda,
    vl_fob,
    vl_custo,
    cd_produto_substituto,
    nm_produto_substituto,
    cd_pais,
    cd_unidade_medida,
    cd_mascara_produto,
    qt_peso_liquido,
    qt_peso_bruto   
  into
    #ImportarFinal
  from
    #Importar

  select
    --Convertendo fator de conversão e múltiplo de embalagem
--     case when cast(round(qt_aereo,0) as int) % cast(qt_multiplo_embalagem as int) > 0 then 
--       qt_multiplo_embalagem - (cast(round(qt_aereo,0) as int) % cast(qt_multiplo_embalagem as int)) + cast(round(qt_aereo,0) as int)
--     else
--       cast(round(qt_aereo,0) as int)
--     end as qt_aereo,

    cast(round(I.qt_aereo,0) as int) as qt_aereo,
  
    case when cast(round(I.qt_maritmo,0) as int) % cast(I.qt_multiplo_embalagem as int) > 0 then 
      I.qt_multiplo_embalagem - (cast(round(I.qt_maritmo,0) as int) % cast(I.qt_multiplo_embalagem as int)) + cast(round(I.qt_maritmo,0) as int)
    else
      cast(round(I.qt_maritmo,0) as int)
    end as qt_maritmo,

    I.cd_produto,
    I.nm_fantasia_produto,
    I.cd_produto_substituto,
    I.nm_produto_substituto,
    I.nm_produto,
    I.sg_pais,
    I.sg_unidade_medida,
    I.qt_multiplo_embalagem,
    I.vl_conversao,
    I.qt_minimo,
    I.qt_atual,
    I.qt_disponivel,
    I.qt_media_mensal,
    Cast(I.qt_frequencia as Varchar(5)) + '/' + Cast(@PeriodoAnalise as Varchar(5)) as qt_frequencia,
    I.qt_cliente,
    I.qt_duracao_disponivel,
    I.qt_requisitado,
    I.qt_importado,
    I.qt_comprado,
    I.qt_transito,
    I.qt_duracao_transito,
    I.sg_moeda,
    I.vl_moeda,
    I.vl_fob,
    case when isnull(I.vl_fob,0) = 0 then
      I.vl_custo
    else
      I.vl_moeda * I.vl_fob
    end as vl_custo,
    0 as 'Selecionado',
    I.cd_pais,
    I.cd_unidade_medida,
    I.cd_mascara_produto,
    I.qt_peso_liquido,
    I.qt_peso_bruto,
    0 as QtdAnt,   
    IsNull(cf.ic_licenca_importacao,'N') as LicencaImportacao
  from
    #ImportarFinal I
    left outer join Produto_Fiscal pf with (nolock) on pf.cd_produto = I.cd_produto
    left outer join Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  order by
    IsNull(cf.ic_licenca_importacao,'N'),
    sg_pais desc,
    nm_fantasia_produto

  

