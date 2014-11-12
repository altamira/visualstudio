
create procedure pr_impressao_laudo_nota
--------------------------------------------------------------------------
--pr_impressao_laudo_nota
--------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                   2004
--------------------------------------------------------------------------  
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Daniel C. Neto.
--Banco de Dados        : EGISSQL
--Objetivo              : Fazer Seleção de Notas de Laudo Técnico.
--Data                  : 26/07/2004
--Atualizado            : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso 
--11.04.2008 - Complemento dos Dados de Produto Químico - Carlos Fernandes
--15.08.2009 - Verificação da rotina - Carlos Fernandes 
---------------------------------------------------------------------------
-- Observação: - Cuidado ao alterar a ordem da apresentação nesta stp.
-- O Campo cd_chave é usado como base para escolha do usuário ao filtrar
-- a impressão dos Laudos selecionados, caso seja necessário mudar a ordem
-- deverá ser mudada a ordem também na stp : pr_laudo
---------------------------------------------------------------------------
-- 14.12.2009 - Ajustes Diversos - Carlos Fernandes
-- 19.03.2010 - Acertos - Carlos Fernandes
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
-- 08.11.2010 - Lote Interno - Carlos Fernandes
-- 06.12.2010 - Verificaçõ da duplicidade - Carlos Fernandes
---------------------------------------------------------------------------

@cd_nota_saida      int = 0,
@cd_item_nota_saida int = 0

as

  select
    IDENTITY(int, 1, 1) as cd_chave, 
    0                   as Sel,
    d.nm_fantasia,
    d.nm_razao_social,
    ns.dt_nota_saida,
    sn.nm_status_nota,

    --Produto
    p.nm_fantasia_produto,
    p.nm_produto,
    p.cd_mascara_produto,

    n.cd_nota_saida_item_lote,
    n.cd_nota_saida,

    case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                  
    end                                   as 'cd_identificacao_nota_saida',

    n.cd_item_nota_saida,
    n.cd_produto,
    n.nm_lote,
    case when isnull(n.cd_laudo,0)=0 then
       ln.cd_laudo 
    else
       n.cd_laudo
    end                                   as 'cd_laudo',

    n.ic_impresso,
    n.cd_lote_produto,
    case when isnull(l.cd_lote_interno,'')<>'' then
      l.cd_lote_interno
    else
      ln.cd_lote_interno
    end                                   as 'cd_lote_interno'

  into 
    #Selecao

--select * from nota_saida_item_lote

  from 
    Nota_Saida ns                  with (nolock) 
    inner join Nota_Saida_Item nsi with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida

    left join
    Nota_saida_item_lote n         with (nolock) on n.cd_nota_saida      = ns.cd_nota_saida and
                                                    n.cd_item_nota_saida = nsi.cd_item_nota_saida

    left outer join
    Laudo l                  with (nolock) on l.cd_laudo        = n.cd_laudo
                                            --and l.cd_produto      = n.cd_produto
    left outer join
    Produto p                with (nolock) on p.cd_produto           = nsi.cd_produto

    left outer join
    vw_Destinatario d        with (nolock) on d.cd_destinatario      = ns.cd_cliente and
                                              d.cd_tipo_destinatario = ns.cd_tipo_destinatario 
    left outer join
    Status_Nota sn           with (nolock) on sn.cd_status_nota      = ns.cd_status_nota

    left outer join laudo ln with (nolock) on ln.cd_lote_interno     = n.nm_lote and
                                              ln.cd_produto          = nsi.cd_produto

  where
    IsNull(ns.cd_nota_saida,0) = (case when @cd_nota_saida = 0 then
                                   IsNull(ns.cd_nota_saida,0) else
                                   @cd_nota_saida end ) and
    IsNull(n.cd_item_nota_saida,0) = ( case when @cd_item_nota_saida = 0 then
                                        IsNull(n.cd_item_nota_saida,0) else
                                      @cd_item_nota_saida end ) and
    
    IsNull(n.ic_impresso,'N') = ( case when @cd_nota_saida = 0 then
                                   'N' else IsNull(n.ic_impresso,'N') end ) 
   order by
    n.cd_nota_saida desc,
    n.cd_item_nota_saida 

   select * from #Selecao --order by cd_chave    

