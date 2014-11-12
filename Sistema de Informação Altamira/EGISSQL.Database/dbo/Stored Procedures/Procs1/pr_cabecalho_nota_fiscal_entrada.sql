

CREATE   PROCEDURE pr_cabecalho_nota_fiscal_entrada
@ic_parametro int, -- mantido apenas para compatibilidade
@nm_fantasia_empresa varchar(20),
@cd_fornecedor int,
@cd_nota_fiscal int,
@cd_serie_nota_fiscal int

as

  select 
     cast('' as char(1)) as 'SAIDA',
     'X' as 'ENTRADA', -- será sempre de entrada

     right('000000'+cast(n.cd_nota_entrada as varchar(6)),6) as 'NUMERO',
     opf.nm_operacao_fiscal   as 'NATUREZAOPERACAO',
     opf.cd_mascara_operacao  as 'CFOP',
----     n.nm_operacao_fiscal2  as 'NATUREZAOPERACAO2',
----     n.cd_mascara_operacao2 as 'CFOP2',
----     n.nm_operacao_fiscal3  as 'NATUREZAOPERACAO3',
----     n.cd_mascara_operacao3 as 'CFOP3',

     cast('' as char(1)) as 'NATUREZAOPERACAO2',
     cast('' as char(1)) as 'CFOP2',
     cast('' as char(1)) as 'NATUREZAOPERACAO3',
     cast('' as char(1)) as 'CFOP3',

     ' ' as 'IESUBSTRIB',

     n.nm_razao_social as 'RAZAOSOCIAL',

     case when isnull(vw.cd_cnpj,'') = '' then '' 
          else case when len(vw.cd_cnpj)<=11 then dbo.fn_Formata_Mascara('999.999.999-99',vw.cd_cnpj)	
                    else dbo.fn_Formata_Mascara('99.999.999/9999-99',vw.cd_cnpj)	
               end 
    end as 'CNPJ',

    'EndCobranca' = 
        case when (vw.nm_endereco = vw.nm_endereco_cob) and 
                  (vw.cd_cep = vw.cd_cep_cob) and 
                  (vw.cd_numero_endereco = vw.cd_numero_endereco_cob) and
                  (vw.nm_complemento_endereco=vw.nm_complemento_endereco_cob) 
             then 'O Mesmo' 
             else vw.nm_endereco_cob + ',' + isnull(vw.cd_numero_endereco_cob,'') + ' ' +
                  isnull(vw.nm_complemento_endereco_cob,'') + ' - ' +
                  isnull(vw.nm_bairro_cob,'') + ' - ' +
                  isnull(ccob.nm_cidade,'') + ' - '+
                  isnull(ecob.sg_estado,'')
             end,

      vw.nm_endereco+' '+vw.cd_numero_endereco	as 'ENDERECO',
      vw.nm_bairro as 'BAIRRO',
      dbo.fn_Formata_Mascara('99999-999',vw.cd_cep)	as 'CEP',
      cend.nm_cidade as 'CIDADE',
      '('+rtrim(vw.cd_ddd)+') '+vw.cd_telefone as 'TELEFONE',
      eend.sg_estado as 'UF',

      vw.cd_inscestadual as 'INSCESTADUAL',
      convert(varchar, n.dt_nota_entrada, 3)     as 'EMISSAO',
      convert(varchar, n.dt_receb_nota_entrada, 3) as 'DATASAIDA',
      cast('' as char(1)) as 'HORASAIDA',
      cast(n.vl_iss_nota_entrada as decimal(25,2))     as 'VLISS',
      cast(n.vl_servico_nota_entrada as decimal(25,2)) as 'VLSERVICO',
      cast(n.vl_bicms_nota_entrada as decimal(25,2))    as 'VLBCICMS',
      cast(n.vl_icms_nota_entrada as decimal(25,2))     as 'VLICMS',
      cast(n.vl_bsticm_nota_entrada as decimal(25,2))  as 'VLBCICMSSUBSTRIB',
      cast(n.vl_sticm_nota_entrada as decimal(25,2))   as 'VLICMSSUBSTRIB',
      cast(n.vl_prod_nota_entrada as decimal(25,2))    as 'VLTOTALPRODUTO',
      cast(n.vl_frete_nota_entrada as decimal(25,2))   as 'VLFRETE',
      cast(n.vl_seguro_nota_entrada as decimal(25,2))  as 'VLSEGURO',
      cast(n.vl_despac_nota_entrada as decimal(25,2))  as 'VLDESPACESS',
      cast(n.vl_ipi_nota_entrada as decimal(25,2))     as 'VLIPI',
      cast(n.vl_total_nota_entrada as decimal(25,2))    as 'VLTOTALNF',

      t.nm_transportadora    as 'TRANSPORTADORA',
      'Fone Transportadora : ('+t.cd_ddd+') '+  t.cd_telefone + ' - '+
         (select top 1 tc.nm_contato from transportadora_contato tc 
          where tc.cd_transportadora = t.cd_transportadora) as 'FONETRANSPORTADORA',

      case when isnull(t.cd_cnpj_transportadora,'') = '' then '' 
           else dbo.fn_Formata_Mascara('99.999.999/9999-99',t.cd_cnpj_transportadora)	
      end as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!      

      LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco)) as 'ENDERECOTRANSP',

      c.nm_cidade                              as 'CIDADETRANSP',
      e.sg_estado                              as 'UFTRANSP',
      t.cd_insc_estadual                       as 'INSCESTTRANSP',

      n.cd_tipo_pagamento_frete as 'FRETECONTA',
      n.cd_placa_nota_saida     as 'PLACAVEICULO',
      n.sg_estado_placa         as 'UFPLACA',

      cast(n.qt_volume_nota_entrada as varchar)  as 'QTDEVOLUME',
      isnull(n.nm_especie_nota_entrada,'Caixa')  as 'ESPECIEVOLUME',
      n.nm_marca_nota_entrada                    as 'MARCAVOLUME',
      n.nm_num_emb_nota_entrada                  as 'NUMEROVOLUME',
      str(n.qt_bruto_nota_entrada,7,3)           as 'PESOBRUTO',
      str(n.qt_liquido_nota_entrada,7,3)         as 'PESOLIQUIDO',
      n.ds_obs_compl_nota_entrada                as 'DADOADICIONAL',

      cast('' as Varchar(50))                  as 'PEDIDOVENDA',                                        
      cast('' as Varchar(50))                  as 'PEDIDOCOMPRA',
      n.cd_serie_nota_fiscal,
      -- ELIAS 03/03/2004
      emp.nm_dominio_internet          as 'SITE',
      emp.nm_email_internet            as 'EMAIL',
      (SELECT TOP 1 CAST(msg.ds_mensagem_nota as VARCHAR(200)) FROM Mensagem_Nota msg WHERE msg.ic_ativa_mensagem_nota = 'S')as 'MENSAGEM',
      '.' as 'PONTO'


  into #CabecalhoNota

  from
     Nota_Entrada n

     Inner Join Operacao_Fiscal opf
                on opf.cd_operacao_fiscal = n.cd_operacao_fiscal

     Left Outer Join vw_Destinatario vw
                on vw.cd_tipo_destinatario = n.cd_tipo_destinatario and
                   vw.cd_destinatario = n.cd_fornecedor

     Left Outer Join Cidade cend
                on cend.cd_cidade = vw.cd_cidade

     Left Outer Join Estado eend
                on eend.cd_estado = vw.cd_estado

     Left Outer Join Cidade ccob
                on ccob.cd_cidade = vw.cd_cidade_cob

     Left Outer Join Estado ecob
                on ecob.cd_estado = vw.cd_estado_cob

     Left outer join Transportadora t
                on t.cd_transportadora = n.cd_transportadora

     left outer join Cidade c
                on c.cd_cidade = t.cd_cidade

     left outer join Estado e
                on e.cd_estado = t.cd_estado

     left outer join EGISADMIN.DBO.Empresa emp 
                on emp.cd_empresa = dbo.fn_empresa()
  where
     n.cd_fornecedor = @cd_fornecedor and
     n.cd_nota_entrada = @cd_nota_fiscal and
     n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

