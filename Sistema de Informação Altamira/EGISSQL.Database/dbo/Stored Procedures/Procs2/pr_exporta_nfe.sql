
-------------------------------------------------------------------------------
--sp_helptext pr_exporta_nfe
-------------------------------------------------------------------------------
--pr_exporta_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 13.11.2008
--Alteração        : 29.11.2008
--
-- 04.04.2009 - Ajuste Diversos - Pessoa Física - Carlos Fernanes
--
------------------------------------------------------------------------------
create procedure pr_exporta_nfe
@ic_parametro       int = 0,
@cd_nota_saida      int = 0,
@cd_item_nota_saida int = 0,
@dt_inicial         datetime,
@dt_final           datetime

as

--select * from documento_arquivo_magnetico

declare @nm_local_arquivo       varchar(500)
--declare @cd_documento_magnetico int

select
  @nm_local_arquivo = isnull(nm_local_arquivo,'')
from
  documento_arquivo_magnetico
where
  cd_documento_magnetico = ( select top 1 cd_documento_magnetico from versao_nfe )

--select @nm_local_arquivo

if @ic_parametro = 0 -- Seleciona Notas que serão geradas
  begin
    select
      ns.cd_nota_saida
    from
      nota_saida ns with (nolock) 
    where
      ns.cd_nota_saida = case when @cd_nota_saida = 0 then 
                           ns.cd_nota_saida 
                         else 
                           @cd_nota_saida 
                         end and/*
      isnull(ns.ic_nfe_nota_saida,'N') = 'N' and*/
      ns.dt_nota_saida between @dt_inicial and @dt_final
    order by
      ns.cd_nota_saida
  end
else if @ic_parametro = 1
  begin -- Cabeçalho da nota (1 Ocorrência)
    select
      cd_item_nota_saida
    from
      nota_saida_item with (nolock) 
    where
      cd_nota_saida = @cd_nota_saida 
    order by
      cd_item_nota_saida
  end 
else if @ic_parametro = 2
  begin -- Cabeçalho da nota (1 Ocorrência)
    select
      cast('NOTAFISCAL' + '|' + 
      cast(isnull((select 
                     count(*) 
                   from  
                     nota_saida with(nolock) 
                   where
                     cd_nota_saida = case when @cd_nota_saida = 0 then 
                                       cd_nota_saida 
                                     else 
                                       @cd_nota_saida 
                                     end and dt_nota_saida between @dt_inicial
                                         and @dt_final),'0') as varchar(10)) as varchar(8000)) as CONC
      
  end 
else if @ic_parametro = 3
  begin  -- Sessão A (1 Ocorrência)
    select 
      cast('A|' +
      cast((select top 1 sg_versao_nfe from versao_nfe) as varchar(4)) + '|' +
      isnull(ChaveAcesso,'') as varchar(8000)) as CONC
    from 
      vw_nfe_chave_acesso vwca with(nolock)
    where 
      cd_nota_saida = case when @cd_nota_saida = 0 then 
                        vwca.cd_nota_saida
                      else
                        @cd_nota_saida 
                      end
    order by
      vwca.cd_nota_saida
  end 
else if @ic_parametro = 4
  begin  -- Sessão B (1 Ocorrência)
    select
      cast( 'B|' + 
            isnull(cUF,'') + '|' +
            isnull(cNF,'') + '|' +
            isnull(natOp,'') + '|' +
            isnull(indPag,'') + '|' +
            isnull(mod,'') + '|' +
            isnull(serie,'') + '|' +
            isnull(nNF,'') + '|' +
            isnull(dEmi,'') + '|' +
            isnull(dSaiEnt,'') + '|' +
            isnull(tpNF,'') + '|' +
            isnull(cMunFG,'') + '|' +
            isnull(NFref,'') + '|' +      
            isnull(tpImp,'') + '|' +     
            isnull(tpEmis,'') + '|' +
            isnull(tpAmb,'')    + '|' +  
            isnull(finNFE,'') + '|' +        
            isnull(procemi,'') + '|' +       
            isnull(verProc,'')    
            as varchar(8000)) as CONC
    from 
      vw_nfe_identificacao_nota_fiscal vwinf with(nolock)
    where 
      vwinf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwinf.cd_nota_saida
  end
