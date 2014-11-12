

CREATE  PROCEDURE pr_consulta_cotacao
@ic_parametro        int,
@ic_status           int, 
@dt_inicial          datetime,
@dt_final            datetime,
@cd_cotacao_compra   int,
@cd_fornecedor	     int
AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Cotação Compras (Todos)
-------------------------------------------------------------------------------
  begin
    select cc.*,
           f.nm_fantasia_fornecedor,
           fc.nm_contato_fornecedor,
           d.nm_departamento
    from cotacao cc
    left outer join fornecedor f 
    on f.cd_fornecedor = cc.cd_fornecedor
    left outer join fornecedor_contato fc 
    on cc.cd_fornecedor = fc.cd_fornecedor and
       cc.cd_contato_fornecedor = fc.cd_contato_fornecedor
    left outer join departamento d
    on fc.cd_departamento = d.cd_departamento
    where (cc.dt_cotacao between @dt_inicial and @dt_final ) and
          (
           (@ic_status = 0) or
           (
            (@ic_status <> 0) and  
            (dt_fechamento_cotacao is not null)
           )
          ) and
          (
           (@cd_cotacao_compra = 0) or
           (cc.cd_cotacao = @cd_cotacao_compra)
          )

    order by cc.cd_cotacao
  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta de Itens de Cotação
-------------------------------------------------------------------------------
  begin
    select cci.*,
           pd.nm_produto,
           pd.nm_fantasia_produto,
           pd.nm_marca_produto,
           um.nm_unidade_medida
    from cotacao_item cci
    left outer join produto pd 
    on pd.cd_produto=cci.cd_produto
    left outer join unidade_medida um
    on um.cd_unidade_medida=pd.cd_unidade_medida
    where cci.cd_cotacao = @cd_cotacao_compra
    order by cci.cd_item_cotacao
  end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta de Cotação Compras (filtrando por fornecedor)
-------------------------------------------------------------------------------
  begin
    select cc.*,
           f.nm_fantasia_fornecedor,
           fc.nm_contato_fornecedor,
           d.nm_departamento
    from cotacao cc
    left outer join fornecedor f 
    on f.cd_fornecedor = cc.cd_fornecedor
    left outer join fornecedor_contato fc 
    on cc.cd_fornecedor = fc.cd_fornecedor and
       cc.cd_contato_fornecedor = fc.cd_contato_fornecedor
    left outer join departamento d
    on fc.cd_departamento = d.cd_departamento
    where (cc.dt_cotacao between @dt_inicial and @dt_final ) and
          (
           (@ic_status = 0) or
           (
            (@ic_status <> 0) and  
            (dt_fechamento_cotacao is not null)
           )
          ) and
          (
           (@cd_cotacao_compra = 0) or
           (cc.cd_cotacao = @cd_cotacao_compra)
          )
    and cc.cd_fornecedor = @cd_fornecedor
    order by cc.cd_cotacao
  end


