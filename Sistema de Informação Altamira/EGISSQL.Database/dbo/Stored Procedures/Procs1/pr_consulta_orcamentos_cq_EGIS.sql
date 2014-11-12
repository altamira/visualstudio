
--pr_consulta_orcamentos_cq_EGIS
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio
--Retorno do Cadastro de Orçamentos Realizados e Em Aberto
--Data         : 21.11.2001
--Atualizado   : 16.07.2002 Colunas RepNet e Orçamentista
--             : 19.07.2002 Várias colunas para igualar com Caract. Técnicas
--             : 12.11.2002 Lucio 
--               15.12.2004 Lucio
--             : 22.06.2005 Acerto da Couna Orçamentista e Inclusão Data do Item
-----------------------------------------------------------------------------------
CREATE procedure pr_consulta_orcamentos_cq_EGIS

@dt_inicial datetime,
@dt_final   datetime

as

select a.cd_consulta,
       a.cd_item_consulta,
       d.dt_item_consulta,
       a.nm_produto_cliente,
       a.dt_orcamento_consulta  as 'DataOrcado',
       a.dt_orcamento_consulta  as 'HoraOrcado',
       a.qt_peso_bruto_string,
       a.qt_cavidade_string,
       a.qt_bucha_consulta,
       a.vl_total_orcamento_cq,
       a.vl_porta_molde_cq,
       a.vl_acessorios_orcamento,
       a.ic_liberado_orcamento,
       a.dt_liberacao_orcamento as 'DataLiberado',
       a.dt_liberacao_orcamento as 'HoraLiberado',
       a.cd_ordem_servico_cliente,
       a.nm_comp_material_plastico,
       ic_desenho_produto = 
       case when a.ic_desenho_produto = 'D' then 'Desenho'
            when a.ic_desenho_produto = 'S' then 'Desenho' -- Campo antigo (antes S ou N)
            when a.ic_desenho_produto = 'C' then 'Croqui '
            when a.ic_desenho_produto = 'N' then 'Nenhum '
       else 'Nenhum ' end,
       a.nm_caminho_desenho,
       isnull(a.ic_amostra_consulta,'N') as 'ic_amostra_consulta',
       a.qt_distancia_centros   as 'qt_distancia_X',
       a.qt_distancia_centros_y as 'qt_distancia_Y',
       ic_carga_consulta =
       case when a.ic_carga_consulta = 'S' then 'Nenhuma' else 'Sim    ' end,
       a.pc_talco_consulta,
       a.pc_fibra_vidro_consulta,
       a.ic_troca_cor_consulta,
       a.nm_caminho_desenho_molde as 'NumeroDesenho',
       ic_elimina_galho_consulta =
       case when a.ic_elimina_galho_consulta = 'T' then 'Total  ' else 'Parcial' end,
       a.qt_espessura_molde_cq,
       a.qt_largura_molde_cq,
       a.qt_comprimento_molde_cq,
       a.qt_zonas_controlador,
       a.qt_comprimento_bico,
       f.nm_fantasia_cliente       as 'fan_cli',
       b.cd_vendedor               as 'vdext02',
       b.cd_consulta_representante as 'ncrep',
       c.sg_material_plastico      as 'Material',
       g.nm_fantasia_usuario       as 'usuorc',
       d.cd_item_consulta_represe  as 'itcrep',
       e.nm_tipo_sistema           as 'TipoSistema',
       a.dt_orcamento_consulta,
       a.dt_liberacao_orcamento

into #TmpOrcamentos

from orcamento_cq a

left outer join consulta b on
a.cd_consulta = b.cd_consulta

left outer join cliente f on
b.cd_cliente = f.cd_cliente

left outer join material_plastico c on
a.cd_material_plastico = c.cd_material_plastico

inner join consulta_itens d on
a.cd_consulta = d.cd_consulta and
a.cd_item_consulta = d.cd_item_consulta

left outer join EgisAdmin.dbo.Usuario g on
a.cd_usuario = g.cd_usuario

left outer join tipo_sistema_cq e on
a.cd_tipo_sistema = e.cd_tipo_sistema 

where ((a.dt_liberacao_orcamento is null) or
       (a.dt_liberacao_orcamento between @dt_inicial and
                                         @dt_final))

select 
   *
from 
   #TmpOrcamentos

order by DataLiberado desc,
         cd_consulta desc

