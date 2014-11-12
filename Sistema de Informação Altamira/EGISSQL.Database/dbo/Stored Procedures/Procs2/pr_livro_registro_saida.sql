
CREATE PROCEDURE pr_livro_registro_saida
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@qt_pagina    int,
@cd_empresa   int

as

--Verifica se as Notas Fiscais de Entrada gerada pelo Faturamento serão processadas no Livro de Saída
--Carlos 12.06.2005

declare @ic_nf_entrada_livro_saida char(1) 

set @ic_nf_entrada_livro_saida = 'N'

select
  @ic_nf_entrada_livro_saida = isnull(ic_nf_entrada_livro_saida,'N')
from
   parametro_fiscal with (nolock) 
where
   cd_empresa = dbo.fn_empresa()

--Verifica se Agrupa ou Não as Notas Fiscais

if @ic_parametro = 3
begin

  if (select 
        isnull(ic_desagrupa_livro_saida,'N') 
      from 
        parametro_fiscal with (nolock) 
      where
        cd_empresa = dbo.fn_empresa()) = 'S'

  set @ic_parametro = 5

end

-------------------------------------------------------------------------------
--Deleta as Notas Fiscais sem Imposto conforme o Tipo de Pedido
-------------------------------------------------------------------------------

--select * from tipo_pedido
--select * from nota_saida_item_registro

delete nota_saida_item_registro 
  from nota_saida_item_registro i
  inner join nota_saida_item nsi on nsi.cd_nota_saida      = i.cd_nota_saida and
                                    nsi.cd_item_nota_saida = i.cd_item_nota_saida
  inner join pedido_venda pv     on pv.cd_pedido_venda     = nsi.cd_pedido_venda

  inner join tipo_pedido  tp     on tp.cd_tipo_pedido      = pv.cd_tipo_pedido
where
  isnull(nsi.cd_pedido_venda,0)>0    and isnull(nsi.cd_item_pedido_venda,0)>0 and
  isnull(tp.ic_imposto_tipo_pedido,'S') = 'N'

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista o resumo p/ CFOP
-------------------------------------------------------------------------------
  begin

    select
      substring(r.cd_mascara_operacao,1,1) 			as 'Grupo',
      r.cd_mascara_operacao 					as 'CFOP',
      sum(round(isnull(r.vl_contabil_item_nota,0),2))	        as 'VlrContabil',
      sum(round(isnull(r.vl_base_icms_item_nota,0),2))	        as 'BCICMS',	
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	        as 'ICMS',
      sum(round(isnull(r.vl_icms_isento_item_nota,0),2))	as 'ICMSIsento',
      sum(round(isnull(r.vl_icms_outras_item_nota,0),2))	as 'ICMSOutras',
      sum(round(isnull(r.vl_icms_obs_item_nota,0),2))	        as 'ICMSObs',
      sum(round(isnull(r.vl_base_ipi_item_nota,0),2))	        as 'BCIPI',
      sum(round(isnull(r.vl_ipi_item_nota_saida,0),2))	        as 'IPI',
      sum(round(isnull(r.vl_ipi_isento_item_nota,0),2))	        as 'IPIIsento',
      sum(round(isnull(r.vl_ipi_outras_item_nota,0),2))	        as 'IPIOutras',
      sum(round(isnull(r.vl_ipi_obs_item_nota,0),2))	        as 'IPIObs'
    into
      #ResumoCFOP
    from
      Nota_Saida_Item_Registro r with (nolock) 
      left outer join Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
--      isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 2  -- SAIDA
    group by
      r.cd_mascara_operacao
    order by
      r.cd_mascara_operacao

    select
      *,
      BCICMS+ICMSIsento+ICMSOutras+ICMSObs+IPIObs+IPI-VlrContabil as 'DifICMS',
      BCIPI+IPI+IPIIsento+IPIOutras+IPIObs-VlrContabil     as 'DifIPI'
    from
      #ResumoCFOP  
    order by
      CFOP

    
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- lista resumo p/ estado
-------------------------------------------------------------------------------
  begin

    select
      r.cd_mascara_operacao 							as 'CFOP',
      r.sg_estado                        					as 'Estado', 
      sum(cast(isnull(r.vl_contabil_item_nota,0) as decimal(25,2)))		as 'VlrContabil',
      sum(cast(isnull(r.vl_base_icms_item_nota,0) as decimal(25,2)))		as 'BCICMS',	
      sum(cast(isnull(r.vl_icms_item_nota_saida,0) as decimal(25,2)))		as 'ICMS',
      sum(cast(isnull(r.vl_icms_isento_item_nota,0) as decimal(25,2)))		as 'ICMSIsento',
      sum(cast(isnull(r.vl_icms_outras_item_nota,0) as decimal(25,2)))		as 'ICMSOutras',
      sum(cast(isnull(r.vl_icms_obs_item_nota,0) as decimal(25,2)))		as 'ICMSObs',
      sum(cast(isnull(r.vl_base_ipi_item_nota,0) as decimal(25,2)))		as 'BCIPI',
      sum(cast(isnull(r.vl_ipi_item_nota_saida,0) as decimal(25,2)))		as 'IPI',
      sum(cast(isnull(r.vl_ipi_isento_item_nota,0) as decimal(25,2)))		as 'IPIIsento',
      sum(cast(isnull(r.vl_ipi_outras_item_nota,0) as decimal(25,2)))		as 'IPIOutras',
      sum(cast(isnull(r.vl_ipi_obs_item_nota,0) as decimal(25,2)))		as 'IPIObs',
      -- ELIAS 06/07/2004
      isnull(op.ic_contribicms_op_fiscal, 'S')  				as 'ContrICMS',
      sum(cast(isnull(r.vl_base_icms_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_icms_isento_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_icms_outras_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_icms_obs_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_item_nota_saida,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_obs_item_nota,0) as decimal(25,2))-
          cast(isnull(r.vl_contabil_item_nota,0) as decimal(25,2))) 		as 'DifICMS',
      sum(cast(isnull(r.vl_base_ipi_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_item_nota_saida,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_isento_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_outras_item_nota,0) as decimal(25,2))+
          cast(isnull(r.vl_ipi_obs_item_nota,0) as decimal(25,2))-
          cast(isnull(r.vl_contabil_item_nota,0) as decimal(25,2)))		as 'DifIPI' 
    into
      #ResumoUF         
    from
      Nota_Saida_Item_Registro r
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      isnull(op.ic_opinterestadual_op_fis,'N') = 'S' and
      r.dt_nota_saida between @dt_inicial and @dt_final and
