
CREATE PROCEDURE pr_consulta_itens_proposta_comercial

@ic_mostrar_valor_original char(1),
@cd_consulta int

as

declare @cd_tipo_sistema int
declare @cd_idioma       int
declare @ic_diversos     char(1)

select top 1
       @cd_idioma       = cl.cd_idioma,
       @cd_tipo_sistema = ct.cd_tipo_sistema
--
from Consulta c
--
inner join Consulta_Caract_Tecnica_Cq ct on   
c.cd_consulta = ct.cd_consulta 

inner join Cliente cl on
c.cd_cliente = cl.cd_cliente
--
where c.cd_consulta = @cd_consulta

-- Atribui o idioma Default se não trouxe nada

if @cd_idioma is null
   set @cd_idioma = 1 -- Português

-- Mais de um item sendo impresso ?

set @ic_diversos = 'N'

if (select count(*)
    from consulta_itens
    where cd_consulta = @cd_consulta and   
       IsNull(ic_sel_fax_consulta,'N') = 'S') > 1

   set @ic_diversos = 'S'

-- Tipo do sistema de CQ

declare @nm_tipo_sistema varchar(60)

select @nm_tipo_sistema = nm_tipo_sistema
from Tipo_Sistema_Cq
where cd_tipo_sistema = @cd_tipo_sistema

-- Verifica se é outro idioma

if @cd_idioma > 1 
  (select @nm_tipo_sistema = nm_tipo_sistema
   from Tipo_Sistema_Cq_Idioma
   where cd_tipo_sistema = @cd_tipo_sistema and
         cd_idioma = @cd_idioma)

-- Pega os dados somente "de CQ"

select 
    top 1
    ct.cd_consulta      as cd_consulta_orcamento,
    ct.cd_item_consulta as cd_item_consulta_orcamento,
    ct.cd_dias_uteis_entrega,  
    ct.nm_produto_cliente,  
    ct.qt_peso_produto_string,   
    ct.nm_comp_material_plastico,  
    EliminacaoCanal =  
    case when ct.ic_elimina_galho_consulta = 'T' then 'Total  '  
             when ct.ic_elimina_galho_consulta = 'P' then 'Parcial'  
    else 'Nenhuma' end,  
    ct.ds_observacao_orcamento as ds_observacao_produto,  
    ct.cd_numero_desenho_molde,  
    ct.qt_cavidade_string,  
    ct.cd_material_plastico,
    ct.qt_via_manifold as Vias,
    ct.cd_dias_uteis_entrega as Dias,
    ts.ic_valvulado_tipo_sistema as Valvulado,
    ct.cd_ordem_servico_cliente,  
    Carga =   
    case when ic_carga_consulta = 'S' then 'Nenhuma   '  
             when isnull(ct.pc_talco_consulta,0) > 0 and isnull(ct.pc_fibra_vidro_consulta,0) = 0 then cast(ct.pc_talco_consulta as varchar(3))+ '% Talco'  
             when isnull(ct.pc_talco_consulta,0) = 0 and isnull(ct.pc_fibra_vidro_consulta,0) > 0 then cast(ct.pc_fibra_vidro_consulta as varchar(3))+ '% Fibra'  
             when isnull(ct.pc_talco_consulta,0) > 0 and isnull(ct.pc_fibra_vidro_consulta,0) > 0 then cast(ct.pc_talco_consulta as varchar(3))+ '% Talco' +  
                      '-' + cast(ct.pc_fibra_vidro_consulta as varchar(3))+ '% Fibra'  
    else '          ' end,
    cast(isnull(ct.ds_observacao_entrega,' ') as text) as ds_observacao_entrega
--
into #TmpCaractTecnicaCQ
--
from consulta_caract_tecnica_cq ct with (NOLOCK)
--
inner join consulta_itens ci with (NOLOCK) on
ct.cd_consulta      = ci.cd_consulta and
ct.cd_item_consulta = ci.cd_item_consulta
--
left outer join tipo_sistema_cq ts on
ct.cd_tipo_sistema = ts.cd_tipo_sistema
--
where ct.cd_consulta = @cd_consulta and 
      isnull(ci.ic_sel_fax_consulta,'N') = 'S'


