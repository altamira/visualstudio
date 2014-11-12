
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Wellington Souza Fagundes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Exibir consulta de notas de entradas baixadas do controle
--Data             : 08/08/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_baixa_nota_entrada_ciap
@cd_mascara_operacao char(10),
@DataInicial datetime,
@DataFinal   datetime

as
   --opf:  Tabela Operação_Fiscal
   --nte:  Tabela Nota_Entrada
   --ntei: Tabela Nota_Entrada_Item
   --f:    Fornecedor
   --cia: Tabela ciap

   select
   
   opf.cd_operacao_fiscal        as 'cd_Operacao_Fiscal',
   opf.cd_mascara_operacao       as 'cd_mascara_operacao',
   opf.nm_operacao_fiscal        as 'nm_operacao_fiscal',
   
   nte.dt_nota_entrada           as 'dt_nota_entrada',
   nte.dt_receb_nota_entrada     as 'dt_receb_nota_entrada',
   nte.cd_nota_entrada           as 'cd_nota_entrada',
   nte.nm_especie_nota_entrada   as 'nm_especie_nota_entrada',
   nte.nm_serie_nota_entrada     as 'nm_serie_nota_entrada',

   ntei.cd_item_nota_entrada     as 'cd_item_nota_entrada',
   ntei.qt_item_nota_entrada     as 'qt_item_nota_entrada',
   ntei.vl_item_nota_entrada     as 'vl_item_nota_entrada',
   ntei.vl_bicms_nota_entrada    as 'vl_bicms_nota_entrada',
   ntei.pc_icms_nota_entrada     as 'pc_icms_nota_entrada',
   ntei.vl_icms_nota_entrada     as 'vl_icms_nota_entrada',

   cia.cd_ciap                   as 'cd_ciap',
   cia.dt_ciap                   as 'dt_ciap',
   cia.dt_baixa_ciap		 as 'dt_baixa_ciap' 

	

   from
   
   Operacao_fiscal opf
   left outer join Nota_entrada nte
   on opf.cd_operacao_fiscal = nte.cd_operacao_fiscal

   left outer join ciap cia
   on opf.cd_operacao_fiscal = cia.cd_operacao_fiscal
   
   left outer join nota_entrada_item ntei
   on nte.cd_nota_entrada = ntei.cd_nota_entrada

   left outer join fornecedor f
   on f.cd_Fornecedor = nte.cd_fornecedor

   where
   
   cia.dt_baixa_ciap is not null and
   
   --Período selecionado pelo usuário
   nte.dt_nota_entrada between @DataInicial and @DataFinal and
   
   --Consulta do CFOP
   isnull(opf.cd_mascara_operacao,' ') =
   case when isnull(@cd_mascara_operacao,'0') = '0' then
     isnull(opf.cd_mascara_operacao,'0')
   else
      @cd_mascara_operacao
   end

   
   
      

