

CREATE   PROCEDURE pr_produto_nota_fiscal
-------------------------------------------------------------------------------
--GBS - Global Business Solution
-------------------------------------------------------------------------------
--Autor      : Fabio Cesar Magalhães
--Objetivo   : Realizar o Salto de três linhas
--Data       : 07.01.2003
--Atualização: 13/05/2003 - Inclusão do nome do grupo de produto quando o
--             mesmo é especial - ELIAS
--             24/09/2003 - Conversão de Float p/ decimal(25,2) - ELIAS
--             25.09.2003 - Parametrização específica para o cliente SMC, imprimir seus produtos de fabricação nacional
--                          com o mesmo fantasia dos produto importados - FABIO
--             17.05.2004 - Foi implementado que somente para as notas proveninentes de requisição de faturamento
--                          ao inves de utilizar o nome do produto na nota venha ser utilizada sua descrição - FABIO
--             25.08.2004 - Alteração no case para impressão da descrição do produto.
--                          Descrição: Em alguns casos da ORDEM DE SERVICO e  POSICAO solicitada pelo cliente 
--                          não são impresso na NF. Motivo : Existe uma clausula "AND" , checando se há conteúdo 
--                          em AMBOS os campos... Na verdade pode ser em um ou no outro... - Igor
--             15/09/2004 - Acertado para Retornar o Nome do Produto, caso a Descrição da RF não
--                          for preenchida. - ELIAS 
--             22/11/2004 - Acrescentado Linha de desconto e SubTotal ao item da NF quando a Mesma
--                          Contêm um Desconto Geral - ELIAS
--             31/03/2005 - Incluído Coluna de Letra que Representa a Classificação Fiscal - ELIAS
--             08.02.2006 - Acerto do Lote - Carlos Fernandes
--             09.05.2006 - Incluído Coluna com o Peso do Produto ( Industécnica ) - Carlos Fernandes
--             29.05.2006 - Acerto da quantidade de casas para o valor unitário - PIC - Carlos Fernandes/Salvatore
--             15.07.2006 - Acerto da impressão de campo descrição Cydak - Carlos Fernandes/Robson
--             18.07.2006 - Mudança na forma de exibição do campos da Nota para Descrição/Memo - Carlos Fernandes
--             25/10/2006 - Incluído verificação no campo de descrição para não concatenar duas vezes o mesmo campo
--                        fazendo com que ficasse duplicado ao emitir a nota. - Daniel C. Neto.
--             31/10/2006 - Integração - Daniel C. Neto.
--             31.10.2006 - Impressão dos Dados Adicionais no Produto na Largura da Nota fiscal - Carlos Fernandes
--             15.11.2006 - Letra da Classificação Fiscal - Carlos Fernandes 
--             13.01.2007 - Adicionando Numero do formulario ao select - Anderson
--             03.02.2007 - Incluído o Número da Ordem de Produção - Carlos Fernandes
--             24.04.2007 - Colocando para imprimir os dados adicionais em outro campo para melhor aproveitar
--                          o espaço do corpo da nota fiscal - Anderson
--             19.05.2007 - Verificação do PIS/COFINS no item da Nota Fiscal - Carlos Fernandes
--             01.09.2007 - Acertos Diversos para Meias Keny - Carlos Fernandes
--             30.10.2007 - Digitos da Classificação Fiscal - Carlos Fernandes
-- 30.01.2008 - Acerto da Impressão de código sem máscara no Grupo de Produto - Carlos Fernandes.
-- 06.09.2008 - Desconto do item da nota fiscal - Carlos Fernandes
-- 15.09.2008 - Valor da Base do ICMS para Substituição tributária - Carlos Fernandes
-- 09.03.2009 - Pedido de Compra no item junto com a Descrição - Carlos Fernandes
-- 15.07.2009 - Certificado do Produto - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
@ic_parametro           int         = 0,
@nm_fantasia_empresa    varchar(20) = '',
@cd_nota_fiscal         int         = 0,
@cd_num_formulario_nota int         = 0

as

--select * from nota_saida_item
--select * from nota_saida_layout

-------------------------------------------------------------------------------
--Controle da Largura do Campo da descrição do Item da Nota Fiscal por Cliente
-------------------------------------------------------------------------------

declare @qt_tamanho_descricao     int
declare @qt_tamanho_dadoadicional int
declare @qt_tamanho_usar          int
declare @qt_tamanho_char10        int
declare @cd_empresa               int

select
  @cd_empresa = dbo.fn_empresa()

set @qt_tamanho_descricao     = 88
set @qt_tamanho_dadoadicional = 0
set @qt_tamanho_usar          = 0
set @qt_tamanho_char10        = 0

select top 1
  @qt_tamanho_descricao = isnull(qt_tam_campo_nota_fiscal,@qt_tamanho_descricao)
from
  Nota_Saida_LayOut with (nolock) 
where
  cd_empresa = @cd_empresa and
  isnull(ic_div_linha_campo,'N') = 'S'

--Pegando Tamanho do Campo Dado Adicional

select top 1
  @qt_tamanho_dadoadicional = isnull(qt_tam_campo_nota_fiscal,0)
from
  Nota_Saida_LayOut with (nolock) 
where
  cd_empresa = @cd_empresa and
  isnull(nm_sp_atributo_ns_layout,'') = 'DADOADICIONALPRODUTO'

--Setando o tamanho a ser usado nos dados adicionais

