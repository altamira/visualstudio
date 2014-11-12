

CREATE function fn_preco_produto_cliente  
(@cd_cliente int,  
 @cd_produto int,
 @ic_tipo_pesquisa char(1) = 'L')  -- 'L' - Loja
                                   -- 'P' - Proposta
                                   -- 'V' - Pedido
returns decimal(25,6)  
  
AS  
BEGIN  
  
declare @ic_tabela_preco       char(1)  
declare @ic_busca_ultimo_preco char(1)  
declare @cd_tabela_preco       int  
declare @vl_preco              decimal(25,6)
 
select   
  @ic_tabela_preco = ic_tabela_preco_loja,  
  @cd_tabela_preco = cd_tabela_preco  
from 
  parametro_loja with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()  

select   
  @ic_busca_ultimo_preco = isnull(ic_busca_ultimo_preco,'N')
from 
  parametro_comercial with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()  
  
if (isnull(@ic_tabela_preco,'N') = 'S')  
begin
  select 
    @vl_preco = isnull(tpp.vl_tabela_produto,0)  
  from 
    tabela_preco_produto tpp,  
    tabela_preco_cliente tpc  
  where 
    tpp.cd_tabela_preco = tpc.cd_tabela_preco and  
    tpp.cd_tabela_preco = @cd_tabela_preco and  
    tpp.cd_produto      = @cd_produto and  
    tpc.cd_cliente      = @cd_cliente  
end

if (IsNull(@ic_busca_ultimo_preco,'N') = 'S') and
   (IsNull(@ic_tipo_pesquisa,'N') = 'P')
begin
  select 
    @vl_preco = dbo.fn_ultimo_preco_proposta ('N', @cd_cliente, @cd_produto)
end

if (IsNull(@ic_busca_ultimo_preco,'N') = 'S') and
   (IsNull(@ic_tipo_pesquisa,'N') = 'V')
begin
  select 
    @vl_preco = dbo.fn_ultimo_preco_pedido('N', @cd_cliente, @cd_produto)
end
  
if isnull(@vl_preco,0) <= 0 
begin
  Select
    @vl_preco = isnull(pc.vl_produto_cliente,0)
  from 
    Produto p                     with (nolock) 
    inner join Produto_Cliente pc with (nolock) on p.cd_produto = pc.cd_produto
  where 
    (isnull(pc.ic_proposta_prod_cliente,'S') = 'S') and
    pc.cd_produto = @cd_produto and 
    pc.cd_cliente = @cd_cliente 
end 

-- Correção para FullCoat -- Verificar depois com calma o motivo.
-- Anderson - 27/12/2006 - 16:51

-- if isnull(@vl_preco,0) <= 0 
-- begin
--   Select
--     @vl_preco = isnull(vl_produto,0)
--   from 
--     Produto with (nolock) 
--   where 
--     cd_produto = @cd_produto 
-- end 

return( isnull(@vl_preco,0) )
  
end  

