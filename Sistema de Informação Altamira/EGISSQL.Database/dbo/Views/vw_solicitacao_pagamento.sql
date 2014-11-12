
--sp_helptext vw_solicitacao_pagamento

CREATE VIEW vw_solicitacao_pagamento
------------------------------------------------------------------------------------
--vw_solicitacao_pagamento
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados da Solicitação de Pagamento
--Data                  : 17.11.2007
--Atualização           : 24.11.2007 - Complemento - Carlos Fernandes
-- 24.01.2008 - Ajustes Gerais para Aprovação Via Internet - Carlos Fernandes
-- 09.02.2008 - Data no format dd/mm/aaaa - Carlos Fernandes
------------------------------------------------------------------------------------
as


--select * from solicitacao_pagamento

Select
      sp.*,
      isnull(f.cd_chapa_funcionario,f.cd_funcionario)                     as cd_chapa_funcionario,  
      isnull(f.nm_funcionario,'')                                         as nm_funcionario,  
      isnull(d.nm_departamento,'')                                        as nm_departamento,  
      isnull(cc.nm_centro_custo,'')                                       as nm_centro_custo,  
      isnull(sp.nm_favorecido_solicitacao,'')                             as nm_favorecido,
      isnull(fa.nm_finalidade_pagamento,'')                               as nm_finalidade_pagamento,  
      u.nm_usuario                                                        as nm_usuario_liberacao,  
      cast((GetDate() - dt_vencimento) as int)                            as Dias,  
      isnull(av.nm_assunto_viagem,'')                                     as nm_assunto_viagem,  
      isnull(m.sg_moeda,'')                                               as sg_moeda,  
      isnull(sp.vl_pagamento,0)                                           as valor_pagamento,
      rtrim(ltrim( cast(isnull(sp.ds_solicitacao,'') as varchar(8000))))  as ds_pagamento 

from
    Solicitacao_Pagamento  sp                 with (nolock) 
    left Join Funcionario    F                with (nolock) on (sp.cd_funcionario = f.cd_funcionario) 
    left join Departamento D                  with (nolock) on (d.cd_departamento = sp.cd_departamento)
    left join Finalidade_Pagamento Fa         with (nolock) on (sp.cd_finalidade_pagamento = fa.cd_finalidade_pagamento) 
    left join EgisAdmin.dbo.Usuario U         with (nolock) on (u.cd_usuario        = sp.cd_usuario_liberacao) 
    left join Solicitacao_pagamento_baixa sab with (nolock) on (sab.cd_solicitacao  = sp.cd_solicitacao)
    left join Moeda m                         with (nolock) on m.cd_moeda           = sp.cd_moeda
    left join Centro_Custo cc                 with (nolock) on cc.cd_centro_custo   = sp.cd_centro_custo
    left join Assunto_Viagem av               with (nolock) on av.cd_assunto_viagem = sp.cd_assunto_viagem

