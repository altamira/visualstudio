

CREATE PROCEDURE pr_emitir_boleto

@ic_parametro         int,  
@cd_documento_receber int,
@cd_banco             int,
@cd_empresa           int

AS 

  --select * from banco_boleto

  SELECT  top 1

    cast(dr.cd_cliente as varchar)                                                as 'cd_str_cliente',
    dr.cd_cliente,
    dr.cd_vendedor,

--    dr.cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
      ns.cd_identificacao_nota_saida
    else
      dr.cd_nota_saida
    end                               as cd_nota_saida,

    dr.vl_documento_receber,
    dr.cd_identificacao, 
    dr.dt_vencimento_documento, 
    d.nm_razao_social + '  ' + d.nm_razao_social_complemento                      as 'nm_sacado_doc_receber',
    dr.dt_emissao_documento,
    dr.cd_banco_doc_receber,
    dr.vl_documento_receber * 
    ((isnull(banco.pc_juros_banco, empresa.pc_juros_boleto)/100)/ 30)              as 'vl_juros_boleto',

    isnull(banco.pc_multa_banco, empresa.pc_multa_boleto)                          as 'pc_multa_boleto',
    isnull(banco.pc_juros_banco, empresa.pc_juros_boleto)                          as 'pc_juros_boleto',
    cast(isnull(banco.ds_banco_boleto, empresa.ds_banco_boleto) as varchar(8000))  as 'intrucoes',
    isnull(banco.nm_local_pagamento, empresa.nm_local_pagamento)                   as 'Local_Pagto',
    0                                                                              as 'dt_limite_desc',
    --dr.cd_cliente, 
    /*d.nm_endereco + ', ' + 
	    IsNull(d.cd_numero_endereco,'') + 
		  IsNull('-' + d.nm_complemento_endereco,'') + IsNull('-' + d.nm_bairro,'') as 'nm_endereco_cliente',*/ 
    es.sg_estado, 
    cid.nm_cidade, 

--select * from tipo_endereco
--select * from vw_destinatario_rapida

    case when 	ce.cd_tipo_endereco = 3
    then
   	isnull(ce.cd_cnpj_cliente,d.cd_cnpj) 
    else
      case when d.cd_tipo_pessoa = 1 then
		    d.cd_cnpj 
		  else
		    dbo.fn_formata_mascara('999.999.999-99',d.cd_cnpj) 
		  end 
    end                                  as 'cd_cnpj_cliente', 
    --c.cd_cep,
    d.cd_cep                             as 'cd_cep',
    d.cd_tipo_pessoa, 
    '.'                                  as ponto,
    isnull((select top 1 
       cd_pedido_venda 
     from 
       nota_saida_item  with (nolock) 
     where 
       cd_nota_saida = ns.cd_nota_saida),0) as 'Pedido',
     
    case when 	ce.cd_tipo_endereco = 3
    then
   	cast(isnull(ce.nm_endereco_cliente,' ') + ', ' + isnull(rtrim(ce.cd_numero_endereco),'') as varchar(2000))
    else
--   	cast(isnull(cli.nm_endereco_cliente,' ') + ', ' + isnull(rtrim(cli.cd_numero_endereco),'') as varchar(2000))
   	cast(isnull(d.nm_endereco,' ') + ', ' + isnull(rtrim(d.cd_numero_endereco),'') as varchar(2000))
    end as nm_endereco_cliente,

