CREATE PROCEDURE pr_consulta_nota_fiscal_individual

------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Carrasco Neto
--Banco de Dados: EGISSQL
--Objetivo: Consultar uma nota Fiscal
--Data: 04/06/2002
--Atualizado: 
-- Adicionado campo Observação da Nota. - 07/06/2002
-- Modificado cd_operacao_fiscal , para cd_mascara_operacao - Daniel C. Neto - 16/04/2002
-- Modificado forma de Pegar o nome do Cliente e Razão Social - Daniel C. Neto - 08/01/2003
-- Adicionado campos de Cancelamento e Devolução da Nota - Daniel C. Neto - 25/03/2003
-- Incluído campos de 2. Naturezao Operação, Op. Triangular, SMO - Daniel C. Neto - 09/04/2003 
-- Incluído flag para indicar existência de carta de correção - Daniel C. Neto - 22/04/2003
-- Incluído flag para indicar existência de complemento - Daniel C. Neto - 05/05/2003
-- 16.06.2007 - Verificação do Item da Nota fiscal - Carlos Fernandes
-- 10.11.2007 - Acerto do campo motivo da devolução/Cancelamento
-- 22.07.2008 - Ajuste
-- 04.09.2008 - Ajuste de Casas Decimais - Carlos Fernandes
-- 10.03.2009 - Inclusão de campos (NFe) - Douglas de Paula Lopes
-- 17.06.2009 - Verificação dos campos para - NFE - Carlos Fernandes
-- 01.07.2009 - Telefone do Cliente - Carlos Fernandes
-- 05.08.2009 - Ajustes - Carlos Fernandes
-- 31.08.2009 - código Kardex do cliente - Carlos Fernandes/Luis
-- 02.09.2009 - Ajuste do Kardex p/ Vir da Nota de Saída - Carlos Fernandes
-- 08.09.2009 - Novo Flag para Ordem de Apresentação dos Itens - Carlos Fernandes
-- 16.09.2009 - Registro do Produto - Carlos Fernandes 
-- 21.09.2009 - Endereço de Entrega - Carlos Fernandes
-- 17.03.2010 - Parâmetro para mostrar o código do Cliente - Carlos Fernandes
-- 02.06.2010 - Checagem da Descrição Técnica do Produto - Carlos Fernandes
-- 12.10.2010 - Busca da Nota Fiscal - Carlos Fernandes
-- 10.12.2010 - Verificação da Chave de acesso - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_nota_saida     int = 0,
@ic_parametro      int = 0,
@cd_tipo_relatorio int = 0 --> 0 : Padrão  / 9 : Cópia da Nota

--@cd_ordem_item int = 0 --0 --> Padrão / 1--> Alfabética

AS

--select * from parametro_faturamento

declare @ic_numeracao_nfe         char(1)
declare @ic_pcd_serie_nota_fiscal char(1)
declare @cd_ordem_item            int 
declare @ic_codigo_destinatario   char(1)
  
declare @cd_nota_saida_v110 int
declare @sg_versao_nfe      char(10)

set @cd_nota_saida_v110 = 0

--select * from versao_nfe

select
  top 1
  @cd_nota_saida_v110 = isnull(cd_nota_saida,0),
  @sg_versao_nfe      = isnull(sg_versao_nfe,'2.00'),
  @ic_codigo_destinatario = isnull(ic_codigo_destinatario,'S')
from
  Versao_NFe with (nolock)


--Ordem de Apresentação do Item

