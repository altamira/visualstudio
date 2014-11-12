
CREATE   PROCEDURE pr_cabecalho_nota_fiscal
------------------------------------------------------------------------------------------
--pr_cabecalho_nota_fiscal
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias P. da Silva/
--Banco de Dados: EGISSQL 
--Objetivo      : Listar as Informações do Cabeçalho da Nota Fiscal p/ sua impressão
--Data          : 06/07/2002
--Atualizado    : 09/08/2002 - Acréscimo dos campos de outras operações fiscais - ELIAS
--                28/08/2002 - Acertos - ELIAS
--                24/03/2003 - Acerto de Configuração de Máscaras e junção de versões
--                             dessa stored procedure (existia uma versão na SMC e outra em 
--                             outros clientes) - ELIAS
--                24.03.2003 - Colocação do Fone da Transportadora - carlos
--                16/05/2003 - Código p/ busca de CNPJ mesmo se o mesmo não foi gravado
--                             na NF, também não trazer nada como default - ELIAS
--                12/06/2003 - Incluído contato no Fone da Transportadora qdo POlimold - ELIAS
--                24/09/2003 - Conversão dos valores float p/ decimal - ELIAS
--                19.04.2004 - Incluido um novo campo de mensagem financeira - RAFAEL M. Santiago
--                14.05.2004 - Incluido o Nome do vendedor 
--                10.12.2004 - Incluido o campo de Referencia do Cliente - Rafael M. Santiago
--                22/01/2005 - Acertado campo Valot Total e Total dos Produtos para imprimir
--                             somado ao Valor Simbólico da NF. - ELIAS
--                30/03/2005 - Implementado rotina de impressão para o Cliente TRM com o recurso
--                             de associação à Classificação Fiscal utilizando Letras - ELIAS
--                28/09/2005 - Colocado o campo de Extenso - RAFAEL
--                12.12.2005 - Mensagem da Condição de Pagamento (TRM) - Carlos Fernandes
--                24.01.2006 - Correção para Meias Keny - Carlos Fernandes
--                25.05.2006 - Acerto dos dados da Transportadora - Bairro - Carlos Fernandes
--                24.07.2006 - Novos Campos - Centro Custo / Plano Financeiro - Carlos Fernandes
--                29.07.2006 - Cubagem - Alumin - Carlos Fernandes
--                19.08.2006 - Campos Fixos / Informações Fixas na Nota Fiscal - Carlos Fernandes
--                24.10.2006 - Acertos nos campos de Endereço de entrega/cobrança
--                             Rotina de impressão dos dados adicionais no Produto - Carlos Fernandes
--                15.11.2006 - Acerto do Pedido de Compra do Cliente - Carlos Fernandes
--                07.12.2006 - Classificação Fiscal - Carlos Fernandes
--                14.12.2006 - Multi-Formulário - Carlos Fernandes           
--                13.01.2007 - Multi-Formulário - Impressão de ****** em folhas da nota fiscal
--                18.01.2007 - Dados Adicionais - Corrigindo dados adicionais da PIC
--                05.02.2007 - Mostrar Classificações Adicionais nos Dados da Nota Fiscal - Carlos Fernandes
--                12.05.2007 - Checagem da Data de Saída conforme parâmetro faturamento - Carlos Fernades                                                   
--                06.07.2007 - Verificação da Data de Saída - Carlos Fernandes
--                01.09.2007 - Acertos Keny - Carlos Fernandes
--                10.10.2007 - Acerto da impressão da Classificação Fiscal - Carlos Fernandes
--                10.11.2007 - Verificação do Nome da FullCoat - Carlos Fernandes
-- 20.02.2008 - Nome Fantasia do Fornecedor na emissão da Nota Fiscal (Keny) - Carlos Fernandes               
-- 04.03.2008 - Criação de um campo específico para a descrição da Condição de Pagamento - Carlos Fernandes
-- 21.05.2008 - Criação de um campo específico para o Código do Cliente - Carlos Fernandes
-- 22.09.2008 - Complemento dos campos para Água Funda ( Motorista/Veículo/Forma de Pagamento/CPF's Autorizados
--              Mensagem do Cheque ) - Carlos Fernandes
-- 26.02.2009 - Complemento de Máscara no CNPJ/CPF do sócio representante - Douglas de Paula Lopes
-- 02.07.2009 - Mensagem de Acordo com a Operação Fiscal (PIC) - Carlos Fernandes
-- 15.07.2009 - Registro do Ministério da Agricultura - Carlos Fernandes
-- 07.10.2009 - Contato do Pedido de Venda - Carlos Fernandes 
-- 19.01.2010 - Ajuste do Endereço de Cobrança - Carlos Fernandes
-- 11.05.2010 - Classificação Fiscal - Meias Keny - Carlos Fernandes
-- 17.05.2010 - Continuação Classificação Fiscal dia 11/5 - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------
@ic_parametro               int         = 0,
@nm_fantasia_empresa        varchar(20) = '',
@cd_nota_fiscal             int         = 0,
@qt_folha_nota_fiscal       int         = 0,
@qt_total_folha_nota_fiscal int         = 0

as  
  
  -----------------------------------------------------------------------------  
  -- CÓDIGO PARA PREENCHER O CNPJ CASO O MESMO NÃO TENHA SIDO GRAVADO NA NOTA  
  -- DEVIDO A ERRO NO SFT - ELIAS 16/05/2003  
  -----------------------------------------------------------------------------  
  
  declare @cd_cnpj                       varchar(30)  
  declare @nm_extenso                    varchar(500)  
  declare @nm_extenso_duplicatas         varchar(500)  
  declare @vl_total                      float  
  declare @vl_total_duplicatas           float  
  declare @ds_complemento_classif_fiscal varchar(8000)  
  declare @nm_autorizado                 varchar(100)
  declare @cd_cliente                    int
  declare @cd_registro_m_agricultura     varchar(30)
  declare @cd_empresa                    int

  set @ds_complemento_classif_fiscal = ''
  set @nm_autorizado                 = ''
  set @cd_registro_m_agricultura     = '' 

  select
    @cd_nota_fiscal = ns.cd_nota_saida
  from
    Nota_Saida ns with (nolock) 
  where
    case when isnull(cd_identificacao_nota_saida,0)>0 
    then 
      cd_identificacao_nota_saida
    else
      cd_nota_saida
    end                                    = @cd_nota_fiscal  


  select
    @cd_empresa = dbo.fn_empresa()

  --CNPJ  
  
  select  
    @cd_cnpj    = replace(replace(replace(cd_cnpj_nota_saida,'.',''),'/',''),'-',''),
    @cd_cliente = isnull(cd_cliente,0)  
  from  
    nota_saida  with (nolock)
  where  
    cd_nota_saida = @cd_nota_fiscal  

   if @nm_fantasia_empresa like '%FUNDA%' 
   begin
      exec pr_cliente_autorizado_nota @cd_cliente,@nm_autorizado output
   end

  if ltrim(rtrim(@nm_autorizado)) <> '' 
    if len(ltrim(rtrim(@nm_autorizado)))< = 11  
      set @nm_autorizado = dbo.fn_Formata_Mascara('999.999.999-99',ltrim(rtrim(@nm_autorizado)))  
    else 
      set @nm_autorizado = dbo.fn_Formata_Mascara('99.999.999/9999-99',ltrim(rtrim(@nm_autorizado)))  

  if (isnull(@cd_cnpj,'') = '')   
    select  
      @cd_cnpj = replace(replace(replace(vw.cd_cnpj,'.',''),'/',''),'-','')  
    from  
      vw_destinatario vw,  
      nota_saida ns  
    where  
      ns.cd_nota_saida        = @cd_nota_fiscal           and  
      vw.cd_destinatario      = ns.cd_cliente             and  
      vw.cd_tipo_destinatario = ns.cd_tipo_destinatario  
  
  
--select * from nota_saida_layout  
--select cd_serie_notsaida_empresa,* from egisadmin.dbo.empresa  
  
------------------------------------------------------------------------------------------  
--A Rotina Abaixo monta uma Tabela com todos os campos fixos da Nota Fiscal  
------------------------------------------------------------------------------------------  
--Carlos 19.08.2006  
------------------------------------------------------------------------------------------  
  
select  
  @cd_nota_fiscal                                           as cd_nota_fiscal,  
  c.cd_campo_nota_fiscal,  
  c.nm_campo_nota_fiscal,  
  nsl.nm_fixo_nota_fiscal,  
  'F'+RTRIM(cast(c.cd_campo_nota_fiscal as varchar(6) ))    as CampoFixo  
into  
  #Fixa  
from  
  campo_nota_fiscal c                 with (nolock) 
  inner join egisadmin.dbo.Empresa e  with (nolock) on e.cd_empresa             = @cd_empresa
  inner join Nota_Saida_LayOut nsl    with (nolock) on nsl.cd_empresa           = e.cd_empresa                          and  
                                                       nsl.cd_serie_nota_fiscal = e.cd_serie_notsaida_empresa and  
                                                       nsl.cd_campo_nota_fiscal = c.cd_campo_nota_fiscal   
                                        
where  
  isnull(c.ic_fixo_campo_nota_fiscal,'N')='S'  
  

--select * from #Fixa

--Verificação da impressão dos Dados Adicionais

declare @ic_dado_adicional_produto    char(1)
declare @ic_gera_classif_fiscal_corpo char(1)
declare @ic_grava_data_hora_saida     char(1) 

select
  @ic_dado_adicional_produto     = isnull(ic_dado_adicional_produto,'N'),
  @ic_gera_classif_fiscal_corpo  = isnull(ic_gera_classif_fiscal_corpo,'N'),
  @ic_grava_data_hora_saida      = isnull(ic_grava_data_hora_saida,'N')
from
  Parametro_Faturamento with (nolock) 
where
  cd_empresa = @cd_empresa

-------------------------------------------------------------------------------  
--Controle da Largura da Nota Fiscal para Impressão Dados Adicionais no Corpo
-------------------------------------------------------------------------------  
--Carlos 31.10.2006

declare @qt_col_serie_nota_fiscal int
set     @qt_col_serie_nota_fiscal = 0

select
  @qt_col_serie_nota_fiscal = isnull(qt_col_serie_nota_fiscal,80)
from
  Serie_Nota_Fiscal with (nolock) 
where
  cd_serie_nota_fiscal = ( select top 1 cd_serie_notsaida_empresa from egisadmin.dbo.empresa where cd_empresa = @cd_empresa )


------------------------------------------------------------------------------------------
--Gera a Classificação Específica ou Gera a Numeração Automática
------------------------------------------------------------------------------------------