if @qt_tamanho_dadoadicional = 0
begin
   set @qt_tamanho_usar = @qt_tamanho_descricao
end
else
begin
   set @qt_tamanho_usar = @qt_tamanho_dadoadicional
end

-------------------------------------------------------------------------------  
--Controle da Largura da Nota Fiscal para Impressão Dados Adicionais no Corpo
-------------------------------------------------------------------------------  
--Carlos 31.10.2006

declare @qt_col_serie_nota_fiscal int
declare @ic_pcd_serie_nota_fiscal char(1)

set     @qt_col_serie_nota_fiscal = 0

select
  @qt_col_serie_nota_fiscal = isnull(qt_col_serie_nota_fiscal,80),
  @ic_pcd_serie_nota_fiscal = isnull(ic_pcd_serie_nota_fiscal,'N')
from
  Serie_Nota_Fiscal with (nolock) 
where
  cd_serie_nota_fiscal = ( select top 1 cd_serie_notsaida_empresa from egisadmin.dbo.empresa where cd_empresa = @cd_empresa )
  
--select @qt_col_serie_nota_fiscal

-------------------------------------------------------------------------------  
--Verifica se os Dados Adicionais será impresso no Corpo da Nota Fiscal
--Após os itens do Produto
-------------------------------------------------------------------------------  


declare @ic_dado_adicional_produto char(1)

select
  @ic_dado_adicional_produto = isnull(ic_dado_adicional_produto,'N')
from
  Parametro_Faturamento with (nolock) 
where
  cd_empresa = @cd_empresa

--select @qt_tamanho_descricao

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- NOTA_FISCAL_SAIDA
-------------------------------------------------------------------------------

begin

    --select * from nota_saida_item

    select
      i.cd_item_nota_saida                                                              as 'CODITEM',    


      isnull(dbo.fn_formata_mascara((select isnull(g.cd_mascara_grupo_produto,'')
                              from Grupo_Produto g, Produto p
                              where i.cd_produto = p.cd_produto and
                                    p.cd_grupo_produto = g.cd_grupo_produto),

			      (select isnull(p.cd_mascara_produto,'')
                              from Produto p
                              where i.cd_produto = p.cd_produto)),i.cd_mascara_produto)  as 'CODIGO',          

     	case  when (@nm_fantasia_empresa like '%SMC%') and substring(i.nm_fantasia_produto, len(rtrim(i.nm_fantasia_produto)) - 2, 3) = '*BR' 
            then substring(i.nm_fantasia_produto, 1, len(rtrim(i.nm_fantasia_produto)) - 3)
			      else i.nm_fantasia_produto             
      end                                                                   as 'FANTASIA',

      -----------------------------------------------------------------------------------------------------------
      --Descrição do Item da Nota            
      -----------------------------------------------------------------------------------------------------------
     
      --Verifica se o Item da Nota é totalmente especial
  
      case when isnull(i.cd_produto,0)=0 and isnull(i.cd_grupo_produto,0)=0 
      then
         (case when IsNull(i.cd_requisicao_faturamento,0) = 0 
         then '' 
         else
            ltrim(i.nm_produto_item_nota) 
         end )                    --          +' '+          --Descrição
--        rtrim(ltrim(cast( i.ds_item_nota_saida as varchar(800))))                --Complemento / Descritivo
      else
         ''
      end 

      +

        --Checa se o Grupo é Especial 
        case when isnull(g.ic_especial_grupo_produto,'N') = 'S' 
              then 
                ltrim(cast( isnull(g.nm_nota_grupo_produto,'') as varchar(100)))
              else 
                 ''
              end +

       --Requisição de Faturamento

         case when 
                isnull(i.cd_requisicao_faturamento,0) = 0
              then 
                rtrim(cast(isnull(i.nm_produto_item_nota,'') as varchar(100)))

