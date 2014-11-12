
/****** Object:  Stored Procedure dbo.pr_consulta_documento_ocorrencia    Script Date: 13/12/2002 15:08:19 ******/


--pr_Consulta_Documento_ocorrencia
-------------------------------------------------------------------------------------------
-- GBS 
-------------------------------------------------------------------------------------------
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta dos Documentos das Ocorrências 
-- Data             : 19.03.2002
-- Atualizado       : 18.07.2002
-- @Parametro : 1-> Tabela Pedido de Vendas 
--              2-> Notas de Saidas   
--              3-> Tabela de Pedido de Compras  
--              4-> Tabela de Notas de Entrada
--              5-> Outras tabelas (precisa definir)
-- @Documento : Númro do documento
-------------------------------------------------------------------------------------------
-- Alteração  : 05.02.2009 
-------------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_consulta_documento_ocorrencia

-- Parametros
@ic_parametro integer = 0,
@cd_documento integer = 0

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Tabela Pedido de Vendas
-------------------------------------------------------------------------------------------
  begin
    Select
      p.cd_pedido_venda         as Documento,
      p.dt_pedido_venda         as Data, 
      c.cd_cliente              as CodigoDestinatario,
      c.nm_razao_social_cliente as Descricao
    from 
      pedido_venda p with (nolock) 
      Left Join cliente c On c.cd_cliente = p.cd_cliente

    where 
      (p.cd_pedido_venda = @cd_documento)
    order by p.cd_Pedido_venda
  end
-------------------------------------------------------------------------------------------
  if @ic_parametro = 2 --Notas de Saidas
-------------------------------------------------------------------------------------------
  begin
    Select
      s.cd_nota_saida as documento,
      c.cd_cliente    as CodigoDestinatario,
      s.dt_nota_saida as Data
    from 
         nota_saida s    with (nolock) 
    Left Join cliente c  On c.cd_cliente = s.cd_cliente

    where 
      (s.cd_Nota_saida = @cd_documento)
    order by s.cd_nota_saida
  end
-------------------------------------------------------------------------------------------
  if @ic_parametro = 3 --Tabela de Pedido de Compras
-------------------------------------------------------------------------------------------
  begin
    Select
      pc.cd_pedido_compra as Documento,
      pc.dt_pedido_compra as Data,
      f.cd_fornecedor     as CodigoDestinatario,
      f.nm_razao_social   as Descricao
    from 
         pedido_compra pc  with (nolock) 
    Left Join fornecedor f On pc.cd_fornecedor = f.cd_fornecedor

    where 
      (pc.cd_pedido_compra = @cd_documento)
    order by pc.cd_Pedido_compra
  end

-------------------------------------------------------------------------------------------
  if @ic_parametro = 4 --Tabela de Notas de Entrada
-------------------------------------------------------------------------------------------
  begin
    Select
      e.cd_nota_entrada as Documento,
      e.dt_nota_entrada as Data,
      f.cd_fornecedor   as CodigoDestinatario,
      f.nm_razao_social as Descricao
    from 
         nota_entrada e    with (nolock) 
    Left Join fornecedor f On f.cd_fornecedor = e.cd_fornecedor

    where 
      (e.cd_nota_entrada = @cd_documento) -- ???
    order by e.cd_nota_entrada
  end

-------------------------------------------------------------------------------------------
  if @ic_parametro = 5 --outras
-------------------------------------------------------------------------------------------
  begin
     print 'precisa ser definido... '
  end

-------------------------------------------------------------------------------------------