if @ic_gera_classif_fiscal_corpo = 'S'
begin

  --Gera a tabela temporária com as Classificações da Configuração

  select 
    i.cd_classificacao_fiscal,
    isnull(c.sg_sigla_classificacao_nota,'') as sg_sigla_classificacao_nota,
    cf.cd_mascara_classificacao              as cd_mascara_classificacao
  into
    #Item_Classificacao
  from 
    nota_saida_item i                     with (nolock) 
    inner join nota_saida_classificacao c with (nolock) on c.cd_classificacao_fiscal      = i.cd_classificacao_fiscal and
                                                           isnull(c.ic_imprime_nota, 'N') = 'S' 
    inner join classificacao_fiscal cf    with (nolock) on cf.cd_classificacao_fiscal     = i.cd_classificacao_fiscal

  where  
    cd_nota_saida = @cd_nota_fiscal and
    isnull(i.cd_classificacao_fiscal,0)>0

  group by
    i.cd_classificacao_fiscal, 
    c.sg_sigla_classificacao_nota,
    cf.cd_mascara_classificacao

  order by  
    c.sg_sigla_classificacao_nota

  --select * from #Item_Classificacao

  --Gera a Tabela das classificações que não estão na nota fiscal

    select 
      i.cd_classificacao_fiscal,
      isnull(f.nm_letra,'') as sg_sigla_classificacao_nota,
      cf.cd_mascara_classificacao            as cd_mascara_classificacao
    into
      #Item_Classificacao_Auxiliar
    from 
      nota_saida_item i                 with (nolock) 
      left join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = i.cd_classificacao_fiscal
      left join dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,0) f   on f.cd_mascara_classificacao = cf.cd_mascara_classificacao
    where  
      i.cd_nota_saida = @cd_nota_fiscal     and
      isnull(i.cd_classificacao_fiscal,0)>0  and
      i.cd_classificacao_fiscal not in ( select cd_classificacao_fiscal from nota_saida_classificacao )
    group by
      i.cd_classificacao_fiscal, 
      f.nm_letra,
      cf.cd_mascara_classificacao
    order by  
      f.nm_letra
   
--  end

  --Montagem da Variavel auxiliar para impressão : CLASSIFICACAOADICIONAL

 
  declare @cd_classificacao_fiscal int
  declare @cd_controle             int

  set @cd_controle = 1

  while exists(Select top 1 cd_classificacao_fiscal from #Item_Classificacao )
  begin

    Select top 1 @cd_classificacao_fiscal = cd_classificacao_fiscal
    from
      #Item_Classificacao	

       Select 
	 @ds_complemento_classif_fiscal = ltrim(rtrim( @ds_complemento_classif_fiscal ) ) +  
         case when sg_sigla_classificacao_nota<>'' 
         then
            cast(sg_sigla_classificacao_nota as Varchar(3)) + '- ' + rtrim(cd_mascara_classificacao)  + ' '
         else
            (select rtrim(nm_letra) + '- ' + rtrim(cd_mascara_classificacao) from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,@cd_controle) )
         end
       from 
 	#Item_Classificacao
       where 
	cd_classificacao_fiscal = @cd_classificacao_fiscal
		 		
       Delete from #Item_Classificacao
                   where cd_classificacao_fiscal = @cd_classificacao_fiscal

       set @cd_controle = @cd_controle + 1

  end

  --Auxiliar

  set @cd_controle = 0

  while exists(Select top 1 cd_classificacao_fiscal from #Item_Classificacao_Auxiliar )
  begin

    Select top 1 @cd_classificacao_fiscal = cd_classificacao_fiscal
    from
      #Item_Classificacao_Auxiliar	

       Select 
	 @ds_complemento_classif_fiscal = @ds_complemento_classif_fiscal +  
         case when sg_sigla_classificacao_nota<>'' 
         then
            cast(sg_sigla_classificacao_nota as Varchar(3)) + '-' + rtrim(cd_mascara_classificacao)  + ' '
          else
            (select top 1 rtrim(nm_letra) + ' - ' + rtrim(cd_mascara_classificacao)+' '
             from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,@cd_controle) )
         end
       from 
 	#Item_Classificacao_Auxiliar
       where 
	cd_classificacao_fiscal = @cd_classificacao_fiscal
		 		
       Delete from #Item_Classificacao_Auxiliar
       where cd_classificacao_fiscal = @cd_classificacao_fiscal


  end


  --Print @ds_complemento_classif_fiscal 

  Drop Table #Item_Classificacao
  Drop Table #Item_Classificacao_Auxiliar

end

 
-------------------------------------------------------------------------------  
if @ic_parametro = 1   -- NOTA_FISCAL_SAIDA  
-------------------------------------------------------------------------------  
  begin  

--print 'Aqui'

    -- TINTAS ATUAL  OU FULLCOAT
    
    if @nm_fantasia_empresa like '%TINTA%'  OR @nm_fantasia_empresa like '%FULL%COAT%'
      begin      
          
        select     
          case when     
            n.cd_tipo_operacao_fiscal = 2     
          then    
            'X'    
          else    
            ''    
          end        as 'SAIDA',    
          case when     
            n.cd_tipo_operacao_fiscal = 1     
          then    
            'X'    
          else    
            ''    
          end        as 'ENTRADA',    

          case when isnull(n.cd_identificacao_nota_saida,0)>0 then
            right('000000'+cast(n.cd_identificacao_nota_saida as varchar(6)),6) 
          else
            right('000000'+cast(n.cd_nota_saida as varchar(6)),6) 
          end                                                                         as 'NUMERO',    


          n.nm_operacao_fiscal                                                        as 'NATUREZAOPERACAO',    
          n.cd_mascara_operacao                                                       as 'CFOP',    
          n.nm_operacao_fiscal2                                                       as 'NATUREZAOPERACAO2',    
          n.cd_mascara_operacao2                                                      as 'CFOP2',    
          n.nm_operacao_fiscal3                                                       as 'NATUREZAOPERACAO3',    
          n.cd_mascara_operacao3                                                      as 'CFOP3',    
          ''                                                                          as 'IESUBSTRIB',    
         rtrim(ltrim(n.nm_razao_social_nota))+' '+rtrim(ltrim(n.nm_razao_social_c))   as 'RAZAOSOCIAL',  
         -- n.cd_cnpj_nota_saida      as 'CNPJ',    
         case isnull(@cd_cnpj,'')   
            when '' then ''   
          else   
            case   
              when len(@cd_cnpj)<=11 then dbo.fn_Formata_Mascara('999.999.999-99',@cd_cnpj)  
            else dbo.fn_Formata_Mascara('99.999.999/9999-99',@cd_cnpj)   
            end   
          end        as 'CNPJ',   
          n.nm_endereco_nota_saida+' '+n.cd_numero_end_nota_saida as 'ENDERECO',    
          n.nm_bairro_nota_saida     as 'BAIRRO',    
          n.cd_cep_nota_saida        as 'CEP',    
          n.nm_cidade_nota_saida     as 'CIDADE',    
          n.cd_telefone_nota_saida+' / '+n.cd_fax_nota_saida  as 'TELEFONE',    
          n.sg_estado_nota_saida     as 'UF',    
          n.cd_inscest_nota_saida    as 'INSCESTADUAL',    
          n.dt_nota_saida            as 'EMISSAO',    
          n.dt_saida_nota_saida      as 'DATASAIDA',    
          n.hr_saida_nota_saida      as 'HORASAIDA',    
          n.vl_iss                   as 'VLISS',    
          n.vl_servico               as 'VLSERVICO',    
          n.vl_bc_icms               as 'VLBCICMS',    
          n.vl_icms                  as 'VLICMS',    
          n.vl_bc_subst_icms         as 'VLBCICMSSUBSTRIB',    
          n.vl_icms_subst            as 'VLICMSSUBSTRIB',    
          isnull(n.vl_simbolico,0) + n.vl_produto       as 'VLTOTALPRODUTO',    
          n.vl_frete                                    as 'VLFRETE',    
          n.vl_seguro                                   as 'VLSEGURO',    
          n.vl_desp_acess                               as 'VLDESPACESS',    
          n.vl_ipi                                      as 'VLIPI',    
          isnull(n.vl_simbolico,0)                      as 'VLSIMBOLICO',
          isnull(n.vl_simbolico,0)
          + isnull(n.vl_total,0)                        as 'VLTOTALNF',    
          --'PIS : '    + cast( cast( isnull(vl_pis,0) as decimal(32,2)) as varchar ) as 'VLPIS',
          --'COFINS : ' + cast( cast( isnull(vl_cofins,0) as decimal(32,2)) as varchar ) as 'VLCOFINS',
          isnull(vl_pis,0)                              as 'VLPIS',
          isnull(vl_cofins,0)                           as 'VLCOFINS',
          t.nm_transportadora                           as 'TRANSPORTADORA',    
          isnull(n.cd_tipo_pagamento_frete,2)           as 'FRETECONTA',    
          n.cd_placa_nota_saida                         as 'PLACAVEICULO',    
          n.sg_estado_placa                             as 'UFPLACA',    
          t.cd_cnpj_transportadora                      as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!          
          LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+LTrim(RTrim(t.nm_bairro)) as 'ENDERECOTRANSP',    
          c.nm_cidade                                   as 'CIDADETRANSP',    
          e.sg_estado                    as 'UFTRANSP',    
          t.cd_insc_estadual             as 'INSCESTTRANSP',    
          n.qt_volume_nota_saida         as 'QTDEVOLUME',    
          n.nm_especie_nota_saida        as 'ESPECIEVOLUME',    
          n.nm_marca_nota_saida          as 'MARCAVOLUME',    
          n.nm_numero_emb_nota_saida     as 'NUMEROVOLUME',    
          n.qt_peso_bruto_nota_saida     as 'PESOBRUTO',    
          n.qt_peso_liq_nota_saida       as 'PESOLIQUIDO',
          case when @ic_gera_classif_fiscal_corpo = 'S' 
          then 
 	    rtrim(ltrim(@ds_complemento_classif_fiscal))
          else 
	    '' 
          end                               as 'CLASSIFICACAOADICIONAL',
              
          Ltrim(RTrim(Cast((case when @ic_dado_adicional_produto = 'N' 
          then n.ds_obs_compl_nota_saida
          else '' end) as varchar(8000))))  as 'DADOADICIONAL',    

          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 1) as 'VENCA',    
          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 2) as 'VENCB',    
          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 3) as 'VENCC',    
          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 4) as 'VENCD',    
          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 5) as 'VENCE',    
          (select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 6) as 'VENCF',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 1) as 'VLRA',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 2) as 'VLRB',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 3) as 'VLRC',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 4) as 'VLRD',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 5) as 'VLRE',    
          (select nsp.vl_parcela_nota_saida from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 6) as 'VLRF'    
        from    
          Nota_Saida n     with (nolock)                                    left outer join    
          Transportadora t with (nolock) on n.cd_transportadora = t.cd_transportadora left outer join    
          Cidade c         with (nolock) on t.cd_cidade = c.cd_cidade                 left outer join    
          Estado e         with (nolock) on t.cd_estado = e.cd_estado    
        where    
          n.cd_nota_saida = @cd_nota_fiscal    

      end    
  
    -- TMBEVO  
    else if @nm_fantasia_empresa like '%TMBEVO%'  
      begin  
     
        declare @cd_mascara_classificacao_c varchar(15)  
        declare @cd_mascara_classificacao_d varchar(15)  
  
        -- Carrega o valor em extenso  
        select  
          @vl_total = isnull(vl_total,0)  
        from  
          Nota_Saida  with (nolock) 
        where  
          cd_nota_saida = @cd_nota_fiscal  

        exec pr_valor_extenso @vl_total, @nm_extenso output  
  
        select  
          @vl_total_duplicatas = Sum( isnull(vl_parcela_nota_saida,0) )
        from  
          Nota_Saida_Parcela with (nolock) 
        where  
          cd_nota_saida = @cd_nota_fiscal  

        exec pr_valor_extenso @vl_total_duplicatas, @nm_extenso_duplicatas output

        -- carrega outra Classificacao Fiscal como C  
        select  
          top 1  
          @cd_mascara_classificacao_c = c.cd_mascara_classificacao  
        from  
          Nota_Saida_Item i                      with (nolock)   
          left outer join Classificacao_Fiscal c with (nolock) on i.cd_classificacao_fiscal = c.cd_classificacao_fiscal  
        where  
          i.cd_nota_saida = @cd_nota_fiscal and  
          i.ic_tipo_nota_saida_item = 'P' and  
          ((replace(c.cd_mascara_classificacao,'.','') <> '84573090') and  
           (replace(c.cd_mascara_classificacao,'.','') <> '84669320'))  
  
        -- carrega outra Classificacao Fiscal como D  
        select  
          top 1  
          @cd_mascara_classificacao_d = c.cd_mascara_classificacao  
        from  
          Nota_Saida_Item i                      with (nolock)     
          left outer join Classificacao_Fiscal c with (nolock) on i.cd_classificacao_fiscal = c.cd_classificacao_fiscal  
        where  
          i.cd_nota_saida           = @cd_nota_fiscal and  
          i.ic_tipo_nota_saida_item = 'P' and  
          ((replace(c.cd_mascara_classificacao,'.','') <> '84573090') and
          (replace(c.cd_mascara_classificacao,'.','')  <> '84669320') and
          (replace(c.cd_mascara_classificacao,'.','')  <> replace(@cd_mascara_classificacao_c,'.','')))
        
        select   
          case when   
            n.cd_tipo_operacao_fiscal = 2   
          then  
            'X'  
          else  
            ''  
          end        as 'SAIDA',  
          case when   
            n.cd_tipo_operacao_fiscal = 1   
          then  
            'X'  
          else  
            ''  
          end        as 'ENTRADA',  
