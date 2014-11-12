
/****** Object:  Stored Procedure dbo.SPVE_RECADOSUNICO_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPVE_RECADOSUNICO_RELATORIO    Script Date: 10/02/2000 09:50:00 ******/
CREATE PROCEDURE SPVE_RECADOSUNICO_RELATORIO

@Numero char(12)

AS
	
    SELECT vere_Numero,
           vere_Data,
           vere_Nome,
           vere_Endereco,
           vere_DDD,
           vere_Telefone,
           vere_DDDFax,
           vere_NumeroFax,
          vere_Bairro,
           vere_Cidade,
           vere_Estado,
           vere_Contato,
           vere_ProcurarPor,
           vere_Departamento,
           vere_Chamado,
           vere_Produto,
           vere_Propaganda,
           vere_Observacao,
           vere_Representante,
           verp_RazaoSocial,
           vere_EMail,
	vere_PrazoDoRecado,
	vere_Protocolo,
	vese_Descrição
     FROM VE_Recados, VE_Representantes,VE_RecadosSelProdutos
      WHERE vere_Representante = verp_Codigo
      AND vere_Numero =  @Numero 
     AND  vese_CodRecado = vere_Numero