--      isnull(op.ic_servico_operacao,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 2  -- SAIDA
    group by
      isnull(op.ic_contribicms_op_fiscal,'S'),
      r.cd_mascara_operacao,
      r.sg_estado

    select * from #ResumoUF order by ContrICMS, CFOP, ESTADO


  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- livro de saída
-------------------------------------------------------------------------------
  begin

    -- variáveis usadas como chave

    declare @Codigo		int
    declare @NumeroInicial      int
    declare @NumeroFinal	int
    declare @Data		datetime
    declare @UF			char(2)
    declare @CodContabil        varchar(20)
    declare @CFOP 		varchar(6)
    declare @AliqICMS		float
    declare @AliqIPI		decimal(25,2)
    declare @Observacoes	varchar(50)
    declare @Contador           int
    declare @CodigoAgrupado     int
    declare @Tipo               char(1)
    declare @TipoAnterior       char(1)

    -- variáveis que acumulam valor    
    declare @VlrContabil        decimal(25,2)
    declare @BCICMS		decimal(25,2)
    declare @ICMS		decimal(25,2)
    declare @ICMSIsento		decimal(25,2)
    declare @ICMSOutras		decimal(25,2)
    declare @ICMSObs		decimal(25,2)
    declare @BCIPI		decimal(25,2)
    declare @IPI		decimal(25,2)
    declare @IPIIsento		decimal(25,2)
    declare @IPIOutras		decimal(25,2)
    declare @IPIObs		decimal(25,2)

    -- inicialização das variáveis
    set     @Data  	    = null
    set	    @UF		    = null
    set     @CodContabil    = null
    set     @CFOP           = null
    set     @AliqICMS       = null
    set     @AliqIPI        = null
    set     @Observacoes    = null
    set     @Contador       = 1
    set     @CodigoAgrupado = null
    set     @Tipo           = null
    set     @TipoAnterior   = null

    -- tabela do livro de registro de saída

    create table #Livro_Registro_Saida (
      Codigo 		int not null primary key,
      Chave		varchar(100)  null,
      Especie 		varchar(25)   null,
      Serie		varchar(2)    null,
      Numero		varchar(20)   null,
      Identificacao     varchar(20)   null,
      NumeroInicial     int,
      NumeroFinal       int,
      Data		datetime      null,
      Dia		integer       null,
      UF		varchar(2)    null,
      VlrContabil	decimal(25,2) null,
      CodContabil       varchar(20) null,
      CFOP              varchar(6) null,
      AliqICMS          float null,
      BCICMS		decimal(25,2) null,
      ICMS		decimal(25,2) null,
      ICMSIsento	decimal(25,2) null,
      ICMSOutras	decimal(25,2) null,
      ICMSObs		decimal(25,2) null,
      AliqIPI		decimal(25,2) null,
      BCIPI		decimal(25,2) null,
      IPI		decimal(25,2) null,
      IPIIsento		decimal(25,2) null,
      IPIOutras		decimal(25,2) null,
      IPIObs		decimal(25,2) null,
      Observacoes       varchar(100) null)                        
 
    -----------------------------------------------------
    -- tabela com todos os registros de nota de saída
    -- Trazer: Notas Canceladas
    --         Notas de Serviço
    --         Notas de Entrada - Carrasco em 28/07/2004
    -----------------------------------------------------

    select
      distinct
      -- ELIAS 11/12/2003
      cast(isnull(s.nm_especie_livro_saida,'NFF') as varchar(20)) as 'Especie', 
      cast(isnull(s.nm_serie_livro_saida,'1') as char(2))         as 'Serie',
      r.cd_nota_saida                  		                  as 'Numero',
      n.cd_identificacao_nota_saida             as 'Identificacao',
      r.cd_item_nota_saida			as 'Item',
      r.dt_nota_saida                           as 'Data',
      day(r.dt_nota_saida)			as 'Dia',
      r.sg_estado				as 'UF',
      isnull(r.vl_contabil_item_nota,0)	 	as 'VlrContabil',
      IsNull(( select top 1 x.nm_conta_liv_saida_grupo 
	       from  Grupo_Produto_Fiscal x with (nolock) 
	       where x.cd_grupo_produto = nsi.cd_grupo_produto and
	       IsNull(o.ic_comercial_operacao,'N') = 'S'),'') as 'CodContabil',
      r.cd_mascara_operacao			as 'CFOP',
      isnull(r.pc_icms_item_nota_saida,0) 	as 'AliqICMS',
      isnull(r.vl_base_icms_item_nota,0) 	as 'BCICMS',	
      isnull(r.vl_icms_item_nota_saida,0) 	as 'ICMS',
      isnull(r.vl_icms_isento_item_nota,0) 	as 'ICMSIsento',
      isnull(r.vl_icms_outras_item_nota,0) 	as 'ICMSOutras',
      isnull(r.vl_icms_obs_item_nota,0)	 	as 'ICMSObs',
      isnull(r.pc_ipi_item_nota_saida,0) 	as 'AliqIPI',
      isnull(r.vl_base_ipi_item_nota,0)	 	as 'BCIPI',
      isnull(r.vl_ipi_item_nota_saida,0) 	as 'IPI',
      isnull(r.vl_ipi_isento_item_nota,0) 	as 'IPIIsento',
      isnull(r.vl_ipi_outras_item_nota,0) 	as 'IPIOutras',
      isnull(r.vl_ipi_obs_item_nota,0)	 	as 'IPIObs',
      o.nm_obs_livro_operacao			as 'Observacoes',
      case when r.ic_cancelada_item_nota = 'S' then 'C' else
