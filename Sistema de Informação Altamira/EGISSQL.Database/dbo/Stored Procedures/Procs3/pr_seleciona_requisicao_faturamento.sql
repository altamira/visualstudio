create procedure dbo.pr_seleciona_requisicao_faturamento
-----------------------------------------------------------------------------------------
--pr_seleciona_requisicao_faturamento
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution   LTDA 	                                     2004
-----------------------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Fabio Cesar
--Banco de Dados       : EGISSQL
--Objetivo             : Disponibilizar nesta consulta todos os dados necessários
--Data                 : 05/02/2003
--Atualizado           : 19.03.2003 - Fabio - Apresentar o número da nota fiscal a qual está vinculada a requisição de faturamento
--                     : 04/02/2004 - Colocado pra apresentar o nome fantasia da transportadora - Daniel C. Neto.
--                     : 22/03/2004 - Incluído nome fantasia do Solicitante. - Daniel C. Neto.
--                     : 14/04/2004 - Inclusão do parâmentro usuario para mostrar somente as requisões daquele usuário, sálvo somente
--                                    se o usuário for supervisor ou o parâmetro não utiliza este filtro. - Igor Gama
--                     : 04/05/2004 - Acerto no relacionamento com a vw_destinatario - Daniel C. Neto.
--                     : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 05.11.2005 - Tipo da Requisição de Faturamento - Carlos Fernandes
--                     : 19.01.2007 - Correção da identação e adição do campo tipo_frete_pagamento e contato
--                     : 23.06.2007 - CFOP - Carlos Fernandes
-- 25.03.2008 - Novo Campo de Fantasia do Produto - Carlos Fernandes
-- 23.10.2008 - Verificação da Nota de Saída - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------
(
  @dt_inicio                 datetime,
  @dt_fim                    datetime,
  @cd_requisicao_faturamento int,
  @ic_aberta                 char(1),
  @cd_usuario                int = 0
 )