else if @ic_parametro = 5 
  begin -- Sessão C (1 Ocorrência)
    select 

----------------------------------------------------- Sessão C
      cast('C|' +
            isnull(xNome,'') + '|' +
            isnull(xFant,'') + '|' +
            isnull(IE,'')    + '|' +
            isnull(IEST,'')  + '|' +
            isnull(IM,'')    + '|' +
            isnull(CNAE,'')
          as varchar(8000)) as CONC
    into
      #SessaoC1
    from 
      vw_nfe_emitente_nota_fiscal vwenf with(nolock)
    where 
      vwenf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwenf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwenf.cd_nota_saida
----------------------------------------------------- FIM C

----------------------------------------------------- Sessão C02
    select 
      cast('C02|' +
            isnull(CNPJ,'') as varchar(8000)) as CONC
    into 
      #SessaoC2
    from 
      vw_nfe_emitente_nota_fiscal vwenf with(nolock)
    where 
      vwenf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwenf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwenf.cd_nota_saida 
----------------------------------------------------- FIM C02

----------------------------------------------------- Sessão C05
    select 
      cast('C05|' +
            isnull(xLgr,'') + '|' +
            isnull(nro,'') + '|' +
            isnull(xCpl,'') + '|' +
            isnull(xBairro,'') + '|' +
            isnull(cMun,'') + '|' +
            isnull(xMun,'') + '|' +
            isnull(UF,'') + '|' +
            isnull(CEP,'') + '|' +
            isnull(cPais,'1058') + '|' +
            isnull(xPais,'') + '|' +
            isnull(fone,'') as varchar(8000)) as CONC
    into 
      #SessaoC3
    from 
      vw_nfe_emitente_nota_fiscal vwenf with(nolock)
    where 
      vwenf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwenf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwenf.cd_nota_saida  
----------------------------------------------------- FIM C05

    create table #SessaoC (Conc varchar(8000))
 
    declare @z int 
    set @z = 1

    declare @sql2 varchar(8000) 
    set @sql2 = ''
 
    while @z <= 3
      begin 
        set @sql2 = 'insert into #SessaoC select * from #SessaoC' + rtrim(ltrim(cast(@z as int))) 
        exec (@sql2)
        set @z = @z + 1 
      end

   select * from #SessaoC

   drop table #SessaoC

-------------------------------------------------------------
  end
else if @ic_parametro = 6
  begin
    select
      cast('D' as varchar(8000)) as CONC    
  end
else if @ic_parametro = 7
  begin -- Sessão E (1 Ocorrência)

----------------------------------------------------- Sessão E
    select 
      cast('E|' +
            isnull(xNome,'') + '|' +
            isnull(IE,'') + '|' +
            isnull(ISUF,'') as varchar(8000)) as CONC
    into
      #SessaoE1
    from 
      vw_nfe_destintario_nota_fiscal_texto vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida
----------------------------------------------------- Fim E

----------------------------------------------------- Sessão E02
    select 
      case when vwdnf.cd_tipo_pessoa = 1 then
      cast('E02|' +
            isnull(CNPJ,'') as varchar(8000)) 
      else
      --Pessoa Física
      cast('E03|' +
            isnull(CPF,'') as varchar(8000)) 

      end                                             as CONC
    into
      #SessaoE2
    from 
      vw_nfe_destintario_nota_fiscal_texto vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida
----------------------------------------------------- Fim E02

----------------------------------------------------- Sessão E05
    select 
      cast('E05|' +
            isnull(xLgr,'') + '|' +
            isnull(nro,'') + '|' +
            isnull(xCpl,'') + '|' +
            isnull(xBairro,'') + '|' +
            isnull(cMun,'') + '|' +
            isnull(xMun,'') + '|' +
            isnull(UF,'') + '|' +
            isnull(CEP,'') + '|' +
            isnull(cPais,'') + '|' +
            isnull(xPais,'') + '|' +
            isnull(fone,'') as varchar(8000)) as CONC
    into
      #SessaoE3
    from 
      vw_nfe_destintario_nota_fiscal_texto vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida 