--          right('000000'+cast(n.cd_nota_saida as varchar(6)),6)  as 'NUMERO',  

          case when isnull(n.cd_identificacao_nota_saida,0)>0 then
            right('000000'+cast(n.cd_identificacao_nota_saida as varchar(6)),6) 
          else
            right('000000'+cast(n.cd_nota_saida as varchar(6)),6) 
          end                                                                         as 'NUMERO',    

          n.nm_operacao_fiscal                            as 'NATUREZAOPERACAO',  
          n.cd_mascara_operacao                           as 'CFOP',  
          n.nm_operacao_fiscal2                           as 'NATUREZAOPERACAO2',  
          n.cd_mascara_operacao2                          as 'CFOP2',  
          n.nm_operacao_fiscal3                           as 'NATUREZAOPERACAO3',  
          n.cd_mascara_operacao3                          as 'CFOP3',  
          ''                                              as 'IESUBSTRIB',  
          rtrim(ltrim(n.nm_razao_social_nota))+' '+rtrim(ltrim(n.nm_razao_social_c))   as 'RAZAOSOCIAL',  
          -- Formatação do CNPJ - ELIAS 24/03/2003  
          -- ELIAS 16/05/2003  
          case isnull(@cd_cnpj,'')   
            when '' then ''   
          else   
            case   
              when len(@cd_cnpj)<=11 then dbo.fn_Formata_Mascara('999.999.999-99',@cd_cnpj)  
            else dbo.fn_Formata_Mascara('99.999.999/9999-99',@cd_cnpj)   
            end   
         end                                                      as 'CNPJ',  
          n.nm_endereco_nota_saida+' '+n.cd_numero_end_nota_saida as 'ENDERECO',  
          n.nm_bairro_nota_saida                                  as 'BAIRRO',  
          -- Formatação do CEP - ELIAS 24/03/2003  
          dbo.fn_Formata_Mascara('99999-999',n.cd_cep_nota_saida) as 'CEP',  
          n.nm_cidade_nota_saida     as 'CIDADE',  
          -- Formatação do Telefone - ELIAS 24/03/2003  
          case isnull(n.cd_ddd_nota_saida,'') when '' then  
            n.cd_telefone_nota_saida+'/'+n.cd_fax_nota_saida  
          else   
            '('+n.cd_ddd_nota_saida+') '+n.cd_telefone_nota_saida+'/'+n.cd_fax_nota_saida  
          end        as 'TELEFONE',  
          n.sg_estado_nota_saida     as 'UF',  
          n.cd_inscest_nota_saida     as 'INSCESTADUAL',  
          convert(varchar, n.dt_nota_saida, 3)      as 'EMISSAO',  
          convert(varchar, isnull(n.dt_saida_nota_saida, n.dt_nota_saida), 3)   
             as 'DATASAIDA',  
          n.hr_saida_nota_saida                                          as 'HORASAIDA',  
          cast(n.vl_iss as decimal(25,2))                                as 'VLISS',  
          cast(n.vl_servico as decimal(25,2))                            as 'VLSERVICO',  
          cast(n.vl_bc_icms as decimal(25,2))                            as 'VLBCICMS',  
          cast(n.vl_icms as decimal(25,2))                               as 'VLICMS',  
          cast(n.vl_bc_subst_icms as decimal(25,2))                      as 'VLBCICMSSUBSTRIB',  
          cast(n.vl_icms_subst as decimal(25,2))                         as 'VLICMSSUBSTRIB',  
          cast(isnull(n.vl_simbolico,0) + n.vl_produto as decimal(25,2)) as 'VLTOTALPRODUTO',  
          cast(n.vl_frete as decimal(25,2))                              as 'VLFRETE',  
          cast(n.vl_seguro as decimal(25,2))                             as 'VLSEGURO',  
          cast(n.vl_desp_acess as decimal(25,2))                         as 'VLDESPACESS',  
          cast(n.vl_ipi as decimal(25,2))                                as 'VLIPI',  
          cast(isnull(n.vl_simbolico,0) as decimal(25,2))                as 'VLSIMBOLICO',
          cast(isnull(n.vl_simbolico,0)+ n.vl_total as decimal(25,2))    as 'VLTOTALNF',  
          --'PIS : '    + cast( cast( isnull(vl_pis,0) as decimal(32,2)) as varchar ) as 'VLPIS',
          --'COFINS : ' + cast( cast( isnull(vl_cofins,0) as decimal(32,2)) as varchar ) as 'VLCOFINS',
          isnull(vl_pis,0)              as 'VLPIS',
          isnull(vl_cofins,0)           as 'VLCOFINS',
          t.nm_transportadora           as 'TRANSPORTADORA',  
          isnull(n.cd_tipo_pagamento_frete,2)                           as 'FRETECONTA',  
         'Fone Transportadora : ('+t.cd_ddd+') '+t.cd_telefone          as 'FONETRANSPORTADORA',  
          n.cd_placa_nota_saida          as 'PLACAVEICULO',  
          n.sg_estado_placa              as 'UFPLACA',  
          t.cd_cnpj_transportadora       as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!        
          LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+LTrim(RTrim(t.nm_bairro)) as 'ENDERECOTRANSP',  
          c.nm_cidade                    as 'CIDADETRANSP',  
          e.sg_estado                    as 'UFTRANSP',  
          t.cd_insc_estadual             as 'INSCESTTRANSP',  
          n.qt_volume_nota_saida         as 'QTDEVOLUME',  
          n.nm_especie_nota_saida        as 'ESPECIEVOLUME',  
          n.nm_marca_nota_saida          as 'MARCAVOLUME',  
          n.nm_numero_emb_nota_saida     as 'NUMEROVOLUME',  
          n.qt_peso_bruto_nota_saida     as 'PESOBRUTO',  
          n.qt_peso_liq_nota_saida       as 'PESOLIQUIDO',  

          case when @ic_gera_classif_fiscal_corpo = 'S' 
          then 
 	    rtrim(ltrim(@ds_complemento_classif_fiscal))
          else 
	    '' 
          end                            as 'CLASSIFICACAOADICIONAL',

          Cast((case when @ic_dado_adicional_produto = 'N' 
          then n.ds_obs_compl_nota_saida
          else '' end) as varchar(8000)) as 'DADOADICIONAL', 

          case when ((select count(*) from Nota_Saida_Parcela nsp   
                      where nsp.cd_nota_saida = n.cd_nota_saida) > 1) then  
                    'VARIOS'  
               else    
                    (select nsp. cd_ident_parc_nota_saida from Nota_Saida_Parcela nsp   
                     where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 1)  
               end as 'DUPLICATA',  
          case when ((select count(*) from Nota_Saida_Parcela nsp   
                      where nsp.cd_nota_saida = n.cd_nota_saida) > 1) then  
                    'ABAIXO'  
               else    
                    (convert(varchar(12),(select nsp.dt_parcela_nota_saida from Nota_Saida_Parcela nsp   
                          where nsp.cd_nota_saida = n.cd_nota_saida and cd_parcela_nota_saida = 1),103))  
               end                             as 'VENCIMENTO',  
          '***('+@nm_extenso+')***'            as 'EXTENSO',  
          '***('+@nm_extenso_duplicatas+')***' as 'EXTENSODUPLICATAS',  
          @vl_total_duplicatas                 as 'VALOTTOTALDUPLICATAS',
          @cd_mascara_classificacao_c          as 'CLASSFISCALC',  
          @cd_mascara_classificacao_d          as 'CLASSFISCALD'  
        from  
          Nota_Saida n     with (nolock) left outer join  
          Transportadora t with (nolock) on n.cd_transportadora = t.cd_transportadora left outer join  
          Cidade c         with (nolock) on t.cd_cidade = c.cd_cidade left outer join  
          Estado e         with (nolock) on t.cd_estado = e.cd_estado  
        where  
          n.cd_nota_saida = @cd_nota_fiscal  

    end else  
  
    if @nm_fantasia_empresa like '%TRM%'  
      begin     
        
    select   
      case when   
        n.cd_tipo_operacao_fiscal = 2   
      then  
        'X'  
      else  
        ''  
      end        as 'SAIDA',  
      case when   
        n.cd_tipo_operacao_fiscal = 1   
      then  
        'X'  
      else  
        ''  
      end        as 'ENTRADA',  