/*
  -- Puxar os números dos Pedidos de Venda e Compra
  declare @PEDIDO as Varchar(50) --lOC
  declare @NUMERO as Integer --CD_PRODUTO
  declare @PEDIDOVENDA as Varchar(100) --LOCALIZACAO
  declare @PEDIDOCOMPRA as Varchar(100) --LOCALIZACAO

  declare cCabecalhoNota
     cursor for select NUMERO, PEDIDOVENDA, PEDIDOCOMPRA
                from   #CabecalhoNota
                for update of PEDIDOVENDA, PEDIDOCOMPRA

  open cCabecalhoNota
  fetch next from cCabecalhoNota into @NUMERO, @PEDIDOVENDA, @PEDIDOCOMPRA

  while (@@FETCH_STATUS =0) begin

     -- atualizar com campo "PEDIDOVENDA" que irá no cabeçalho
     Set @PEDIDO = ( Select MAX( cd_pedido_venda )
                     from Nota_Saida_Item
                     where ( cd_nota_saida = @cd_nota_fiscal ) and
                     ( cd_pedido_venda is not null ) and
                     ( cd_pedido_venda > 0 ) )

     if ( @PEDIDO is not null ) begin

        Set @PEDIDO = ('('+ rtrim(cast(@PEDIDO as varchar)) +')')

        update #CabecalhoNota SET PEDIDOVENDA = @PEDIDO
        where NUMERO=@NUMERO
     end

     -- atualizar com campo "PEDIDOCOMPRA" que irá no cabeçalho
     Set @PEDIDO = ( Select MAX( cd_pd_Compra_item_nota )
                     from Nota_Saida_Item
                     where ( cd_nota_saida = @cd_nota_fiscal ) and
                           ( cd_pd_Compra_item_nota is not null ) and
                           ( cd_pd_Compra_item_nota <> '' ) )

     if ( @PEDIDO is not null ) begin

        Set @PEDIDO = ('('+ rtrim(cast(@PEDIDO as varchar)) +')')

        update #CabecalhoNota SET PEDIDOCOMPRA = @PEDIDO
        where NUMERO=@NUMERO
     end

     fetch next from cCabecalhoNota into @NUMERO, @PEDIDOVENDA, @PEDIDOCOMPRA

  end -- while

  close cCabecalhoNota
  deallocate cCabecalhoNota
*/

  select * from #CabecalhoNota
  drop table #CabecalhoNota

