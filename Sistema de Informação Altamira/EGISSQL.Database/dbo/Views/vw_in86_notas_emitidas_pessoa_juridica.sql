
create  VIEW vw_in86_notas_emitidas_pessoa_juridica

-- vw_in86_notas_emitidas_pessoa_juridica

---------------------------------------------------------------------------------
--GBS - Global Business Solution	                                           2004
--Stored Procedure	: Microsoft SQL Server                                   2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Selecionar as notsa de Serviço Emitidas por pessoa Juridica
--Data			        : 29/03/2004
----------------------------------------------------------------------------------

as


select  distinct

  snf.sg_serie_nota_fiscal    as 'SERIE',
  nsi.cd_nota_saida           as 'NUMDOC',
  ns.dt_nota_saida            as 'DATAEMISS',
  case when ns.cd_tipo_destinatario = 1 then
         'Cl' + cast(ns.cd_cliente as varchar(12))
       else
         case when ns.cd_tipo_destinatario = 2 then
           'Fo' + cast(ns.cd_cliente as varchar (12)) 
         else
           case when ns.cd_tipo_destinatario = 3 then
             'Ve' + cast(ns.cd_cliente as varchar(12))      
           end
         end
       end                 as 'CODPART',
  sum( nsi.vl_total_item )       as 'VLRTOTALSERV',     
  ((sum( nsi.vl_total_item ) * sum( nsi.pc_desconto_item ))/100)    as 'VLRTOTALDESC',
  sum( ns.pc_irrf_serv_empresa )          as 'ALIQIRRF',
  null    as 'BASEIRRF', 
  sum( ns.vl_irrf_nota_saida )            as 'VLRIRRF',
  case when isnull(ns.cd_status_nota,0 ) = 7 then 
         'S'
       else
         'N'
       end           as 'SITCANCDOC'
 
 
from 
  nota_saida_item nsi

  left outer join operacao_fiscal opf
    on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal

  left outer join   nota_saida ns
    on ns.cd_nota_saida = nsi.cd_nota_saida 

  left outer join  Serie_Nota_Fiscal snf
    on snf.cd_serie_nota_fiscal = ns.cd_serie_nota


where 
  opf.ic_servico_operacao = 'S' 


group by   snf.sg_serie_nota_fiscal,
           nsi.cd_nota_saida,
           ns.dt_nota_saida,
           ns.cd_tipo_destinatario,
           ns.cd_cliente,
           ns.cd_status_nota             

-- Teste de View

-- select * from vw_in86_notas_emitidas_pessoa_juridica
