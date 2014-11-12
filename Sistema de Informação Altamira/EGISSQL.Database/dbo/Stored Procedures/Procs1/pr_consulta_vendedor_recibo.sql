
CREATE procedure pr_consulta_vendedor_recibo

@cd_vendedor              int, 
@cd_tipo_vendedor         int

as

--select * from vendedor

  select 
     a.cd_vendedor,
     max(a.cd_regiao_venda)           as cd_regiao_venda,
     max(b.nm_fantasia_vendedor)      as nm_fantasia_vendedor,
     max(b.nm_vendedor)               as nm_vendedor,
     max(b.cd_ddd_vendedor)           as cd_ddd_vendedor,  
     max(b.cd_telefone_vendedor)      as cd_telefone_vendedor, 
     max(b.cd_fax_vendedor)           as cd_fax_vendedor,
     max(b.cd_cep)                    as cd_cep, 
     max( ltrim(rtrim(b.nm_endereco_vendedor)) +', '+
          ltrim(rtrim(b.cd_numero_endereco))   +' '+
          ltrim(rtrim(b.nm_complemento_endereco)))
                                      as nm_endereco_vendedor, 
     max(b.cd_numero_endereco)        as cd_numero_endereco,
     max(b.nm_bairro_vendedor)        as nm_bairro_vendedor,
     max(d.sg_estado)                 as sg_estado, 
     max(c.nm_cidade)                 as nm_cidade, 
     max(b.cd_cnpj_vendedor)          as cd_cnpj_vendedor, 
     max(b.cd_inscestadual_vendedor)  as cd_inscestadual_vendedor, 
     max(b.cd_banco)                  as cd_banco, 
     max(b.cd_agencia_banco_vendedor) as cd_agencia_banco_vendedor, 
     max(b.pc_aliquota_irpj)          as pc_aliquota_irpj,
     max(b.cd_conta_corrente)         as cd_conta_corrente,
     max(e.nm_fantasia_banco)         as nm_fantasia_banco,
     max(b.pc_iss_vendedor)           as pc_iss_vendedor,
     max(b.cd_fornecedor)             as cd_fornecedor,
     max(b.cd_empresa_diversa)        as cd_empresa_diversa,
     max(b.cd_favorecido_empresa)     as cd_favorecido_empresa

  from 
    vendedor_comissao a
    inner join vendedor b
      on a.cd_vendedor = b.cd_vendedor
         and isnull(b.ic_ativo,'S') = 'S'
         and isnull(b.ic_recibo_comis_vendedor,'N') = 'S'
    inner join Tipo_Vendedor f
      on b.cd_tipo_vendedor = f.cd_tipo_vendedor 
         and f.ic_comissao_tipo_vendedor = 'S'
    left outer join cidade c
      on b.cd_cidade = c.cd_cidade
    left outer join estado d
      on b.cd_estado = d.cd_estado
    left outer join banco e
      on b.cd_banco = e.cd_banco       
  where 
    IsNull(a.cd_vendedor,0) = ( case @cd_vendedor
                                  when 0 then IsNull(a.cd_vendedor,0)
                                  else @cd_vendedor
                                end )    
    and IsNull(b.cd_tipo_vendedor,0) = ( case @cd_tipo_vendedor
                                           when 0 then IsNull(b.cd_tipo_vendedor,0)
                                           else @cd_tipo_vendedor
                                         end )
  group by 
    a.cd_vendedor
  order by 
    b.nm_fantasia_vendedor