-- CARLOS 20.02.2008
--                 +
-- 
--                 case when  
--                   (@nm_fantasia_empresa like '%MAGNO%')      OR (@nm_fantasia_empresa like '%MARIANA%') OR   
--                   (@nm_fantasia_empresa like '%MEIAS KENY%') OR (@nm_fantasia_empresa like '%SANGELO%') -- Meias Keny  
--                 then 
--                    rtrim(ltrim(cast( i.ds_item_nota_saida as varchar(800))))
--                 else
--                    ''
--                 end

              else 
                   case when isnull(cast(i.ds_item_nota_saida as varchar),'') = ''
                        then rtrim(cast(i.nm_produto_item_nota as varchar(100)))
                        else rtrim(cast(i.ds_item_nota_saida   as varchar(100))) 
                        end
 
              end +

        --Kardex

        case when isnull(i.nm_kardex_item_nota_saida,'')=''       
             then '' 
             else ' (' + isnull(i.nm_kardex_item_nota_saida,'') + ') ' end +     

        --OS

        case when isnull(i.cd_os_item_nota_saida,'') = ''
             then ''
             else ' (OS:'+ltrim(i.cd_os_item_nota_saida)               end +     
        
        --Posição

        case when isnull(i.cd_posicao_item_nota,'') = ''
             then ''
             else ' POS:'+ltrim(i.cd_posicao_item_nota)+')' end   +       

        --Pedido de Compra
        case when @ic_pcd_serie_nota_fiscal = 'S' --and i.cd_pd_compra_item_nota<>'Verbal'
             then
                ' '+rtrim(ltrim(isnull(i.cd_pd_compra_item_nota,'')))
             else
                  '' end      

                                                                      as 'DESCRICAO',

      --------------------------------------------------------------------------------------------------------------

      i.qt_liquido_item_nota                                          as 'PESOLIQ',
      i.qt_bruto_item_nota_saida                                      as 'PESOBRUTO', 
      isnull(i.qt_cubagem_item_nota,0)                                as 'CUBAGEM',
      i.ds_item_nota_saida                                            as 'OBSITEM',    
      c.cd_mascara_classificacao	                              as 'CLASSFISCAL',
      i.cd_situacao_tributaria	                                      as 'SITTRIB',
      u.sg_unidade_medida		                              as 'UNIDADE',
      IsNull(i.qt_item_nota_saida,0)                                  as 'QUANTIDADE',

      --Preço Unitário com Casas decimais diferente do Padrão ( 2 casas )

      case when ( @nm_fantasia_empresa like '%PIC%' ) or ( @nm_fantasia_empresa like '%TRM%' )    or 
                ( @nm_fantasia_empresa like '%EVC%' ) or ( @nm_fantasia_empresa like '%LUFAED%' ) or
                ( @nm_fantasia_empresa like '%PROREVEST%' ) or ( @nm_fantasia_empresa like '%MEGAPRINT%' )
      then
          cast(IsNull(i.vl_unitario_item_nota,0) as decimal(25,5))  
      else
        case when  ( @nm_fantasia_empresa like '%ATLAS%' ) 
        then
          cast(IsNull(i.vl_unitario_item_nota,0) as decimal(25,6))  
         else
           cast(IsNull(i.vl_unitario_item_nota,0) as decimal(25,2))
         end
      end                                                             as 'UNITARIO',

      cast(IsNull(i.vl_total_item,0) as decimal(25,2))	              as 'VLTOTALITEM',
      isnull(i.pc_desconto_item,0)                                    as 'VLALIQDESC',
      case when isnull(i.pc_desconto_item,0)>0 then '*' else ' ' end  as 'PRODDESC',

      case when ( @nm_fantasia_empresa like '%SERVNEWS%' ) then
        rtrim(ltrim(str(IsNull(i.pc_icms,0),5,2)))
      else
        str(IsNull(i.pc_icms,0),2,0)
      end                                                             as 'VLALIQICMS',

      str(IsNull(i.pc_ipi,0),2,0)	                              as 'VLALIQIPI',
      cast(IsNull(i.vl_ipi,0) as decimal(25,2))	      	              as 'VLIPIITEM',
      cast(isnull(i.vl_pis,0) as decimal(25,2))                       as 'VLPISITEM',
      cast(isnull(i.vl_cofins,0) as decimal(25,2))                    as 'VLCOFINSITEM',
      dbo.fn_produto_localizacao(i.cd_produto,i.cd_fase_produto)      as 'LOCALIZACAO',	  
      str(isnull(i.qt_saldo_estoque,0),8,0)	                      as 'SALDOESTOQUE',

      i.cd_produto,

      --Letra da Classificação Fiscal

      case when isnull(nc.sg_sigla_classificacao_nota,'')=''
           then cl.nm_letra 
           else nc.sg_sigla_classificacao_nota end                    as 'LETRACLASSFISCAL',

--      cl.nm_letra,
--      nc.sg_sigla_classificacao_nota,

      --Modificado em 08.02.2006
      --Empresa que Opera com Lote na Nota Fiscal

      case when @nm_fantasia_empresa<>'Phamaspecial' then
           i.cd_lote_item_nota_saida 
      else
         case when isnull(nsil.nm_lote,'') <> '' 
             then 'ITEM: ' + cast(i.cd_item_nota_saida as varchar(10)) + ' - LOTE: ' + isnull(nsil.nm_lote,'')
         else
             ''
         end
      end                                                               as 'LOTE',

      i.cd_num_formulario_nota                                          as 'FORMULARIO',

      --Número da Ordem de Produção

      case when ( @nm_fantasia_empresa like '%LUFAED%' ) then
        i.cd_pedido_venda
      else
        isnull(( select 
          top 1 pp.cd_processo 
        from processo_producao pp with (nolock) 
        where pp.cd_pedido_venda      = i.cd_pedido_venda and
              pp.cd_item_pedido_venda = i.cd_item_pedido_venda ),0) 
      end                                                              as 'ORDEMPRODUCAO',

      cast( '' as varchar(8000))                                       as 'DADOADICIONALPRODUTO',
 
