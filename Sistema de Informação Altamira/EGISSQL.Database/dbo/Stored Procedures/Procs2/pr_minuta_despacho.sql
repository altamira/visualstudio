

CREATE  procedure pr_minuta_despacho
------------------------------------------------------------------------------
--GBS - Global Business Solution
------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es) : Luciano
--Data      : 07/05/2002
--Atualizada: Mudança de ic_minuta_nota_usuario para ic_minuta_nota_saida - Daniel C. Neto -- 4/07/2002
--            22/10/2002
--Objetivo  : Emitir a Minuta de Despacho Para Acompanhar a NF 
--Numero Os : 057 (Data de 30/03)
--Modul0    : SRE
--Alteração : Alterado a ordem do retorno da sp - Igor Gama 20/01/2003
--Alteração : Inclusão ded tipo Destinatário - Igor Gama 20/01/2003
--            20/05/2003 - Separação da STP p/ executar para uma nota somente - ELIAS
--            10/06/2003 - Daniel C. NEto.
--            11/06/2003 - A partir de agora, permitir nota fiscal s/ transportadora
--                       - quando for digitado uma nota fiscal - Daniel C. Neto.
--            01/08/2003 - Daniel Duela - Criação de Campos q retornam o Quantidade de Reg. e a Somatória de Valores pois a Grid no Delphi
--                         está em GridMode (não pode ser LoadAllRecords).        
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------        
@dt_inicial        datetime,
@dt_final          datetime,
@cd_nota_Saida     int     = 0,
@cd_transportadora int     = 0,
@cd_entregador     int     = 0

as 

  declare @ic_tipo_endereco_minuta char(1)

  set @ic_tipo_endereco_minuta = ( select IsNull(ic_tipo_endereco_minuta,'N')
  from
    Parametro_Logistica with (nolock) 
  where 
    cd_empresa = dbo.fn_empresa() )

-------------------------------------------------------------------------------
if (isnull(@cd_nota_saida,0)<>0)  -- Se for Informado uma NF específica, não utilizar data para filtro - ELIAS 20/05/2003
-------------------------------------------------------------------------------
  begin

--  print ('1')

  select 
    distinct
    0 as Selecionado,
    (select count(1) from nota_saida ns with (nolock) 
     left outer join Operacao_fiscal opf on ns.cd_operacao_fiscal = opf.cd_operacao_fiscal
     left outer join Grupo_Operacao_Fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
     where gof.cd_tipo_operacao_fiscal = 2 and
           ns.cd_nota_saida = @cd_nota_Saida)  as 'Qtd_Total_Minutas',
    (select sum(ns.vl_total) from nota_saida ns with (nolock)  
     left outer join Operacao_fiscal opf on ns.cd_operacao_fiscal = opf.cd_operacao_fiscal
     left outer join Grupo_Operacao_Fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
     where gof.cd_tipo_operacao_fiscal = 2 and
           ns.cd_nota_saida = @cd_nota_Saida)  as 'Valor_Total_Minutas',
    t.nm_fantasia,
    td.nm_tipo_destinatario,
    n.nm_fantasia_destinatario as nm_fantasia_cliente,	 --Cliente
    isnull(n.dt_saida_nota_saida,getdate()) as 'dt_saida_nota_saida', --Saida
    isnull(n.dt_nota_saida,getdate()) as 'dt_nota_saida', --Emissao
    n.vl_total, 		 --Valor
    v.nm_fantasia_vendedor,
    v.nm_vendedor,		 --Vendedor
    t.ic_coleta,
    case when (@ic_tipo_endereco_minuta = 'D') then t.nm_transportadora
			   else n.nm_razao_social_nota end as 'nm_transportadora' ,         --Transportadora
    n.cd_transportadora, 	 --Codigo Transportadora

--    n.cd_nota_saida,		 --Nota

    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as 'Nota',

    IsNull(n.ic_minuta_nota_saida,'S') as 'ic_minuta_nota_saida',     --Minuta
    case when (@ic_tipo_endereco_minuta = 'D') then n.nm_razao_social_nota
				 else t.nm_transportadora end as 'nm_razao_social_nota', 
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then IsNull(n.nm_endereco_nota_saida,'') + ' - ' + IsNull(n.cd_numero_end_nota_saida,'') 
      when (@ic_tipo_endereco_minuta = 'D') then IsNull(n.nm_endereco_entrega,'') + ' - ' + IsNull(n.cd_numero_endereco_ent,'') + ' - ' + IsNull(n.nm_complemento_end_ent,'') 
      else IsNull(t.nm_endereco,'') + ' - ' + IsNull(t.cd_numero_endereco,'') + ' - ' + IsNull(t.nm_endereco_complemento,'') 
    end as 'Endereco',
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then n.nm_bairro_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.nm_bairro_entrega
	    else nm_bairro 
    end as 'nm_bairro',
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then n.nm_cidade_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.nm_cidade_entrega 
	    else cid.nm_cidade
    end as 'nm_cidade',
    case 
      when n.cd_tipo_local_entrega = 1 and (@ic_tipo_endereco_minuta = 'D') then n.sg_estado_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.sg_estado_entrega 
      else est.sg_estado
    end as 'sg_estado',
    case 
      when n.cd_tipo_local_entrega = 1 and (@ic_tipo_endereco_minuta = 'D') then '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
      when (@ic_tipo_endereco_minuta = 'D') then '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
      else '(' + Isnull(t.cd_ddd,'') + ')' + t.cd_telefone
    end as 'cd_telefone',
