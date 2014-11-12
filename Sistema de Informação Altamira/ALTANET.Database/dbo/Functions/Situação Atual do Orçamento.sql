

CREATE FUNCTION [dbo].[Situação Atual do Orçamento] (@Orcamento AS INT, @Situacao AS NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
	IF EXISTS (SELECT * FROM [Pedido de Venda] WITH (NOLOCK) WHERE [Pedido de Venda].[Número do Orçamento] = @Orcamento)
		RETURN 'Fechado'
	
	IF @Situacao IS NULL
		RETURN 'Pendente'
		
	RETURN @Situacao

END