--      right('000000'+cast(n.cd_nota_saida as varchar(6)),6)  as 'NUMERO',  
      case when isnull(n.cd_identificacao_nota_saida,0)>0 then
        right('000000'+cast(n.cd_identificacao_nota_saida as varchar(6)),6) 
      else
        right('000000'+cast(n.cd_nota_saida as varchar(6)),6) 
      end                                                                         as 'NUMERO',    

      n.nm_operacao_fiscal      as 'NATUREZAOPERACAO',  
      n.cd_mascara_operacao      as 'CFOP',  
      n.nm_operacao_fiscal2      as 'NATUREZAOPERACAO2',  
      n.cd_mascara_operacao2      as 'CFOP2',  
      n.nm_operacao_fiscal3      as 'NATUREZAOPERACAO3',  
      n.cd_mascara_operacao3      as 'CFOP3',  
      ' '        as 'IESUBSTRIB',  
      rtrim(ltrim(n.nm_razao_social_nota))+' '+rtrim(ltrim(n.nm_razao_social_c))   as 'RAZAOSOCIAL',  
      -- ELIAS 16/05/2003  
      case isnull(@cd_cnpj,'') when '' then ''   
         else case when len(@cd_cnpj)<=11  
              then dbo.fn_Formata_Mascara('999.999.999-99',@cd_cnpj)   
              else dbo.fn_Formata_Mascara('99.999.999/9999-99',@cd_cnpj)   
              end   
         end  
         as 'CNPJ',  

      'EndCobranca' =   
      case   
         when (n.nm_endereco_nota_saida=n.nm_endereco_cobranca) and   
              (n.cd_cep_nota_saida=n.cd_cep_cobranca) and   
              (n.cd_numero_end_nota_saida=n.cd_numero_endereco_cob) and  
              (n.nm_compl_endereco_nota=n.nm_complemento_end_cob)   
         then 'O Mesmo'   
         else rtrim(n.nm_endereco_cobranca)              + ','   +
              rtrim(isnull(n.cd_numero_endereco_cob,'')) + ' '   + 
              rtrim(isnull(n.nm_complemento_end_cob,'')) + ' - ' + 
              rtrim(isnull(n.nm_bairro_cobranca,''))     + ' - ' +
              rtrim(isnull(n.nm_cidade_cobranca,''))     + ' - ' +isnull(sg_estado_cobranca,'')  + ' - Cep: ' +
              rtrim(isnull(n.cd_cep_cobranca,''))    
         end,  

      rtrim(n.nm_endereco_nota_saida)+' '+rtrim(n.cd_numero_end_nota_saida)  as 'ENDERECO',  
      n.nm_bairro_nota_saida                                                 as 'BAIRRO',  
      dbo.fn_Formata_Mascara('99999-999',n.cd_cep_nota_saida)                as 'CEP',  
      n.nm_cidade_nota_saida                                                 as 'CIDADE',  
      '('+n.cd_ddd_nota_Saida+') '+n.cd_telefone_nota_saida                  as 'TELEFONE',  
      n.sg_estado_nota_saida                                                 as 'UF',  
      n.cd_inscest_nota_saida                                                as 'INSCESTADUAL',  
      convert(varchar, n.dt_nota_saida, 3)                                   as 'EMISSAO',  
      convert(varchar, n.dt_saida_nota_saida, 3)                             as 'DATASAIDA',  
      n.hr_saida_nota_saida                                                  as 'HORASAIDA',  
      cast(n.vl_iss as decimal(25,2))                                        as 'VLISS',  
      cast(n.vl_servico as decimal(25,2))                                    as 'VLSERVICO',  
      cast(n.vl_bc_icms as decimal(25,2))                                    as 'VLBCICMS',  
      cast(n.vl_icms as decimal(25,2))                                       as 'VLICMS',  
      cast(n.vl_bc_subst_icms as decimal(25,2))                              as 'VLBCICMSSUBSTRIB',  
      cast(n.vl_icms_subst as decimal(25,2))                                 as 'VLICMSSUBSTRIB',  
      cast(isnull(n.vl_simbolico,0)+ n.vl_produto as decimal(25,2))          as 'VLTOTALPRODUTO',  
      cast(n.vl_frete as decimal(25,2))     as 'VLFRETE',  
      cast(n.vl_seguro as decimal(25,2))    as 'VLSEGURO',  
      cast(n.vl_desp_acess as decimal(25,2))    as 'VLDESPACESS',  
      cast(n.vl_ipi as decimal(25,2))     as 'VLIPI',  
      cast(isnull(n.vl_simbolico,0)   as decimal(25,2))               as 'VLSIMBOLICO',
      cast(isnull(n.vl_simbolico,0)+ n.vl_total as decimal(25,2))     as 'VLTOTALNF',  

      --'PIS : '    + cast( cast( isnull(vl_pis,0) as decimal(32,2)) as varchar ) as 'VLPIS',
      --'COFINS : ' + cast( cast( isnull(vl_cofins,0) as decimal(32,2)) as varchar ) as 'VLCOFINS',

      isnull(vl_pis,0)                                                as 'VLPIS',
      isnull(vl_cofins,0)                                             as 'VLCOFINS',
      t.nm_transportadora                                             as 'TRANSPORTADORA',  
      'Fone Transportadora : ('+t.cd_ddd+') '+  
      t.cd_telefone + ' - '+  
      /* ELIAS 12/06/2003 */  
      (select top 1 tc.nm_contato from transportadora_contato tc   
       where tc.cd_transportadora = t.cd_transportadora)                as 'FONETRANSPORTADORA',  
      isnull(n.cd_tipo_pagamento_frete,2)                               as 'FRETECONTA',  
      n.cd_placa_nota_saida      as 'PLACAVEICULO',  
      n.sg_estado_placa       as 'UFPLACA',  
      case isnull(t.cd_cnpj_transportadora,'')   
         when ''  
         then ''   
         else  dbo.fn_Formata_Mascara('99.999.999/9999-99',t.cd_cnpj_transportadora)   
         end  
         as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!        
      LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco)) as 'ENDERECOTRANSP',  
  
--       Foi tirado o bairro para ser colocado ao lado do peso liquido  
--       LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+t.nm_bairro  as 'ENDERECOTRANSP',  
  
      c.nm_cidade       as 'CIDADETRANSP',  
      e.sg_estado       as 'UFTRANSP',  
      t.cd_insc_estadual      as 'INSCESTTRANSP',  
      /* ELIAS 10/06/2003 */   
      cast(n.qt_volume_nota_saida as varchar)    as 'QTDEVOLUME',  
      isnull(n.nm_especie_nota_saida,'Caixa')    as 'ESPECIEVOLUME',  
      n.nm_marca_nota_saida      as 'MARCAVOLUME',  
      n.nm_numero_emb_nota_saida     as 'NUMEROVOLUME',  
      str(n.qt_peso_bruto_nota_saida,7,3)    as 'PESOBRUTO',  
      str(n.qt_peso_liq_nota_saida,7,3)     as 'PESOLIQUIDO',  
          
      case when @ic_gera_classif_fiscal_corpo = 'S' 
      then 
         rtrim(ltrim(@ds_complemento_classif_fiscal))
      else 
	 '' 
      end                            as 'CLASSIFICACAOADICIONAL',

      rtrim(ltrim(Cast((case 
				when @ic_dado_adicional_produto = 'N' then 
						n.ds_obs_compl_nota_saida
				else 
					'' 
				end) as varchar(8000))))                as 'DADOADICIONAL',     
--Carlos 27.12.2005  
--    cast('' as Varchar(50))        as 'PEDIDOVENDA',                                          
--    cast('' as Varchar(50))        as 'PEDIDOCOMPRA',  
      cast(pv.cd_pedido_venda          as Varchar(50))                  as 'PEDIDOVENDA',                                                
      cast(pv.cd_pdcompra_pedido_venda as Varchar(50))                  as 'PEDIDOCOMPRA',        
  
   -- RAFAEL 09.10.2003    
      n.cd_vendedor                    as 'VENDEDOR',  
      upper(v.nm_fantasia_vendedor)    as 'NMVENDEDOR',  
      emp.nm_dominio_internet          as 'SITE',    
      emp.nm_email_internet                               as 'EMAIL',    

   --Mensagem Fixa na nota Fiscal
 
      (SELECT TOP 1 CAST(msg.ds_mensagem_nota as VARCHAR(200)) 
       FROM Mensagem_Nota msg 
       WHERE 
          isnull(msg.cd_tipo_operacao_fiscal,0) = isnull(n.cd_tipo_operacao_fiscal,0) and
          msg.ic_ativa_mensagem_nota = 'S' and
          isnull(msg.ic_comercial_mensagem,'N') = case when isnull(msg.ic_comercial_mensagem,'N')='S' 
                                                  then 
                                                   case when isnull(opf.ic_comercial_operacao,'N')='S' then 'S' else 'N' end
                                                  else
                                                   isnull(msg.ic_comercial_mensagem,'N')
                                                  end
      )                                                   as 'MENSAGEM',  
      CAST(pf.ds_mensagem_nota_saida_fin as VARCHAR(200)) as 'MENFINANCEIRA',    
      pv. nm_referencia_consulta                          as 'REFERENCIA_PEDIDO',     
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,1)) as 'CLASSFISCALA',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,2)) as 'CLASSFISCALB',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,3)) as 'CLASSFISCALC',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,4)) as 'CLASSFISCALD',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,5)) as 'CLASSFISCALE',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,6)) as 'CLASSFISCALF',  
      (select nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,7)) as 'CLASSFISCALG',  
      (select isnull(nm_condicao_pagamento,'') from condicao_pagamento where cd_condicao_pagamento = n.cd_condicao_pagamento and  
                                                                  isnull(ic_imprimir_sigla,'N' ) = 'S')            as 'MENCONDPAGAMENTO',  
      --REGISTRO DO MINISTÉRIO DA AGRICULTA
      emp.cd_registro_m_agricultura                                                           as 'REGISTRO_AGRICULTURA',

      '.' as PONTO        

    --select * from nota_saida

    from    
      Nota_Saida n              with(nolock) left outer join    
      Transportadora t          with(nolock) on n.cd_transportadora = t.cd_transportadora left outer join    
      Pedido_Venda pv           with(nolock) ON n.cd_pedido_venda = pv.cd_pedido_venda left outer join      
      Cidade c                  with(nolock) on t.cd_cidade = c.cd_cidade left outer join    
      Estado e                  with(nolock) on t.cd_estado = e.cd_estado left outer join  
      Vendedor v                with(nolock) on n.cd_vendedor = v.cd_vendedor left outer join   
      EGISADMIN.DBO.Empresa emp with(nolock) on emp.cd_empresa = @cd_empresa

--       EGISADMIN.DBO.Empresa emp with(nolock) on emp.cd_empresa = (select cd_empresa     
--                                                      from EGISADMIN.DBO.Empresa     
--                                                      where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )  
      LEFT OUTER JOIN    
      Parametro_Faturamento pf ON pf.cd_empresa = @cd_empresa

-- (select cd_empresa     
--                                                    from EGISADMIN.DBO.Empresa     
--                                                    where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )   

      left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = n.cd_operacao_fiscal

    where    
      n.cd_nota_saida = @cd_nota_fiscal  

--select * from operacao_fiscal
  
  end  
  
