
-----------------------------------------------------------------
-- pr_ConsultaClientePesqCredito  
-----------------------------------------------------------------
--GBS - Global Business Solution Ltda                        2004
-----------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Fabio
--Banco de Dados       : EGISSQL
--Objetivo             : Filtra sobre as informações pertinentes da empresa
--Data                 : 07/05/2002
--Atualizado           : Foi modificado o select da coluna ic_liberado_pesq_credito para que trabalhasse
--                       com 1 ou 0 em vez de S ou N para evitar problemas de conversão de tipo
--                     : 29/03/2004 - Anderson Cunha
--                     : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 14.08.2006 - Trazer os Clientes com a Consulta Vencida - Carlos Fernandes
---------------------------------------------------------------------------------------------------------


CREATE   procedure pr_ConsultaClientePesqCredito  
@nm_fantasia_cliente varchar(15) = ''
as  

--select * from parametro_financeiro

declare @qt_dia_validacao_credito int

select
  @qt_dia_validacao_credito = isnull(qt_dia_validacao_credito,0)
from
  Parametro_Financeiro
where
  cd_empresa = dbo.fn_empresa()


if @qt_dia_validacao_credito<>0
begin

  --print '-'
  --select * from Cliente_Informacao_Credito

  --Atualização dos Clientes que estão com a Liberação Vencida
  update
    Cliente
  set
    ic_liberado_pesq_credito = 'N'
  from
    Cliente c 
    inner join Cliente_Informacao_Credito cr on cr.cd_cliente = c.cd_cliente
  where
    cr.dt_validade_orgao_credito is not null and
    cr.dt_orgao_credito          is not null and
    cr.dt_validade_orgao_credito<getdate()

end

begin  

  /*Filtra todos os clientes*/  

  if @nm_fantasia_cliente = ''
  begin  
    Select   
          c.cd_Cliente,  
          c.dt_cadastro_cliente,
          c.nm_fantasia_cliente,   
          c.nm_razao_social_cliente,
          T.nm_tipo_pessoa,  
          R.nm_ramo_atividade,  
          c.cd_cnpj_cliente, 
          case when C.ic_liberado_pesq_credito = 'S' then '1'
                                                     else '0' end as 'ic_liberado_pesq_credito',
      	  CR.cd_orgao_credito,
          cr.dt_orgao_credito,
          v.nm_fantasia_vendedor,
          case when cr.dt_validade_orgao_credito<getdate() then getdate()+@qt_dia_validacao_credito
                                                           else cr.dt_validade_orgao_credito end as dt_validade_orgao_credito,
          @qt_dia_validacao_credito    as qt_dia_validacao_credito
    From 
      Cliente C  
        left join 
      Tipo_Pessoa T  
        on C.cd_tipo_pessoa = T.cd_tipo_pessoa  
        left join 
      Ramo_Atividade R  
        on C.cd_ramo_atividade = R.cd_ramo_atividade  
        left join 
      Cliente_Informacao_Credito CR  
        on CR.cd_cliente = C.cd_cliente
        left outer join
      Vendedor v
        on c.cd_vendedor = v.cd_vendedor
    where 
      IsNull(C.ic_liberado_pesq_credito,'N') = 'N'  
    order by C.nm_fantasia_cliente  

  /*Filtra somente os clientes que começam com o valor informado*/  

  end else   
  begin  
       Select   
          C.cd_Cliente,  
          c.dt_cadastro_cliente,
          C.nm_fantasia_cliente,   
          c.nm_razao_social_cliente,
          T.nm_tipo_pessoa,  
          R.nm_ramo_atividade,  
          C.cd_cnpj_cliente,  
          case when C.ic_liberado_pesq_credito = 'S' then '1'
                                                     else '0' end as 'ic_liberado_pesq_credito',
      	  CR.cd_orgao_credito,
          cr.dt_orgao_credito,
          v.nm_fantasia_vendedor,
          case when cr.dt_validade_orgao_credito<getdate() then getdate()+@qt_dia_validacao_credito
                                                           else cr.dt_validade_orgao_credito end as dt_validade_orgao_credito,
          @qt_dia_validacao_credito    as qt_dia_validacao_credito
   
       From 
         Cliente C  
           left join 
         Tipo_Pessoa T  
           on C.cd_tipo_pessoa = T.cd_tipo_pessoa  
           left join 
         Ramo_Atividade R  
           on C.cd_ramo_atividade = R.cd_ramo_atividade  
           left join 
         Cliente_Informacao_Credito CR  
           on CR.cd_cliente = C.cd_cliente
           left outer join
         Vendedor v
           on c.cd_vendedor = v.cd_vendedor
       where 
        IsNull(C.ic_liberado_pesq_credito,'N') = 'N'  
        and C.nm_fantasia_cliente like @nm_fantasia_cliente + '%'  
       order by C.nm_fantasia_cliente  
   end    

end  
  

