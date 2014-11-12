

/****** Object:  Stored Procedure dbo.pr_ConsultaClienteCredito    Script Date: 13/12/2002 15:08:09 ******/
CREATE PROCEDURE pr_ConsultaClienteCredito
--pr_ConsultaClienteCredito
---------------------------------------------------
--GBS - Global Business Solution	       2001
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio
--Banco de Dados: EGISSQL
--Objetivo: Filtra sobre as informações pertinentes da empresa
--Data: 07/05/2002
--Atualizado: 
---------------------------------------------------
as
Select cd_cliente, nm_fantasia_cliente, nm_razao_social_cliente, ic_liberado_pesq_credito from Cliente
where ic_liberado_pesq_credito = 'N'
-- =============================================
-- example to execute the store procedure
-- =============================================