--      isnull(i.vl_bc_subst_icms_item,0)                                as 'BASEICMSTEMSUBSTRIB' 

   isnull(dbo.fn_tabela_base_icms_categoria_produto ( i.cd_produto,ns.cd_cliente),0) as 'BASEICMSTEMSUBSTRIB',
   p.cd_certificado_produto                                                          as 'CERTIFICADO' 

    into #Produto_Nota_Fiscal    

    from 
      Nota_Saida_Item i                       with (nolock) 
      left outer join Nota_Saida ns           with (nolock) on ns.cd_nota_saida               = i.cd_nota_saida
      left outer join Classificacao_Fiscal c  with (nolock) on c.cd_classificacao_fiscal      = i.cd_classificacao_fiscal
      left outer join Unidade_Medida u        with (nolock) on i.cd_unidade_medida            = u.cd_unidade_medida
    -- necessário incluir a tabela grupo de produto 
    -- para verificação do grupo de produtos especiais
    -- para a correta impressão da nota fiscal - ELIAS 12/05/2003
      left outer join Grupo_Produto g         with (nolock) on g.cd_grupo_produto             = i.cd_grupo_produto

      --Busca da Classificação Fiscal
      left outer join (select nm_letra, cd_classificacao_fiscal from dbo.fn_letra_classificacao_fiscal(@cd_nota_fiscal,0)) cl
                       on cl.cd_classificacao_fiscal = i.cd_classificacao_fiscal

      left outer join Nota_saida_Item_Lote nsil   with (nolock) on nsil.cd_nota_saida         = i.cd_nota_saida and nsil.cd_item_nota_saida = i.cd_item_nota_saida
      left outer join Nota_Saida_Classificacao nc with (nolock) on nc.cd_classificacao_fiscal = i.cd_classificacao_fiscal
      left outer join Produto p                   with (nolock) on p.cd_produto               = i.cd_produto
       
    where
          i.cd_nota_saida           = @cd_nota_fiscal and
          i.ic_tipo_nota_saida_item = 'P' and
          isnull(i.cd_num_formulario_nota,0)  = case when isnull(@cd_num_formulario_nota,0)=0 then i.cd_num_formulario_nota else isnull(@cd_num_formulario_nota,0) end

    union all  

    select 
      null                as 'CODITEM',
      null                as 'CODIGO',          
      null                as 'FANTASIA',
      case when  
        (@nm_fantasia_empresa like '%MAGNO%')      OR (@nm_fantasia_empresa like '%MARIANA%') OR   
        (@nm_fantasia_empresa like '%MEIAS KENY%') OR (@nm_fantasia_empresa like '%SANGELO%') -- Meias Keny  
      then 
        'BONIFICACAO '+cast(qt_desconto_nota_saida as varchar)+'%'
      else
        'DESCONTO '+cast(qt_desconto_nota_saida as varchar)+'%'
      end                 as 'DESCRICAO',
      null                as 'CLASSFISCAL',
      null                as 'SITTRIB',
      null                as 'UNIDADE',
      null                as 'PESOLIQ',
      null                as 'PESOBRUTO',
      null                as 'CUBAGEM',
      cast(null as text ) as 'OBSITEM',
      null                as 'QUANTIDADE',  
      null                as 'UNITARIO',
      cast(vl_desconto_nota_saida as decimal(25,2)) as 'VLTOTALITEM',
      null                as 'VLALIQDESC',
      ' '                 as 'PRODDESC',

      null as 'VLALIQICMS',
      null as 'VLALIQIPI',
      null as 'VLIPIITEM',
      null as 'VLPISITEM',
      null as 'VLCOFINSITEM',
      null as 'LOCALIZACAO',	  
      null as 'SALDOESTOQUE',
      null                       as cd_produto,
      null                       as 'LETRACLASSFISCAL',
      null                       as 'LOTE',
      null                       as 'FORMULARIO',
      0                          as 'ORDEMPRODUCAO',
      cast( '' as varchar(8000)) as 'DADOADICIONALPRODUTO',
      null                       as 'BASEICMSTEMSUBSTRIB',
      null                       as 'CERTIFICADO'   

    from nota_saida with (nolock) 
    where 
      cd_nota_saida = @cd_nota_fiscal and
          (isnull(qt_desconto_nota_saida,0)<>0) and
          isnull(cd_num_formulario_nota,0)  = case when isnull(@cd_num_formulario_nota,0)=0 then isnull(cd_num_formulario_nota,0) else isnull(@cd_num_formulario_nota,0) end

    union all

    select 
      null                as 'CODITEM',
      null                as 'CODIGO',          
      null                as 'FANTASIA',
      'SUB-TOTAL'         as 'DESCRICAO',
      null                as 'CLASSFISCAL',
      null                as 'SITTRIB',
      null                as 'UNIDADE',
      null                as 'PESOLIQ',
      null                as 'PESOBRUTO',
      null                as 'CUBAGEM',
      cast(null as text ) as 'OBSITEM',
      null                as 'QUANTIDADE',
      null                as 'UNITARIO',
      cast((vl_produto - (vl_desconto_nota_saida)) as decimal(25,2)) as 'VLTOTALITEM',
      null                as 'VLALIQDESC',
      ' '                 as 'PRODDESC',
      null                as 'VLALIQICMS',
      null                as 'VLALIQIPI',
      null                as 'VLIPIITEM',
      null                as 'VLPISITEM',
      null                as 'VLCOFINSITEM',
      null                as 'LOCALIZACAO',	  
      null                as 'SALDOESTOQUE',
      null                as cd_produto,
      null                as 'LETRACLASSFISCAL',
      null                as 'LOTE',
      null                       as 'FORMULARIO',
      0                          as 'ORDEMPRODUCAO',
      cast( '' as varchar(8000)) as 'DADOADICIONALPRODUTO',
      null                       as 'BASEICMSTEMSUBSTRIB',
      null                       as 'CERTIFICADO'

    from 
      nota_saida with (nolock) 

    where
      cd_nota_saida = @cd_nota_fiscal        and
      (isnull(qt_desconto_nota_saida,0)<>0 ) and
       isnull(cd_num_formulario_nota,0)  = case when isnull(@cd_num_formulario_nota,0)=0 
                                                then isnull(cd_num_formulario_nota,0)
                                                else isnull(@cd_num_formulario_nota,0) end