--           case when r.ic_servico_item_nota = 'S' then 'S' else
                 case when (gop.cd_tipo_operacao_fiscal = 1) then 'E' else
                -- Comentado por não estar cadastrado corretamente 
                -- na Base de Dados - ELIAS 20/06/2003
                --case when o.ic_destaca_vlr_livro_op_f <> 'S' then 'N' else
                     'V' end
                --end
--                end
           end					as 'Tipo'      
    into
      #Nota_Saida_Temp2

    from
      Nota_Saida_Item_Registro r with (nolock) 

    inner join
      Nota_Saida n               with (nolock) 
    on
      r.cd_nota_saida = n.cd_nota_saida  
    left outer join
      Operacao_Fiscal o
    on
      r.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
    left outer join
      Plano_Conta c
    on
      r.cd_conta   = c.cd_conta and
      c.cd_empresa = dbo.fn_empresa()
    left outer join
      Serie_Nota_Fiscal s
    on
      s.cd_serie_nota_fiscal = n.cd_serie_nota
    left outer join
      Nota_Saida_Item nsi on nsi.cd_nota_saida = r.cd_nota_saida and														 nsi.cd_item_nota_saida = r.cd_item_nota_saida  
    where
      n.dt_nota_saida between @dt_inicial and @dt_final  and
      gop.cd_tipo_operacao_fiscal = case when @ic_nf_entrada_livro_saida='S' then 1 else 2 end 


