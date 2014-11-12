
create procedure pr_consulta_conta_corrente
@cd_favorecido      int     = 0,
@ic_tipo_favorecido char(1) = '',
@cd_item_favorecido int     = 0 

as

  if @ic_tipo_favorecido = 'F' 
    begin

      --select * from fornecedor

      select 
        case when f.cd_banco = 0 then cast(null as int) else f.cd_banco end          as 'Banco',
        cast(f.cd_agencia_banco as varchar(20))                                      as 'Agencia',
        cast(f.cd_conta_banco as varchar(20))                                        as 'Conta',
        ba.cd_numero_banco,
        f.nm_razao_social                                                            as 'Favorecido'                  
        
      from 
 
        fornecedor f with (nolock) 
        left outer join Banco ba with (nolock) on (f.cd_banco = ba.cd_banco)
      where 
        f.cd_fornecedor = @cd_favorecido

    end
  else if @ic_tipo_favorecido = 'E' and @cd_item_favorecido=0 
    begin
      --select * from empresa_diversa 
      --select * from favorecido_empresa
      select
        case when e.cd_banco = 0 then cast(null as int) else e.cd_banco end          as 'Banco',
        cast(e.cd_agencia_banco as varchar(20))  as 'Agencia',
        cast(e.cd_conta_corrente as varchar(20)) as 'Conta',
        ba.cd_numero_banco,
        e.nm_empresa_diversa                                                         as 'Favorecido'                  
      from
        empresa_diversa e        with (nolock) 
        left outer join Banco ba with (nolock) on (e.cd_banco = ba.cd_banco) 
      where
        cd_empresa_diversa = @cd_favorecido

    end
  else if @ic_tipo_favorecido = 'V' or @cd_item_favorecido>0 
    begin
      --select * from favorecido_empresa
      select
        case when fe.cd_banco = 0 then cast(null as int) else fe.cd_banco end          as 'Banco',
        cast(fe.nm_agencia_banco_favoreci as varchar(20))  as 'Agencia',
        cast(fe.cd_conta_favorecido       as varchar(20))  as 'Conta',
        ba.cd_numero_banco,
        fe.nm_favorecido_empresa                                                       as 'Favorecido'                  
 
      from
        favorecido_empresa fe        with (nolock) 
        left outer join Banco ba with (nolock) on fe.cd_banco = ba.cd_banco
      where
        cd_empresa_diversa        = @cd_favorecido and
        cd_favorecido_empresa_div = @cd_item_favorecido

    end

  else if @ic_tipo_favorecido = 'U'
    begin

      select
        case when fu.cd_banco = 0 then cast(null as int) else fu.cd_banco end                as 'Banco',
        cast(fu.cd_agencia_funcionario as varchar(20))  as 'Agencia',
        cast(fu.cd_conta_funcionario as varchar(20))    as 'Conta',
        ba.cd_numero_banco 
      from
        funcionario fu            with (nolock) 
         left outer join Banco ba with (nolock) on (fu.cd_banco = ba.cd_banco)
      where
        fu.cd_funcionario =@cd_favorecido

    end
  else --if @ic_tipo_favorecido = 'C'
    begin

      select
        case when fo.cd_banco = 0 then cast(null as int) else fo.cd_banco end                as 'Banco',
        cast(fo.cd_agencia_banco as varchar(20))  as 'Agencia',
        cast(fo.cd_conta_banco as varchar(20))    as 'Conta' ,
        ba.cd_numero_banco
      from
        fornecedor fo                      with (nolock) 
          left outer join contrato_pagar c with (nolock) on (c.cd_contrato_pagar = 11)
          left outer join banco ba         with (nolock) on(fo.cd_banco = ba.cd_banco)    
      where
        c.cd_fornecedor = fo.cd_fornecedor

   end
     