----------------------------------------------------- Fim E05

    create table #SessaoE (Conc varchar(8000))
 
    declare @x int 
    set @x = 1

    declare @sql3 varchar(8000) 
    set @sql3 = ''
 
    while @x <= 3
      begin 
        set @sql3 = 'insert into #SessaoE select * from #SessaoE' + rtrim(ltrim(cast(@x as int))) 
        exec (@sql3)
        set @x = @x + 1 
      end

   select * from #SessaoE

   drop table #SessaoE

-------------------------------------------------------------
  end
else if @ic_parametro = 8 --Sessão F
  begin
    select
      cast('' as varchar(8000)) as CONC    
  end
else if @ic_parametro = 9
  begin

    if not (select top 1 
              case when nm_endereco_entrega is null or ltrim(rtrim(nm_endereco_entrega)) = ltrim(rtrim(nm_endereco_nota_saida)) then
                'X'  
              else
                'O'
              end as tipo 
             from nota_saida with (nolock)
             where 
               cd_nota_saida = @cd_nota_saida 
               ) <> 'X'
      begin
        select
          cast('' as varchar(8000)) as CONC 
      end
    else
      begin
        select
          top 1
          cast('G|' +
            isnull(CNPJ,'') + '|' +
            isnull(xLgr,'') + '|' +
            isnull(nro,'') + '|' +
            isnull(xCpl,'') + '|' +
            isnull(xBairro,'') + '|' +
            isnull(cMun,'') + '|' +
            isnull(xMun,'') + '|' +
            isnull(UF,'') as varchar(8000)) as CONC
        from 
          vw_nfe_entrega_nota_fiscal vwpsnf with(nolock)
        where 
          vwpsnf.cd_nota_saida = case when @cd_nota_saida = 0      then 
                                   vwpsnf.cd_nota_saida
                                 else
                                   @cd_nota_saida 
                                 end 
      end   
  end
else if @ic_parametro = 10
  begin -- Sessão H, I, M, N, N02, O, O07, O010, Q, Q02, R, R02, S, S02, T, T02 (N Registros) --

----------------------------------------------------- Sessão H
    select
      identity(smallint,1,1) as Contador, --Conta todos os itens da nota
      nsi.cd_nota_saida,
      nsi.cd_item_nota_saida
    into
      #nota
    from
      nota_saida_item nsi
    where
      cd_nota_saida = @cd_nota_saida
    order by
      cd_nota_saida,
      cd_item_nota_saida

    select 
      cast( 'H|' +
      cast((select 
              Contador -- Retorna o valor do contador no item da nota 
            from 
              #nota 
            where 
              cd_nota_saida      = @cd_nota_saida and 
              cd_item_nota_saida = @cd_item_nota_saida) as varchar(100)) as varchar(8000)) as Conc
    into
      #produto1

    drop table #nota
-------------------------------------------------------- Fim H

----------------------------------------------------- Sessão I
    select 
      cast('I|' +
            isnull(cProd,'') + '|' + --
            isnull(cEan,'') + '|' + --
            isnull(xProd,'') + '|' + 
            isnull(NCM,'') + '|' + 
            isnull(EXTIPI,'') + '|' + 
            isnull(genero,'') + '|' + 
            isnull(CFOP,'') + '|' + 
            isnull(uCom,'') + '|' + 
            isnull(qCom,'') + '|' + 
            isnull(vUnCom,'') + '|' + 
            isnull(vProd,'') + '|' + 
            isnull(cEanTrib,'') + '|' + 
            isnull(uTrib,'') + '|' + 
            isnull(qTrib,'') + '|' + 
            isnull(vUnTrib,'') + '|' + 
            isnull(vFrete,'') + '|' + 
            isnull(vSeg,'') + '|' + 
            isnull(vDesc,'') as varchar(8000)) as CONC
    into 
      #produto2
    from 
      vw_nfe_produto_servico_nota_fiscal vwpsnf with(nolock)
    where 
      vwpsnf.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwpsnf.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwpsnf.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwpsnf.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwpsnf.cd_nota_saida  
----------------------------------------------------- Fim I

