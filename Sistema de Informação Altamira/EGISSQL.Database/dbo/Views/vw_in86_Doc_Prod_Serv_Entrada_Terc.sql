
create  VIEW vw_in86_Doc_Prod_Serv_Entrada_Terc
-- vw_in86_Doc_Prod_Serv_Entrada_Terc
---------------------------------------------------------------------------
--GBS - Global Business Solution                                       2004
--Stored Procedure	: Microsoft SQL Server                             2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Produtos/Serviços (Entradas) - Enviadas por Terceiros
--                    4.3.3
--Data			        : 26/03/2004
---------------------------------------------------------------------------
as

select
  isnull(snf.cd_modelo_serie_nota,'01')                                                     as 'MODDOC',    -- 1)
  case when snf.sg_serie_nota_fiscal = '1.'
         then '1'
       else IsNull(snf.sg_serie_nota_fiscal,'1')
       end 
                                                                                            as 'SERIE',     -- 2)
  ne.cd_nota_entrada                                                                        as 'NUNDOC',    -- 3)  
  ne.dt_nota_entrada                                                                        as 'DTEMISSAO', -- 4)
  case when ne.cd_tipo_destinatario = 1 then
        'Cl' + cast(ne.cd_fornecedor as varchar(4))
       else
         case when ne.cd_tipo_destinatario = 2 then       
                'Fo' + cast(ne.cd_fornecedor as varchar(4))   
              else
                case when ne.cd_tipo_destinatario = 3 then
                      'Ve' + cast(ne.cd_fornecedor as varchar(4))
                     else
                       null      
                end
         end      
  end                                                                                       as 'CODPART',            -- 5)
  ne.dt_receb_nota_entrada                                                                  as 'DTENTRADA',          -- 6)
  isnull(ne.vl_prod_nota_entrada, vl_servico_nota_entrada)                                  as 'VLTOTALPROD',        -- 7)
  null                                                                                      as 'VLTDESC',            -- 8)
  ne.vl_frete_nota_entrada                                                                  as 'VLFRETE',            -- 9)
  ne.vl_seguro_nota_entrada                                                                 as 'VLSEGURO',           -- 10)
  ne.vl_despac_nota_entrada                                                                 as 'VLOUTRASDESP',       -- 11)
  ne.vl_ipi_nota_entrada                                                                    as 'VLTOTALIPI',         -- 12)
  ne.vl_sticm_nota_entrada                                                                  as 'VLTOTALICMS',        -- 13) 
  ne.vl_total_nota_entrada                                                                  as 'VLTOTALNF',          -- 14)
  null                                                                                      as 'INSCRICAO_ESTADUAL', -- 15)
  case when(ne.cd_condicao_pagamento <> 1) then
         '2'
       else
         '1'
       end                                                                                  as 'TIPO_FATURA', -- 16)
  ne.ds_obs_compl_nota_entrada                                                              as 'OBSERVACAO'   -- 17)
from
  nota_entrada ne

  left outer join serie_nota_fiscal snf
    on ( snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal )

where
  
  isnull( snf.ic_tipo_emitente_nota, 'S' ) <> 'P' 

