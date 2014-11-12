create procedure pr_consulta_mapa_servico_especial
------------------------------------------------------------------
--pr_consulta_mapa_servico_especial
------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EgisSQL
--Objetivo		: Mapa de Serviços Especial p/ Processo de Fabricação
--Data			: 15.06.2004
--Alteração		: 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--Alteração		: 26/02/2007 - Correções Diversas - Anderson
-- 15.11.2008 - Carlos Fernandes
-- 20.05.2009 - Produto da Ordem de Produção - Carlos Fernandes
------------------------------------------------------------------------------
@cd_servico_especial int = 0,
@dt_inicial          datetime = '',
@dt_final            datetime = ''

as

  select
    0                                   as ic_selecao,                    
    f.nm_fantasia_fornecedor,
    se.nm_servico_especial,
    pp.dt_processo,
    ppc.cd_processo,
    isnull(ppc.cd_seq_processo,0)       as cd_seq_processo,
    isnull(ppc.qt_dia_processo,0)       as qt_dia_processo,
    isnull(ppc.qt_hora_real_processo,0) as qt_hora_real_processo,
    op.nm_operacao,
    ppc.nm_obs_item_processo,
    pp.cd_pedido_venda,
    pp.cd_item_pedido_venda,
    pj.nm_projeto,
    pc.nm_item_desenho_projeto, --projeto_composicao
    pcomp.nm_item_desenho_projeto +'/'+ cast(pp.cd_projeto_material as varchar) as 'Material',
    DATEADD(day, isnull(ppc.qt_dia_processo,0), pp.dt_processo)                 as 'DataPrevista',
    pp.qt_planejada_processo,
    c.nm_fantasia_cliente,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida
  from
    Processo_Producao pp                       with (nolock) 
    left join Processo_Producao_Composicao ppc with (nolock) on pp.cd_processo          = ppc.cd_processo
    left join Servico_Especial se              with (nolock) on ppc.cd_servico_especial = se.cd_servico_especial
    left join Fornecedor f                     with (nolock) on ppc.cd_fornecedor       = f.cd_fornecedor
    left join Operacao op                      with (nolock) on ppc.cd_operacao         = op.cd_operacao
    left join Projeto pj                       with (nolock) on pp.cd_projeto           = pj.cd_projeto
    left join projeto_composicao pc            with (nolock) on pp.cd_projeto           = pc.cd_projeto and 
                                                                pp.cd_item_projeto      = pc.cd_item_projeto
    left join Projeto_Composicao pcomp         with (nolock) on pcomp.cd_projeto        = pp.cd_projeto and
                                                                pcomp.cd_item_projeto   = pp.cd_item_projeto
    left join Produto p                        with (nolock) on p.cd_produto            = pp.cd_produto

    left join Pedido_Venda pv                  with (nolock) on pv.cd_pedido_venda      = pp.cd_pedido_venda
    left join Cliente c                        with (nolock) on c.cd_cliente            = pv.cd_cliente
    left join Unidade_Medida um                with (nolock) on um.cd_unidade_medida    = p.cd_unidade_medida

--select * from processo_padrao

   where
     isnull(ppc.cd_servico_especial,0) = 
      case 
        when isnull(@cd_servico_especial,0) = 0
          then isnull(ppc.cd_servico_especial,0)
          else @cd_servico_especial
      end and 
     isnull(ppc.cd_servico_especial,0) > 0 and
     pp.dt_processo between @dt_inicial and @dt_final

  order by
    f.nm_fantasia_fornecedor,
    se.nm_servico_especial,
    pp.dt_processo,
    ppc.cd_processo,
    ppc.cd_item_processo