--	cast( 	isnull(ce.nm_endereco_cliente,' ') + ', ' + isnull(rtrim(ce.cd_numero_endereco),'') + '- CEP:' +
--		isnull(ce.cd_cep_cliente,' ') as varchar(2000))
--    else
--	cast( 	isnull(cli.nm_endereco_cliente,' ') + ', ' + isnull(rtrim(cli.cd_numero_endereco),'') + '- CEP:' +
--		isnull(cli.cd_cep,' ') as varchar(2000))
--    end as nm_endereco_cliente,

    case when 	ce.cd_tipo_endereco = 3
    then
	cast(	cast(ce.cd_ddd_cliente as char(5)) + ' ' + isnull(ce.cd_telefone_cliente,'')as varchar(2000))
    else
	--cast(	cast(cli.cd_ddd as char(5)) + ' ' + isnull(cli.cd_telefone,'') as varchar(2000))
        cast(	cast(d.cd_ddd as char(5)) + ' ' + isnull(d.cd_telefone,'') as varchar(2000))
    end                                                                                     as cd_telefone,

   --Telefone da Empresa

   emp.cd_telefone_empresa,

   case when ce.cd_tipo_endereco = 3 then 
  			   isnull(ce.nm_bairro_cliente, cli.nm_bairro)
        else 
         --cli.nm_bairro
         d.nm_bairro
    end                                             as nm_bairro_cliente,

  emp.nm_empresa,

  dbo.fn_formata_cnpj(emp.cd_cgc_empresa)           as cd_cgc_empresa,

  b.nm_logotipo_banco,

  Banco.sg_especie_doc_boleto,

  cast(dri.ds_instrucao_documento as varchar(8000)) as ds_instrucao_documento,
  isnull(ci.pc_desconto_boleto,0)                   as pc_desconto_boleto,
  isnull(banco.ic_calculo_juros_boleto,'N')         as 'ic_calculo_juros_boleto'

  Into
    #Temp

  FROM 
    Documento_Receber dr                         with (nolock) 
  LEFT OUTER JOIN  cliente_endereco ce		 with (nolock) ON ce.cd_cliente          = dr.cd_cliente and ce.cd_tipo_endereco = 3 
  LEFT OUTER JOIN  cliente cli			 with (nolock) ON cli.cd_cliente         = dr.cd_cliente 
  left outer join  vw_Destinatario_Rapida d    	 with (nolock) ON d.cd_destinatario      = dr.cd_cliente and
                                    		                  d.cd_tipo_destinatario = dr.cd_tipo_destinatario   
 
  LEFT OUTER JOIN  Cep                    c      with (nolock) ON c.cd_cep = 	case when isnull(ce.cd_tipo_endereco,0) = 3
								  then
									ce.cd_cep_cliente
								else
									--cli.cd_cep
                                                                   d.cd_cep
								end
								
  LEFT OUTER JOIN  Estado                 es     with (nolock) ON  es.cd_estado = case when isnull(ce.cd_tipo_endereco,0) = 3
								then
									ce.cd_estado
								else
									--cli.cd_estado	
                                                                  d.cd_estado
								end 
							
  LEFT OUTER JOIN  Cidade                 cid     with (nolock) ON cid.cd_cidade = case when isnull(ce.cd_tipo_endereco,0) = 3
								then
									ce.cd_cidade
								else
									--cli.cd_cidade
                                                                  d.cd_cidade
								end 	
								
  LEFT OUTER JOIN  Nota_Saida             ns       with (nolock) ON dr.cd_nota_saida   = ns.cd_nota_saida  
  LEFT OUTER JOIN  Banco_Boleto           Banco    with (nolock) ON banco.cd_banco     = @cd_banco 
  LEFT OUTER JOIN  Banco                  b        with (nolock) ON b.cd_banco         = @cd_banco 
  LEFT OUTER JOIN  Parametro_Boleto       Empresa  with (nolock) ON empresa.cd_empresa = dbo.fn_empresa() 
  LEFT OUTER JOIN  egisadmin.dbo.empresa  emp      with (nolock) ON emp.cd_empresa     = dbo.fn_empresa()
  LEFT OUTER JOIN  Documento_receber_instrucao dri with (nolock) ON dri.cd_documento_receber = dr.cd_documento_receber
  LEFT OUTER JOIN  Cliente_Informacao_Credito ci   with (nolock) ON ci.cd_cliente            = cli.cd_cliente

  WHERE       
    dr.cd_documento_receber = @cd_documento_receber

--select * from vw_destinatario_rapida

select 
	t.*,

--         case when isnull(t.vl_juros_boleto,0)=0 
--         then
--          ''
--         else
--          'R$ '+ cast( round(isnull(t.vl_juros_boleto,0),2) as varchar)+' '
--         end
-- 
--         +  

	--rtrim(ltrim(cast(t.intrucoes as varchar(8000)))  as 'ds_banco_boleto'

	ltrim(rtrim( cast(t.intrucoes as varchar(7940) )))

        +

        case when isnull(t.vl_juros_boleto,0)=0 
        then
         ''
        else
          case when t.ic_calculo_juros_boleto='S' then
            ltrim(rtrim( 'R$ '+ cast( round(isnull(t.vl_juros_boleto,0),2) as varchar(60) )+' '))
          else
            ''
          end

        end                                         as 'ds_banco_boleto'

from #temp t

