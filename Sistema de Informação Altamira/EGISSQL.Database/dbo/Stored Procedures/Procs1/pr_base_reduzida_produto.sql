
CREATE  PROCEDURE pr_base_reduzida_produto
---------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda            2002
---------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Carlos Cardoso Fernandes
--Banco de Dados  : EgisSql
--Objetivo        : Cadastrar as Informacoes refrente a saida da mercadoria da empresa
--Data            : 15/05/2002
--Atualizado      : 10/04/2003 - Colocado o Grupo de Produto
--                : 06/12/2004 - Inserido nova funcionalidade para Buscar BC Reduzida
--                               Específica de Cliente - ELIAS
--                : 29.10.2007 - Verificado porque somente calcula quando existe um produto
--                               Mas será necessário alterar para notas sem produto e
--                               que tem redução - Carlos Fernandes.
-- 13.05.2009 - Ajustes Diversos - Carlos Fernandes
-------------------------------------------------------------------------------------
@ic_parametro            int     = 0,
@cd_produto              int     = 0,
@sg_estado               char(2) = '',
@cd_grupo_produto        int     = 0,
@cd_cliente              int     = null,
@cd_classificacao_fiscal int     = 0,
@cd_tipo_destinatario    int     = 1 --Cliente

--@cd_nota_saida      int = 0,
--@cd_item_nota_saida int = 0
--select * from tipo_destinatario

as

begin

  declare @BCReduzida  char(1)

  -- variável utilizada para verificar se existe Redução de BC do ICMS
  -- Específica para o Cliente
  declare @BCReduzidaCliente char(1)

  declare @ClassFiscal       int

  declare @Estado            int

  select
    @Estado = cd_estado
  from
    Estado with (nolock) 
  where
    sg_estado = @sg_estado and
    cd_pais   = 1  -- Brasil


set @cd_produto        = isnull(@cd_produto,0)
set @cd_grupo_produto  = isnull(@cd_grupo_produto,0)
set @BCReduzidaCliente = 'N'

------------------------------------------------------------------------------------------------------
--Cliente ( Específico do Cadastro do Cliente )
------------------------------------------------------------------------------------------------------

if ( (select isnull(pc_icms_reducao_cliente,0) 
     from 
       cliente with (nolock) 
     where 
       cd_cliente = @cd_cliente ) <>0  and isnull(@cd_tipo_destinatario,1) = 1)

  set @BCReduzidaCliente = 'S'

else

  set @BCReduzidaCliente = 'N'

--select @cd_grupo_produto,@cd_produto,@BCReduzidaCliente
------------------------------------------------------------------------------------------------------
  
-- Verifica se pode existir Redução de ICMS configurada
-- Na Classificação Fiscal do Produto

if ((@cd_produto > 0) and (@BCReduzidaCliente = 'N'))
begin

  -- verifica se o produto contêm base de cálculo reduzida
  select
    @BCReduzida  = isnull(cf.ic_base_reduzida,'N'),
    @ClassFiscal = cf.cd_classificacao_fiscal
  from
    Classificacao_Fiscal cf           with (nolock)
    left outer join Produto_Fiscal pf with (nolock)
  on
    cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  where
    pf.cd_produto = @cd_produto

end

else

-- Verifica se pode existir Redução de ICMS configurada
-- Na Classificação Fiscal do Grupo de Produto

if ((@cd_grupo_produto > 0) and (@BCReduzidaCliente = 'N'))
begin

  -- verifica se o produto contêm base de cálculo reduzida
  select
    @BCReduzida  = isnull(cf.ic_base_reduzida,'N'),
    @ClassFiscal = cf.cd_classificacao_fiscal
  from
    Classificacao_Fiscal cf                  with (nolock)
    left outer join Grupo_Produto_Fiscal gpf with (nolock) on cf.cd_classificacao_fiscal = gpf.cd_classificacao_fiscal
  where
    gpf.cd_grupo_produto = @cd_grupo_produto

end

--Verificação de Base para Nota sem Produto/sem Grupo

else
begin
  if @cd_produto = 0 and @cd_grupo_produto = 0 and @BCReduzidaCliente = 'N'
  begin
    if @cd_classificacao_fiscal > 0 
    begin
      select
        @BCReduzida  = isnull(cf.ic_base_reduzida,'N'),
        @ClassFiscal = cf.cd_classificacao_fiscal
      from
        Classificacao_Fiscal cf with (nolock)
      where
        cf.cd_classificacao_fiscal = @cd_classificacao_fiscal
  
    end

   end

end


-- Busca o Percentual de Redução do Cliente e o Dispositivo Legal  

if (@BCReduzidaCliente = 'S')
begin

  -- Carrega o Percentual de BC Reduzida Específica do Cliente
	select 
	   c.pc_icms_reducao_cliente as 'PercReducao',
	   dl.ds_dispositivo_legal   as 'DispLegal',
          'S'                        as 'BCReduzida'
	from cliente c with (nolock)
	left outer join dispositivo_legal dl with (nolock) on dl.cd_dispositivo_legal = c.cd_dispositivo_legal
	where 
          c.cd_cliente = @cd_cliente

end

else

-- Caso tenha encontrado BC no Produto ou no Grupo de Produto é
-- verificado de onde será buscado o Percentual e o Dispositivo
-- Legal, se na Calssificação Fiscal ou na Classificação Fiscal Estado

if @BCReduzida = 'S'
begin
  -- carrega o percentual de redução e o disp. legal da class. fiscal específica do estado
  if exists(select * from classificacao_fiscal_estado with (nolock)
            where cd_classificacao_fiscal = @ClassFiscal and
                  cd_estado = @Estado)
  begin
    select
      cfe.pc_redu_icms_class_fiscal	        as 'PercReducao',
      dl.ds_dispositivo_legal   		as 'DispLegal',
      'S'					as 'BCReduzida'
    from
      Classificacao_Fiscal_Estado cfe      with (nolock)
      left outer join Dispositivo_Legal dl with (nolock) on dl.cd_dispositivo_legal = cfe.cd_dispositivo_legal
    where
      cfe.cd_classificacao_fiscal = @ClassFiscal and
      cfe.cd_estado               = @Estado

  end
  else
  begin
    -- carrega o dispositivo legal da Classificação Fiscal e Percentual 
    -- de Redução do Estado Parâmetro
    select
      ep.qt_base_calculo_icms as 'PercReducao',
      dl.ds_dispositivo_legal as 'DispLegal',                  
      'S'	              as 'BCReduzida'         
    from        
      Estado_Parametro ep,
      Classificacao_fiscal cf
      left outer join Dispositivo_Legal dl with (nolock) on cf.cd_dispositivo_legal = dl.cd_dispositivo_legal
    where
      cf.cd_classificacao_fiscal = @ClassFiscal and
      ep.cd_estado = @Estado
  end
end

else
  select
    cast(0    as float)	as 'PercReducao',
    cast(null as text)	as 'DispLegal',
    'N'			as 'BCReduzida'

end

--select @cd_grupo_produto,@cd_produto,@BCReduzidaCliente