--    n.cd_nota_saida,

    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as 'cd_nota_saida',

    n.nm_endereco_entrega, n.cd_numero_endereco_ent,
    n.nm_complemento_end_ent,
    n.nm_bairro_entrega,
    n.nm_pais_nota_saida,
    n.sg_estado_entrega,
    n.nm_cidade_entrega,
    n.nm_fantasia_destinatario,
    n.cd_tipo_local_entrega, 
    n.nm_obs_entrega_nota_saida,
    n.nm_marca_nota_saida, 
    n.nm_numero_emb_nota_saida, 
    n.qt_volume_nota_saida, 
    n.nm_especie_nota_saida, 
    n.qt_peso_liq_nota_saida, 
    n.qt_peso_bruto_nota_saida ,
    n.vl_frete,
    n.cd_entregador,
    e.nm_entregador
  from
    nota_saida n               with (nolock)                            left join
    Tipo_Destinatario td      on n.cd_tipo_destinatario      = td.cd_tipo_destinatario left outer join
    Operacao_fiscal op        on n.cd_operacao_fiscal        = op.cd_operacao_fiscal Left Outer Join
    Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal Left outer Join
    transportadora t          on n.cd_transportadora         = t.cd_transportadora left outer join
    vendedor v                on n.cd_vendedor               = v.cd_vendedor left outer join
    Entregador e              on n.cd_entregador             = e.cd_entregador left outer join
    Cidade cid                on cid.cd_cidade = t.cd_cidade and cid.cd_estado = t.cd_estado and cid.cd_pais = t.cd_pais left outer join
    Estado est                on est.cd_estado = t.cd_estado and est.cd_pais = t.cd_pais     
  where
--     op.ic_comercial_operacao = 'S' and
     gop.cd_tipo_operacao_fiscal = 2 and
     n.cd_nota_saida = @cd_nota_Saida 

--     and 
--     ((isnull(@cd_transportadora,0) = 0 and n.cd_transportadora is not null) or 
--      (n.cd_transportadora = @cd_transportadora)) and
--     ((isnull(@cd_entregador,0) = 0) or (n.cd_entregador = @cd_entregador))  

end
-------------------------------------------------------------------------------
else  -- selecionado um range de notas
-------------------------------------------------------------------------------
begin

--  print ('2')

  select 
    distinct
    0        As Selecionado,
    (select count(1) from nota_saida ns with (nolock) 
     left outer join Operacao_fiscal opf       on ns.cd_operacao_fiscal = opf.cd_operacao_fiscal
     left outer join Grupo_Operacao_Fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
     where ns.dt_nota_saida between @dt_inicial and @dt_final and
          ((isnull(@cd_transportadora,0) = 0 and ns.cd_transportadora is not null) or 
          (ns.cd_transportadora = @cd_transportadora)) and
          ((isnull(@cd_entregador,0) = 0) or (ns.cd_entregador = @cd_entregador))) as 'Qtd_Total_Minutas',
    (select sum(ns.vl_total) from nota_saida ns
     left outer join Operacao_fiscal opf on ns.cd_operacao_fiscal = opf.cd_operacao_fiscal
     left outer join Grupo_Operacao_Fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
     where ns.dt_nota_saida between @dt_inicial and @dt_final and
          ((isnull(@cd_transportadora,0) = 0 and ns.cd_transportadora is not null) or 
          (ns.cd_transportadora = @cd_transportadora)) and
          ((isnull(@cd_entregador,0) = 0) or (ns.cd_entregador = @cd_entregador))) as 'Valor_Total_Minutas',
    t.nm_fantasia,
    td.nm_tipo_destinatario,
    n.nm_fantasia_destinatario as nm_fantasia_cliente,	 --Cliente
    isnull(n.dt_saida_nota_saida,getdate()) as 'dt_saida_nota_saida', --Saida
    isnull(n.dt_nota_saida,getdate()) as 'dt_nota_saida', --Emissao
    n.vl_total, 		 --Valor
    v.nm_fantasia_vendedor,
    v.nm_vendedor,		 --Vendedor
    t.ic_coleta,
    case when (@ic_tipo_endereco_minuta = 'D') then t.nm_transportadora
			   else n.nm_razao_social_nota end as 'nm_transportadora' ,         --Transportadora
    n.cd_transportadora, 	 --Codigo Transportadora