--      select * from #Produto_Nota_Fiscal    

--    print 'mostra tabela'   

    if (@nm_fantasia_empresa like '%MAGNO%')      OR (@nm_fantasia_empresa like '%MARIANA%') OR   
       (@nm_fantasia_empresa like '%MEIAS KENY%') OR (@nm_fantasia_empresa like '%SANGELO%') -- Meias Keny  
    begin
      select * from #Produto_Nota_Fiscal    
    end

--   print 'mostra tabela'   

else
begin  

    --Rotina Especial para Descrição Técnica 

    create table #Produto_Observacao(    
      CODITEM          int          null,    
      CODIGO           varchar(100) null,    
      FANTASIA         varchar(100) null,    
      DESCRICAO        varchar(100) null,    
      PESOLIQ          float        null,
      PESOBRUTO        float        null,
      CUBAGEM          float        null,
      OBSITEM          text         null,    
      CLASSFISCAL      varchar(20)  null,    
      SITTRIB          varchar(3)   null,    
      UNIDADE          varchar(10 ) null,    
      QUANTIDADE       float        null,    
      UNITARIO         float        null,    
      VLTOTALITEM      float null,    
      VLALIQDESC       float null,
      PRODDESC         char(1),
      VLALIQICMS       float null,    
      VLALIQIPI        float null,    
      VLIPIITEM        float null,    
      VLPISITEM            float null,
      VLCOFINSITEM         float null,
      LOCALIZACAO          varchar(20) null,       
      SALDOESTOQUE         float null,    
      cd_produto           int     null,
      LETRACLASSFISCAL     char(2) null,
      LOTE                 varchar(25) null,
      FORMULARIO           varchar(10) null,
      ORDEMPRODUCAO        int         null,
      DADOADICIONALPRODUTO varchar(8000) null,
      BASEICMSTEMSUBSTRIB  float null,
      CERTIFICADO          varchar(20) )
    
      declare @nm_produto_item_nota    varchar(100)    
      declare @ds_item_nota_saida      varchar(8000)    
      declare @cd_item_nota_saida      int    
    
      declare cCursor cursor for       
      select CODITEM  from #Produto_Nota_Fiscal    
    
      open cCursor    
      
      fetch next from cCursor into @cd_item_nota_saida    
      while @@FETCH_STATUS = 0    
      begin    

        select     
          @ds_item_nota_saida   = OBSITEM,    
          @nm_produto_item_nota = DESCRICAO
        from    
          #Produto_Nota_Fiscal    
        where    
          CODITEM = @cd_item_nota_saida    
    
--         select *  
--              from 
--                 #Produto_Nota_Fiscal 
--              where     
--                CODITEM = @cd_item_nota_saida  


    --select @ds_item_nota_saida,@nm_produto_item_nota

        if (rtrim(isnull(@ds_item_nota_saida,'')) =     
            rtrim(isnull(@nm_produto_item_nota,'')))    
        begin    
           --print(rtrim(@ds_item_nota_saida))    
           --print(rtrim(@nm_produto_item_nota))    
          insert into #Produto_Observacao     
            select * from #Produto_Nota_Fiscal where     
             CODITEM = @cd_item_nota_saida  
        end    
      else    
        begin    
          --print @cd_item_nota_saida

          --print 'v'

          insert into #Produto_Observacao    
                (CODITEM,    
                 CODIGO,    
                 FANTASIA,    
                 DESCRICAO,   
                 PESOLIQ,
                 PESOBRUTO,
                 CUBAGEM,  
                 OBSITEM,    
                 CLASSFISCAL,    
                 SITTRIB,    
                 UNIDADE,    
                 QUANTIDADE,    
                 UNITARIO,    
                 VLTOTALITEM,    
                 VLALIQDESC,
                 PRODDESC,
                 VLALIQICMS,    
                 VLALIQIPI,    
                 VLIPIITEM,    
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,       
                 SALDOESTOQUE,    
                 cd_produto,
                 LETRACLASSFISCAL,
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO)    
            select     
                isnull(CODITEM,0)           as CODITEM ,    
                isnull(CODIGO,' ')          as CODIGO,    
                isnull(FANTASIA,' ')        as FANTASIA,    
                isnull(DESCRICAO,' ')       as DESCRICAO,    
                isnull(PESOLIQ,0)           as PESOLIQ,
                isnull(PESOBRUTO,0)         as PESOBRUTO,
                isnull(CUBAGEM,0)           as CUBAGEM,
                isnull(OBSITEM,' ')         as OBSITEM,    
                isnull(CLASSFISCAL,' ')     as CLASSFISCAL,    
                isnull(SITTRIB,' ')         as SITTRIB,    
                isnull(UNIDADE,' ')         as UNIDADE,    
                isnull(QUANTIDADE,0)        as QUANTIDADE,    
                isnull(UNITARIO,0)          as UNITARIO,    
                isnull(VLTOTALITEM,0)       as VLTOTALITEM,    
                isnull(VLALIQDESC,0)        as VLALIQDESC,
                isnull(PRODDESC,' ')        as PRODDESC,
                isnull(VLALIQICMS,0)        as VLALIQICMS,    
                isnull(VLALIQIPI,0)         as VLALIQIPI,    
                isnull(VLIPIITEM,0)         as VLIPIITEM,    
                isnull(VLPISITEM,0)         as VLPISITEM,
                isnull(VLCOFINSITEM,0)             as VLCOFINSITEM,
                isnull(LOCALIZACAO,'')             as LOCALIZACAO,       
                isnull(SALDOESTOQUE,0)             as SALDOESTOQUE,    
                isnull(cd_produto,0)               as cd_produto,
                isnull(LETRACLASSFISCAL,' ')       as LETRACLASSFISCAL,
                isnull(LOTE,' ')                   as LOTE,
                isnull(FORMULARIO,'')              as FORMULARIO,
                isnull(ORDEMPRODUCAO,'')           as ORDEMPRODUCAO,
                isnull(DADOADICIONALPRODUTO,'')    as DADOADICIONALPRODUTO,
                isnull(BASEICMSTEMSUBSTRIB,0.00)   as BASEICMSTEMSUBSTRIB,
                isnull(CERTIFICADO,'')             as CERTIFICADO
             from 
                #Produto_Nota_Fiscal 
             where     
               CODITEM = @cd_item_nota_saida  

   --print 'xxxx'
   --select * from #Produto_Observacao

   -- Márcio Rodrigues Somente para corrigir um erro temporario para o Cliente FullCoat       

   
    if  @nm_fantasia_empresa like '%Full%'  
          begin  
  