as
begin

  set @cd_usuario = IsNull(@cd_usuario,0)

  If IsNull(@cd_usuario,0) <> 0
  Begin
    --Verifica no paramentro_financeiro se vai utilizar o filtro por usuário
    Declare @ic_filtro char(1),
            @ic_supervisor char(1)
    Select @ic_filtro = IsNull(ic_filtrar_req_fat_usuario,'N') 
    from parametro_faturamento with (nolock)
    Where cd_empresa = dbo.fn_empresa()

    if @ic_filtro = 'S'

    --Verifica se o usuário = S --Supervisor
    select @ic_supervisor = ic_tipo_usuario 
    from egisadmin.dbo.usuario with (nolock) 
    where cd_usuario = @cd_usuario

  end Else
    Set @ic_filtro = 'N'

    if (@ic_aberta != 'F')
      select 
        r.*,
        d.nm_departamento,
        o.nm_operacao_fiscal,
        o.cd_mascara_operacao,
        u.nm_fantasia_usuario as nm_usuario,
        (Select top 1 nm_fantasia         from transportadora with (nolock) where cd_transportadora         = r.cd_transportadora)         as nm_transportadora,
        (Select top 1 cd_nota_saida       from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as cd_nota_saida,
        (Select top 1 dt_nota_saida       from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as dt_nota_saida,
        (Select top 1 dt_saida_nota_saida from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as dt_saida_nota_saida,
        td.nm_tipo_destinatario,
        vd.nm_fantasia,
        tr.nm_tipo_requisicao,
        t.nm_fantasia            as nm_fantasia_transportadora,
        v.nm_fantasia_vendedor
      from 
        requisicao_faturamento r                       with (nolock)
        left outer join Departamento                 d with (nolock) on d.cd_departamento           = r.cd_departamento
        left outer join Operacao_Fiscal              o with (nolock) on o.cd_operacao_fiscal        = r.cd_operacao_fiscal
        left outer join Egisadmin.dbo.usuario        u with (nolock) on u.cd_usuario                = r.cd_usuario_solicitante
        left outer join vw_destinatario             vd with (nolock) on vd.cd_destinatario          = r.cd_destinatario and vd.cd_tipo_destinatario = r.cd_tipo_destinatario
        left outer join Tipo_Destinatario           td with (nolock) on td.cd_tipo_destinatario     = vd.cd_tipo_destinatario
        left outer join Tipo_Requisicao_Faturamento tr with (nolock) on tr.cd_tipo_requisicao       = r.cd_tipo_requisicao
        left outer join Transportadora              t  with (nolock) on t.cd_transportadora         = r.cd_transportadora
        left outer join Vendedor                    v  with (nolock) on v.cd_vendedor               = r.cd_vendedor                   
      where 
        (( IsNull(@cd_requisicao_faturamento,0) = 0 and dt_requisicao_faturamento between @dt_inicio and @dt_fim )  or
         ( r.cd_requisicao_faturamento = @cd_requisicao_faturamento and IsNull(@cd_requisicao_faturamento,0) > 0 )) and 
           IsNull(r.ic_req_fat_cancelamento,'N') = @ic_aberta and 
         ( IsNull((Select top 1 cd_nota_saida from Nota_Saida with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento),0) = 0 ) and
           r.cd_usuario = case when @ic_filtro = 'N' then r.cd_usuario else case When @ic_supervisor = 'S' then r.cd_usuario else @cd_usuario end end
      order by 
        r.dt_necessidade_requisicao desc
    else
      select 
        r.*,
        d.nm_departamento,
        o.nm_operacao_fiscal,
        o.cd_mascara_operacao,
        u.nm_usuario,
        (Select top 1 nm_fantasia         from transportadora with (nolock) where cd_transportadora         = r.cd_transportadora)         as nm_transportadora,
        (Select top 1 cd_nota_saida       from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as cd_nota_saida,
        (Select top 1 dt_nota_saida       from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as dt_nota_saida,
        (Select top 1 dt_saida_nota_saida from nota_saida     with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento) as dt_saida_nota_saida,
        td.nm_tipo_destinatario,
        vd.nm_fantasia,
        r.vl_ipi_obs,
        r.vl_ipi_outros,
        r.vl_ipi_isento,
        r.vl_ipi,
        r.vl_bc_ipi,
        r.vl_icms_obs,
        r.vl_icms_outros,
        r.vl_icms_isento,
        r.vl_icms,
        r.vl_bc_icms,
        tr.nm_tipo_requisicao,
        t.nm_fantasia            as nm_fantasia_transportadora,
        v.nm_fantasia_vendedor

      from 
        requisicao_faturamento r with (nolock)
        left outer join Departamento           d with (nolock) on d.cd_departamento           = r.cd_departamento
        left outer join Operacao_Fiscal        o with (nolock) on o.cd_operacao_fiscal        = r.cd_operacao_fiscal
        left outer join Egisadmin.dbo.usuario  u with (nolock) on u.cd_usuario                = r.cd_usuario
        left outer join vw_destinatario       vd with (nolock) on vd.cd_destinatario          = r.cd_destinatario and 
                                                                  vd.cd_tipo_destinatario     = r.cd_tipo_destinatario
        left outer join Tipo_Destinatario     td with (nolock) on td.cd_tipo_destinatario     = vd.cd_tipo_destinatario
        left outer join Tipo_Requisicao       tr with (nolock) on tr.cd_tipo_requisicao       = r.cd_tipo_requisicao
        left outer join Transportadora              t  with (nolock) on t.cd_transportadora         = r.cd_transportadora
        left outer join Vendedor                    v  with (nolock) on v.cd_vendedor               = r.cd_vendedor                   
     where 
       ((IsNull(@cd_requisicao_faturamento,0) = 0 and dt_requisicao_faturamento between @dt_inicio and @dt_fim ) or
        (r.cd_requisicao_faturamento = @cd_requisicao_faturamento and IsNull(@cd_requisicao_faturamento,0) > 0)) and 
        (IsNull((Select top 1 cd_nota_saida from Nota_Saida with (nolock) where cd_requisicao_faturamento = r.cd_requisicao_faturamento),0) > 0) and
         r.cd_usuario = case when @ic_filtro = 'N' then r.cd_usuario else case When @ic_supervisor = 'S' then r.cd_usuario else @cd_usuario end end
     order by 
       r.dt_necessidade_requisicao desc
end