set @cd_ordem_item = 0  --> 0 = Ordem de Item de Nota / 1 = Ordem Alfab[etica / 2 = Código / 3 = Fantasia 
                        

select
  @ic_numeracao_nfe = isnull(ic_numeracao_nfe,'N'),
  @cd_ordem_item    = isnull(cd_ordem_item,0)
from
  parametro_faturamento with (nolock) 

where
  cd_empresa = dbo.fn_empresa()


--Ordem de geração da Nota / NFE 

if @cd_tipo_relatorio <> 9 
   set @cd_ordem_item = 0

--Série da Nota
  
select
  @ic_pcd_serie_nota_fiscal = isnull(ic_pcd_serie_nota_fiscal,'N')
from
  Serie_Nota_Fiscal with (nolock) 
where
  cd_serie_nota_fiscal = ( select top 1 cd_serie_notsaida_empresa 
                           from egisadmin.dbo.empresa 
                           where cd_empresa = dbo.fn_empresa() )

  
------------------------------------------------------  
if @ic_parametro = 1 -- Consultar Dados.
------------------------------------------------------
begin

  SELECT    --- select replicate('0',5)

    --Identificação da Nota Fiscal
    ns.cd_identificacao_nota_saida,

    --Dados do Nfe 
    'N: '     + 
    case when @ic_numeracao_nfe = 'N' then
      --replicate('0', 7 - len(isnull(cast(ns.cd_nota_saida as varchar(20)),''))) + cast(ns.cd_nota_saida as varchar(20)) 
      replicate('0', 7 - len(isnull(cast(ns.cd_identificacao_nota_saida as varchar(20)),''))) + cast(ns.cd_identificacao_nota_saida as varchar(20)) 
    else
      replicate('0', 7 - len(isnull(cast(ns.cd_num_formulario_nota as varchar(20)),''))) + cast(ns.cd_num_formulario_nota as varchar(20)) 
    end                                                                    as NumeroCabecalho,  

    'Série: ' + isnull(cast(snf.qt_serie_nota_fiscal as varchar(3)),'1')   as SerieCabecalho,

    --Destinatário-----------------------------------------------------------------------

    case when @ic_codigo_destinatario = 'S' then
       isnull(rtrim(ltrim(cast(isnull(d.cd_destinatario,0) as varchar(10)))),'') + ' - '
    else
       '' 
    end
    + 
    isnull(d.nm_razao_social,'')                                                                        as destinatario,

    isnull(d.nm_endereco,'') + ', ' + isnull(rtrim(ltrim(cast(d.cd_numero_endereco as varchar(8)))),'') as enderecoDest,

    case when rtrim(ltrim(ns.nm_endereco_nota_saida)) = '' then  
      '' 
    else
      rtrim(ltrim(ns.nm_endereco_nota_saida))+ ', ' + 
      isnull(cast(ns.cd_numero_end_nota_saida as varchar(8)),'S/N') 
    end                                             as EnderecoCabecalho,

--    substring(vw.chaveAcesso,4,len(vw.chaveacesso)) as ChaveAcesso,

    case when  ns.cd_identificacao_nota_saida <= @cd_nota_saida_v110 then
        substring(vw110.chaveAcesso,4,len(vw110.chaveacesso)) 
    else
       substring(vw.chaveAcesso,4,len(vw.chaveacesso)) 
    end                                             as ChaveAcesso,  


    ns.cd_inscest_nota_saida,
    case when len(rtrim(ltrim(replace(replace(replace(d.cd_cnpj ,'.',''),'/',''),'-','')))) > 11 then
      dbo.fn_Formata_Mascara('99.999.999/9999-99',d.cd_cnpj ) 
    else
      dbo.fn_Formata_Mascara('999.999.999-99',d.cd_cnpj)  -- select cd_cnpj_entrega_nota from nota_saida
    end                                                                                        as cnpjNotaSaida,
    case when isnull(ns.cd_tipo_operacao_fiscal,0)=2 then '1' else '2' end                     as 'tpNF',
    case when ns.cd_placa_nota_saida is null then 
      vei.cd_placa_veiculo
    else
      ns.cd_placa_nota_saida
    end  as cd_placa_veiculo,
 
   cast(t.cd_registro_transportadora as varchar(20)) as cd_registro_transportadora,

    (select e.sg_estado from estado e where e.cd_estado = vei.cd_estado)                                as UFPlacaVeiculo, 
    (select mv.nm_marca_veiculo from marca_veiculo mv where mv.cd_marca_veiculo = vei.cd_marca_veiculo) as MarcaVeiculo, 
    t.cd_insc_estadual as cd_insc_estadual_transp,
    ns.cd_inscmunicipal_nota,

    --Dados Gerais da NF----------------------------------------------------------------------------

    ns.cd_nota_saida                                     as cd_controle, 
    ns.cd_nota_saida,

--     case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
--        ns.cd_identificacao_nota_saida
--     else
--        ns.cd_nota_saida
--     end                                                  as cd_nota_saida,

    ns.cd_num_formulario_nota,
    ns.dt_nota_saida,
    ns.cd_status_nota,
    sn.nm_status_nota,
    ns.cd_pedido_venda,
    ns.nm_mot_cancel_nota_saida,
    IsNull(dt_nota_dev_nota_saida,ns.dt_cancel_nota_saida) as 'dt_cancel_nota_saida',
    ( select count(d.cd_nota_saida) from Documento_Receber d where d.cd_nota_saida = ns.cd_nota_saida) as 'QtdeDuplicatas',

    ns.cd_mascara_operacao,
    ns.cd_mascara_operacao2,
    ns.cd_mascara_operacao3,

    ns.nm_operacao_fiscal,
    ns.nm_operacao_fiscal2,
    ns.nm_operacao_fiscal3,

    ns.cd_nota_fiscal_origem,
    ns.ds_obs_compl_nota_saida,

    dp.nm_destinacao_produto,
 	  cp.nm_condicao_pagamento,
    fp.nm_forma_pagamento,

    --dados do Vendedor

    v.nm_fantasia_vendedor,
   ( select ' (' + IsNull(cd_ddd_vendedor,'') + ') ' + IsNull(cd_telefone_vendedor,'') from Vendedor where cd_vendedor = ns.cd_vendedor) as 'cd_telefone_vendedor', 

    --Dados do Destinatário 

	  td.nm_tipo_destinatario,
		d.nm_fantasia                  as 'nm_fantasia_dest',
		d.nm_razao_social              as 'nm_razao_social_dest',
		(select nm_tipo_pessoa from Tipo_Pessoa where cd_tipo_pessoa = d.cd_tipo_pessoa) as 'tipo_pessoa_dest',
		d.cd_cnpj                      as 'cd_cnpj_dest',
		d.cd_inscestadual              as 'cd_inscestadual_dest',
		d.nm_endereco                  as 'nm_endereco_dest',
		d.cd_numero_endereco           as 'cd_numero_end_dest',
		d.nm_complemento_endereco      as 'nm_end_compl_dest',
		d.nm_bairro                    as 'nm_bairro_dest',
		d.cd_cep                       as 'cd_cep_dest',
		(Select nm_cidade from Cidade where cd_pais = d.cd_pais and cd_estado = d.cd_estado and cd_cidade = d.cd_cidade) as 'nm_cidade_dest',
		(Select sg_estado from Estado where cd_pais = d.cd_pais and cd_estado = d.cd_estado) as 'sg_estado_dest',
		d.cd_ddd                       as 'cd_ddd_dest',
		d.cd_telefone                  as 'cd_telefone_dest',
		d.cd_fax                       as 'cd_fax_dest',

    --Cobrança

		d.nm_endereco_cob              as 'nm_end_dest_cob',
		d.cd_numero_endereco_cob       as 'cd_num_end_dest_cob',
		d.nm_complemento_endereco_cob  as 'nm_end_compl_dest_cob',
		d.nm_bairro_cob                as 'nm_bairro_dest_cob',
		d.cd_cep_cob                   as 'cd_cep_dest_cob',
		(Select nm_cidade from Cidade where cd_pais = d.cd_pais_cob and cd_estado = d.cd_estado_cob and cd_cidade = d.cd_cidade_cob) as 'nm_cidade_dest_cob',
		(Select sg_estado from Estado where cd_pais = d.cd_pais and cd_estado = d.cd_estado) as 'sg_estado_dest_cob',

    --select * from nota_saida

                nm_endereco_nota_saida,
                cd_numero_end_nota_saida,
                nm_compl_endereco_nota,
                nm_bairro_nota_saida,
                ns.cd_num_formulario_nota,
		ns.cd_cep_entrega,
                (select count(*) from nota_saida_item where cd_nota_saida = ns.cd_nota_saida and ic_tipo_nota_saida_item = 'P') as total_itens_nota_saida,
                (Select nm_pais  from pais where cd_pais = ns.cd_pais) as 'pais',
                ns.cd_cep_nota_saida,
                mot.nm_motorista,
                vei.nm_veiculo,

                ns.cd_ddd_nota_saida,
                --ns.cd_telefone_nota_saida,

                case when isnull(ns.cd_ddd_nota_saida,'') <> '' then
                  '('+ns.cd_ddd_nota_saida+')-'+ns.cd_telefone_nota_saida
                else
                   ns.cd_telefone_nota_saida
                end                              cd_telefone_nota_saida,
                
    --Local de Entrega

                -- Endereço de Entrega

                ns.cd_cnpj_entrega_nota,
		ns.dt_entrega_nota_saida,
		ns.nm_bairro_entrega,
		ns.nm_cidade_entrega,
		ns.nm_endereco_entrega,
                ns.cd_numero_endereco_ent,
		ns.nm_entregador_nota_saida,
		ns.nm_local_entrega_nota,
		ns.sg_estado_entrega,
                tle.nm_tipo_local_entrega,

                case when nm_endereco_entrega = nm_endereco_nota_saida 
                then 'O Mesmo'           
                else
                  ltrim(rtrim(ns.nm_endereco_entrega))+', '+ltrim(rtrim(ns.cd_numero_endereco_ent))+' '+
                  ltrim(rtrim(ns.nm_bairro_entrega))+' '+ltrim(rtrim(ns.nm_cidade_entrega))+'/'+ltrim(rtrim(ns.sg_estado_entrega))
                end as 'Entrega',
 
    --Dados de Volume da NF

    ns.qt_volume_nota_saida,
    ns.nm_marca_nota_saida,
    ns.nm_especie_nota_saida,
    ns.nm_numero_emb_nota_saida,
    ns.qt_peso_bruto_nota_saida,
    ns.qt_peso_liq_nota_saida,
    ns.dt_saida_nota_saida,


    --Dados da Transportadora

    t.nm_transportadora,
    t.nm_fantasia           as 'nm_fantasia_trans',

    --Verificar se o cliente é retira
    --select * from vw_destinatario

    case when isnull(t.ic_destinatario,'N')='N' then
       t.cd_cnpj_transportadora
    else
       d.cd_cnpj
    end                     as 'cd_cnpj_transportadora',
    
    case when isnull(t.ic_destinatario,'N')='N' then
      t.cd_cep
    else
      d.cd_cep
    end                     as 'cd_cep_trans',

    case when isnull(t.ic_destinatario,'N')='N' then
       t.cd_numero_endereco 
    else
       d.cd_numero_endereco
    end   as 'cd_num_end_trans',
    
    case when isnull(t.ic_destinatario,'N')='N' then
      ltrim(rtrim(t.nm_endereco))+' '+ltrim(rtrim(t.cd_numero_endereco)) 
    else
      ltrim(rtrim(d.nm_endereco))+' '+ltrim(rtrim(d.cd_numero_endereco)) 
    end                     as 'nm_end_trans',

    case when isnull(t.ic_destinatario,'N')='N' then
      t.nm_bairro 
    else
     d.nm_bairro
    end            as 'nm_bairro_trans',
    
    case when isnull(t.ic_destinatario,'N')='N' then
      t.cd_fax 
    else
      d.cd_fax
    end               as 'cd_fax_trans',

    case when isnull(t.ic_destinatario,'N')='N' then
      t.cd_telefone   
    else
      d.cd_telefone
    end                     as 'cd_telefone_trans',

    case when isnull(t.ic_destinatario,'N')='N' then
      t.cd_ddd
    else
      d.cd_ddd
    end                    as 'cd_ddd_trans',
 
    case when isnull(t.ic_destinatario,'N')='N' then
      '('+rtrim(ltrim(t.cd_ddd)) + ')-' + rtrim(ltrim(t.cd_telefone))                           
    else
      '('+rtrim(ltrim(d.cd_ddd)) + ')-' + rtrim(ltrim(d.cd_telefone))                           
    end as 'Telefone_Transportadora',

    case when isnull(t.ic_destinatario,'N')='N' then
      (Select sg_estado From Estado where cd_pais = t.cd_pais and cd_estado = t.cd_estado) 
    else
      d.sg_estado
    end as 'sg_estado_trans',

    case when isnull(t.ic_destinatario,'N')='N' then  
    (Select nm_cidade From Cidade where cd_pais = t.cd_pais and cd_estado = t.cd_estado and cd_cidade = t.cd_cidade) 
    else
      d.nm_cidade
    end as 'nm_cidade_trans',

    t.cd_insc_municipal,

--  t.cd_insc_estadual,

    case when isnull(t.ic_destinatario,'N')='N' then
      cast(replace(replace(replace(t.cd_insc_estadual,'-',''),'.',''),'/','') as varchar(15))      
    else
      cast(replace(replace(replace(d.cd_inscestadual,'-',''),'.',''),'/','') as varchar(15))      
    end                                                                                            as 'cd_insc_estadual',

    ( select nm_tipo_transporte from Tipo_Transporte where cd_tipo_transporte = t.cd_tipo_transporte) as 'ViaTransporte',
	  tpf.nm_tipo_pagamento_frete,

    --Valores da Nota Fiscal

	  ns.vl_bc_icms,
	  ns.vl_bc_subst_icms,
	  ns.vl_icms,
	  ns.vl_icms_subst,
	  ns.vl_ipi,
	  ns.vl_servico,
	  ns.vl_iss,
	  ns.vl_irrf_nota_saida,
	  ns.vl_frete,
	  ns.vl_seguro,
	  ns.vl_desp_acess,
	  ns.vl_produto,
	  ns.vl_total,
	  ns.ic_fiscal_nota_saida,
    IsNull(oe.nm_observacao_entrega,'') + ' ' + IsNull(ns.nm_obs_entrega_nota_saida,'') as 'ObsEntrega',
    IsNull(e.nm_entregador,'') + ' - ' + IsNull(nm_entregador_nota_saida,'')            as 'Entregador',
    ic_entrega_nota_saida,
    ic_minuta_nota_saida,
    it.nm_itinerario,

    --Flags para verificação das TabSheets
    isnull(ns.ic_emitida_nota_saida,'N')                                                as ic_emitida_nota_saida,

	  case 
            when IsNull(op.cd_oper_fiscal_smo, 0) = 0 then 'N' 
            else 'S' 
          end as 'ic_smo',
	  case 
            when IsNull(op.cd_oper_fiscal_op_triang,0) = 0 then 'N' 
            else 'S' 
          end as 'ic_op_triang',
	  case 
            when exists ( select top 1 c.* from Carta_Correcao c with (nolock) 
	                  where c.cd_nota_saida = ns.cd_nota_saida ) then 'S'
	    else 'N' 
          end as 'ic_carta_correcao',
	  case 
            when exists ( select top 1 nsc.* from Carta_Correcao c with (nolock) 
	                  where nsc.cd_nota_saida = ns.cd_nota_saida ) then 'S'
	    else 'N' 
          end as 'ic_nota_saida_complemento',

        nsr.dt_autorizacao_nota,
        nsr.cd_protocolo_nfe,
        nsr.cd_recibo_nfe_nota_saida,
        snf.sg_serie_nota_fiscal,
        snf.nm_serie_nota_fiscal	  

	FROM         
	  Nota_Saida ns with (nolock) 
          left outer join Transportadora t         with (nolock) on t.cd_transportadora = ns.cd_transportadora
          left outer join Tipo_Pagamento_Frete tpf with (nolock) on tpf.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete 
          left outer join Operacao_Fiscal op       with (nolock) on op.cd_operacao_fiscal = ns.cd_operacao_fiscal 
          left outer join Status_Nota sn           with (nolock) ON sn.cd_status_nota = ns.cd_status_nota 
          LEFT OUTER JOIN Vendedor v               with (nolock) ON v.cd_vendedor = ns.cd_vendedor 
          left outer join Cliente c                ON c.cd_cliente = ns.cd_cliente 
          left outer join Condicao_Pagamento cp    on ns.cd_condicao_pagamento = cp.cd_condicao_pagamento
          left outer join Tipo_Destinatario td     on td.cd_tipo_destinatario = ns.cd_tipo_destinatario
          left outer join Nota_Saida_Complemento nsc on nsc.cd_nota_saida = ns.cd_nota_saida 
          left outer join vw_destinatario d      on ns.cd_tipo_destinatario = d.cd_tipo_destinatario   
                                                    and ns.cd_cliente      = d.cd_destinatario 
          Left Outer Join Destinacao_Produto dp  on ns.cd_destinacao_produto = dp.cd_destinacao_produto
          Left Outer Join Tipo_Local_Entrega tle on ns.cd_tipo_local_entrega = tle.cd_tipo_local_entrega
          Left outer join Observacao_Entrega oe  on oe.cd_observacao_entrega = ns.cd_observacao_entrega
          Left outer join Entregador e           on e.cd_entregador = ns.cd_entregador 
          Left outer join Itinerario it          on it.cd_itinerario = ns.cd_itinerario
          Left outer join veiculo vei            on vei.cd_veiculo = ns.cd_veiculo
          Left outer join motorista mot          on mot.cd_motorista = ns.cd_motorista 
          left outer join vw_nfe_chave_acesso vw    with (nolock)    on vw.cd_nota_saida     = ns.cd_nota_saida

     left outer join cliente_informacao_credito cic with (nolock) on cic.cd_cliente              = ns.cd_cliente
     left outer join forma_pagamento            fp  with (nolock) on fp.cd_forma_pagamento       = cic.cd_forma_pagamento
     left outer join serie_nota_fiscal          snf with (nolock) on snf.cd_serie_nota_fiscal    = ns.cd_serie_nota   
     left outer join nota_saida_recibo          nsr with (nolock) on nsr.cd_nota_saida           = ns.cd_nota_saida
     left outer join vw_nfe_chave_acesso_110 vw110  with (nolock) on vw110.cd_nota_saida          = ns.cd_nota_saida  

--select * from nota_saida_recibo
--select * from nota_saida

 WHERE
   ns.cd_nota_saida = @cd_nota_saida

end

--------------------------------------------------------
else -- Consultar Itens
--------------------------------------------------------
--select * from nota_saida_item

begin

SELECT     
  ns.cd_identificacao_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida, 
  isnull(nsi.qt_item_nota_saida,0)                 as qt_item_nota_saida, 
  isnull(nsi.vl_unitario_item_nota,nsi.vl_servico) as vl_unitario_item_nota, 

--   case when isnull(cd_servico,0)=0 then
--     round(nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota,2) 
--   else
--     round(nsi.qt_item_nota_saida * nsi.vl_servico,2)
--   end                                               as vl_total_item, 

  nsi.vl_total_item,

  case when isnull(nsi.cd_servico,0)>0 then
   nsi.cd_servico
  else
   isnull(nsi.cd_produto,nsi.cd_grupo_produto) 
  end                                                 as cd_mascara_produto,

  isnull(nsi.cd_mascara_produto,p.cd_mascara_produto) as CodigoVer,
  nsi.nm_fantasia_produto, 

  --Concatenar o Código do Cliente --> Produto Kardex
  rtrim(ltrim(isnull(nsi.nm_produto_item_nota,'')))  
  +
  case when isnull(pc.ic_nf_produto_cliente,'N')='S' and isnull(pc.nm_fantasia_prod_cliente,'')<>'' then
    ' ('+ltrim(rtrim(isnull(pc.nm_fantasia_prod_cliente,'')))+')'
  else
   ''
  end                                          

  --select * from nota_saida_item  
  +

  --Kardex digitado direto na Nota Fiscal

  case when isnull(pc.nm_fantasia_prod_cliente,'')='' and isnull(pc.nm_fantasia_prod_cliente,'')<>nsi.nm_kardex_item_nota_saida then
   ' ('+ISNULL(nsi.nm_kardex_item_nota_saida,'')+')'
  else
    ''
  end

  --verifica o kardex do item da nota fiscal

  --Lote
  +
  case when isnull(nsi.cd_lote_item_nota_saida,'')<>'' then
    ' Lote: '+ltrim(rtrim(isnull(nsi.cd_lote_item_nota_saida,'')))
  else
   ''
  end

  +

  --Pedido de Compra do Cliente
  --select * from nota_saida_item

  case when @ic_pcd_serie_nota_fiscal = 'S' and isnull(nsi.cd_pd_compra_item_nota,'')<>''
  then
    ' '+rtrim(ltrim(isnull(nsi.cd_pd_compra_item_nota,'')))
  else
    ''
  end      

  --Registro do Produto
  --select * from produto

  + 

  case when isnull(p.cd_certificado_produto,'')<>'' then
    ' ('+ltrim(rtrim(isnull(p.cd_certificado_produto,'')))+') '
  else
   ''
  end
 
  as 'nm_produto', 

  --Descrição Técnica-----------------------------------------------------------
  

  --Descrição Técnica do Produto 1

  case when 
     ltrim(rtrim(cast(nsi.ds_item_nota_saida as varchar(500))))<>''     --isnull(p.ic_descritivo_nf_produto,'N') = 'S' and
  then
     case when isnull(cast(nsi.ds_item_nota_saida as varchar(500)),'')<>'' then
       nsi.ds_item_nota_saida
     end
  else
     case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' and
          ltrim(rtrim(cast(p.ds_produto as varchar(500))))<>'' 
    then
       case when isnull(cast(p.ds_produto as varchar(500)),'')<>'' then
         p.ds_produto
       end
    else
      cast(null as text )
    end
  end as nm_produto_1,

  um.sg_unidade_medida,                  
  nsi.cd_status_nota,
  nsi.cd_pedido_venda, 
  nsi.cd_item_pedido_venda, 
  nsi.ic_status_item_nota_saida,
  nsi.dt_cancel_item_nota_saida,
  cast(nsi.nm_motivo_restricao_item as varchar(40)) as nm_motivo_restricao_item,
--  nsi.nm_motivo_restricao_item,
  cast(nsi.nm_motivo_restricao_item as varchar )    as Motivo,
  nsi.dt_restricao_item_nota,
  nsi.qt_devolucao_item_nota,
  nsi.cd_pd_compra_item_nota,
  nsi.cd_requisicao_faturamento,
  nsi.cd_item_requisicao,
  nsi.cd_lote_item_nota_saida,
  nsi.vl_ipi,
  nsi.pc_ipi,
  nsi.vl_icms_item,
  nsi.vl_base_icms_item,
  nsi.pc_icms,  -- select * from Nota_Saida_Item
  rtrim(ltrim(cast(ti.cd_digito_tributacao_icms as varchar(2)))) as cd_digito_tributacao_icms,
  isnull(rtrim(ltrim(replace(cf.cd_mascara_classificacao,'.',''))) + replicate('0', 8 - len(rtrim(ltrim(replace(cf.cd_mascara_classificacao,'.',''))))),'00000000')  as 'NCM',
  rtrim(ltrim(cast(replace(opf.cd_mascara_operacao,'.','') as varchar(10))))                          as 'CFOP',
  nsi.cd_situacao_tributaria
--select * from nota_saida_item

into
  #ConsultaItemNota

FROM
  Nota_Saida_Item                            nsi with (nolock)
  left outer join Nota_Saida                 ns  with (nolock) on ns.cd_nota_saida           = nsi.cd_nota_saida           
  left outer join classificacao_fiscal       cf  with (nolock) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal  
  left outer join unidade_medida             um  with (nolock) on um.cd_unidade_medida       = nsi.cd_unidade_medida
  left outer join produto_fiscal             pf  with (nolock) on pf.cd_produto              = nsi.cd_produto
  left outer join tributacao                 t   with (nolock) on t.cd_tributacao            = pf.cd_tributacao
  left outer join tributacao_icms            ti  with (nolock) on ti.cd_tributacao_icms      = t.cd_tributacao_icms 
  left outer join operacao_fiscal            opf with (nolock) on opf.cd_operacao_fiscal     = nsi.cd_operacao_fiscal     
  left outer join produto_cliente            pc  with (nolock) on pc.cd_produto              = nsi.cd_produto and
                                                                  pc.cd_cliente              = ns.cd_cliente

  left outer join produto                    p   with (nolock) on p.cd_produto               = nsi.cd_produto

--select * from produto_cliente
--select * from produto

WHERE
   nsi.cd_nota_saida = @cd_nota_saida 
   and 
   nsi.ic_tipo_nota_saida_item = 'P'

ORDER BY 
   nsi.cd_item_nota_saida

if @cd_ordem_item = 0
begin

   select * from #ConsultaItemNota
   order by
      cd_item_nota_saida

end

if @cd_ordem_item = 1
begin
   select * from #ConsultaItemNota
   order by
      nm_produto
end


end