--   Print 'FullCoat'   

             insert into #Produto_Observacao      
                (CODITEM,      
                 CODIGO,      
                 FANTASIA,      
                 DESCRICAO,      
                 PESOLIQ,  
                 PESOBRUTO,   
                 CUBAGEM,  
                 OBSITEM,      
                 CLASSFISCAL,      
                 SITTRIB,      
                 UNIDADE,      
                 QUANTIDADE,      
                 UNITARIO,      
                 VLTOTALITEM,      
                 VLALIQDESC,
                 PRODDESC,
                 VLALIQICMS,      
                 VLALIQIPI,      
                 VLIPIITEM,      
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,         
                 SALDOESTOQUE,      
                 cd_produto,    
                 LETRACLASSFISCAL,  
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO )      
  
                (select       
                   CODITEM,    --CODITEM  
                   '',         --CODIGO  
                   '',         --FANTASIA  
                   '',         --DESCRICAO   
                   0,          --PESOLIQ  
                   0,          --PESOBRUTO  
                   0,          --CUBAGEM  
                   '',         --OBSITEM  
                   '',         --CLASSFISCAL  
                   '',         --SITTRIB  
                   '',         --UNIDADE  
                   0,          --QUANTIDADE  
                   0,          --UNITARIO  
                   0,          --VLTOTALITEM  
                   0,          --VLALIQDESC,
                   '',         --PRODDESC,
                   0,          --VLALIQICMS  
                   0,          --VLALIQIPI  
                   0,          --VLIPIITEM
                   0,          --VLPISITEM
                   0,          --VLCOFINSITEM  
                   '',         --LOCALIZACAO  
                   0,          --SALDOESTOQUE   
                   0,          --CD_PRODUTO  
                   '',         --LETRACLASSFISCAL  
                   '',         --LOTE  
                   '',         --FORMULARIO
                   0,          --ORDEMPRODUCAO
                   '',         --DADOADICIONALPRODUTO,
                   0.00,       --BASEICMSTEMSUBSTRIB 
                   ''          --CERTIFICADO

        from #Produto_Nota_Fiscal   
        where       
          CODITEM = @cd_item_nota_saida)    

   end  

   --(Fim) Márcio Rodrigues Somente para corrigir um erro temporario para o Cliente FullCoat    

   --print 'yyyy'  

          declare @posicao            int
          --select * from #Produto_Observacao
    
          declare @Obs                varchar(8000)    
          declare @ObsImp             varchar(8000)
          declare @cd_form_nota_saida int
    
          select     
            @cd_form_nota_saida = FORMULARIO
          from    
            #Produto_Nota_Fiscal    
          where    
            CODITEM = @cd_item_nota_saida    

          select 
            @Obs = OBSITEM    
          from 
            #Produto_Observacao    
          where 
            CODITEM = @cd_item_nota_saida    

        --select len(@Obs),@qt_tamanho_usar
  
          while (len(@Obs)>= @qt_tamanho_usar ) --//or len(@Obs)=0   
          begin    

            set @posicao = charindex(char(10), @Obs )
      
            if @posicao > 0
               set @ObsImp = rtrim( substring(@Obs,1,@posicao) )
            else
               set @ObsImp = rtrim( substring(@Obs,1,@qt_tamanho_usar) )
 
              --set @ObsImp = rtrim(substring(@Obs,1,@qt_tamanho_usar))    
              --print 'j'

              insert into #Produto_Observacao    
                (CODITEM,    
                 CODIGO,    
                 FANTASIA,    
                 DESCRICAO,    
                 PESOLIQ,
                 PESOBRUTO, 
                 CUBAGEM,
                 OBSITEM,    
                 CLASSFISCAL,    
                 SITTRIB,    
                 UNIDADE,    
                 QUANTIDADE,    
                 UNITARIO,    
                 VLTOTALITEM,    
                 VLALIQDESC,
                 PRODDESC,
                 VLALIQICMS,    
                 VLALIQIPI,    
                 VLIPIITEM,    
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,       
                 SALDOESTOQUE,    
                 cd_produto,  
                 LETRACLASSFISCAL,
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO )    

                (select     
                   CODITEM,    --CODITEM
                   '',         --CODIGO
                   '',         --FANTASIA
                   cast(case when isnull(@qt_tamanho_dadoadicional,0)=0 then @ObsImp else '' end as varchar(100)), --DESCRICAO 
                   0,          --PESOLIQ
                   0,          --PESOBRUTO
                   0,          --CUBAGEM
                   '',         --OBSITEM
                   '',         --CLASSFISCAL
                   '',         --SITTRIB
                   '',         --UNIDADE
                   0,          --QUANTIDADE
                   0,          --UNITARIO
                   0,          --VLTOTALITEM
                   0,          --VLALIQDESC,
                   '',         --PRODDESC,
                   0,          --VLALIQICMS
                   0,          --VLALIQIPI
                   0,          --VLIPIITEM
                   0,          --VLPISITEM
                   0,          --VLCOFINSITEM
                   '',         --LOCALIZACAO
                   0,          --SALDOESTOQUE 
                   0,          --CD_PRODUTO
                   '',         --LETRACLASSFISCAL
                   '',          --LOTE
                   cast(@cd_form_nota_saida as varchar), --FORMULARIO
                   0,            --ORDEMPRODUCAO   
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then '' else @ObsImp end, --DADOADICIONALPRODUTO
                   0.00,         --BASEICMSTEMSUBSTRIB
                   ''            --CERTIFICADO

    from 
        #Produto_Nota_Fiscal 

    where     
        CODITEM = @cd_item_nota_saida)    
     
        if @posicao > 0
           set @Obs = rtrim(substring(@Obs,@posicao+1,len(@Obs)))    
        else
           set @Obs = rtrim(substring(@Obs,@qt_tamanho_usar+1,len(@Obs)))    
    
   
     end    
    
