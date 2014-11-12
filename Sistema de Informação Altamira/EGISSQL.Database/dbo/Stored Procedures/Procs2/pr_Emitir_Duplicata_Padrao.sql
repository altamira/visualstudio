
CREATE PROCEDURE pr_Emitir_Duplicata_Padrao

@cd_cliente int,
@dt_inicial DateTime,
@dt_final DateTime

as

  if exists (select top 1 'x' 
               from cliente_endereco
              where cd_cliente = @cd_cliente
                and cd_tipo_endereco = 3)
    begin
      -- Lista documentos à receber onde os clientes possuem endereço de cobrança
      select dcr.dt_emissao_documento as Data_Emissao, 
             dcr.cd_identificacao as NumeroDoc,
             dcr.vl_documento_receber as  Valor,
             dcr.dt_vencimento_documento as Vencimento,
             cli.nm_razao_social_cliente as Cliente,
             cli.cd_cnpj_cliente as CNPJ,
             clie.nm_endereco_cliente as Endereco,
             clie.cd_numero_endereco as Numero,
             clie.nm_complemento_endereco as Complemento,
             clie.nm_bairro_cliente as Bairro,
             clie.cd_cep_cliente as Cep,     
             cid.nm_cidade as Cidade,       
             est.sg_estado as Estado      

     from documento_receber dcr
     left outer join cliente cli on cli.cd_cliente = dcr.cd_cliente
     left outer join cliente_endereco clie on clie.cd_cliente = cli.cd_cliente
     left outer join cidade cid on cid.cd_cidade = clie.cd_cidade
     left outer join estado est on est.cd_estado = clie.cd_estado

     where dcr.vl_saldo_documento > 0
       and dcr.dt_vencimento_documento >= @dt_inicial
       and dcr.dt_vencimento_documento <= @dt_final
       and dcr.cd_cliente = @cd_cliente

     order by dcr.dt_vencimento_documento

    end
  else
    begin
      -- Lista documentos à receber onde os clientes não possuem endereço de cobrança
      select dcr.dt_emissao_documento as Data_Emissao, 
             dcr.cd_identificacao as NumeroDoc,
             dcr.vl_documento_receber as  Valor,
             dcr.dt_vencimento_documento as Vencimento,
             cli.nm_razao_social_cliente as Cliente,
             cli.cd_cnpj_cliente as CNPJ,
             cli.nm_endereco_cliente as Endereco,
             cli.cd_numero_endereco as Numero,
             cli.nm_complemento_endereco as Complemento,
             cli.nm_bairro as Bairro,
             cli.cd_cep as Cep,
             cid.nm_cidade as Cidade,       
             est.sg_estado as Estado      

      from documento_receber dcr
      left outer join cliente cli on cli.cd_cliente = dcr.cd_cliente
      left outer join cidade cid on cid.cd_cidade = cli.cd_cidade
      left outer join estado est on est.cd_estado = cli.cd_estado

      where dcr.vl_saldo_documento > 0
        and dcr.dt_vencimento_documento >= @dt_inicial
        and dcr.dt_vencimento_documento <= @dt_final
        and dcr.cd_cliente = @cd_cliente

      order by dcr.dt_vencimento_documento
    end 
