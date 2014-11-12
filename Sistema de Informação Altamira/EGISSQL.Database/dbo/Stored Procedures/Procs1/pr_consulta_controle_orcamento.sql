
CREATE PROCEDURE pr_consulta_controle_orcamento
----------------------------------------------------------------------------------------------------------
--GBS - Global Business Sollution              2002
----------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Lucio Saraiva
--Banco de Dados   : EGISSQL
--Objetivo         : Listar dados de consultas a serem orçadas
--Data             : 27/02/2004
--Atualizado       : 12/11/2004 Status : Lucio
--                 : 01/03/2005 Alteração em velocidade : Lucio
--                 : 09/09/2005 Novo campo indicando se já possui orçamento : Lucio
--                 : 28/09/2005 Zeros para campos Lista e Unitário quando forem Null : Lucio
--                 : 27.03.2006 - Acertos Diversos - Carlos Fernandes
--                 : 27.06.2007 - Carlos Fernandes
--                 : 08.09.2007 - Desenho e Revisão - Carlos Fernandes
-- 12.02.2008 - Complemento das Informações - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
@cd_consulta  int       = 0,
@dt_inicial   datetime  = 0,
@dt_final     datetime  = 0,
@cd_cliente   int       = 0,
@cd_parametro int       = 0,
@cd_usuario   int       = 0,
@ic_liberar   char(1)   = 'N' -- Default (Todos)
                   -- = 'S' -- Só "não liberados" 

as

--select * from consulta_itens

declare @cd_departamento int
declare @qt_registros    int

select top 1 @cd_departamento = cd_departamento
from 
  EgisAdmin.dbo.Usuario
where 
  cd_usuario = @cd_usuario

select
       a.cd_consulta,
       a.cd_item_consulta,
       cast(a.cd_consulta      as varchar(6)) + '-' + 
       cast(a.cd_item_consulta as varchar(2)) as cd_chave_consulta, 
       a.dt_item_consulta,
       a.nm_fantasia_produto,
       a.qt_item_consulta,
       isnull(a.vl_lista_item_consulta,0) as vl_lista_item_consulta,
       vl_total_item_consulta = a.qt_item_consulta * 
                               (case when isnull(a.vl_unitario_item_consulta,0) = 0 then 
                                isnull(a.vl_lista_item_consulta,0) else isnull(a.vl_unitario_item_consulta,0) end),
       isnull(a.vl_unitario_item_consulta,0) as vl_unitario_item_consulta,
       --isnull(a.vl_lista_item_consulta,0)    as vl_lista_item_consulta,
       a.qt_dia_entrega_consulta, 
       a.dt_entrega_consulta,
       liberado = 
       case when a.dt_orcamento_liberado_con is not null then 'S' else 'N' end,      
       dt_orcamento_liberado_con as DataLiberacao,

       perdido = 
       case when a.dt_perda_consulta_itens is not null then 'S' else 'N' end, 
       smo = isnull(b.ic_fatsmo_consulta,'N'),
       c.nm_fantasia_cliente,
       v.nm_fantasia_vendedor,
       a.ic_orcamento_status as Status,

      (select top 1 isnull(cd_pedido_venda,0) from pedido_venda_item 
       where cd_consulta = a.cd_consulta and cd_item_consulta = a.cd_item_consulta and
             dt_cancelamento_item is null
       order by dt_item_pedido_venda desc) as cd_pedido_venda,

       a.nm_produto_consulta,
       e.cd_usuario           as CodUsuarioLiberacao, 
       e.nm_fantasia_usuario  as UsuarioLiberacao,
       f.nm_fantasia_usuario  as UsuarioConsulta,
       substring(a.ds_observacao_fabrica,1,1000) as ds_observacao_fabrica,
       ValorOutraMoeda =
       case when isnull(vl_indice_item_consulta,0) > 0 then vl_indice_item_consulta else null end,
       PossuiOrcamento = 
       case when ((select top 1 cd_consulta
                   from consulta_item_orcamento cio
                   where cio.cd_consulta       = a.cd_consulta and 
                         cio.cd_item_consulta  = a.cd_item_consulta)
                   UNION 
                  (select top 1 cd_consulta
                   from consulta_item_componente cic
                   where cic.cd_consulta       = a.cd_consulta and 
                         cic.cd_item_consulta  = a.cd_item_consulta)
                   UNION
                  (select top 1 cd_consulta
                   from consulta_item_servico_externo cis
                   where cis.cd_consulta       = a.cd_consulta and 
                         cis.cd_item_consulta  = a.cd_item_consulta)) > 0 then 'S' else 'N' end,
        a.cd_desenho_item_consulta,
        a.cd_rev_des_item_consulta,
        p.cd_interno_projeto,
        um.sg_unidade_medida,
        pp.cd_processo,
        nsi.cd_nota_saida,
        nsi.cd_item_nota_saida,
        ns.dt_nota_saida,
        ns.dt_saida_nota_saida
        
