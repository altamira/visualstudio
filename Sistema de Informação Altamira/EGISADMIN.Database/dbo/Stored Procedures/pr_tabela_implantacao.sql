

--pr_tabela_implantacao
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Carlos Cardoso Fernandes
--Consulta de Menu utizados nos Módulos
--Data          : 29.12.2002
--Atualizado    : 
--              : 
---------------------------------------------------------------------------------------

CREATE procedure pr_tabela_implantacao
as

select 'N' as ic_selecao,
       cd_tabela,
       nm_tabela,
       ic_fixa_tabela,
       ic_implantacao_tabela,
       ic_supervisor_altera
from
  tabela
WHERE
  isnull(ic_implantacao_tabela,'N') = 'S' AND
  isnull(ic_inativa_tabela, 'N') = 'N' AND
  isnull(ic_sap_admin, 'N') = 'N'

order by
       cd_prioridade_tabela desc, dt_criacao_tabela, nm_tabela