------  
-----------------------------------------------------------------------------------------------------------------  
-- INICIO MEIAS KENY  
-----------------------------------------------------------------------------------------------------------------------  
  
  if (@nm_fantasia_empresa like '%MAGNO%')      OR (@nm_fantasia_empresa like '%MARIANA%') OR   
     (@nm_fantasia_empresa like '%MEIAS KENY%') OR (@nm_fantasia_empresa like '%SANGELO%') -- Meias Keny  
  begin  
  
    select   
      case when   
        n.cd_tipo_operacao_fiscal = 2   
      then  
        'X'  
      else  
        ''  
      end        as 'SAIDA',  
      case when   
        n.cd_tipo_operacao_fiscal = 1   
      then  
        'X'  
      else  
        ''  
      end        as 'ENTRADA',  
--      right('000000'+cast(n.cd_nota_saida as varchar(6)),6)  as 'NUMERO',  
      case when isnull(n.cd_identificacao_nota_saida,0)>0 then
        right('000000'+cast(n.cd_identificacao_nota_saida as varchar(6)),6) 
      else
        right('000000'+cast(n.cd_nota_saida as varchar(6)),6) 
      end                                                                         as 'NUMERO',    

      n.nm_operacao_fiscal        as 'NATUREZAOPERACAO',  
      n.cd_mascara_operacao       as 'CFOP',  
      n.nm_operacao_fiscal2       as 'NATUREZAOPERACAO2',  
      n.cd_mascara_operacao2      as 'CFOP2',  
      n.nm_operacao_fiscal3       as 'NATUREZAOPERACAO3',  
      n.cd_mascara_operacao3      as 'CFOP3',  
      ' '                         as 'IESUBSTRIB',  
      rtrim(ltrim(n.nm_razao_social_nota))+' '+rtrim(ltrim(n.nm_razao_social_c))   as 'RAZAOSOCIAL',  
      -- ELIAS 16/05/2003  
      case isnull(@cd_cnpj,'') when '' then ''   
         else case when len(@cd_cnpj)<=11  
              then dbo.fn_Formata_Mascara('999.999.999-99',@cd_cnpj)   
              else dbo.fn_Formata_Mascara('99.999.999/9999-99',@cd_cnpj)   
              end   
         end  
         as 'CNPJ',  
      'EndCobranca' =   
      case   
         when (n.nm_endereco_nota_saida  =n.nm_endereco_cobranca) and   
              (n.cd_cep_nota_saida       =n.cd_cep_cobranca) and   
              (n.cd_numero_end_nota_saida=n.cd_numero_endereco_cob) and  
              (n.nm_compl_endereco_nota  =n.nm_complemento_end_cob)   
         then 'O Mesmo'   
         else rtrim(n.nm_endereco_cobranca) + ',' + 
              rtrim(isnull(n.cd_numero_endereco_cob,'')) + ' '   + 
              rtrim(isnull(n.nm_complemento_end_cob,'')) + ' - ' + 
              rtrim(isnull(n.nm_bairro_cobranca,''))     + ' - ' + 
              rtrim(isnull(n.nm_cidade_cobranca,'')) + ' - '+isnull(sg_estado_cobranca,'') + ' - Cep: ' +
              rtrim(isnull(n.cd_cep_cobranca,''))    
         end,  

      rtrim(n.nm_endereco_nota_saida)+' '+n.cd_numero_end_nota_saida+ ' '+rtrim(cli.nm_complemento_endereco)  as 'ENDERECO',  

--select * from nota_saida
      --cli.nm_fantasia_cliente                                  as 'COMPLEMENTO',  
      n.nm_fantasia_destinatario                               as 'COMPLEMENTO',
      n.nm_bairro_nota_saida                                   as 'BAIRRO',  
      --'6115.92.00'                                             as 'CLAS_FISCAL',
      --select * from nota_saida_classificacao
     isnull(( select top 1 cd_mascara_classificacao
       from
         nota_saida_classificacao nsc     with (nolock) 
       inner join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal  = nsc.cd_classificacao_fiscal 
       inner join nota_saida_item     nsi with (nolock) on nsi.cd_classificacao_fiscal = nsc.cd_classificacao_fiscal and
                                                           nsi.cd_nota_saida           = n.cd_nota_saida
       where cd_controle = 1 ),'') as 'CLAS_FISCAL',
        
     isnull(( select top 1 cd_mascara_classificacao
       from
         nota_saida_classificacao nsc     with (nolock) 
       inner join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal  = nsc.cd_classificacao_fiscal
       inner join nota_saida_item nsi     with (nolock) on nsi.cd_nota_saida           = n.cd_nota_saida and
                                                           nsi.cd_classificacao_fiscal = nsc.cd_classificacao_fiscal
       where cd_controle = 2 ),'') as 'CLAS_FISCALA',

     ( select top 1 cd_mascara_classificacao
       from
         nota_saida_classificacao nsc     with (nolock) 
       inner join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = nsc.cd_classificacao_fiscal 
       inner join nota_saida_item nsi     with (nolock) on nsi.cd_nota_saida           = n.cd_nota_saida and
                                                           nsi.cd_classificacao_fiscal = nsc.cd_classificacao_fiscal

       where cd_controle = 3 ) as 'CLAS_FISCALB',
        
     isnull(( select top 1 cd_mascara_classificacao
       from
         nota_saida_classificacao nsc     with (nolock) 
       inner join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal  = nsc.cd_classificacao_fiscal
       inner join nota_saida_item nsi     with (nolock) on nsi.cd_nota_saida           = n.cd_nota_saida and
                                                           nsi.cd_classificacao_fiscal = nsc.cd_classificacao_fiscal

       where cd_controle = 4 ),'') as 'CLAS_FISCALC',

      pv.cd_pdcompra_pedido_venda                              as 'PEDIDOVENDA_KENY',   
      dbo.fn_Formata_Mascara('99999-999',n.cd_cep_nota_saida)  as 'CEP',  
      n.nm_cidade_nota_saida                                   as 'CIDADE',  
      '('+n.cd_ddd_nota_Saida+') '+n.cd_telefone_nota_saida    as 'TELEFONE',  
      n.sg_estado_nota_saida                                   as 'UF',  
      n.cd_inscest_nota_saida                                  as 'INSCESTADUAL',  
      convert(varchar, n.dt_nota_saida, 3)                     as 'EMISSAO',  
      convert(varchar, n.dt_saida_nota_saida, 3)               as 'DATASAIDA',  
      n.hr_saida_nota_saida                                    as 'HORASAIDA',  
      cast(n.vl_iss as decimal(25,2))                          as 'VLISS',  
      cast(n.vl_servico as decimal(25,2))                      as 'VLSERVICO',  
      cast(n.vl_bc_icms as decimal(25,2))                      as 'VLBCICMS',  
      cast(n.vl_icms as decimal(25,2))                                 as 'VLICMS',  
      cast(n.vl_bc_subst_icms as decimal(25,2))                        as 'VLBCICMSSUBSTRIB',  
      cast(n.vl_icms_subst as decimal(25,2))                           as 'VLICMSSUBSTRIB',  
      cast(isnull(n.vl_simbolico,0)+ n.vl_produto as decimal(25,2))    as 'VLTOTALPRODUTO',  
      cast(n.vl_frete as decimal(25,2))                                as 'VLFRETE',  
      cast(n.vl_seguro as decimal(25,2))                               as 'VLSEGURO',  
      cast(n.vl_desp_acess as decimal(25,2))                           as 'VLDESPACESS',  
      cast(n.vl_ipi as decimal(25,2))                                  as 'VLIPI',  
      cast(isnull(n.vl_simbolico,0) as decimal(25,2))                  as 'VLSIMBOLICO',
      cast(isnull(n.vl_simbolico,0)+ n.vl_total as decimal(25,2))      as 'VLTOTALNF',  

      --'PIS : '    + cast( cast( isnull(vl_pis,0) as decimal(32,2)) as varchar ) as 'VLPIS',
      --'COFINS : ' + cast( cast( isnull(vl_cofins,0) as decimal(32,2)) as varchar ) as 'VLCOFINS',
      isnull(vl_pis,0)                                                as 'VLPIS',
      isnull(vl_cofins,0)                                             as 'VLCOFINS',
      t.nm_transportadora                                             as 'TRANSPORTADORA',  
      'Fone Transportadora : ('+t.cd_ddd+') '+  
      t.cd_telefone + ' - '+  
      /* ELIAS 12/06/2003 */  
      (select top 1 tc.nm_contato from transportadora_contato tc   
       where tc.cd_transportadora = t.cd_transportadora)       
           as 'FONETRANSPORTADORA',  
      isnull(n.cd_tipo_pagamento_frete,2)                             as 'FRETECONTA',  
      n.cd_placa_nota_saida                                           as 'PLACAVEICULO',  
      n.sg_estado_placa                                               as 'UFPLACA',  
      case isnull(t.cd_cnpj_transportadora,'')   
         when ''  
      
     then ''   
         else  dbo.fn_Formata_Mascara('99.999.999/9999-99',t.cd_cnpj_transportadora)   
         end  
         as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!        
--      LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco)) as 'ENDERECOTRANSP',  
      LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+LTrim(RTrim(t.nm_bairro)) as 'ENDERECOTRANSP',  
      c.nm_cidade                                  as 'CIDADETRANSP',  
      e.sg_estado                                  as 'UFTRANSP',  
      t.cd_insc_estadual                           as 'INSCESTTRANSP',  
      /* ELIAS 10/06/2003 */   
      cast(n.qt_volume_nota_saida as varchar)      as 'QTDEVOLUME',  
      isnull(n.nm_especie_nota_saida,'Caixa')      as 'ESPECIEVOLUME',  
      n.nm_marca_nota_saida                        as 'MARCAVOLUME',  
      n.nm_numero_emb_nota_saida                   as 'NUMEROVOLUME',  
      str(n.qt_peso_bruto_nota_saida,7,3)+' kg'    as 'PESOBRUTO',  
      str(n.qt_peso_liq_nota_saida,7,3)+' kg'      as 'PESOLIQUIDO',  
  

      Ltrim(RTrim(Cast((case when @ic_dado_adicional_produto = 'N' 
          then n.ds_obs_compl_nota_saida
          else '' end) as varchar(8000))))        as 'DADOADICIONAL',    

      -- Edison  


--       case when substring(n.ds_obs_compl_nota_saida,1,32)='Base de Calculo do ICMS Reduzida'      
--            then substring(n.ds_obs_compl_nota_saida,48,300)      
--            else n.ds_obs_compl_nota_saida      
--            end  as 'DADOADICIONAL',      