-- Realiza a pesquisa na talela de itens da consulta


SELECT  
     ci.cd_item_consulta,  
     case ci.ic_consulta_item  
       when 'P' then rtrim(ci.nm_fantasia_produto)  
       else (Select top 1 s.nm_servico from Servico s where s.cd_servico = IsNull(ci.cd_servico,0))  
     end as nm_fantasia_produto,  
     ci.nm_produto_consulta,  
     ci.ds_produto_consulta,  
     ci.ds_observacao_fabrica,  
     ci.qt_item_consulta,  
     Case @ic_mostrar_valor_original  
       When 'S' Then (ci.vl_unitario_item_consulta / ( case when ci.vl_moeda_cotacao = 0 then 1 else IsNull(ci.vl_moeda_cotacao,1) end ))  
       Else ci.vl_unitario_item_consulta  
     end vl_unitario_item_consulta,  
     ci.pc_ipi, 
     qt_dia_entrega_padrao =
        case when (ct.dias is not null) and (ci.dt_orcamento_liberado_con is null) then 
                   ct.dias else ci.qt_dia_entrega_padrao end,
     Case When LTRIM(RTRim(Cast(ci.pc_icms as varchar(20)) + '/' + cast(ci.pc_reducao_icms as varchar(20)))) = '/'  
         Then null  
         Else Case When IsNull(ci.pc_reducao_icms, 0) = 0  
                   then RTrim(LTrim(Cast(ci.pc_icms as varchar(20))))  
                   Else LTRIM(RTRim(Cast(ci.pc_icms as varchar(20)) + '/' + cast(ci.pc_reducao_icms as varchar(20))))  
              end  
     End pc_icms,  
     ci.vl_moeda_cotacao,  
     ci.dt_moeda_cotacao,  
     ci.dt_validade_item_consulta,  
     Case @ic_mostrar_valor_original  
       When 'S' Then  cast(( ci.vl_unitario_item_consulta * ci.qt_item_consulta) as numeric (18,2)) / 
                           ( case when ci.vl_moeda_cotacao = 0 then 1 else IsNull(ci.vl_moeda_cotacao,1) end )  
       Else cast(( ci.vl_unitario_item_consulta * ci.qt_item_consulta) as numeric (18,2))  
     end as vl_total,  
     ci.qt_dia_entrega_consulta,  
     ci.cd_os_consulta,  
     ci.cd_posicao_consulta,  
     ci.ic_consulta_item,  
     ci.pc_reducao_icms,  
     ci.dt_perda_consulta_itens, 
     ci.nm_kardex_item_consulta,  
     case dt_perda_consulta_itens  
        when null then 'N' else 'S' end ic_perda_consulta_itens,  
     case ci.ic_consulta_item when 'P' then ci.nm_fantasia_produto  else '0' end as nm_fantasia_procura,  
     ci.cd_grupo_produto,  
     u.sg_unidade_medida,  
     cd_consulta_orcamento =  
     case when ct.cd_item_consulta_orcamento = ci.cd_item_consulta then cd_consulta_orcamento else 0 end,
     vl_total_orcamento_cq =  
    (select sum(cic.qt_item_comp_orcamento * cic.vl_produto)  
     from consulta_item_componente cic with (NOLOCK)
     where cic.cd_consulta      = ci.cd_consulta and  
           cic.cd_item_consulta = ci.cd_item_consulta and  
           isnull(cic.ic_acessorio_orcamento,'N') <> 'S' and -- Não acessório
           isnull(cic.ic_componente_agregado,'N') <> 'S'),   -- Não agregado
     ct.cd_dias_uteis_entrega,  
     ct.nm_produto_cliente,  
     ct.qt_peso_produto_string,   
     RTrim(IsNull(mp.sg_material_plastico,'')) + ' ' + IsNull(ct.nm_comp_material_plastico,'') as 'Material',  
     cic.qt_item_comp_orcamento as qt_produto_orcamento_cq,  
     ct.eliminacaocanal,  
     ds_obs_orcamento_proposta = -- Obs. a ser impressa "antes" dos itens ...
     case when ci.cd_item_consulta = ciop.cd_item_consulta then ciop.ds_obs_orcamento_proposta else null end,
     cic.nm_produto_orcamento as nm_produto_orcamento_cq,  
     cic.ds_produto_orcamento as ds_produto_orcamento_cq,  
     ct.ds_observacao_produto,
     qt_registro_orcamento =
       (select count(*) as x from Consulta_Item_Componente x  
        where x.cd_consulta      = ci.cd_consulta and  
              x.cd_item_consulta = ci.cd_item_consulta and  
              isnull(x.ic_acessorio_orcamento,'N') <> 'S' and
              isnull(x.ic_componente_agregado,'N') <> 'S'),  
     ct.cd_numero_desenho_molde,  
     ct.qt_cavidade_string,  
     ct.cd_ordem_servico_cliente,  
     @nm_tipo_sistema as nm_tipo_sistema,
     ci.cd_pedido_compra_consulta,  
     ct.carga,
     ci.cd_item_consulta as cd_item_consulta_original,
     isnull(ct.ds_observacao_entrega,' ') as ds_observacao_entrega,
     round(ci.vl_indice_item_consulta,0) as vl_indice_item_consulta,
     PesoManifold  = case when (ci.cd_item_consulta = 1 or ci.ic_sel_fax_consulta = 'S') then cast(round(ciop.qt_peso_acabado_manifold,2) as float) 
                     else cast(0 as float) end,
     PesoHotHalf   = case when (ci.cd_item_consulta = 2 or ci.ic_sel_fax_consulta = 'S') then cast(round(ciop.qt_peso_acabado_hothalf,2) as float) 
                     else cast(0 as float) end,
     FreteManifold = case when (ci.cd_item_consulta = 1 or ci.ic_sel_fax_consulta = 'S') then cast(ciop.vl_frete_manifold as float) 
                     else cast(0 as float) end,
     FreteHotHalf  = case when (ci.cd_item_consulta = 2 or ci.ic_sel_fax_consulta = 'S') then cast(ciop.vl_frete_hothalf as float) 
                     else cast(0 as float) end
     
  from
    
    Consulta_Itens ci with (NOLOCK)
    
    left outer join #TmpCaractTecnicaCQ ct on   
    ci.cd_consulta      = ct.cd_consulta_orcamento and  
    ci.cd_item_consulta = (case when @ic_diversos = 'S' then ci.cd_item_consulta else ct.cd_item_consulta_orcamento end) and  
    ct.nm_produto_cliente is not null -- Só trazer os dados de CQ, se estiver preenchido o produto. Controlador não !  
    
    left outer join Consulta_Item_Componente cic with (NOLOCK) on   
    ci.cd_consulta      = cic.cd_consulta and  
    ci.cd_item_consulta = cic.cd_item_consulta and  
    IsNull(cic.ic_acessorio_orcamento,'N') = 'N' and  
    IsNull(cic.ic_componente_agregado,'N') = 'N' and  
    -- Só deve trazer da tabela de componentes, se for CQ/Manifold
   (ct.cd_consulta_orcamento is not null and ct.cd_item_consulta_orcamento = ci.cd_item_consulta)
    
    left outer join Material_Plastico mp on   
    mp.cd_material_plastico = ct.cd_material_plastico  
    
    left outer join Unidade_Medida u on   
    u.cd_unidade_medida = ci.cd_unidade_medida  
    
    left outer join Consulta_Item_Orcamento_Proposta ciop with (NOLOCK) on   
    ci.cd_consulta        = ciop.cd_consulta and  
    ci.cd_item_consulta   = ciop.cd_item_consulta
    
  WHERE  
    ci.cd_consulta = @cd_consulta and   
    IsNull(ic_sel_fax_consulta,'N') = 'S'  

  ORDER BY  
    ci.cd_item_consulta  

