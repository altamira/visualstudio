
--pr_percentual_comissao
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes 
--Busca o Percentual de comissão
--Data          : 01.09.2000
--Atualizado   : 
--------------------------------------------------------------------------------------
CREATE procedure pr_percentual_comissao
@qt_percentual_desconto float
as

select 
     pc_comissao_desc_comissao
from
    Desconto_Comissao
Where
   ( @qt_percentual_desconto between pc_ini_desconto_comissao and pc_fim_desconto_comissao )