--       case when substring(n.ds_obs_compl_nota_saida,1,32)='Base de Calculo do ICMS Reduzida'  
--            then substring(n.ds_obs_compl_nota_saida,48,300)  
--            else 
--             cast( (case	when @ic_dado_adicional_produto = 'N'
--                         then 
-- 			     n.ds_obs_compl_nota_saida
--           		else 	
-- 		             '' 
-- 			end) as varchar(8000))
--         end                           as 'DADOADICIONAL',  

      -- Edison  
         
      cast('' as Varchar(100))        as 'PEDIDOVENDA',                                          
      cast('' as Varchar(100))        as 'PEDIDOCOMPRA',  

      -- RAFAEL 09.10.2003    

      n.cd_vendedor                    as 'VENDEDOR',  
      upper(v.nm_fantasia_vendedor)    as 'NMVEMDEDOR',  
      emp.nm_dominio_internet          as 'SITE',    
      emp.nm_email_internet            as 'EMAIL',     

      --MENSAGEM FIXA na Nota Fiscal

      (SELECT TOP 1 CAST(msg.ds_mensagem_nota as VARCHAR(200)) 
       FROM Mensagem_Nota msg 
       WHERE 
          isnull(msg.cd_tipo_operacao_fiscal,0) = isnull(n.cd_tipo_operacao_fiscal,0) and
          msg.ic_ativa_mensagem_nota = 'S' and
          isnull(msg.ic_comercial_mensagem,'N') = case when isnull(msg.ic_comercial_mensagem,'N')='S' 
                                                  then 
                                                   case when isnull(opf.ic_comercial_operacao,'N')='S' then 'S' else 'N' end
                                                  else
                                                   isnull(msg.ic_comercial_mensagem,'N')
                                                  end
      )                                                   as 'MENSAGEM',  
      CAST(pf.ds_mensagem_nota_saida_fin as VARCHAR(200)) as 'MENFINANCEIRA',    
      pv. nm_referencia_consulta                          as 'REFERENCIA_PEDIDO',     
      --REGISTRO DO MINISTÉRIO DA AGRICULTA
      emp.cd_registro_m_agricultura                                                           as 'REGISTRO_AGRICULTURA',

      '.'                                                 as PONTO    
      
    into #CabecalhoNotaKeny    
    from    
      Nota_Saida n              with (nolock)                                               left outer join    
      Cliente cli               with (nolock) ON n.cd_cliente         = cli.cd_cliente      left outer join    
      Transportadora t          with (nolock) on n.cd_transportadora  = t.cd_transportadora left outer join    
      Pedido_Venda pv           with (nolock) ON n.cd_pedido_venda    = pv.cd_pedido_venda  left outer join      
      Cidade c                  with (nolock) on t.cd_cidade          = c.cd_cidade         left outer join    
      Estado e                  with (nolock) on t.cd_estado          = e.cd_estado         left outer join  
      Vendedor v                with (nolock) on n.cd_vendedor        = v.cd_vendedor       left outer join   
      EGISADMIN.DBO.Empresa emp with (nolock) on emp.cd_empresa       = @cd_empresa

-- (
--                                                      select top 1 cd_empresa  
--                                                      from EGISADMIN.DBO.Empresa     
--                                                      where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )  
      LEFT OUTER JOIN    
      Parametro_Faturamento pf ON pf.cd_empresa = @cd_empresa

-- (select top 1 cd_empresa     
--                                                    from EGISADMIN.DBO.Empresa     
--                                                    where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )   
      left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = n.cd_operacao_fiscal

    where  
      n.cd_nota_saida = @cd_nota_fiscal  
  
  
   declare @PEDIDOKENY       as Varchar(50) --lOC  
   declare @NUMEROKENY       as Integer --CD_PRODUTO  
   declare @PEDIDOVENDAKENY  as Varchar(100) --LOCALIZACAO  
   declare @PEDIDOCOMPRAKENY as Varchar(100) --LOCALIZACAO  
  
   
  declare cCabecalhoNotaKeny cursor for  
   select   
      NUMERO,  
      PEDIDOVENDA  
   from  
      #CabecalhoNotaKeny  
   for update of PEDIDOVENDA  
  
   Select distinct cd_pedido_venda   
   into #PedidoVendaKeny  
   from Nota_Saida_Item  
   where cd_nota_saida=@cd_nota_fiscal and cd_pedido_venda is not null and cd_pedido_venda > 0  
  
   open cCabecalhoNotaKeny  
   fetch next from cCabecalhoNotaKENY into @NUMEROKENY, @PEDIDOVENDAKENY  
  
   while (@@FETCH_STATUS =0)  
      begin  
         set @PEDIDOKENY=''  
  
         select @PEDIDOKENY = @PEDIDOKENY + (rtrim(cast(cd_pedido_venda as varchar)))  
         from #PedidoVendaKeny pv   
  
         update #CabecalhoNotaKeny SET PEDIDOVENDA = @PEDIDOKENY where NUMERO=@NUMEROKENY  
  
      fetch next from cCabecalhoNotaKENY into @NUMEROKENY, @PEDIDOVENDAKENY  
     end  
     close cCabecalhoNotaKENY  
     deallocate cCabecalhoNotaKENY  
  
   declare cCabecalhoNotaKENY cursor for  
   select   
      NUMERO,  
      PEDIDOCOMPRA   
   from  
      #CabecalhoNotaKeny  
   for update of PEDIDOCOMPRA  
  
   Select distinct cd_pd_Compra_item_nota   
   into #PedidoCompraKeny     
   from Nota_Saida_Item  
   where cd_nota_saida=@cd_nota_fiscal and cd_pd_Compra_item_nota is not null and cd_pd_Compra_item_nota <> ''  
  
   open cCabecalhoNotaKENY  
   fetch next from cCabecalhoNotaKENY into @NUMEROKENY, @PEDIDOCOMPRAKENY  
  
   while (@@FETCH_STATUS =0)  
      begin  
         set @PEDIDOKENY=''  
         select @PEDIDOKENY = @PEDIDOKENY + (rtrim(cast(cd_pd_compra_item_nota as varchar(40))))  
         from #PedidoCompraKeny pc   
         update #CabecalhoNotaKeny SET PEDIDOCOMPRA = upper(@PEDIDOKENY) where NUMERO=@NUMEROKENY  
      fetch next from cCabecalhoNotaKENY into @NUMEROKENY, @PEDIDOCOMPRAKENY  
     end  
     close cCabecalhoNotaKENY  
     deallocate cCabecalhoNotaKENY  
  
  select * from #CabecalhoNotaKeny  
  drop table #CabecalhoNotaKeny  
  drop table #PedidoVendaKeny  
  drop table #PedidoCompraKeny  

end  

--end  

------------------------------------------------------------------------------------------------------------------  
-- FIM MEIAS KENY  
------------------------------------------------------------------------------------------------------------  
  
    else -- Outras Empresas (POLIMOLD/SMC/TODAS)  
  
  begin  

   print 'Extenso'
  
   select  
     @vl_total = isnull(vl_total,0)  
   from  
     Nota_Saida with (nolock)   
   where  
     cd_nota_saida = @cd_nota_fiscal  
  
   exec pr_valor_extenso @vl_total, @nm_extenso output  

   select  
     @vl_total_duplicatas = Sum( isnull(vl_parcela_nota_saida,0) )
   from  
     Nota_Saida_Parcela with (nolock) 
   where  
     cd_nota_saida = @cd_nota_fiscal  

   exec pr_valor_extenso @vl_total_duplicatas, @nm_extenso_duplicatas output  

   Declare @ic_imprime_complemento_end varchar(1)

   if @nm_fantasia_empresa like '%ALUMIN%'
   begin
      set @ic_imprime_complemento_end = 'S'
   end
   else
   begin
      set @ic_imprime_complemento_end = 'N'
   end

    select   
      case when   
        n.cd_tipo_operacao_fiscal = 2   
      then  
        'X'  
      else  
        ''  
      end        as 'SAIDA',  
      case when   
        n.cd_tipo_operacao_fiscal = 1   
      then  
        'X'  
      else  
        ''  
      end        as 'ENTRADA',  
--      right('000000'+cast(n.cd_nota_saida as varchar(6)),6)  as 'NUMERO',  

      case when isnull(n.cd_identificacao_nota_saida,0)>0 then
        right('000000'+cast(n.cd_identificacao_nota_saida as varchar(6)),6) 
      else
        right('000000'+cast(n.cd_nota_saida as varchar(6)),6) 
      end                                                                         as 'NUMERO',    

      n.nm_operacao_fiscal        as 'NATUREZAOPERACAO',  
      n.cd_mascara_operacao       as 'CFOP',  
      n.nm_operacao_fiscal2       as 'NATUREZAOPERACAO2',  
      n.cd_mascara_operacao2      as 'CFOP2',  
      n.nm_operacao_fiscal3       as 'NATUREZAOPERACAO3',  
      n.cd_mascara_operacao3      as 'CFOP3',  
      ' '                         as 'IESUBSTRIB',  
      rtrim(ltrim(n.nm_razao_social_nota))+' '+rtrim(ltrim(n.nm_razao_social_c))   as 'RAZAOSOCIAL',  

      -- ELIAS 16/05/2003  

      case isnull(@cd_cnpj,'') when '' then ''   
         else case when len(@cd_cnpj)<=11  
              then dbo.fn_Formata_Mascara('999.999.999-99',@cd_cnpj)   
              else dbo.fn_Formata_Mascara('99.999.999/9999-99',@cd_cnpj)   
              end   
         end  
         as 'CNPJ',  
      'COBRANCA'                                                                    as COBRANCA,
      'EndCobranca' =   
      case   
         when (n.nm_endereco_nota_saida  =n.nm_endereco_cobranca)   and   
              (n.cd_cep_nota_saida       =n.cd_cep_cobranca)        and   
              (n.cd_numero_end_nota_saida=n.cd_numero_endereco_cob) and  
              (n.nm_compl_endereco_nota  =n.nm_complemento_end_cob)   
         then
            'O Mesmo'   
         else
            case when isnull(n.nm_endereco_cobranca,'')='' then 
              'O Mesmo'   
            else rtrim(n.nm_endereco_cobranca) + ',' + 
                 rtrim(isnull(n.cd_numero_endereco_cob,'')) + ' ' + 
                 rtrim(isnull(n.nm_complemento_end_cob,'')) + ' - ' + 
                 rtrim(isnull(n.nm_bairro_cobranca,''))     + ' - ' + 
                 rtrim(isnull(n.nm_cidade_cobranca,''))     + ' - '+isnull(n.sg_estado_cobranca,'')  + ' - Cep: ' +
                 rtrim(isnull(n.cd_cep_cobranca,''))    
            end
         end,  

      'ENTREGA'                     as ENTREGA,   
      'EndEntrega' =   

      case   
         when (n.nm_endereco_nota_saida  =n.nm_endereco_entrega)    and   
              (n.cd_cep_nota_saida       =n.cd_cep_entrega)         and   
              (n.cd_numero_end_nota_saida=n.cd_numero_endereco_ent) and  
              (n.nm_compl_endereco_nota  =n.nm_complemento_end_ent)   
         then 'O Mesmo'   
         else 
            case when isnull(n.nm_endereco_entrega,'')='' then
              'O Mesmo'
            else
              rtrim(n.nm_endereco_entrega) + ',' + rtrim(isnull(n.cd_numero_endereco_ent,'')) + ' ' + rtrim(isnull(n.nm_complemento_end_ent,'')) + ' - ' + rtrim(isnull(n.nm_bairro_entrega,'')) + ' - ' + rtrim(isnull(n.nm_cidade_entrega,'')) + ' - '+isnull(sg_estado_entrega,'')  
            end
         end,  
      case 
        when @ic_imprime_complemento_end = 'S' then
          rtrim(n.nm_endereco_nota_saida)+' '+n.cd_numero_end_nota_saida+' '+(
          select nm_complemento_endereco from vw_destinatario where cd_tipo_destinatario = n.cd_tipo_destinatario and cd_destinatario = n.cd_cliente
        )
        else
          rtrim(n.nm_endereco_nota_saida)+' '+n.cd_numero_end_nota_saida
      end   as 'ENDERECO',
      n.nm_bairro_nota_saida      as 'BAIRRO',  
      dbo.fn_Formata_Mascara('99999-999',n.cd_cep_nota_saida)  as 'CEP',  
      n.nm_cidade_nota_saida      as 'CIDADE',  
      '('+rtrim(ltrim(n.cd_ddd_nota_Saida))+') '+rtrim(ltrim(n.cd_telefone_nota_saida))  as 'TELEFONE',  
      n.sg_estado_nota_saida                                 as 'UF',  
      n.cd_inscest_nota_saida                                as 'INSCESTADUAL',  
      convert(varchar, n.dt_nota_saida, 3)                   as 'EMISSAO',  
      convert(varchar,(case when @ic_grava_data_hora_saida='S' and n.dt_saida_nota_saida is null then
         getdate()
      else
         n.dt_saida_nota_saida end),3)                as 'DATASAIDA',  
      n.hr_saida_nota_saida                           as 'HORASAIDA',  
      cast(n.vl_iss as decimal(25,2))                 as 'VLISS',  
      cast(n.vl_servico as decimal(25,2))             as 'VLSERVICO',  
      cast(n.vl_total -((IsNull(n.vl_irrf_nota_saida,0) + IsNull(n.vl_inss_nota_saida,0) +  
                                        IsNull(n.vl_iss_retido,0)  
                                      + IsNull(n.vl_cofins,0) + IsNull(n.vl_pis,0)  
                                      + IsNull(n.vl_csll,0))) as decimal(25,2))       as 'TOTSERV',  
      cast(n.vl_bc_icms as decimal(25,2))          as 'VLBCICMS',  
      cast(n.vl_icms as decimal(25,2))             as 'VLICMS',  
      cast(n.vl_bc_subst_icms as decimal(25,2))    as 'VLBCICMSSUBSTRIB',  
      cast(n.vl_icms_subst as decimal(25,2))       as 'VLICMSSUBSTRIB',  
      cast(isnull(n.vl_simbolico,0)+ n.vl_produto as decimal(25,2)) as 'VLTOTALPRODUTO',  
      cast(n.vl_frete as decimal(25,2))                             as 'VLFRETE',  
      cast(n.vl_seguro as decimal(25,2))                            as 'VLSEGURO',  
      cast(n.vl_desp_acess as decimal(25,2))                        as 'VLDESPACESS',  
      cast(n.vl_ipi as decimal(25,2))                               as 'VLIPI',  
      cast(isnull(n.vl_simbolico,0) as decimal(25,2))               as 'VLSIMBOLICO',

