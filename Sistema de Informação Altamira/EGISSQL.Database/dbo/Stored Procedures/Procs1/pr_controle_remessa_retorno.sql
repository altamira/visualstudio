
CREATE PROCEDURE pr_controle_remessa_retorno
@ic_parametro int,
@cd_nota_saida int,
@cd_operacao_fiscal int,
@cd_usuario_responsavel int,
@cd_departamento_responsavel int,
@dt_inicial datetime,
@dt_final datetime
as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- LISTAGEM DE SALDOS DAS NOTAS EM ABERTO
-------------------------------------------------------------------------------
begin

  -- BUSCA TODAS AS NOTAS EM ABERTO
  if (isnull(@cd_nota_saida,0) = 0)
  begin

    select cd_nota_fiscal, 
      sum(vl_nota_entrada) as vl_baixado
    into #ControleBaixado
    from Nota_Vencimento_Baixa
    where dt_nota_entrada < getdate()
    group by cd_nota_fiscal

    select 
      --ns.cd_nota_saida as NFS, 

      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                  
      end                                   as 'NFS',


      ns.dt_nota_saida as Emissao,
      op.cd_mascara_operacao as CFOP,
      op.nm_operacao_fiscal as NomeCFOP,
      ns.nm_fantasia_nota_saida as Fantasia,
      cast(ns.vl_total as decimal(25,2)) as Total, 
      cast((ns.vl_total - isnull(cb.vl_baixado,0)) as decimal(25,2)) as Saldo,
      nv.nm_obs_nota_vencimento as Observacao,
      u.nm_fantasia_usuario as Usuario,
      nv.cd_usuario_responsavel as CodUsuario,
      d.nm_departamento as Departamento,
      nv.cd_departamento_responsavel as CodDepartamento,
      isnull(d.nm_departamento, u.nm_fantasia_usuario) as Responsavel,      
      isnull(op.qt_prazo_operacao_fiscal,0) as PrazoDias,
      (ns.dt_nota_saida + isnull(op.qt_prazo_operacao_fiscal,0)) as PrazoData,
      case when isnull(op.qt_prazo_operacao_fiscal,0) = 0 
      then 0
      else datediff(dd, getDate(), (ns.dt_nota_saida + isnull(op.qt_prazo_operacao_fiscal,0))) end as QtdeDia
    from Nota_Saida ns 
      inner join Nota_Vencimento nv on ns.cd_nota_saida = nv.cd_nota_fiscal 
      inner join Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join #ControleBaixado cb on nv.cd_nota_fiscal = cb.cd_nota_fiscal 
      left outer join EgisAdmin.dbo.Usuario u on nv.cd_usuario_responsavel = u.cd_usuario
      left outer join EgisAdmin.dbo.Departamento d on nv.cd_departamento_responsavel = d.cd_departamento
    where cast(isnull(cb.vl_baixado,0) as decimal(25,2)) < cast(ns.vl_total as decimal(25,2)) and
      ns.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(ns.cd_status_nota,6) in (1,2,3,5) and
      isnull(ns.cd_operacao_fiscal,0) = (case when isnull(@cd_operacao_fiscal,0) = 0 
                                         then isnull(ns.cd_operacao_fiscal,0)
                                         else @cd_operacao_fiscal end) and
      isnull(nv.cd_usuario_responsavel,0) = (case when isnull(@cd_usuario_responsavel,0) = 0
                                             then isnull(nv.cd_usuario_responsavel,0)
                                             else @cd_usuario_responsavel end) and
      isnull(nv.cd_departamento_responsavel,0) = (case when isnull(@cd_departamento_responsavel,0) = 0
                                                  then isnull(nv.cd_departamento_responsavel,0)
                                                  else @cd_departamento_responsavel end)
    order by NFS, QtdeDia

    drop table #ControleBaixado

  end
  else
  begin

    select 
--      ns.cd_nota_saida as NFS, 
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                  
      end                                   as 'NFS',

      ns.dt_nota_saida as Emissao,
      op.cd_mascara_operacao as CFOP,
      op.nm_operacao_fiscal as NomeCFOP,
      ns.nm_fantasia_nota_saida as Fantasia,
      cast(ns.vl_total as decimal(25,2)) as Total, 

      cast((ns.vl_total - isnull((select sum(vl_nota_entrada)
                                  from Nota_Vencimento_Baixa
                                  where cd_nota_fiscal = ns.cd_nota_saida
                                  group by cd_nota_fiscal),0)) as decimal(25,2)) as Saldo,

      nv.nm_obs_nota_vencimento as Observacao,
      u.nm_fantasia_usuario as Usuario,
      nv.cd_usuario_responsavel as CodUsuario,
      d.nm_departamento as Departamento,
      nv.cd_departamento_responsavel as CodDepartamento,
      isnull(d.nm_departamento, u.nm_fantasia_usuario) as Responsavel,       
      isnull(op.qt_prazo_operacao_fiscal,0) as PrazoDias,
      (ns.dt_nota_saida + isnull(op.qt_prazo_operacao_fiscal,0)) as PrazoData,
      case when isnull(op.qt_prazo_operacao_fiscal,0) = 0 
      then 0
      else datediff(dd, getDate(), (ns.dt_nota_saida + isnull(op.qt_prazo_operacao_fiscal,0))) end as QtdeDia
    from Nota_Saida ns 
      inner join Nota_Vencimento nv on ns.cd_nota_saida = nv.cd_nota_fiscal 
      inner join Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join EgisAdmin.dbo.Usuario u on nv.cd_usuario_responsavel = u.cd_usuario
      left outer join EgisAdmin.dbo.Departamento d on nv.cd_departamento_responsavel = d.cd_departamento
    where ns.cd_nota_saida = @cd_nota_saida and
      isnull(ns.cd_status_nota,6) in (1,2,3,5)
    order by QtdeDia

  end

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- LISTAGEM NAS NOTAS DE ENTRADA DE UMA NOTA DE SAÍDA
-------------------------------------------------------------------------------
begin

  select 
    nvb.cd_nota_entrada as NFE,
    vw.nm_fantasia as Fantasia,
    nvb.dt_nota_entrada as Data,
    nvb.vl_nota_entrada as Valor
  from Nota_Vencimento_Baixa nvb
    left outer join Nota_Saida ns on nvb.cd_nota_fiscal = ns.cd_nota_saida 
    left outer join Nota_Entrada ne on nvb.cd_nota_entrada = ne.cd_nota_entrada and
                                       nvb.cd_fornecedor = ne.cd_fornecedor and
                                       nvb.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                       nvb.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
    left outer join vw_destinatario vw on vw.cd_tipo_destinatario = isnull(ne.cd_tipo_destinatario, ns.cd_tipo_destinatario) and
                                          vw.cd_destinatario = isnull(ne.cd_fornecedor, ns.cd_cliente)
  where nvb.cd_nota_fiscal = @cd_nota_saida

end
-------------------------------------------------------------------------------
else if @ic_parametro = 3   -- LISTAGEM DOS ITENS DAS NFS EM ABERTO
-------------------------------------------------------------------------------
begin

  select cd_item_nota_saida as Item,
    nm_fantasia_produto as Fantasia,
    nm_produto_item_nota as Produto,
    qt_item_nota_saida as Quantidade
  from nota_saida_item
  where cd_nota_saida = @cd_nota_saida
  order by 1

end

