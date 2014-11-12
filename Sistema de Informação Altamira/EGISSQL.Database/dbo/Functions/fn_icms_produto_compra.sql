
create function fn_icms_produto_compra (
  @cd_produto          int, 
  @sg_estado           varchar(2) = 'SP', -- Mantido por compatibilidade
  @cd_estado           int = 0, --Código do estado
  @ic_retornar_reducao char(1) = 'N') --Caso for definido como "S" será retornado o valor da redução do ICMS
returns decimal(25,2)

as

begin

  declare @vl_retorno        decimal(25,2)
  declare @vl_bc_reduzida    decimal(25,2)
  declare @pc_icms_estado    decimal(25,2)
  declare @cd_estado_empresa int

  set @vl_retorno     = null
  set @vl_bc_reduzida = null
  set @pc_icms_estado = null

  select 
    @cd_estado_empresa = cd_estado
  from 
    EGISADMIN.dbo.Empresa with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  if (@ic_retornar_reducao is null)  
    set @ic_retornar_reducao = 'N'

  -- REDUÇÃO DE BASE

  if @ic_retornar_reducao = 'S'
  begin

    if (isnull(@cd_produto,0) = 0) 
      set @vl_retorno = null
    else
    begin
      select @vl_bc_reduzida = isnull(qt_base_calculo_icms,0)
      from 
        Estado_Parametro with(nolock)
      where cd_estado = case when isnull(@cd_estado,0) = 0 
                          then @cd_estado_empresa 
                          else @cd_estado 
                        end and
        cd_pais = 1 -- BRASIL   
   
      -- VERIFICA REDUÇÃO CONFIGURADA NO PRODUTO_FISCAL_ENTRADA    

      if (select isnull(cf.ic_base_reduzida,'N')                 as ic_base_reduzida
          from Classificacao_Fiscal cf          with (nolock)
          inner join Produto_Fiscal_Entrada pfe with (nolock) on cf.cd_classificacao_fiscal = pfe.cd_classificacao_fiscal
          where pfe.cd_produto = @cd_produto) = 'S'
      begin
        set @vl_retorno = @vl_bc_reduzida
      end

    end

  end
  else
  -- ICMS
  begin

    select 
      @pc_icms_estado = isnull(pc_aliquota_icms_estado,0)
    from
       Estado_Parametro with(nolock)
    where 
       cd_estado = case when isnull(@cd_estado,0) = 0 
                        then @cd_estado_empresa 
                        else @cd_estado 
                      end and
         cd_pais = 1 -- BRASIL   

    if (isnull(@cd_produto,0) = 0) or (@cd_estado <> @cd_estado_empresa) 
      set @vl_retorno = @pc_icms_estado
    else
      select @vl_retorno = case when (pfe.cd_produto is not null) and 
                                     (isnull(p.ic_especial_produto,'N') = 'N') then 
                             case when isnull(pfe.pc_aliquota_icms_produto,0) < @pc_icms_estado and isnull(pfe.pc_aliquota_icms_produto,0) <> 0 then
                               isnull(pfe.pc_aliquota_icms_produto,0)
                             else
                               case when pfe.ic_isento_icms_produto = 'S' then
                                  0.00
                               else
                                  @pc_icms_estado
                               end
                             end 
                           else 
                             @pc_icms_estado 
                           end                                                      
      from
        Produto p                                  with(nolock)
        left outer join Produto_Fiscal_Entrada pfe with(nolock) on p.cd_produto = pfe.cd_produto
      where p.cd_produto = @cd_produto

  end    

  return @vl_retorno

end