--Carlos 23.01.2008

      cast(isnull(n.vl_simbolico,0)+ 
           isnull(n.vl_total,0) as decimal(25,2))                   as 'VLTOTALNF',  

      --'PIS : '    + cast( cast( isnull(vl_pis,0) as decimal(32,2)) as varchar ) as 'VLPIS',
      --'COFINS : ' + cast( cast( isnull(vl_cofins,0) as decimal(32,2)) as varchar ) as 'VLCOFINS',

      isnull(vl_pis,0)                                              as 'VLPIS',
      isnull(vl_cofins,0)                                           as 'VLCOFINS',
      t.nm_transportadora                                           as 'TRANSPORTADORA',  
      'Fone Transportadora : ('+t.cd_ddd+') '+  
      t.cd_telefone + ' - '+  
      /* ELIAS 12/06/2003 */  
      (select top 1 tc.nm_contato from transportadora_contato tc   
       where tc.cd_transportadora = t.cd_transportadora)            as 'FONETRANSPORTADORA',  
      isnull(n.cd_tipo_pagamento_frete,2)                           as 'FRETECONTA',  
      n.cd_placa_nota_saida                                         as 'PLACAVEICULO',  
      n.sg_estado_placa                                             as 'UFPLACA',  
      case isnull(t.cd_cnpj_transportadora,'')   
         when ''  
         then ''   
         else  dbo.fn_Formata_Mascara('99.999.999/9999-99',t.cd_cnpj_transportadora)   
         end  
         as 'CNPJTRANSP',  -- Campo deveria ser fixo na NF, verificar!!        
      LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+LTrim(RTrim(t.nm_bairro)) as 'ENDERECOTRANSP',  
  
--       Foi tirado o bairro para ser colocado ao lado do peso liquido  
--       LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco)) as 'ENDERECOTRANSP',  
--       LTrim(RTrim(t.nm_endereco))+' '+LTrim(RTrim(t.cd_numero_endereco))+' '+t.nm_bairro  as 'ENDERECOTRANSP',  
  
      c.nm_cidade                                as 'CIDADETRANSP',  
      e.sg_estado                                as 'UFTRANSP',  
      t.cd_insc_estadual                         as 'INSCESTTRANSP',  
      /* ELIAS 10/06/2003 */   
      cast(n.qt_volume_nota_saida as varchar)    as 'QTDEVOLUME',  
      isnull(n.nm_especie_nota_saida,'Caixa')                           as 'ESPECIEVOLUME',  
      n.nm_marca_nota_saida                                             as 'MARCAVOLUME',  
      n.nm_numero_emb_nota_saida                                        as 'NUMEROVOLUME',  
      str(n.qt_peso_bruto_nota_saida,7,3)                               as 'PESOBRUTO',  
      str(n.qt_peso_liq_nota_saida,7,3)                                 as 'PESOLIQUIDO',  

--Comentado em 12.05.2007 - Dino/CCF
--Devido a problema de cortar os dados adcionais.

/*

      --Verifica se os Dados adicionais serão impressos após o último produto da Nota Fiscal ou
      --no campo do lay-ouy (linha,coluna)
      
      rtrim(ltrim((case when @qt_folha_nota_fiscal>0 and @qt_total_folha_nota_fiscal>0 
      then
         'Folha '+cast(@qt_folha_nota_fiscal as varchar)+'/'+cast(@qt_total_folha_nota_fiscal as varchar)+' '
      else '' end)
      +
      Ltrim(Rtrim((case when @ic_dado_adicional_produto='N' 
      then 
         cast(n.ds_obs_compl_nota_saida as varchar(1000))
      else '' end)))) +                     
		 Ltrim(Rtrim(Cast((case 
				when @ic_gera_classif_fiscal_corpo = 'S' then 
					@ds_complemento_classif_fiscal
        		else 
					'' 
				end) as varchar(8000)))))   as 'DADOADICIONAL',
*/

          case when @ic_gera_classif_fiscal_corpo = 'S' 
          then 
 	    rtrim(ltrim(@ds_complemento_classif_fiscal))
          else 
	    '' 
          end                                                            as 'CLASSIFICACAOADICIONAL',


      case when @ic_dado_adicional_produto='N' 
      then n.ds_obs_compl_nota_saida
      else '' end                                                        as 'DADOADICIONAL',    
    

      --Atributo para Multi-Formulário
 
      rtrim(ltrim((case when @qt_folha_nota_fiscal>0 and @qt_total_folha_nota_fiscal>1 
      then
         'Folha '+cast(@qt_folha_nota_fiscal as varchar)+'/'+cast(@qt_total_folha_nota_fiscal as varchar) 
      else '' end)))                                                    as 'FOLHA',

      d.nm_destinacao_produto	                                        as 'DESTINACAOPROD',
      cast('' as Varchar(50))                                           as 'PEDIDOVENDA',                                          