--     print 'z'
--          select len(@Obs),@qt_tamanho_usar,@obs
--select @qt_tamanho_dadoadicional

          if ((len(@Obs)<@qt_tamanho_usar) and (isnull(@Obs,'')<>''))    
          begin
            --print 'i'
            --select '1'

              insert into #Produto_Observacao    
                (CODITEM,    
                 CODIGO,    
                 FANTASIA,    
                 DESCRICAO,    
                 PESOLIQ,
                 PESOBRUTO,
                 CUBAGEM,
                 OBSITEM,    
                 CLASSFISCAL,    
                 SITTRIB,    
                 UNIDADE,    
                 QUANTIDADE,    
                 UNITARIO,    
                 VLTOTALITEM,    
                 VLALIQDESC,
                 PRODDESC,
                 VLALIQICMS,    
                 VLALIQIPI,    
                 VLIPIITEM,    
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,       
                 SALDOESTOQUE,    
                 cd_produto,
                 LETRACLASSFISCAL,
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO )    

                (select     
                   CODITEM,    
                   '',    
                   '',    
                   cast(case when isnull(@qt_tamanho_dadoadicional,0)=0 then @Obs else @Obs end as varchar(100)), --DESCRICAO 
                   0.00, --PESOLIQ
                   0.00, --PESOBRUTO
                   0.00, --CUBAGEM,
                   '',   --OBSITEM  
                   '',   --CLASSFISCAL  
                   '',   --SITTRIB,     
                   '',   --UNIDADE,     
                   0,    --QUANTIDADE
                   0,    --UNITÁRIO
                   0,    --VLTOTALITEM
                   0,    --VLALIQDESC
                   '',   --PRODDESC 
                   0,    --VLALIQICMS
                   0,    --VLALIQIPI
                   0,    --VLIPIITEM 
                   0,    --VLPISITEM
                   0,    --VLCOFINSITEM
                   '',   --LOCALIZACAO 
                   0,    --SALDOESTOQUE
                   0,    --cd_produto
                   '',   --LETRACLASSFISCAL
                   '',   --LOTE
                   cast(@cd_form_nota_saida as varchar), --FORMULARIO
                   0,     --ORDEMPRODUCAO
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then '' else @Obs end, --DADOADICIONALPRODUTO
                   0.00,  --BASEICMSTEMSUBSTRIB
                   ''
                 from #Produto_Nota_Fiscal 
                 where     
                   CODITEM = @cd_item_nota_saida)    
            end
        end                  

      --print 'i : '+cast(@cd_item_nota_saida as varchar)
    
      fetch next from cCursor into @cd_item_nota_saida    
    
    end    
    
  close      cCursor    
  deallocate cCursor      

--select * from #Produto_Observacao