-------
into #TmpConsulta
-------

from consulta_itens a                        with (NOLOCK) 

inner join consulta b                        with (NOLOCK) on a.cd_consulta      = b.cd_consulta
left outer join cliente c                    with (NOLOCK) on b.cd_cliente       = c.cd_cliente 
left outer join grupo_produto_departamento d with (NOLOCK) on a.cd_grupo_produto = d.cd_grupo_produto
left outer join egisadmin.dbo.usuario e      with (NOLOCK) on a.cd_usuario_liberacao_orc = e.cd_usuario
left outer join egisadmin.dbo.usuario f      with (NOLOCK) on a.cd_usuario  = f.cd_usuario
left outer join vendedor v                   with (NOLOCK) on v.cd_vendedor = b.cd_vendedor
left outer join Projeto  p                   with (NOLOCK) on p.cd_projeto  = a.cd_projeto
left outer join Unidade_Medida um            with (NOLOCK) on um.cd_unidade_medida     = a.cd_unidade_medida
left outer join Pedido_venda_item pvi        with (nolock) on pvi.cd_pedido_venda      = a.cd_pedido_venda and
                                                              pvi.cd_item_pedido_venda = a.cd_item_pedido_venda and
                                                              pvi.dt_cancelamento_item is null

left outer join Processo_producao pp         with (nolock) on pp.cd_pedido_venda       = a.cd_pedido_venda and
                                                              pp.cd_item_pedido_venda  = a.cd_item_pedido_venda

left outer join Nota_Saida_Item nsi          with (nolock) on nsi.cd_pedido_venda      = a.cd_pedido_venda      and
                                                              nsi.cd_item_pedido_venda = a.cd_item_pedido_venda and
                                                              nsi.dt_restricao_item_nota is null                and
                                                              a.cd_pedido_venda>0

left outer join Nota_Saida ns                with (nolock) on ns.cd_nota_saida         = nsi.cd_nota_saida

--select * from nota_saida_item
--select cd_consulta,* from processo_producao

where ((a.cd_consulta = @cd_consulta) or
       ((@cd_consulta = 0) and (a.dt_item_consulta between @dt_inicial and @dt_final) and (a.dt_fechamento_consulta is null)) ) and 
      (b.cd_cliente = @cd_cliente or @cd_cliente = 0) and 
       isnull(a.ic_orcamento_consulta,'N') = 'S'                  --and
       --Carlos 18.04.2007
       --Liberado para todos os departamento independente do usuário
       --d.cd_departamento = @cd_departamento and
       --isnull(d.ic_orcamento,'N') = 'S' 

--select * from projeto

set @qt_registros = (select count(*) from #TmpConsulta)

-- Atenção : muda a ordem ...

if @cd_parametro = 0 
   select a.*, @qt_registros as qt_registro
   from #TmpConsulta a
   where (@ic_liberar = 'N') or
        ((@ic_liberar <> Liberado and
          Perdido <> 'S'))
   order by a.cd_consulta, a.cd_item_consulta
else
   select a.*, @qt_registros as qt_registro
   from #TmpConsulta a
   where (@ic_liberar = 'N') or
        ((@ic_liberar <> Liberado and
          Perdido <> 'S'))
   order by 
       a.nm_fantasia_produto, 
       a.cd_consulta, 
       a.cd_item_consulta

drop table #TmpConsulta  