--    n.cd_nota_saida,		 --Nota

    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as 'Nota',

    IsNull(n.ic_minuta_nota_saida,'S') as 'ic_minuta_nota_saida',     --Minuta
    case when (@ic_tipo_endereco_minuta = 'D') then n.nm_razao_social_nota
				 else t.nm_transportadora end as 'nm_razao_social_nota', 
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then IsNull(n.nm_endereco_nota_saida,'') + ' - ' + IsNull(n.cd_numero_end_nota_saida,'') 
      when (@ic_tipo_endereco_minuta = 'D') then IsNull(n.nm_endereco_entrega,'') + ' - ' + IsNull(n.cd_numero_endereco_ent,'') + ' - ' + IsNull(n.nm_complemento_end_ent,'') 
      else IsNull(t.nm_endereco,'') + ' - ' + IsNull(t.cd_numero_endereco,'') + ' - ' + IsNull(t.nm_endereco_complemento,'') 
    end as 'Endereco',
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then n.nm_bairro_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.nm_bairro_entrega
	    else nm_bairro 
    end as 'nm_bairro',
    case 
      when (n.cd_tipo_local_entrega = 1) and (@ic_tipo_endereco_minuta = 'D') then n.nm_cidade_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.nm_cidade_entrega 
	    else cid.nm_cidade
    end as 'nm_cidade',
    case 
      when n.cd_tipo_local_entrega = 1 and (@ic_tipo_endereco_minuta = 'D') then n.sg_estado_nota_saida 
      when (@ic_tipo_endereco_minuta = 'D') then n.sg_estado_entrega 
      else est.sg_estado
    end as 'sg_estado',
    case 
      when n.cd_tipo_local_entrega = 1 and (@ic_tipo_endereco_minuta = 'D') then '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
      when (@ic_tipo_endereco_minuta = 'D') then '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
      else '(' + Isnull(t.cd_ddd,'') + ')' + t.cd_telefone
    end as 'cd_telefone',

--    n.cd_nota_saida,

    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as 'cd_nota_saida',

    n.nm_endereco_entrega, n.cd_numero_endereco_ent,
    n.nm_complemento_end_ent,
    n.nm_bairro_entrega,
    n.nm_pais_nota_saida,
    n.sg_estado_entrega,
    n.nm_cidade_entrega,
    n.nm_fantasia_destinatario,
    n.cd_tipo_local_entrega, 
    n.nm_obs_entrega_nota_saida,
    n.nm_marca_nota_saida, 
    n.nm_numero_emb_nota_saida, 
    n.qt_volume_nota_saida, 
    n.nm_especie_nota_saida, 
    n.qt_peso_liq_nota_saida, 
    n.qt_peso_bruto_nota_saida ,
    n.vl_frete,
    n.cd_entregador,
    e.nm_entregador

  from
    nota_saida n with (nolock)  
    left join
    Tipo_Destinatario td
      on n.cd_tipo_destinatario = td.cd_tipo_destinatario
      left outer join
    Operacao_fiscal op
      on n.cd_operacao_fiscal = op.cd_operacao_fiscal
      Left Outer Join
    Grupo_Operacao_Fiscal gop
      on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
      Left outer Join
    transportadora t 
      on n.cd_transportadora = t.cd_transportadora 
      left outer join
    vendedor v
      on n.cd_vendedor = v.cd_vendedor 
      left outer join
    Entregador e
      on n.cd_entregador = e.cd_entregador left outer join 
    Cidade cid on cid.cd_cidade = t.cd_cidade and cid.cd_estado = t.cd_estado and cid.cd_pais = t.cd_pais left outer join
    Estado est on est.cd_estado = t.cd_estado and est.cd_pais = t.cd_pais

  where
     n.dt_nota_saida between @dt_inicial and @dt_final and
     gop.cd_tipo_operacao_fiscal = 2 and
     IsNull(n.cd_transportadora,0) = ( case when IsNull(@cd_transportadora,0) = 0 and IsNull(n.cd_transportadora,0) <> 0 then
                                        IsNull(n.cd_transportadora,0) 
                                             when IsNull(n.cd_transportadora,0) = 0 then Null 
                                        else IsNull(@cd_transportadora,0) end ) and
     IsNull(n.cd_entregador,0) = ( case when isnull(@cd_entregador,0) = 0 then
                                     IsNull(n.cd_entregador,0) else 
                                     @cd_entregador end )
  order by
    n.dt_nota_saida desc,
    n.cd_nota_saida desc

end

------------------------------------------------------------------------------
------------------------------Testando Procedure------------------------------
------------------------------------------------------------------------------
--select * from grupo_operacao_fiscal

---Pra uma Nota Que Exista     (Traz Apenas o Registro Selecionado ex-140269)
-- exec pr_minuta_despacho 1,'01/01/1998', '03/02/2003', 0

---Pra uma Nota Que Não Exista (Traz Todos os Registros)
-- exec pr_minuta_despacho 2, '01/01/2003', '03/02/2009', 0


