
CREATE PROCEDURE pr_inconsistencia_cliente
AS

  select 	
    a.cd_cliente,
    a.nm_fantasia_cliente,
    a.nm_razao_social_cliente,
    isnull((select nm_vendedor from vendedor where cd_vendedor = a.cd_vendedor),'') as vendedor,
    a.cd_cep,
    e.sg_estado,
    a.cd_inscestadual as inscestadual,
    a.cd_cnpj_cliente,
    case  
      when a.cd_tipo_pessoa = 1 then dbo.fn_valida_cnpj('cnpj',a.cd_cnpj_cliente) 
      when a.cd_tipo_pessoa = 2 then dbo.fn_valida_cnpj('cpf',a.cd_cnpj_cliente)
    else
      'INVALIDO'
    end as cnpj_cpf,
    case  
      when a.ic_inscestadual_valida = 'S' then 'VALIDO' 
      when a.ic_inscestadual_valida = 'N' then 'INVALIDO'
    else
      null
    end as cd_inscestadual,
    case when len(a.cd_cep) < 8 then 'x' else '' end as cep_incorreto,
    case when a.cd_ddd = '' then 'x' else '' end as sem_ddd,
    case when rtrim(ltrim(a.cd_telefone)) = '-' and len(cd_telefone) < 7 then 'x' else '' end as sem_fone,
    case when isnull(a.cd_vendedor,0) = 0 then 'x' else '' end as sem_vendedor_ex,
    case when isnull(a.cd_vendedor_interno,0) = 0 then 'x' else '' end as sem_vendedor_in,
    case when a.nm_fantasia_cliente like '%desativ%' or 
    a.nm_fantasia_cliente like '%falid%' or
    a.nm_fantasia_cliente like '%fechad%' then 'x' else '' end as inativar,
    tp.nm_tipo_pessoa,
    sc.nm_status_cliente,
    cv.nm_criterio_visita
  from 	
    Cliente a with (nolock)            left outer join
    Pais    p on a.cd_pais = p.cd_pais left outer join
    Estado  e on a.cd_pais = e.cd_pais and a.cd_estado          = e.cd_estado
    left outer join Tipo_Pessoa tp     on tp.cd_tipo_pessoa     = a.cd_tipo_pessoa
    left outer join Status_Cliente sc  on sc.cd_status_cliente  = a.cd_status_cliente
    left outer join Criterio_Visita cv on cv.cd_criterio_visita = a.cd_criterio_visita
  where 	
  (
    a.cd_cep 			 = ''  or 
    len(a.cd_cep) 		 < 8   or
    a.cd_ddd 			 = ''  or
    rtrim(ltrim(a.cd_telefone))  = '-' or
    len(rtrim(ltrim(a.cd_telefone))) < 7   or
    isnull(a.cd_vendedor,0)	 = 0   or
    isnull(a.cd_vendedor_interno,0)= 0   or
    isnull(a.ic_inscestadual_valida,'S') = 'N' or
    a.nm_fantasia_cliente 	 like '%desativ%' or 
    a.nm_fantasia_cliente 	 like '%falid%'   or
    a.nm_fantasia_cliente 	 like '%fechad%' or
    ((dbo.fn_valida_cnpj('cnpj',a.cd_cnpj_cliente) = 'invalido') and a.cd_tipo_pessoa = 1) or
    ((dbo.fn_valida_cnpj('cpf',a.cd_cnpj_cliente) = 'invalido') and a.cd_tipo_pessoa = 2)
  ) and
    a.cd_status_cliente = 1  
  order by 
    a.nm_razao_social_cliente