--      cast('' as Varchar(50))        as 'PEDIDOCOMPRA',  
      cast(pv.cd_pdcompra_pedido_venda as Varchar(50))                  as 'PEDIDOCOMPRA',        
      n.cd_vendedor                                                     as 'VENDEDOR',  
      upper(v.nm_fantasia_vendedor)                                     as 'NMVEMDEDOR',  
      emp.nm_dominio_internet                                           as 'SITE',    
      emp.nm_email_internet                                             as 'EMAIL',    
  
      --MENSAGENS ESPECIAIS NA NOTA FISCAL ( EXEMPLO : NOVO TELEFONE OU PARTICIPAÇÃO FEIRA )  
     
      (SELECT TOP 1 CAST(msg.ds_mensagem_nota as VARCHAR(200)) 
       FROM Mensagem_Nota msg with (nolock) 
       WHERE 
          isnull(msg.cd_tipo_operacao_fiscal,0) = isnull(n.cd_tipo_operacao_fiscal,0) and
          msg.ic_ativa_mensagem_nota = 'S' and
          isnull(msg.ic_comercial_mensagem,'N') = case when isnull(msg.ic_comercial_mensagem,'N')='S' 
                                                  then 
                                                   case when isnull(opf.ic_comercial_operacao,'N')='S' then 'S' else 'N' end
                                                  else
                                                   isnull(msg.ic_comercial_mensagem,'N')
                                                  end
      )                                                   as 'MENSAGEM',  

      --MENSAGEM FINANCEIRA  
      CAST(pf.ds_mensagem_nota_saida_fin as VARCHAR(200))               as 'MENFINANCEIRA',    
  
      --REFERÊNCIA DO PEDIDO DE VENDA  
      pv.nm_referencia_consulta                                         as 'REFERENCIA_PEDIDO',     
  
      --EXTENSO DO TOTAL DA NOTA FISCAL  
  
      '***('+@nm_extenso+')***'                                                               as 'EXTENSO',  
      '***('+@nm_extenso_duplicatas+')***'                                                    as 'EXTENSODUPLICATAS',  
      @vl_total_duplicatas                                                                    as 'VALOTTOTALDUPLICATAS',
  
      --CENTRO DE CUSTO  
  
      (select top 1 isnull(cc.nm_centro_custo,'')  
      from  
        Centro_Custo cc                   with (nolock) 
        inner Join Nota_Saida_Parcela nsp with (nolock) on nsp.cd_centro_custo=cc.cd_centro_custo )  as 'CENTROCUSTO',  
  
      --PLANO FINANCEIRO  
  
      (select top 1 isnull(pf.nm_conta_plano_financeiro,'')  
      from  
        Plano_Financeiro pf  with (nolock) 
        inner Join Nota_Saida_Parcela nsp on nsp.cd_plano_financeiro=pf.cd_plano_financeiro ) as 'PLANOFINANCEIRO',  
  
      --CUBAGEM  
  
      isnull(n.qt_cubagem_nota_saida,0)                                                       as 'CUBAGEM',                                                                 
  
      --NOME DO VENDEDOR  
      upper(v.nm_fantasia_vendedor)                                                           as 'NMVENDEDOR',  
  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,1)) as 'CLASSFISCALA',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,2)) as 'CLASSFISCALB',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,3)) as 'CLASSFISCALC',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,4)) as 'CLASSFISCALD',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,5)) as 'CLASSFISCALE',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,6)) as 'CLASSFISCALF',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,7)) as 'CLASSFISCALG',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,8)) as 'CLASSFISCALH',  
      (select top 1 nm_letra + ' ' + cd_mascara_classificacao from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,9)) as 'CLASSFISCALI',

      --Código do Cliente

      isnull(n.cd_cliente,0)                                                                 as 'CODIGO_CLIENTE',

      --Condição de Pagamento

      cp.nm_condicao_pagamento                                                               as 'Condicao_Pagamento',
  
      --Observação da Duplicata ( 1a. Observação não Vazia )
      --select * from nota_saida_parcela
      ( select top 1 isnull(nsp.nm_obs_parcela_nota_saida,'') 
        from nota_saida_parcela nsp with (nolock) 
        where     
          nsp.cd_nota_saida = n.cd_nota_saida and
          isnull(nsp.nm_obs_parcela_nota_saida,'')<>'' 
        order by cd_parcela_nota_saida )                                                     as 'OBS_PARCELA',

      --Observação do Usuário 
      cast(isnull(ds_obs_usuario_nota_saida,'') as varchar(8000) )                           as 'OBS_USUARIO',  

      --INFORMAÇÃO FIXA       
  

      --Linha de Asterísco para MultiFormulário

       case when isnull(qt_formulario_nota_saida,0)>0 
            then 
                 replicate('*',@qt_col_serie_nota_fiscal)
            else '' end                                                                       as 'ASTERISCO',                         
 
      --MOTORISTA
 
      isnull(m.nm_motorista,'')                                                               as 'MOTORISTA',

      --VEÍCULO
 
      isnull(vc.nm_veiculo,'')                                                                as 'VEICULO',
 
      --CPF'S AUTORIZADOS
      @nm_autorizado                                                                          as 'AUTORIZADOS',
        

      --FORMA DE PAGAMENTO

      isnull(fp.nm_forma_pagamento,'')                                                        as 'FORMA_PAGAMENTO', 

      --MENSAGEM CHEQUE/FINANCEIRA


      --REGISTRO DO MINISTÉRIO DA AGRICULTA
      emp.cd_registro_m_agricultura                                                           as 'REGISTRO_AGRICULTURA',

      --CONTATO
      --select * from cliente_contato

      ( select top 1
          cc.nm_contato_cliente
        from
          Cliente_Contato cc             with (nolock) 
          inner join nota_saida_item nsi with (nolock) on nsi.cd_nota_saida   = n.cd_nota_saida
          inner join pedido_venda pv     with (nolock) on nsi.cd_pedido_venda = pv.cd_pedido_venda
        where
          cc.cd_cliente = n.cd_cliente  and
          cc.cd_contato = pv.cd_contato)                                                      as  'CONTATO_CLIENTE',            
      
      --PONTO DE CONTROLE   
  
      '.'                                                                                     as 'PONTO'  
      
    into 
        #CabecalhoNota    

    from    
      Nota_Saida n              with (nolock)                                                       left outer join    
      Transportadora t          with (nolock) on n.cd_transportadora      = t.cd_transportadora     left outer join    
      Pedido_Venda pv           with (nolock) on n.cd_pedido_venda        = pv.cd_pedido_venda      left outer join      
      Cidade c                  with (nolock) on t.cd_cidade              = c.cd_cidade             left outer join    
      Estado e                  with (nolock) on t.cd_estado              = e.cd_estado             left outer join  
      Vendedor v                with (nolock) on n.cd_vendedor            = v.cd_vendedor           left outer join   
      Condicao_Pagamento cp     with (nolock) on cp.cd_condicao_pagamento = n.cd_condicao_pagamento left outer join
      Destinacao_Produto d      with (nolock) on d.cd_destinacao_produto  = n.cd_destinacao_produto Left outer join 

      EGISADMIN.DBO.Empresa emp with (nolock) on emp.cd_empresa = @cd_empresa

-- (select top 1 cd_empresa     
--                                                      from EGISADMIN.DBO.Empresa     
--                                                      where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )  
      LEFT OUTER JOIN    
      Parametro_Faturamento pf  with (nolock) on pf.cd_empresa = @cd_empresa

-- (select top 1 cd_empresa     
--                                                      from EGISADMIN.DBO.Empresa     
--                                                      where nm_fantasia_empresa LIKE '%' + @nm_fantasia_empresa + '%' )   
     
      left outer join Motorista m  with (nolock)        on m.cd_motorista = n.cd_motorista
      left outer join Veiculo   vc with (nolock)        on vc.cd_veiculo  = n.cd_veiculo  
      left outer join Forma_Pagamento fp  with (nolock) on fp.cd_forma_pagamento = n.cd_forma_pagamento
      left outer join Operacao_Fiscal opf               on opf.cd_operacao_fiscal = n.cd_operacao_fiscal


    where    
      n.cd_nota_saida = @cd_nota_fiscal  
  

   --print 'mostra cabeçalho'

   --select * from #CabecalhoNota    

  
   --Montando as Colunas com os Valores fixos  
  
   if exists ( select top 1 cd_campo_nota_fiscal from #Fixa )   
   begin  
     declare @i        int  
     declare @coluna   varchar(10)  
     declare @sql      varchar(2000)  
     declare @conteudo varchar(50)  
  
     while exists( select top 1 cd_campo_nota_fiscal from #Fixa )   
     begin  
       select top 1           
         @i        = cd_campo_nota_fiscal,  
         @coluna   = CampoFixo,  
         @conteudo = nm_fixo_nota_fiscal  
       from  
         #Fixa     
  
      set @sql = 'alter table #CabecalhoNota add '+@coluna+' varchar(50)'  
  
      exec (@sql)  
  
      set @sql = 'update #CabecalhoNota set '+@coluna+'='+''''+@conteudo+''''  
      --print @sql  
   
      exec (@sql)  
  
      delete from #Fixa where cd_campo_nota_fiscal = @i  
  
     end  
  
  
   end  
  
   --Mostra o Cabeçalho da Nota Fiscal  
   --select * from #CabecalhoNota  
  
   declare @PEDIDO       as Varchar(50)  --lOC  
   declare @NUMERO       as Integer      --CD_PRODUTO  
   declare @PEDIDOVENDA  as Varchar(100) --LOCALIZACAO  
   declare @PEDIDOCOMPRA as Varchar(100) --LOCALIZACAO  
  
   declare cCabecalhoNota cursor for  
   select   
      NUMERO,  
      PEDIDOVENDA  
   from  
      #CabecalhoNota  
   for update of PEDIDOVENDA  
  
   Select distinct cd_pedido_venda   
   into #PedidoVenda  
   from Nota_Saida_Item  
   where cd_nota_saida=@cd_nota_fiscal and cd_pedido_venda is not null and cd_pedido_venda > 0  
  
   open cCabecalhoNota  
   fetch next from cCabecalhoNota into @NUMERO, @PEDIDOVENDA  
  
   while (@@FETCH_STATUS =0)  
      begin  
         set @PEDIDO=''  
  
         select @PEDIDO = @PEDIDO + (rtrim(cast(cd_pedido_venda as varchar)))  
         from #PedidoVenda pv   
  
         update #CabecalhoNota SET PEDIDOVENDA = @PEDIDO where NUMERO=@NUMERO  
  
      fetch next from cCabecalhoNota into @NUMERO, @PEDIDOVENDA  
     end  
     close cCabecalhoNota  
     deallocate cCabecalhoNota  
  
   declare cCabecalhoNota cursor for  
   select   
      NUMERO,  
      PEDIDOCOMPRA  
   from  
      #CabecalhoNota  
   for update of PEDIDOCOMPRA  
  
   Select distinct 
     isnull(cd_pd_Compra_item_nota,'') as cd_pd_compra_item_nota   
   into 
     #PedidoCompra     
   from 
     Nota_Saida_Item  
   where 
     cd_nota_saida=@cd_nota_fiscal and cd_pd_Compra_item_nota is not null and cd_pd_Compra_item_nota <> ''  

   --Verifica se o Pedido de Compra está nos itens
   declare @iPedido int
   set @iPedido = 0

   select 
     @iPedido = 1
   from
     #PedidoCompra 
   where      
     cd_pd_Compra_item_nota <> ''  

   --select * from #CabecalhoNota

   if @iPedido>0
   begin
  
     open cCabecalhoNota  
     fetch next from cCabecalhoNota into @NUMERO, @PEDIDOCOMPRA  
  
     while (@@FETCH_STATUS =0)  
        begin  
           set @PEDIDO=''  
           select @PEDIDO = @PEDIDO + (rtrim(cast(cd_pd_Compra_item_nota as varchar)))  
           from #PedidoCompra pc   
           update #CabecalhoNota 
             SET PEDIDOCOMPRA = case when @PEDIDO<>'' then upper(@PEDIDO) else PEDIDOCOMPRA end
           where NUMERO=@NUMERO  
          fetch next from cCabecalhoNota into @NUMERO, @PEDIDOCOMPRA  
        end  
     close cCabecalhoNota  
     deallocate cCabecalhoNota  

  end
  
  --Mostra o Cabeçalho da Nota Fiscal
  
  select * from #CabecalhoNota  
  
  drop table #CabecalhoNota  
  drop table #PedidoVenda  
  drop table #PedidoCompra  

  --Atualiza o Pedido de Serviço - Somente a empresa PROREVEST

--   if @nm_fantasia_empresa like '%PROREVEST%'
--   begin
--     --
--     select 
--       pvi.cd_pedido_venda,
--       pvi.cd_item_pedido_venda,
--       pvi.qt_saldo_pedido_venda,
--       pvs.cd_pedido_venda      as cd_pvs,
--       pvs.cd_item_pedido_venda as cd_pvis
--     into
--       #Saldo_Servico
--     from pedido_venda_item pvi 
--     left outer join pedido_venda_item pvs on pvs.cd_pedido_venda = pvi.cd_pedido_venda and
--                                       isnull(pvs.cd_produto_servico,0) >0
--     where
--       isnull(pvi.cd_produto_servico,0)=0 and
--       isnull(pvi.qt_saldo_pedido_venda,0)>0 and
--       isnull(pvs.cd_produto_servico,0) >0
-- 
--     update
--       pedido_venda_item
--     set
--      qt_saldo_pedido_venda = 0
--     from
--      pedido_venda_item pvi
--      inner join #Saldo_Servico SS ON ss.cd_pedido_venda      = pvi.cd_pedido_venda and
--                                      ss.cd_item_pedido_venda = pvi.cd_item_pedido_venda
-- 
--      drop table #Saldo_Servico
-- 
--    --end
--     
--    end
--   


   end  
  
end  
  