----------------------------------------------------- Sessão M
    select 
      cast('M' as varchar(8000)) as CONC
    into 
      #produto3
    from 
      vw_nfe_produto_servico_nota_fiscal vwpsnf with(nolock)
    where 
      vwpsnf.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwpsnf.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwpsnf.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwpsnf.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwpsnf.cd_nota_saida  
----------------------------------------------------- Fim M

----------------------------------------------------- Sessão N
    select 
      cast('N' as varchar(8000)) as CONC
    into 
      #produto4
    from 
      vw_nfe_produto_servico_nota_fiscal vwpsnf with(nolock)
    where 
      vwpsnf.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwpsnf.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwpsnf.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwpsnf.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwpsnf.cd_nota_saida  
----------------------------------------------------- Fim N

----------------------------------------------------- Sessão N02
    --select * from tributacao_icms

    select 
      top 1
      --cast('N02|' +
      case when icms='N05' then
        cast(icms+'|'+
            isnull(orig,'') + '|' + 
            isnull(CST,'') + '|' + 
            isnull('0','0') + '|' + 
            isnull(pMVAST,'0') + '|' +
            isnull(pRedBCST,'0') + '|' +
            isnull(vBCST,'') + '|' + 
            isnull(pICMSST,'') + '|' +
            isnull(vICMSST,'') as varchar(8000))
      else         
      cast(icms+'|'+
            isnull(orig,'') + '|' + 
            isnull(CST,'') + '|' + 
            isnull('0','0') + '|' + 
            isnull(vBC,'') + '|' + 
            isnull(pICMS,'') + '|' +
            isnull(vICMS,'') as varchar(8000)) 
      end                                         as CONC
    into 
      #produto5
    from 
      vw_nfe_icms_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  
----------------------------------------------------- Fim N02

----------------------------------------------------- Sessão O
  declare @flag1 int
  set @flag1 = 0 

  if isnull((select 
               vl_ipi 
             from 
               nota_saida_item with (nolock) 
             where 
               cd_nota_saida      = @cd_nota_saida and 
               cd_item_nota_saida = @cd_item_nota_saida),0.00) > 0.00
    begin
      select 
        cast('O|'           +
        isnull(cIEnq,'')    + '|' + 
        isnull(CNPJProd,'') + '|' + 
        isnull(cSelo,'')    + '|' + 
        isnull(qSelo,'')    + '|' + 
        isnull(cEnq,'')     as varchar(8000)) as CONC
      into 
        #produto98
      from 
        vw_nfe_ipi_nota_fiscal vwinfe with(nolock)
      where 
        vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                      vwinfe.cd_nota_saida
                                    else
                                      @cd_nota_saida 
                                    end                 and

        vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                      vwinfe.cd_item_nota_saida
                                    else
                                      @cd_item_nota_saida 
                                    end
      order by
        vwinfe.cd_nota_saida 

----------------------------------------------------- Sessão O07

    --Modificar com todos os tipos de tributação do IPI

    select 
      cast('O07|' +
            isnull(CST,'00') + '|' + 
            isnull(vIPI,'') as varchar(8000)) as CONC
    into 
      #produto99
    from 
      vw_nfe_ipi_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  
----------------------------------------------------- Fim O

----------------------------------------------------- Sessão O10
    select 
      cast('O10|' +
            isnull(vBC,'') + '|' + 
            isnull(pIPI,'') as varchar(8000)) as CONC
    into 
      #produto100
    from 
      vw_nfe_ipi_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  
----------------------------------------------------- Fim O10

      set @flag1 = 1
  end
    else
      begin
        select 
          cast('' as varchar(8000)) as CONC
        into 
          #produto101
        set @flag1 = 2
      end 

  create table #produto6 (Conc varchar(8000))

  if @flag1 = 1 
    begin
 
       declare @p int 
       set @p = 98

       declare @sql20 varchar(8000) 
       set @sql20 = ''
 
       while @p <= 100
         begin 
           set @sql20 = 'insert into #produto6 select * from #produto' + rtrim(ltrim(cast(@p as int))) 
           exec (@sql20)
           set @p = @p + 1 
         end
 
    end
  else
    begin
      insert into #produto6 select * from #produto101
    end  
----------------------------------------------------- Fim O

----------------------------------------------------- Sessão P
  declare @flag2 int
  set @flag2 = 0
  if isnull((select top 1 
               vl_ii 
             from 
               nota_saida_item with (nolock) 
             where 
               cd_nota_saida = @cd_nota_saida and 
               cd_item_nota_saida = @cd_item_nota_saida),0.00) > 0.00
    begin
      select 
        cast('P|' +  
        isnull(vBC,'') + '|' + 
        isnull(vDespAdu,'') + '|' + 
        isnull(vl_ii,'') + '|' +
        isnull(vl_iof,'') as varchar(8000)) as CONC
      into 
        #produto102
      from 
        vw_nfe_imposto_importacao_nota_fiscal vwinfe with(nolock)
      where 
        vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                      vwinfe.cd_nota_saida
                                    else
                                      @cd_nota_saida 
                                    end and

        vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                      vwinfe.cd_item_nota_saida
                                    else
                                      @cd_item_nota_saida 
                                    end
      order by
        vwinfe.cd_nota_saida 
    set @flag2 = 1 
  end
else
  begin
    select 
      cast('' as varchar) as Conc
    into
      #produto103 
    set @flag2 = 2 
  end

  create table #produto7 (Conc varchar(8000))
  
  if @flag2 = 1 
    begin 
      insert into #produto7 select * from #produto102
    end
  else
    begin
      insert into #produto7 select * from #produto103
    end
----------------------------------------------------- Fim P

  --Complementar com os tipos de tributação

  declare @flag123 int
  set @flag123 = 0

  if isnull((select vl_Pis from nota_saida_item where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida),0.00) = 0.00
    begin 
      select
        cast('Q04|07' as varchar) as CONC
      into
        #produto300
      insert into #produto300 select cast('Q' as varchar) as CONC
      set @flag123 = 1
    end
  else
    begin
----------------------------------------------------- Sessão Q02

--exec pr_exporta_nfe 10,86732,1,0,0
/*
      select
        cast('Q04|02' as varchar) as CONC
      into #produto301
*/
----------------------------------------------------- Sessão Q
      
      select 
        cast('Q02|' +
              isnull('02','') + '|' + 
              isnull(vBC,'') + '|' + 
              isnull(pPIS,'') + '|' + 
              isnull(vPIS,'') as varchar(8000)) as CONC
      into #produto301 
      from 
        vw_nfe_pis_nota_fiscal vwinfe with(nolock)
      where 
        vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                      vwinfe.cd_nota_saida
                                    else
                                      @cd_nota_saida 
                                    end and

        vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                      vwinfe.cd_item_nota_saida
                                    else
                                      @cd_item_nota_saida 
                                    end
      order by
        vwinfe.cd_nota_saida

      insert into #produto301
      select 
        cast('Q' as varchar(8000)) as CONC 

      

----------------------------------------------------- Fim Q
 
      set @flag123 = 2
    end 
  create table #produto8 (Conc varchar(8000))
  if @flag123 = 1
    begin
      insert into #produto8 select * from #produto300
    end
  else
    begin
      insert into #produto8 select * from #produto301
    end
----------------------------------------------------- Fim Q02

----------------------------------------------------- Sessão R
/*  select 
      cast('R' +
            isnull(vPIS,'')  as varchar(8000)) as CONC
    into 
      #produto12
    from 
      vw_nfe_pis_st_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  
----------------------------------------------------- Fim R

----------------------------------------------------- Sessão R02
    select 
      cast('R02' +
            isnull(vBC,'') + '|' + 
            isnull(pPIS,'')  as varchar(8000)) as CONC
    into 
      #produto13 
    from 
      vw_nfe_pis_st_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  */ 
----------------------------------------------------- Fim R02

----------------------------------------------------- Sessão S
/*
    select 
      cast('S' as varchar(8000)) as CONC
    into 
      #produto10
*/
----------------------------------------------------- Fim S

----------------------------------------------------- Sessão S02
 
  --complementar com os tipos de tributação

  declare @flag10 int
  set @flag10 = 0
  if isnull((select vl_cofins from nota_saida_item where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida),0.00) = 0.00
    begin

      select
        cast('S04|07' as varchar) as CONC
      into
        #produto200

      insert into #produto200 select cast('S' as varchar) as CONC 

      set @flag10 = 1
    end
  else
    begin
/*      
      select
        cast('S04|02' as varchar) as CONC
      into #produto201 
*/
     
      select 
        cast('S02|' +
              isnull('02','') + '|' + 
              isnull(vBC,'') + '|' + 
              isnull(pCOFINS,'')  + '|' +   
              isnull(vCOFINS,'') as varchar(8000)) as CONC into #produto201 
      from 
        vw_nfe_cofins_nota_fiscal vwinfe with(nolock)
      where 
        vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                      vwinfe.cd_nota_saida
                                    else
                                      @cd_nota_saida 
                                    end and

        vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                      vwinfe.cd_item_nota_saida
                                    else
                                      @cd_item_nota_saida 
                                    end
      order by
        vwinfe.cd_nota_saida

      insert into #Produto201 select cast('S' as varchar) as CONC
    
      set @flag10 = 2 
    end 

  create table #produto9 (Conc varchar(8000))

  if @flag10 = 1
    begin
      insert into #produto9 select * from #produto200
    end
  else
    begin
      insert into #produto9 select * from #produto201
    end
----------------------------------------------------- Fim S02

----------------------------------------------------- Sessão T
/*    select 
      cast('T|' +
            isnull(vCOFINS,'') as varchar(8000)) as CONC
    into 
      #produto15
    from 
      vw_nfe_cofins_st_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida  
----------------------------------------------------- Fim T

----------------------------------------------------- Sessão T02
    select 
      cast('T02|' +
            isnull(vBC,'') + '|' + 
            isnull(pCOFINS,'') as varchar(8000)) as CONC
    into 
      #produto16
    from 
      vw_nfe_cofins_st_nota_fiscal vwinfe with(nolock)
    where 
      vwinfe.cd_nota_saida      = case when @cd_nota_saida = 0      then 
                                    vwinfe.cd_nota_saida
                                  else
                                    @cd_nota_saida 
                                  end and

      vwinfe.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                                    vwinfe.cd_item_nota_saida
                                  else
                                    @cd_item_nota_saida 
                                  end
    order by
      vwinfe.cd_nota_saida */
----------------------------------------------------- Fim T02

    create table #produto (Conc varchar(8000))
 
    declare @i int 
    set @i = 1

    declare @sql varchar(8000) 
    set @sql = ''
 
    while @i <= 9
      begin 
        set @sql = 'insert into #produto select * from #produto' + rtrim(ltrim(cast(@i as int))) 
        exec (@sql)
        set @i = @i + 1 
      end

   select * from #produto

   drop table #produto

  end
else if @ic_parametro = 11
  begin -- Sessão W (1 Ocorrência)

----------------------------------------------------- Sessão W
    select 
      cast('W' as varchar(8000)) as CONC
    into
      #SessaoW1
----------------------------------------------------- Fim W

----------------------------------------------------- Sessão W02
    select 
      cast('W02|' +
            isnull(vBC,'') + '|' +
            isnull(vICMS,'') + '|' +
            isnull(vBCST,'') + '|' +
            isnull(vST,'') + '|' +
            isnull(vProd,'') + '|' +
            isnull(vFrete,'') + '|' +
            isnull(vSeg,'') + '|' +
            isnull(vDesc,'') + '|' +
            isnull(vII,'') + '|' +
            isnull(vIPI,'') + '|' +
            isnull(vPIS,'') + '|' +
            isnull(vCOFINS,'') + '|' +
            isnull(vOutro,'') + '|' +
            isnull(vNF,'') as varchar(8000)) as CONC
    into
      #SessaoW2
    from 
      vw_nfe_totais_nota_fiscal_texto vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida  
----------------------------------------------------- Fim W02

----------------------------------------------------- Sessão W17
    select 
      cast('W17|' +
            isnull(vServ,'') + '|' +
            isnull(vBCISS,'') + '|' +
            isnull(vISS,'') + '|' +
            isnull(vPIS,'') + '|' +
            isnull(vCOFINS,'') as varchar(8000)) as CONC
    into
      #SessaoW3
    from 
      vw_nfe_totais_nota_fiscal_texto vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida  
----------------------------------------------------- Fim W17


    create table #SessaoW (Conc varchar(8000))
 
    declare @u int 
    set @u = 1

    declare @sql4 varchar(8000) 
    set @sql4 = ''
 
    while @u <= 3
      begin 
        set @sql4 = 'insert into #SessaoW select * from #SessaoW' + rtrim(ltrim(cast(@u as int))) 
        exec (@sql4)
        set @u = @u + 1 
      end

   select * from #SessaoW

   drop table #SessaoW

  end

else if @ic_parametro = 13
  begin -- Sessão Y (N Ocorrência), Parcelas da Nota de Saída

    select
      top 1
      cast('Y'+
      '|'+isnull(nfat,'')+
      '|'+isnull(vOrig,'')+
      '|'+isnull(vDesc,'')+
      '|'+isnull(vLiq,'')
                   as varchar(8000))               as CONC
    from
      vw_nfe_parcela_nota_fiscal 
    where
      vl_total > 0 and
      cd_nota_saida = case when @cd_nota_saida = 0 then 
                    cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      cd_nota_saida 
end

--Parcelas

else if @ic_parametro = 14
begin
    select
      cast('Y07'+
      '|'+isnull(ndup,'')+
      '|'+isnull(dVenc,'')+
      '|'+isnull(vDup,'')
                   as varchar(8000))               as CONC
    from
      vw_nfe_parcela_nota_fiscal 
    where
      vl_total > 0 and
      cd_nota_saida = case when @cd_nota_saida = 0 then 
                    cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      cd_nota_saida 


  end

else if @ic_parametro = 12
  begin -- Sessão X (1 Ocorrência)

----------------------------------------------------- Sessão X
    select 
      cast('X|' +
            isnull(modFrete,'') as varchar(8000)) as CONC
    into
      #SessaoX1
    from 
      vw_nfe_transporte_nota_fiscal vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida 
----------------------------------------------------- Fim X

----------------------------------------------------- Sessão X03
    select 
      cast('X03|' +
            isnull(xNome,'') + '|' +
            isnull(IE,'') + '|' +
            isnull(xEnder,'') + '|' +
            isnull(UF,'') + '|' +
            isnull(xMun,'') as varchar(8000)) as CONC
    into
      #SessaoX2
    from 
      vw_nfe_transporte_nota_fiscal vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida   
----------------------------------------------------- Fim X03

----------------------------------------------------- Sessão X04
    select 
      cast('X04|' +
            isnull(CNPJ,'') as varchar(8000)) as CONC
    into
      #SessaoX3
    from 
      vw_nfe_transporte_nota_fiscal vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida  
----------------------------------------------------- Fim X04
/*
----------------------------------------------------- Sessão X11
if isnull((select vICMSRet from nota_saida where cd_nota_saida = @cd_nota_saida),0.00) = 0.00
  begin
    select 
      cast('X11|' +
            isnull(vServ,'') + '|' +
            isnull(vBCRet,'') + '|' +
            isnull(pICMSRet,'') + '|' +
            isnull(vICMSRet,'') + '|' +
            isnull(CFOP,'') + '|' +
            isnull(cMunFG,'') as varchar(8000)) as CONC
    into                                                          NÃO EXISTE CAMPOS NO EGIS 
      #SessaoX4
    from 
      vw_nfe_transporte_nota_fiscal vwdnf with(nolock)
    where 
      vwdnf.cd_nota_saida = case when @cd_nota_saida = 0 then 
                    vwdnf.cd_nota_saida
                  else
                    @cd_nota_saida 
                  end
    order by
      vwdnf.cd_nota_saida  
  end
----------------------------------------------------- Fim X11
*/

    create table #SessaoX (Conc varchar(8000))
 
    declare @q int 
    set @q = 1

    declare @sql5 varchar(8000) 
    set @sql5 = ''
 
    while @q <= 3
      begin 
        set @sql5 = 'insert into #SessaoX select * from #SessaoX' + rtrim(ltrim(cast(@q as int))) 
        exec (@sql5)
        set @q = @q + 1 
      end

   select * from #SessaoX

   drop table #SessaoX

  end
