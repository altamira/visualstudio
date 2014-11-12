
CREATE PROCEDURE pr_analise_previsao_venda
@cd_vendedor  int = 0, --Vendedor
@cd_cliente   int = 0,
@cd_pais      int = 0,
@ic_parametro char(2) = 'VC' --VC Vendedor Cliente, PC Pais Cliente, P Pais, T Todos
AS

--
--Atualização Potencial / Programado
--
--Print @ic_parametro

update
  Previsao_Venda
set
  qt_potencial_previsao  = ( select sum ( isnull(qt_potencial,0) ) from previsao_venda_composicao apvc where apvc.cd_previsao_venda = pv.cd_previsao_venda ),
  qt_programado_previsao = ( select 
                               sum( isnull(qt_jan_previsao,0) +
                                    isnull(qt_fev_previsao,0) +
                                    isnull(qt_mar_previsao,0) +
                                    isnull(qt_abr_previsao,0) +
                                    isnull(qt_mai_previsao,0) +
                                    isnull(qt_jun_previsao,0) +
                                    isnull(qt_jul_previsao,0) +
                                    isnull(qt_ago_previsao,0) +
                                    isnull(qt_set_previsao,0) +
                                    isnull(qt_out_previsao,0) +
                                    isnull(qt_nov_previsao,0) +
                                    isnull(qt_dez_previsao,0) 
                                    ) 
                            from Previsao_Venda_Composicao apvc where apvc.cd_previsao_venda = pv.cd_previsao_venda )

from
  Previsao_Venda pv, Previsao_Venda_Composicao pvc
where
  pv.cd_previsao_venda = pvc.cd_previsao_venda


SELECT
  pv.cd_previsao_venda,
  pv.cd_vendedor,
  v.nm_fantasia_vendedor,
  pv.cd_cliente,
  c.nm_fantasia_cliente,
  pv.cd_grupo_produto,
  gp.nm_fantasia_grupo_produto,
  pv.cd_categoria_produto,
  cp.sg_categoria_produto,
  pv.cd_produto,
  p.nm_fantasia_produto,
  pv.cd_produto_desenv,
  pd.nm_produto_desenv                   as nm_fantasia_produto_desenv,
  pv.dt_ultima_compra_cliente,
  isnull(pv.qt_anterior_previsao,0)      as qt_anterior_previsao,
  isnull(pv.qt_produto_previsao_venda,0) as qt_produto_previsao_venda,
  isnull(pv.qt_potencial_previsao,0)     as qt_potencial_previsao,

  --soma a quantidade na tabela de composição
  --qt_potencial_previsao = ( select sum(isnull(qt_potencial,0)) from Previsao_Venda_Composicao pvc where pvc.cd_previsao_venda = pv.cd_previsao_venda ),

  --isnull(pv.qt_programado_previsao,0)    as qt_programado_previsao,
  --soma a quantidade na tabela de composição

  qt_programado_previsao = ( select 
                               sum( isnull(qt_jan_previsao,0) +
                                    isnull(qt_fev_previsao,0) +
                                    isnull(qt_mar_previsao,0) +
                                    isnull(qt_abr_previsao,0) +
                                    isnull(qt_mai_previsao,0) +
                                    isnull(qt_jun_previsao,0) +
                                    isnull(qt_jul_previsao,0) +
                                    isnull(qt_ago_previsao,0) +
                                    isnull(qt_set_previsao,0) +
                                    isnull(qt_out_previsao,0) +
                                    isnull(qt_nov_previsao,0) +
                                    isnull(qt_dez_previsao,0) 
                                    ) 
                            from Previsao_Venda_Composicao pvc where pvc.cd_previsao_venda = pv.cd_previsao_venda ),

  --select * from previsao_venda_composicao
  case  
  when pv.qt_potencial_previsao > 0	then
      isnull( (pv.qt_programado_previsao / pv.qt_potencial_previsao)*100,0)
  else
     0
  end as 'participacao',
  --(SELECT a.qt_programado_previsao) FROM Previsao_Venda a )) * 100,0) as 'participacao',
  pv.cd_usuario,
  pv.dt_usuario,
  isnull(pv.qt_ranking_cliente,0) as qt_ranking_cliente,
  pv.cd_fase_produto,
  pv.dt_inicio_previsao_venda,
  pv.dt_final_previsao_venda,
  ra.nm_ramo_atividade,
  pv.cd_moeda,
  Pais.nm_pais,
  pv.cd_pais
FROM 
  Previsao_Venda pv with (nolock) 
  LEFT OUTER JOIN
  Vendedor v
  ON pv.cd_vendedor = v.cd_vendedor
  LEFT OUTER JOIN
  Cliente c
  ON pv.cd_cliente = c.cd_cliente
  LEFT OUTER JOIN
  Grupo_Produto gp
  ON pv.cd_grupo_produto = gp.cd_grupo_produto
  LEFT OUTER JOIN 
  Categoria_Produto cp
  ON 
  pv.cd_categoria_produto = cp.cd_categoria_produto
  LEFT OUTER JOIN 
  Produto p
  ON
  pv.cd_produto = p.cd_produto
  LEFT OUTER JOIN
  Produto_Desenvolvimento pd
  ON
  pv.cd_produto_desenv = pd.cd_produto_desenv
  LEFT OUTER JOIN
  Ramo_Atividade ra
  ON
  c.cd_ramo_atividade = ra.cd_ramo_atividade
  left join Pais on (pais.cd_pais = pv.cd_pais)
WHERE
   isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
   isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente  end and
   isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais     end and
   1  =
	Case @ic_parametro
		when 'VC' then
                        --Verificar internamente na GBS
                        --Parametrização quando o uso for sem o cliente.

			case when isnull(pv.cd_vendedor,0) > 0 or isnull(pv.cd_cliente,0) > 0 then	
				1
			else
				0
			end
		when 'PC' then
			case when isnull(pv.cd_pais,0) > 0 and isnull(pv.cd_cliente,0) > 0 and isnull(pv.cd_vendedor,0) = 0 then	
				1
			else
				0
			end
		when 'P' then
			case when isnull(pv.cd_vendedor,0) = 0 and isnull(pv.cd_cliente,0) = 0 then	
				1
			else
				0
			end
		else 
			1
	end

ORDER BY
   Pais.nm_pais,
   v.nm_fantasia_vendedor,
   c.nm_fantasia_cliente

