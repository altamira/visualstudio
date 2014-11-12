
--sp_helptext vw_contabiliza_entradas      
      
CREATE VIEW vw_contabiliza_entradas      
------------------------------------------------------------------------------------      
--vw_contabiliza_entradas      
------------------------------------------------------------------------------------      
--GBS - Global Business Solution                                        2006      
------------------------------------------------------------------------------------      
--Stored Procedure      : Microsoft SQL Server 2000      
--Autor(es)             : Carlos Fernandes      
--Banco de Dados        : EGISSQL       
--Objetivo              : Contabilização das Notas Fiscais de Entrada      
--                        para a TMBEVO - Customização      
--Data                  : 29.04.2004      
--Atualização           : 18.12.2006 - Modificações conforme Cida - Carlos Fernandes   
--                      : 27.03.2007 - Ajuste Gerais - Carlos Fernandes   
------------------------------------------------------------------------------------      
as      
      
--select * from nota_entrada_contabil      
      
select      
  nec.cd_nota_entrada                                as Nota,      
  nec.cd_it_contab_nota_entrada                      as Item,      
  convert(datetime, nec.dt_contab_nota_entrada, 103) as Data,      
  replace(pd.cd_mascara_conta,'.','')                as Debito,      
  replace(pc.cd_mascara_conta,'.','')                as Credito,      
  case when isnull(nec.vl_contab_nota_entrada,0)>0       
  then      
     isnull(nec.vl_contab_nota_entrada,0)      
  else      
   case when isnull(nec.vl_ipi_nota_entrada,0)>0       
     then      
        isnull(nec.vl_ipi_nota_entrada,0)      
     else       
        case when isnull(nec.vl_icms_nota_entrada,0)>0      
        then      
          isnull(nec.vl_icms_nota_entrada,0)      
        else       
          case when isnull(nec.vl_pis_nota_entrada,0)>0      
          then      
            isnull(nec.vl_pis_nota_entrada,0)      
          else                      
            case when isnull(nec.vl_cofins_nota_entrada,0)>0       
            then      
              isnull(nec.vl_cofins_nota_entrada,0)      
            else 0 end      
          end      
        end      
     end      
  end                                        as Valor,      
  cast(nec.nm_historico_nota_entrada as char(6))+' NF '+cast(nec.cd_nota_entrada  as char(6) )+      
  ' '+cast(f.cd_cnpj_fornecedor      as char(8) )+      
  ' '+cast(f.nm_fantasia_fornecedor  as varchar(15)) as Historico            
from      
  nota_entrada_contabil nec  with (nolock)--, INDEX(IX_NOTA_ENTRADA_CONTABIL))      
  left outer join plano_conta pd on pd.cd_conta     = nec.cd_conta_debito       
  left outer join plano_conta pc on pc.cd_conta     = nec.cd_conta_credito       
  left outer join fornecedor f   on f.cd_fornecedor = nec.cd_fornecedor      

--   left outer join plano_conta pd on pd.cd_conta_reduzido = nec.cd_conta_debito       
--   left outer join plano_conta pc on pc.cd_conta_reduzido = nec.cd_conta_credito       
-- order by    
--    nec.dt_contab_nota_entrada,nec.cd_nota_entrada    
          
  
