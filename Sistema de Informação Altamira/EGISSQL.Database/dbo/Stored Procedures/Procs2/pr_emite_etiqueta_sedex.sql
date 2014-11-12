
CREATE PROCEDURE pr_emite_etiqueta_sedex
@ic_parametro int,
@cd_sedex_nota_saida int,
@cd_nota_saida int,
@ic_rotulo char(1) = 'S'

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    --  LISTA TODAS AS ETIQUETAS DE UMA REMESSA
-------------------------------------------------------------------------------
  begin

    -- OBSERVAÇÃO: TROCAR O CEP P/ BUSCAR O DE ENTREGA

     select
       distinct
       (case @ic_rotulo when 'S' then 'Destinatario ' else '' end) + cast( sed.cd_nota_saida as varchar ) as 'CodDestinatario',
       vw.nm_razao_social as 'Destinatario',
       'Endereco:' as 'LabelEndereco',
       
       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         ns.nm_endereco_entrega + ', ' + ns.cd_numero_endereco_ent 
       else
         ns.nm_endereco_nota_saida + ', ' + ns.cd_numero_end_nota_saida 
       end as 'Endereco',

       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         (case @ic_rotulo when 'S' then  'Bairro : ' else '' end) + ns.nm_bairro_entrega
       else      
         (case @ic_rotulo when 'S' then  'Bairro : ' else '' end) + ns.nm_bairro_nota_saida 
       end as 'Bairro',
       
       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
			(case @ic_rotulo when 'S' then 'Cidade : ' else '' end) + ns.nm_cidade_entrega
       else
         (case @ic_rotulo when 'S' then 'Cidade : ' else '' end) + ns.nm_cidade_nota_saida
       end as 'Cidade',
       
       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         (case @ic_rotulo when 'S' then  'Estado : ' else '' end) + ns.sg_estado_entrega
       else
         (case @ic_rotulo when 'S' then  'Estado : ' else '' end) + ns.sg_estado_nota_saida 
       end as 'Estado',

       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then 
       (case @ic_rotulo when 'S' then  'Cep    : ' else '' end) + dbo.fn_formata_mascara('99999-999',ns.cd_cep_entrega)
       else
       (case @ic_rotulo when 'S' then  'Cep    : ' else '' end) + dbo.fn_formata_mascara('99999-999',vw.cd_cep)
       end as 'CEP',

       (case @ic_rotulo when 'S' then  'A/C    : ' else '' end) +  Isnull(cc.nm_contato_cliente,'_______________________') as 'Contato' 
     from
        sedex_nota_saida_item sed 
		  inner join Nota_Saida ns  on sed.cd_nota_saida       = ns.cd_nota_saida 
        inner join Nota_Saida_item nsi on ns.cd_nota_saida        = nsi.cd_nota_saida
        left outer join Pedido_Venda pv  on nsi.cd_pedido_venda     = pv.cd_pedido_venda
        inner join vw_Destinatario vw  on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and  vw.cd_destinatario      = ns.cd_cliente
		  left join cliente_contato cc on ( ns.cd_cliente = cc.cd_cliente and cc.cd_contato=pv.cd_contato)
     where
        sed.cd_sedex_nota_saida       = @cd_sedex_nota_saida

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- LISTA UMA ÚNICA ETIQUETA DE UMA NOTA
-------------------------------------------------------------------------------
  begin

    -- OBSERVAÇÃO: TROCAR O CEP P/ BUSCAR O DE ENTREGA

     select
       distinct
       (case @ic_rotulo when 'S' then 'Destinatario ' else '' end)+cast( sed.cd_nota_saida as varchar ) as 'CodDestinatario',
       vw.nm_razao_social as 'Destinatario',
       (case @ic_rotulo when 'S' then  'Endereco: ' else '' end) as 'LabelEndereco',
		 case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         ns.nm_endereco_entrega + ', ' + ns.cd_numero_endereco_ent 
       else
         ns.nm_endereco_nota_saida + ', ' + ns.cd_numero_end_nota_saida 
       end as 'Endereco',

       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         (case @ic_rotulo when 'S' then 'Bairro : ' else '' end) + ns.nm_bairro_entrega
       else      
         (case @ic_rotulo when 'S' then 'Bairro : ' else '' end) + ns.nm_bairro_nota_saida 
       end as 'Bairro',
       
       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         (case @ic_rotulo when 'S' then 'Cidade : ' else '' end) + ns.nm_cidade_entrega
       else
         (case @ic_rotulo when 'S' then 'Cidade : ' else '' end) + ns.nm_cidade_nota_saida
       end as 'Cidade',
       
       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then
         (case @ic_rotulo when 'S' then 'Estado : ' else '' end) + ns.sg_estado_entrega
       else
         (case @ic_rotulo when 'S' then 'Estado : ' else '' end) + ns.sg_estado_nota_saida 
       end as 'Estado',

       case when ns.nm_endereco_entrega is not null and ns.nm_endereco_entrega <> ns.nm_endereco_nota_saida then 
       (case @ic_rotulo when 'S' then 'Cep    : ' else '' end) + dbo.fn_formata_mascara('99999-999',ns.cd_cep_entrega)
       else
       (case @ic_rotulo when 'S' then 'Cep    : ' else '' end) +dbo.fn_formata_mascara('99999-999',vw.cd_cep)
       end as 'CEP',

       (case @ic_rotulo when 'S' then  'A/C    : ' else '' end) +  Isnull(cc.nm_contato_cliente,'_______________________') as 'Contato' 
     from
        sedex_nota_saida_item sed
        inner join Nota_Saida ns  on sed.cd_nota_saida       = ns.cd_nota_saida 
        inner join Nota_Saida_item nsi on ns.cd_nota_saida        = nsi.cd_nota_saida
        left outer join Pedido_Venda pv on nsi.cd_pedido_venda     = pv.cd_pedido_venda
        inner join vw_Destinatario vw on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and vw.cd_destinatario      = ns.cd_cliente
		  left join cliente_contato cc on ( ns.cd_cliente = cc.cd_cliente and cc.cd_contato=pv.cd_contato)
     where
        sed.cd_nota_saida       = @cd_nota_saida
  end  