-- print 'tttt'

 --Rotina de Impressão dos Dados Adicionais após o último Produto da Nota Fiscal

  if @ic_dado_adicional_produto = 'S'
  begin

    declare @ds_obs_compl_nota_saida varchar(8000)
    declare @ds_adicional            varchar(8000)

    --Busca os Dados Adicionais da Nota Fiscal

    select
      @ds_obs_compl_nota_saida = ds_obs_compl_nota_saida --rtrim(ltrim(cast(ds_obs_compl_nota_saida as varchar(8000))))
    from 
      Nota_Saida ns with (nolock) 
    where 
      cd_nota_saida = @cd_nota_fiscal

    -- set @ds_obs_compl_nota_saida = replace( @ds_obs_compl_nota_saida, char(10), '|' )
    -- select @ds_obs_compl_nota_saida
    -- select @qt_col_serie_nota_fiscal

    if @qt_col_serie_nota_fiscal>100
       set @qt_col_serie_nota_fiscal = 100

    while (len(@ds_obs_compl_nota_saida)>=@qt_tamanho_usar)--@qt_col_serie_nota_fiscal Anderson
    begin      

       set @posicao = charindex(char(10), @ds_obs_compl_nota_saida )
      
       if @posicao > 0
          set @ds_adicional = rtrim( substring(@ds_obs_compl_nota_saida,1,@posicao) )
       else
          set @ds_adicional = rtrim( substring(@ds_obs_compl_nota_saida,1,@qt_tamanho_usar) )
          

       --select @ds_adicional

    insert into #Produto_Observacao      
                (CODITEM,      
                 CODIGO,      
                 FANTASIA,      
                 DESCRICAO,      
                 PESOLIQ,  
                 PESOBRUTO,   
                 CUBAGEM,  
                 OBSITEM,      
                 CLASSFISCAL,      
                 SITTRIB,      
                 UNIDADE,      
                 QUANTIDADE,      
                 UNITARIO,      
                 VLTOTALITEM,   
                 VLALIQDESC,
                 PRODDESC,   
                 VLALIQICMS,      
                 VLALIQIPI,      
                 VLIPIITEM,      
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,         
                 SALDOESTOQUE,      
                 cd_produto,    
                 LETRACLASSFISCAL,  
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO )      
  
                (select       
                   '',    --CODITEM  
                   '',         --CODIGO  
                   '',         --FANTASIA  
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then @ds_adicional else '' end, --DESCRICAO 
                   0,          --PESOLIQ  
                   0,          --PESOBRUTO  
                   0,          --CUBAGEM  
                   '',         --OBSITEM  
                   '',         --CLASSFISCAL  
                   '',         --SITTRIB  
                   '',         --UNIDADE  
                   0,          --QUANTIDADE  
                   0,          --UNITARIO  
                   0,          --VLTOTALITEM  
                   0,          --VLALIQDESC,
                   '',         --PRODDESC,
                   0,          --VLALIQICMS  
                   0,          --VLALIQIPI  
                   0,          --VLIPIITEM  
                   0,          --VLPISITEM,
                   0,          --VLCOFINSITEM,
                   '',         --LOCALIZACAO  
                   0,          --SALDOESTOQUE   
                   0,          --CD_PRODUTO  
                   '',         --LETRACLASSFISCAL  
                   '',         --LOTE  
                   '',         --Formulario
                   0,          --Ordem Produção
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then '' else @ds_adicional end, ----Dado Adicional
                   0 ,         --BASEICMSTEMSUBSTRIB
                   ''          --CERTIFICADO
                   )       

       if @posicao > 0
          set @ds_obs_compl_nota_saida = 
              rtrim(substring(@ds_obs_compl_nota_saida,@posicao+1,len(@ds_obs_compl_nota_saida)))      
       else
          set @ds_obs_compl_nota_saida = 
              rtrim(substring(@ds_obs_compl_nota_saida,@qt_tamanho_usar+1,len(@ds_obs_compl_nota_saida)))      

--     set @ds_obs_compl_nota_saida = 
--          rtrim(substring(@ds_obs_compl_nota_saida,@qt_tamanho_usar+1,len(@ds_obs_compl_nota_saida)))      


    --select * from #Produto_Observacao      
    
    end

    if ((len(@ds_obs_compl_nota_saida)<@qt_tamanho_usar) and (isnull(@ds_obs_compl_nota_saida,'')<>''))      
    begin
      insert into #Produto_Observacao      
                (CODITEM,      
                 CODIGO,      
                 FANTASIA,      
                 DESCRICAO,      
                 PESOLIQ,  
                 PESOBRUTO,  
                 CUBAGEM,  
                 OBSITEM,      
                 CLASSFISCAL,      
                 SITTRIB,      
                 UNIDADE,      
                 QUANTIDADE,      
                 UNITARIO,      
                 VLTOTALITEM,      
                 VLALIQDESC,
                 PRODDESC,
                 VLALIQICMS,      
                 VLALIQIPI,      
                 VLIPIITEM,      
                 VLPISITEM,
                 VLCOFINSITEM,
                 LOCALIZACAO,         
                 SALDOESTOQUE,      
                 cd_produto,  
                 LETRACLASSFISCAL,  
                 LOTE,
                 FORMULARIO,
                 ORDEMPRODUCAO,
                 DADOADICIONALPRODUTO,
                 BASEICMSTEMSUBSTRIB,
                 CERTIFICADO)      

                (select       
                   '',      
                   '',      
                   '',      
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then @ds_obs_compl_nota_saida else '' end, --DESCRICAO 
                   0,  
                   0,  
                   0,  
                   '',      
                   '',      
                   '',      
                   '',      
                   0,
                   0,
                   0,
                   0,
                   '',      
                   0,      
                   0,      
                   0,      
                   0,      
                   0,       
                   '',      
                   0,      
                   0,  
                   '',  
                   '',
                   '',
                   0,
                   case when isnull(@qt_tamanho_dadoadicional,0)=0 then '' else @ds_obs_compl_nota_saida end, --DESCRICAO 
                   0,
                   ''
                   )
    end 

  end

  --Mostra a Tabela Desmembrada para apresentação
  --print 'Mostra : '+'Produto_Observacao'    

  select * from #Produto_Observacao    

  drop table #Produto_Nota_Fiscal    
  drop table #Produto_Observacao    

end

end

else
  return