--Comentado hoje 17.12.2009

    insert into #Nota_Saida_Temp2
    select
      distinct
      cast(isnull(s.nm_especie_livro_saida,'NFF') as varchar(20)) as 'Especie', 
      cast(isnull(s.nm_serie_livro_saida,'1') as char(2))         as 'Serie',
      r.cd_nota_entrada                                           as 'Numero',
      r.cd_nota_entrada                                           as 'Identificacao',
      r.cd_item_nota_entrada     			          as 'Item',
      n.dt_nota_entrada                                           as 'Data',
      day(n.dt_nota_entrada)			                  as 'Dia',
      ''	 			                          as 'UF',
      0                                                           as 'VlrContabil',
      ''                                                          as 'CodContabil',
      ''			                                  as 'CFOP',
      0 	                                                  as 'AliqICMS',
      0 	                                                  as 'BCICMS',	
      0  	                                                  as 'ICMS',
      0 	as 'ICMSIsento',
      0 	as 'ICMSOutras',
      0	 	as 'ICMSObs',
      0 	as 'AliqIPI',
      0	 	as 'BCIPI',
      0 	as 'IPI',
      0 	as 'IPIIsento',
      0 	as 'IPIOutras',
      0	 	as 'IPIObs',
      ''			as 'Observacoes',
      'E' as 'Tipo'      
    from
      Nota_Entrada n left outer join
      Nota_Entrada_Item r on r.cd_nota_entrada      = n.cd_nota_entrada and
                             r.cd_fornecedor        = n.cd_fornecedor and
                             r.cd_operacao_fiscal   = n.cd_operacao_fiscal and
                             r.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal left outer join
      Serie_Nota_Fiscal s on s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
    where
      n.dt_nota_entrada between @dt_inicial and @dt_final and
      n.ic_lista_livro_saida = 'S'


    select
      identity(int, 1,1) as 'Codigo',
      *
    into
      #Nota_Saida_Temp
    from
      #Nota_Saida_Temp2
    order by
      Numero,
      UF,
      CodContabil,
      CFOP,
      AliqICMS,
      AliqIPI,
      Observacoes
 
    -- leitura da tabela temporária p/ geração dos registros no livro

    while exists(select top 1 Codigo from #Nota_Saida_Temp order by Numero)
      begin        

        -- carregamento das variáveis de acúmulo
        select
          top 1
          @Codigo 	= Codigo,
          @NumeroFinal 	= cast(Numero as varchar(10)),
          @VlrContabil 	= VlrContabil,
          @BCICMS   	= BCICMS,
          @ICMS		= ICMS,
          @ICMSIsento	= ICMSIsento,
          @ICMSOutras	= ICMSOutras,
          @ICMSObs	= ICMSObs,
      	  @BCIPI	= BCIPI,
          @IPI		= IPI,
          @IPIIsento	= IPIIsento,
          @IPIOutras	= IPIOutras,
          @IPIObs	= IPIObs,
          @Tipo         = Tipo
        from
          #Nota_Saida_Temp

        order by
          Codigo
          
        -- verifica se o registro, deacordo com a chave composta dos dados
        -- que são permitidos serem agrupados numa mesma linha do livro,
        -- já existe, agrupando-o
        if (select 
              top 1 
              isnull(cast(Data        as char(12)),' ')+
              isnull(cast(UF          as char(2)),' ')+
              isnull(cast(CodContabil as char(20)),' ')+
              isnull(cast(CFOP        as char(6)),' ')+
              isnull(cast(AliqICMS    as char(20)),' ')+
              --isnull(cast(AliqIPI     as char(20)),' ')+
              case Tipo when 'C' then 'C A N C E L A D A'
                        when 'S' then 'PRESTAÇÃO DE SERVIÇO'
                        when 'E' then 'NOTA FISCAL DE ENTRADA'
                        else isnull(cast(Observacoes as char(50)),' ') end
            from
              #Nota_Saida_Temp

            where 
              Tipo   = @Tipo and     
              Tipo   = @TipoAnterior and
              Codigo = @Codigo) = (isnull(cast(@Data         as char(12)),' ')+
                                   isnull(cast(@UF           as char(2)),' ')+
                                   isnull(cast(@CodContabil  as char(20)),' ')+
                                   isnull(cast(@CFOP         as char(6)),' ')+
                                   isnull(cast(@AliqICMS     as char(20)),' ')+
                                   --isnull(cast(@AliqIPI      as char(20)),' ')+
                                   isnull(cast(@Observacoes  as char(50)),' '))
          begin
  
            if (@Tipo <> 'V')
              begin

                update
                  #Livro_Registro_Saida
                set
                  Numero = case when @NumeroInicial <> @NumeroFinal then cast(@NumeroInicial as varchar(10)) + ' A ' + 
                                                                         cast(@NumeroFinal   as varchar(10))
                                                                    else cast(@NumeroFinal   as varchar(10)) end
                where
                  Chave = (isnull(cast(@Data         as char(12)),' ')+
                           isnull(cast(@UF           as char(2)),' ')+
                           isnull(cast(@CodContabil  as char(20)),' ')+
                           isnull(cast(@CFOP         as char(6)),' ')+
                           isnull(cast(@AliqICMS     as char(20)),' ')+
                           --isnull(cast(@AliqIPI      as char(20)),' ')+
                           isnull(cast(@Observacoes  as char(50)),' ')) and
                  Codigo = @CodigoAgrupado

              end
            else
              begin

                -- acúmulo dos valores no livro
                update
                  #Livro_Registro_Saida
                set
                  Numero = case when @NumeroInicial <> @NumeroFinal then cast(@NumeroInicial as varchar(10)) + ' A ' + 
                                                                         cast(@NumeroFinal   as varchar(10))
                                                                    else cast(@NumeroFinal   as varchar(10)) end,
                  NumeroInicial = @NumeroInicial,
                  NumeroFinal   = @NumeroFinal,
                  VlrContabil 	= VlrContabil 	+ @VlrContabil,
                  BCICMS 	= BCICMS 	+ @BCICMS,
                  ICMS 		= ICMS 		+ @ICMS,
                  ICMSIsento 	= ICMSIsento 	+ @ICMSIsento,
                  ICMSOutras 	= ICMSOutras 	+ @ICMSOutras, 
                  ICMSObs 	= ICMSObs 	+ @ICMSObs,
                  BCIPI 	= BCIPI 	+ @BCIPI,
                  IPI 		= IPI 		+ @IPI,
                  IPIIsento 	= IPIIsento 	+ @IPIIsento,
                  IPIOutras 	= IPIOutras 	+ @IPIOutras,
                  IPIObs 	= IPIObs 	+ @IPIObs
                where
                  Chave = (isnull(cast(@Data         as char(12)),' ')+
                           isnull(cast(@UF           as char(2)),' ')+
                           isnull(cast(@CodContabil  as char(20)),' ')+
                           isnull(cast(@CFOP         as char(6)),' ')+
                           isnull(cast(@AliqICMS     as char(20)),' ')+
                           --isnull(cast(@AliqIPI      as char(20)),' ')+
                           isnull(cast(@Observacoes  as char(50)),' ')) and
                  Codigo = @CodigoAgrupado
              end

            -- contador utilizado p/ que o agrupamento aconteça sempre na sequência
            -- de notas, sem este contador não é identificado na cláusula where em
            -- qual registro será acumulado os valores.
            if @NumeroInicial <> @NumeroFinal
              set @Contador = @Contador + 1

            set @TipoAnterior = @Tipo
            
          end 
        else
          begin

            select
              top 1
              @Codigo 	     	= Codigo,
              @CodigoAgrupado   = Codigo,
              @NumeroInicial 	= Numero,
              @Data		= Data,
              @UF		= UF,
              @CodContabil      = CodContabil,
              @CFOP             = CFOP,
    	      @AliqICMS		= AliqICMS,
    	      @AliqIPI		= AliqIPI,
  	      @Observacoes 	= Observacoes,
              @Tipo             = Tipo
            from
              #Nota_Saida_Temp
            where
              Codigo = @Codigo            

            -- Na inserção de Notas Canceladas ou Servico não mostrar valores
            if (@Tipo <> 'V')
              begin

                if @Tipo = 'C'
                  set @Observacoes = 'C A N C E L A D A'

                if @Tipo = 'S'
                  set @Observacoes = 'PRESTAÇÃO DE SERVIÇO'

                if @Tipo = 'E'
                  set @Observacoes = 'NOTA FISCAL DE ENTRADA'
                
                -- inserção do primeiro registro que compõe a linha
                insert into #Livro_Registro_Saida 
                  (Codigo,
                   Chave,
	           Especie,
     	           Serie,
                   Data,
                   Dia,
                   UF,
                   Numero,
                   Identificacao,
                   NumeroInicial,
                   NumeroFinal,
                   Observacoes)                                           
                select 
                  top 1
                  Codigo,
                  (isnull(cast(Data         as char(12)),' ')+
                   isnull(cast(UF           as char(2)),' ')+
                   isnull(cast(CodContabil  as char(20)),' ')+
                   isnull(cast(CFOP         as char(6)),' ')+
                   isnull(cast(AliqICMS     as char(20)),' ')+
                   --isnull(cast(AliqIPI      as char(20)),' ')+
                   isnull(cast(@Observacoes  as char(50)),' ')),
	          Especie,
	          Serie,
                  Data,
                  Dia,
                  UF,  
                  @NumeroInicial,
                  @NumeroInicial,
                  @NumeroInicial,
                  @NumeroFinal,
--                  cast(@NumeroInicial as int ),
--                  cast(@NumeroFinal   as int ),
                  @Observacoes
                from
                  #Nota_Saida_Temp
                where
                  Codigo = @Codigo

                set @CodigoAgrupado = @Codigo

              end
            else
              begin
                
                -- inserção do primeiro registro que compõe a linha (Vendas)
                insert into #Livro_Registro_Saida 
                  (Codigo,
                   Chave,
	           Especie,
    	           Serie,
                   Numero,
                   Identificacao,
                   NumeroInicial,
                   NumeroFinal, 
                   Data,
                   Dia,
                   UF,
                   VlrContabil,
                   CodContabil,
                   CFOP,
                   AliqICMS,
                   BCICMS,
                   ICMS,
                   ICMSIsento,
                   ICMSOutras,
                   ICMSObs,
                   AliqIPI,
                   BCIPI,
                   IPI,
                   IPIIsento,
                   IPIOutras,
                   IPIObs,
                   Observacoes)                                           
                select 
                  top 1
                  Codigo,
                  (isnull(cast(Data         as char(12)),' ')+
                   isnull(cast(UF           as char(2)),' ')+
                   isnull(cast(CodContabil  as char(20)),' ')+
                   isnull(cast(CFOP         as char(6)),' ')+
                   isnull(cast(AliqICMS     as char(20)),' ')+
                   --isnull(cast(AliqIPI      as char(20)),' ')+
                   isnull(cast(Observacoes  as char(50)),' ')),
	          Especie,
    	          Serie,
                  @NumeroInicial,
                  @NumeroInicial,
                  @NumeroInicial,
                  @NumeroFinal,
                  Data,
                  Dia,
                  UF,
                  VlrContabil,
                  CodContabil,
                  CFOP, 
                  AliqICMS,
                  BCICMS,
                  ICMS,
                  ICMSIsento,
                  ICMSOutras,
                  ICMSObs,
                  AliqIPI,
                  BCIPI,
                  IPI,
                  IPIIsento,
                  IPIOutras,
                  IPIObs,
                  Observacoes
                from
                  #Nota_Saida_Temp

                where
                  Codigo = @Codigo

              end

            set @Contador     = 1
            set @TipoAnterior = @Tipo

          end

        delete from 
          #Nota_Saida_Temp
        where
          Codigo = @Codigo 

      end                            

    -- seleção do livro              

    select
      Codigo,
      Especie,
      Serie,

      case when isnull(Identificacao,'')<>'' then Identificacao
      else
        Numero
      end                                   as Numero,

      --Numero,
      Identificacao,
      NumeroInicial,
      NumeroFinal,
      Data,
      Dia,
      UF,
      isnull(VlrContabil,0)  as VlrContabil,
      isnull(CodContabil,'') as CodContabil,
      isnull(CFOP,'')        as CFOP,
      isnull(AliqICMS,0)     as AliqICMS,
      isnull(BCICMS,0)       as BCICMS,
      isnull(ICMS,0)         as ICMS,
      isnull(ICMSIsento,0)   as ICMSIsento,
      isnull(ICMSOutras,0)   as ICMSOutras,
      isnull(ICMSObs,0)      as ICMSObs,
      isnull(AliqIPI,0)      as AliqIPI,
      isnull(BCIPI,0)        as BCIPI,
      isnull(IPI,0)          as IPI,
      isnull(IPIIsento,0)    as IPIIsento,
      isnull(IPIOutras,0)    as IPIOutras,
      isnull(IPIObs,0)       as IPIObs,
      Observacoes,
      isnull(BCICMS,0)+isnull(ICMSIsento,0)+isnull(ICMSOutras,0)+
      isnull(ICMSObs,0)+isnull(IPI,0)+isnull(IPIObs,0)-isnull(VlrContabil,0)
			     as DifICMS,
      isnull(BCIPI,0) + isnull(IPIIsento,0)+isnull(IPIOutras,0)+
      isnull(IPIObs,0)+ isnull(IPI,0)-isnull(VlrContabil,0)
			     as DifIPI
    from
      #Livro_Registro_Saida

    order by
      NumeroInicial

     --Numero,
     --cast(NumeroInicial as int ) -- ELIAS 18/11/2003
   

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 5  -- livro de saída Sem Agrupamento
-------------------------------------------------------------------------------
  begin

    -- TABELA COM AS NOTAS DE SAÍDA 

    select
      distinct
      cast(isnull(s.nm_especie_livro_saida,'NFF') as varchar(20)) as 'Especie', 
      cast(isnull(s.nm_serie_livro_saida,'1') as char(2))         as 'Serie',

      cast(
      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        r.cd_nota_saida
      end as varchar(20))                       as 'Numero',

      --cast(r.cd_nota_saida as varchar(20))      as 'Numero',

      r.cd_nota_saida			        as 'NumeroInicial',
      r.cd_nota_saida      		        as 'NumeroFinal',
      r.cd_item_nota_saida			as 'Item',
      r.dt_nota_saida                           as 'Data',
      day(r.dt_nota_saida)			as 'Dia',
      r.sg_estado				as 'UF',
      isnull(r.vl_contabil_item_nota,0)	 	as 'VlrContabil',
      IsNull(( select top 1 x.nm_conta_liv_saida_grupo 
	       from  Grupo_Produto_Fiscal x 
	       where x.cd_grupo_produto = nsi.cd_grupo_produto and
	       IsNull(o.ic_comercial_operacao,'N') = 'S'),'') as 'CodContabil',
      r.cd_mascara_operacao			as 'CFOP',
      isnull(r.pc_icms_item_nota_saida,0) 	as 'AliqICMS',
      isnull(r.vl_base_icms_item_nota,0) 	as 'BCICMS',	
      isnull(r.vl_icms_item_nota_saida,0) 	as 'ICMS',
      isnull(r.vl_icms_isento_item_nota,0) 	as 'ICMSIsento',
      isnull(r.vl_icms_outras_item_nota,0) 	as 'ICMSOutras',
      isnull(r.vl_icms_obs_item_nota,0)	 	as 'ICMSObs',
      isnull(r.pc_ipi_item_nota_saida,0) 	as 'AliqIPI',
      isnull(r.vl_base_ipi_item_nota,0)	 	as 'BCIPI',
      isnull(r.vl_ipi_item_nota_saida,0) 	as 'IPI',
      isnull(r.vl_ipi_isento_item_nota,0) 	as 'IPIIsento',
      isnull(r.vl_ipi_outras_item_nota,0) 	as 'IPIOutras',
      isnull(r.vl_ipi_obs_item_nota,0)	 	as 'IPIObs',
      o.nm_obs_livro_operacao		        as 'Observacoes'
    into
      #Nota_Saida_Desagr

    from
      Nota_Saida_Item_Registro r
    inner join
      Nota_Saida n
    on
      r.cd_nota_saida = n.cd_nota_saida  
    left outer join
      Operacao_Fiscal o
    on
      r.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
    left outer join
      Plano_Conta c
    on
      r.cd_conta = c.cd_conta and
      c.cd_empresa = dbo.fn_empresa()
    left outer join
      Serie_Nota_Fiscal s
    on
      s.cd_serie_nota_fiscal = n.cd_serie_nota
    left outer join
      Nota_Saida_Item nsi 
    on 
      nsi.cd_nota_saida      = r.cd_nota_saida and
      nsi.cd_item_nota_saida = r.cd_item_nota_saida  
    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      gop.cd_tipo_operacao_fiscal = 2 and
      ((isnull(r.ic_cancelada_item_nota,'N') = 'N'))  

--Mudança de Legislaçao
--and
--      ((isnull(r.ic_servico_item_nota,'N') = 'N'))

    -- NOTAS CANCELADAS E DE PRESTAÇÃO DE SERVICO

    select
      distinct
      cast(isnull(s.nm_especie_livro_saida,'NFF') as varchar(20)) as 'Especie', 
      cast(isnull(s.nm_serie_livro_saida,'1') as char(2))         as 'Serie',
--      cast(r.cd_nota_saida as varchar(20))      as 'Numero',

      cast(
      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        r.cd_nota_saida
      end as varchar(20))                       as 'Numero',


      r.cd_nota_saida			        as 'NumeroInicial',
      r.cd_nota_saida      		        as 'NumeroFinal',
      0				                as 'Item',
      r.dt_nota_saida                           as 'Data',
      day(r.dt_nota_saida)			as 'Dia',
      r.sg_estado				as 'UF',
      0                                         as 'VlrContabil',
      cast('' as varchar)  			as 'CodContabil',
      cast('' as varchar)			as 'CFOP',
      0 					as 'AliqICMS',
      0 					as 'BCICMS',	
      0 					as 'ICMS',
      0 					as 'ICMSIsento',
      0 					as 'ICMSOutras',
      0 					as 'ICMSObs',
      0 					as 'AliqIPI',
      0 					as 'BCIPI',
      0 					as 'IPI',
      0 					as 'IPIIsento',
      0 					as 'IPIOutras',
      0 					as 'IPIObs',
      case when r.ic_cancelada_item_nota = 'S' then
        'C A N C E L A D A'
      else
--        case when r.ic_servico_item_nota = 'S' then
--          'PRESTAÇÃO DE SERVICO'
--        else
          case when (gop.cd_tipo_operacao_fiscal = 1) then
            'NOTA FISCAL DE ENTRADA'
          end
--        end
      end					as 'Observacoes'
    into
      #Nota_Saida_Desagr_Cancelada
    from
      Nota_Saida_Item_Registro r
    inner join
      Nota_Saida n
    on
      r.cd_nota_saida = n.cd_nota_saida  
    left outer join
      Operacao_Fiscal o
    on
      r.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
    left outer join
      Serie_Nota_Fiscal s
    on
      s.cd_serie_nota_fiscal = n.cd_serie_nota
    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      --Verificação do Parâmetro - Carlos 12.06.2005
      ((gop.cd_tipo_operacao_fiscal = case when @ic_nf_entrada_livro_saida='S' then 1 else 2 end ) or 
       (isnull(r.ic_cancelada_item_nota,'N') = 'S')) -- ELIAS 08/01/2004


    insert into #Nota_Saida_Desagr
    select
      distinct
      cast(isnull(s.nm_especie_livro_saida,'NFF') as varchar(20)) as 'Especie', 
      cast(isnull(s.nm_serie_livro_saida,'1')     as char(2))     as 'Serie',
      cast(r.cd_nota_entrada as varchar(20))                      as 'Numero',

      r.cd_item_nota_entrada         		as 'Item',
      r.cd_nota_entrada            		as 'NumeroInicial',
      r.cd_nota_entrada            		as 'NumeroFinal',

      n.dt_nota_entrada                           as 'Data',
      day(n.dt_nota_entrada)			as 'Dia',
      ''				as 'UF',
      0                                                    	 	as 'VlrContabil',
      '' as 'CodContabil',
      ''			as 'CFOP',
      0 	as 'AliqICMS',
      0 	as 'BCICMS',	
      0 	as 'ICMS',
      0 	as 'ICMSIsento',
      0 	as 'ICMSOutras',
      0	 	as 'ICMSObs',
      0 	as 'AliqIPI',
      0	 	as 'BCIPI',
      0 	as 'IPI',
      0 	as 'IPIIsento',
      0 	as 'IPIOutras',
      0	 	as 'IPIObs',
      'NOTA DE ENTRADA'			as 'Observacoes'
    from
      Nota_Entrada n left outer join
      Nota_Entrada_Item r on r.cd_nota_entrada = n.cd_nota_entrada and
                             r.cd_fornecedor = n.cd_fornecedor and
                             r.cd_operacao_fiscal = n.cd_operacao_fiscal and
                             r.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal left outer join
      Serie_Nota_Fiscal s on s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
    where
      n.dt_nota_entrada between @dt_inicial and @dt_final and
      n.ic_lista_livro_saida = 'S'


    select * 
    into 
      #Nota_Saida_Desagr_Total
    from 
      #Nota_Saida_Desagr
    union all
    select * 
    from
      #Nota_Saida_Desagr_Cancelada
 
    -- seleção do livro              
    select
      identity(int, 1,1) as 'Codigo',
      Especie,
      Serie,
      Numero,
      NumeroInicial,
      NumeroFinal,
      Data,
      Dia,
      UF,
      sum(isnull(VlrContabil,0))  as VlrContabil,
      isnull(CodContabil,'')      as CodContabil,
      isnull(CFOP,'')             as CFOP,
      isnull(AliqICMS,0)          as AliqICMS,
      sum(isnull(BCICMS,0))       as BCICMS,
      sum(isnull(ICMS,0))         as ICMS,
      sum(isnull(ICMSIsento,0))   as ICMSIsento,
      sum(isnull(ICMSOutras,0))   as ICMSOutras,
      sum(isnull(ICMSObs,0))      as ICMSObs,
      max(isnull(AliqIPI,0))      as AliqIPI,
      sum(isnull(BCIPI,0))        as BCIPI,
      sum(isnull(IPI,0))          as IPI,
      sum(isnull(IPIIsento,0))    as IPIIsento,
      sum(isnull(IPIOutras,0))    as IPIOutras,
      sum(isnull(IPIObs,0))       as IPIObs,
      case when Observacoes = 'NOTA DE ENTRADA' then 'NOTA FISCAL DE ENTRADA' else Observacoes end as Observacoes,
      sum(isnull(BCICMS,0)+isnull(ICMSIsento,0)+isnull(ICMSOutras,0)+
          isnull(ICMSObs,0)+isnull(IPI,0)+isnull(IPIObs,0)-isnull(VlrContabil,0))
		    	          as DifICMS,
      sum(isnull(BCIPI,0)+isnull(IPIIsento,0)+isnull(IPIOutras,0)+
          isnull(IPIObs,0)+isnull(IPI,0)-isnull(VlrContabil,0))
		 	          as DifIPI
    into
      #Nota_Saida_Desagr_Final

    from
      #Nota_Saida_Desagr_Total

    group by
      Especie,
      Serie,
      Numero,
      NumeroInicial,
      NumeroFinal,
      Data,
      Dia,
      UF,
      isnull(CodContabil,''),
      isnull(CFOP,''),
      isnull(AliqICMS,0),
      Observacoes      

    select * 
    from 
      #Nota_Saida_Desagr_Final
    where
      isnull(CFOP,'')<>''        

    order by
      --Numero,
      NumeroInicial,
      UF,
      CodContabil,
      CFOP,
      AliqICMS,
      AliqIPI,
      Observacoes


  end


-------------------------------------------------------------------------------
else if @ic_parametro = 4  -- atualização no número da página do livro
-------------------------------------------------------------------------------
  begin
    
    begin tran

    update
      EgisAdmin.dbo.Empresa
    set
      qt_pagreg_saida_empresa = @qt_pagina
    where
      cd_empresa = @cd_empresa

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 6    -- lista o resumo p/ CFOP por Alíquota
-------------------------------------------------------------------------------
  begin
    
    --select * from nota_saida_item_registro

    select
      substring(r.cd_mascara_operacao,1,1) 			as 'Grupo',
      r.cd_mascara_operacao 					as 'CFOP',
      isnull(r.pc_icms_item_nota_saida,0)                       as 'AliqICMS',
      sum(round(isnull(r.vl_contabil_item_nota,0),2))	        as 'VlrContabil',
      sum(round(isnull(r.vl_base_icms_item_nota,0),2))	        as 'BCICMS',	
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	        as 'ICMS',
      sum(round(isnull(r.vl_icms_isento_item_nota,0),2))	as 'ICMSIsento',
      sum(round(isnull(r.vl_icms_outras_item_nota,0),2))	as 'ICMSOutras',
      sum(round(isnull(r.vl_icms_obs_item_nota,0),2))	        as 'ICMSObs',
      sum(round(isnull(r.vl_base_ipi_item_nota,0),2))	        as 'BCIPI',
      sum(round(isnull(r.vl_ipi_item_nota_saida,0),2))	        as 'IPI',
      sum(round(isnull(r.vl_ipi_isento_item_nota,0),2))	        as 'IPIIsento',
      sum(round(isnull(r.vl_ipi_outras_item_nota,0),2))	        as 'IPIOutras',
      sum(round(isnull(r.vl_ipi_obs_item_nota,0),2))	        as 'IPIObs'
    into
      #ResumoCFOPAliquota
    from
      Nota_Saida_Item_Registro r
      left outer join Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
--      isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 2  -- SAIDA
    group by
      r.cd_mascara_operacao,
      r.pc_icms_item_nota_saida
    order by
      r.cd_mascara_operacao,
      r.pc_icms_item_nota_saida

    select
      *,
      BCICMS+ICMSIsento+ICMSOutras+ICMSObs+IPIObs+IPI-VlrContabil as 'DifICMS',
      BCIPI+IPI+IPIIsento+IPIOutras+IPIObs-VlrContabil            as 'DifIPI'
    from
      #ResumoCFOPAliquota  
    order by
      CFOP, AliqICMS

    
  end


else  
  return
    
